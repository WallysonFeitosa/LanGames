const express = require('express');
const router  = express.Router();
const db      = require('../db');

// GET /api/caixa/resumo
// Retorna os totais de entrada, saída e saldo do caixa
router.get('/resumo', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM vw_caixa_totais');
        res.json(rows[0] || { total_entrada: 0, total_saida: 0, saldo: 0 });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// GET /api/caixa
// Retorna o histórico de lançamentos do caixa
router.get('/', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM auditoria_caixa ORDER BY data_hora DESC');
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;