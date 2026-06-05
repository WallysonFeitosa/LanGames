-- ============================================================
-- Otimização com EXPLAIN e Índices

USE LanGames;

-- Diagnóstico inicial antes dos índices
EXPLAIN
SELECT s.id_sessao, cl.nome, co.numero, s.valor_total
FROM   sessoes s
JOIN   clientes     cl ON s.id_cliente    = cl.id_cliente
JOIN   computadores co ON s.id_computador = co.id_computador
WHERE  s.status = 'fechada'
ORDER  BY s.valor_total DESC;

-- Criação de índices para otimização
CREATE INDEX idx_status_sessoes ON sessoes(status);
CREATE INDEX idx_cliente_sessoes ON sessoes(id_cliente);
CREATE INDEX idx_computador_sessoes ON sessoes(id_computador);
CREATE INDEX idx_email_clientes ON clientes(email);

-- Diagnóstico após criação dos índices
EXPLAIN
SELECT s.id_sessao, cl.nome, co.numero, s.valor_total
FROM   sessoes s
JOIN   clientes     cl ON s.id_cliente    = cl.id_cliente
JOIN   computadores co ON s.id_computador = co.id_computador
WHERE  s.status = 'fechada'
ORDER  BY s.valor_total DESC;

-- Diagnóstico detalhado (JSON)
EXPLAIN FORMAT=JSON
SELECT cl.nome, COUNT(*) AS sessoes, SUM(s.valor_total) AS total
FROM   clientes cl
JOIN   sessoes s ON cl.id_cliente = s.id_cliente
WHERE  s.status = 'fechada'
GROUP  BY cl.id_cliente
HAVING total > 30
ORDER  BY total DESC;

-- Diagnóstico de query com subquery correlacionada
EXPLAIN
SELECT cl.nome,
       SUM(s.valor_total)                     AS total_gasto,
       (SELECT AVG(valor_total) FROM sessoes
        WHERE  status = 'fechada')             AS media_geral
FROM   clientes cl
JOIN   sessoes  s ON cl.id_cliente = s.id_cliente AND s.status = 'fechada'
GROUP  BY cl.id_cliente, cl.nome
HAVING total_gasto > (SELECT AVG(valor_total) FROM sessoes WHERE status = 'fechada')
ORDER  BY total_gasto DESC;

-- Exibe todos os índices criados no banco
SELECT TABLE_NAME, INDEX_NAME, COLUMN_NAME, NON_UNIQUE
FROM   INFORMATION_SCHEMA.STATISTICS
WHERE  TABLE_SCHEMA = 'LanGames'
ORDER  BY TABLE_NAME, INDEX_NAME;
