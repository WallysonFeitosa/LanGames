const express = require('express');
const router  = express.Router();
const db      = require('../db');

// GET /api/torneios
// Retorna a lista de torneios com a contagem de inscritos e o nome do ganhador
router.get('/', async (req, res) => {
    try {
        const query = `
            SELECT t.id_torneio, t.data_torneio, t.taxa_inscricao, c.nome AS ganhador,
                   COUNT(i.id_inscricao) AS total_inscritos
            FROM torneios t
            LEFT JOIN clientes c ON t.ganhador = c.id_cliente
            LEFT JOIN inscricoes i ON t.id_torneio = i.id_torneio
            GROUP BY t.id_torneio
            ORDER BY t.data_torneio DESC
        `;
        const [rows] = await db.query(query);
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// POST /api/torneios/inscrever
// Registra um cliente em um torneio
router.post('/inscrever', async (req, res) => {
    const { id_torneio, id_cliente, pago } = req.body;
    
    if (!id_torneio || !id_cliente) {
        return res.status(400).json({ error: 'Torneio e cliente são obrigatórios.' });
    }
    
    const status_pag = pago ? 'pago' : 'pendente';
    
    try {
        const [existente] = await db.query('SELECT id_inscricao FROM inscricoes WHERE id_torneio = ? AND id_cliente = ?', [id_torneio, id_cliente]);
        if (existente.length > 0) {
            return res.status(400).json({ error: 'Este cliente já está inscrito neste torneio.' });
        }

        await db.query('INSERT INTO inscricoes (id_torneio, id_cliente, status_pag) VALUES (?, ?, ?)', [id_torneio, id_cliente, status_pag]);
        res.json({ message: 'Inscrição realizada com sucesso.' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;