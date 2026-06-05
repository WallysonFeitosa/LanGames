const express = require('express');
const router  = express.Router();
const db      = require('../db');

// GET /api/clientes
// Retorna todos os clientes ordenados por nome.
// Colunas esperadas: id_cliente, nome, email, telefone, saldo_creditos, data_cadastro
router.get('/', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM clientes ORDER BY nome');
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// GET /api/clientes/ranking
// Retorna clientes ranqueados pelo total gasto.
// Depende da view: vw_ranking_clientes
// Colunas esperadas: id_cliente, nome, total_sessoes, total_gasto, gasto_medio
router.get('/ranking', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM vw_ranking_clientes');
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// GET /api/clientes/:id
// Retorna um cliente pelo id.
router.get('/:id', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM clientes WHERE id_cliente = ?', [req.params.id]);
        if (rows.length === 0) {
            return res.status(404).json({ error: 'Cliente não encontrado' });
        }
        res.json(rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// POST /api/clientes
// Cadastra um novo cliente.
// Body esperado: { nome, email, telefone }
router.post('/', async (req, res) => {
    const { nome, email, telefone } = req.body;
    if (!nome || !email) return res.status(400).json({ error: 'Nome e e-mail são obrigatórios.' });
    try {
        const [result] = await db.query('INSERT INTO clientes (nome, email, telefone) VALUES (?, ?, ?)', [nome, email, telefone || null]);
        res.json({ id: result.insertId, message: 'Cliente cadastrado com sucesso.' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;
