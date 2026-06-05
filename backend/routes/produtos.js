const express = require('express');
const router  = express.Router();
const db      = require('../db');

// GET /api/produtos
// Retorna todos os produtos ordenados por categoria e nome.
// Colunas esperadas: id_produto, nome, categoria, preco, estoque
router.get('/', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM produtos ORDER BY categoria, nome');
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// GET /api/produtos/mais-vendidos
// Retorna produtos ranqueados pela quantidade vendida.
// Depende da view: vw_produtos_mais_vendidos
// Colunas esperadas: nome, categoria, total_vendido, receita_total
router.get('/mais-vendidos', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM vw_produtos_mais_vendidos');
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// POST /api/produtos/vender
// Registra uma venda de produto vinculada a uma sessão ativa.
// Body esperado: { id_sessao, id_produto, quantidade }
// O trigger trg_atualiza_estoque deve diminuir o estoque automaticamente.
// O trigger trg_valida_estoque deve bloquear vendas com estoque insuficiente.
router.post('/vender', async (req, res) => {
    const { id_sessao, id_produto, quantidade } = req.body;
    if (!id_sessao || !id_produto || !quantidade)
        return res.status(400).json({ error: 'id_sessao, id_produto e quantidade são obrigatórios.' });
    try {
        const [prod] = await db.query('SELECT preco FROM produtos WHERE id_produto = ?', [id_produto]);
        if (prod.length === 0) {
            return res.status(404).json({ error: 'Produto não encontrado.' });
        }
        
        await db.query('INSERT INTO consumo (id_sessao, id_produto, quantidade, preco_unitario) VALUES (?, ?, ?, ?)', [id_sessao, id_produto, quantidade, prod[0].preco]);
        
        res.json({ message: 'Venda registrada.' });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
});

// POST /api/produtos
// Cadastra um novo produto (Alimentando o Estoque)
router.post('/', async (req, res) => {
    const { nome, descricao, categoria, preco, estoque } = req.body;
    if (!nome || preco === undefined) 
        return res.status(400).json({ error: 'Nome e preço são obrigatórios.' });
    
    try {
        const [result] = await db.query(
            'INSERT INTO produtos (nome, descricao, categoria, preco, estoque) VALUES (?, ?, ?, ?, ?)', 
            [nome, descricao || null, categoria || null, preco, estoque || 0]
        );
        res.json({ id: result.insertId, message: 'Produto cadastrado com sucesso.' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// POST /api/produtos/atualizar-estoque
// Atualiza a quantidade em estoque de um produto existente
router.post('/atualizar-estoque', async (req, res) => {
    const { id_produto, quantidade } = req.body;
    
    if (!id_produto || !quantidade || quantidade <= 0) {
        return res.status(400).json({ error: 'Produto e quantidade válida são obrigatórios.' });
    }

    try {
        await db.query('UPDATE produtos SET estoque = estoque + ? WHERE id_produto = ?', [quantidade, id_produto]);
        res.json({ message: 'Estoque atualizado com sucesso.' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;
