SELECT c.nome, 
       COUNT(s.ID_Sessao) AS qtd_sessoes,
       SUM(s.valor_total + IFNULL(cons.total_consumo,0)) AS faturamento
FROM Clientes c
JOIN Sessoes s ON c.ID_Cliente = s.ID_Cliente
LEFT JOIN (
    SELECT ID_Sessao, SUM(subtotal) AS total_consumo
    FROM Consumo
    GROUP BY ID_Sessao
) cons ON s.ID_Sessao = cons.ID_Sessao
GROUP BY c.ID_Cliente, c.nome
HAVING COUNT(s.ID_Sessao) > 1
ORDER BY faturamento DESC
LIMIT 5;

clientes sem nenhuma sessão registrada

SELECT c.nome, 
       c.email, 
       c.data_cadastro
FROM Clientes c
LEFT JOIN Sessoes s 
       ON c.ID_Cliente = s.ID_Cliente
WHERE s.ID_Sessao IS NULL;

Query para validar clientes sem sessão

SELECT c.nome, c.email, c.data_cadastro
FROM Clientes c
LEFT JOIN Sessoes s ON c.ID_Cliente = s.ID_Cliente
WHERE s.ID_Sessao IS NULL;

Query para validar produtos nunca consumidos

SELECT p.nome, p.preco_venda, p.estoque
FROM Produtos p
LEFT JOIN Consumo c ON p.ID_Produto = c.ID_Produto
WHERE c.ID_Consumo IS NULL;
