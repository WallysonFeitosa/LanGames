const express = require('express');
const router  = express.Router();
const db      = require('../db');

// GET /api/computadores
// Retorna todos os computadores ordenados por numero.
// Colunas esperadas: id_computador, numero, descricao, status, valor_hora
router.get('/', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM computadores ORDER BY numero');
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// GET /api/computadores/disponiveis
// Retorna apenas computadores com status = 'disponivel'.
router.get('/disponiveis', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM computadores WHERE status = "disponivel" ORDER BY numero');
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// PATCH /api/computadores/:id/status
// Atualiza o status de um computador.
// Body esperado: { status: 'disponivel' | 'ocupado' | 'manutencao' }
router.patch('/:id/status', async (req, res) => {
    const { status } = req.body;
    const validos = ['disponivel', 'ocupado', 'manutencao'];
    if (!validos.includes(status))
        return res.status(400).json({ error: 'Status inválido.' });
    try {
        await db.query('UPDATE computadores SET status = ? WHERE id_computador = ?', [status, req.params.id]);
        res.json({ message: 'Status atualizado com sucesso.' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;
