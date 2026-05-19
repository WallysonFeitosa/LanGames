-- CLIENTES 
INSERT INTO Clientes (nome, email, telefone, data_cadastro) 
VALUES ('Carlos Silva', 'carlos@email.com', '81999990001', '2026-01-10'); 
INSERT INTO Clientes (nome, email, telefone, data_cadastro) 
VALUES ('Ana Souza', 'ana@email.com', '81999990002', '2026-01-12'); 
INSERT INTO Clientes (nome, email, telefone, data_cadastro) 
VALUES ('Marcos Lima', 'marcos@email.com', '81999990003', '2026-01-15'); -- COMPUTADORES 
INSERT INTO Computadores (modelo, preco_hora, status) 
VALUES ('PC Gamer RTX 4060', 15.00, 'ativo'); 
INSERT INTO Computadores (modelo, preco_hora, status) 
VALUES ('PC Gamer RTX 4070', 20.00, 'ativo'); 
INSERT INTO Computadores (modelo, preco_hora, status) 
VALUES ('PC Básico i5', 10.00, 'manutencao'); -- PRODUTOS 
INSERT INTO Produtos (nome, preco_venda, estoque) 
VALUES ('Refrigerante', 6.50, 50); 
INSERT INTO Produtos (nome, preco_venda, estoque) 
VALUES ('Salgadinho', 8.00, 30); 
INSERT INTO Produtos (nome, preco_venda, estoque) 
VALUES ('Chocolate', 5.00, 40); -- TORNEIOS 
INSERT INTO Torneios (nome, data, ID_Jogo, premio) 
VALUES ('Campeonato CS2', '2026-06-20', 1, 'R$ 1.000'); 
INSERT INTO Torneios (nome, data, ID_Jogo, premio) 
VALUES ('Torneio FIFA', '2026-07-05', 2, 'Headset Gamer'); -- SESSOES 
INSERT INTO Sessoes (ID_Cliente, ID_PC, inicio, fim, valor_total, status_pag) 
VALUES (1, 1, '2026-05-01 14:00:00', '2026-05-01 16:00:00', 30.00, 'pago'); 
INSERT INTO Sessoes (ID_Cliente, ID_PC, inicio, fim, valor_total, status_pag) 
VALUES (2, 2, '2026-05-02 15:00:00', '2026-05-02 18:00:00', 60.00, 'pendente'); -- INSCRICOES 
INSERT INTO Inscricoes (ID_Cliente, ID_Torneio, data_inscricao) 
VALUES (1, 1, '2026-05-10'); 
INSERT INTO Inscricoes (ID_Cliente, ID_Torneio, data_inscricao) 
VALUES (2, 2, '2026-05-11'); -- ========================================= -- UPDATES -- ========================================= 
UPDATE Clientes 
SET telefone = '81988887777' 
WHERE ID_Cliente = 1; 
UPDATE Clientes 
SET nome = 'Ana Clara Souza' 
WHERE ID_Cliente = 2; 
UPDATE Clientes 
SET email = 'marcos.lima@email.com' 
WHERE ID_Cliente = 3; 
UPDATE Computadores 
SET status = 'inativo' 
WHERE ID_PC = 1; 
UPDATE Computadores 
SET preco_hora = 22.00 
WHERE ID_PC = 2; 
UPDATE Computadores 
SET status = 'ativo' 
WHERE ID_PC = 3; 
UPDATE Produtos 
SET estoque = 45 
WHERE ID_Produto = 1; 
UPDATE Produtos 
SET preco_venda = 9.50 
WHERE ID_Produto = 2; 
UPDATE Produtos 
SET nome = 'Chocolate Branco' 
WHERE ID_Produto = 3; 
UPDATE Sessoes 
SET status_pag = 'pago' 
WHERE ID_Sessao = 2; 
UPDATE Sessoes 
SET valor_total = 35.00 
WHERE ID_Sessao = 1; 
UPDATE Torneios 
SET premio = 'R$ 2.000' 
WHERE ID_Torneio = 1; 
UPDATE Torneios 
SET nome = 'Torneio FIFA 26' 
WHERE ID_Torneio = 2; 
UPDATE Inscricoes 
SET data_inscricao = '2026-05-15' 
WHERE ID_Inscricao = 1; 
UPDATE Inscricoes 
SET ID_Torneio = 1 
WHERE ID_Inscricao = 2; -- ========================================= -- DELETES -- ========================================= 
DELETE FROM Inscricoes 
WHERE ID_Inscricao = 1; 
DELETE FROM Inscricoes 
WHERE ID_Inscricao = 2; 
DELETE FROM Sessoes 
WHERE ID_Sessao = 1; 
DELETE FROM Sessoes 
WHERE ID_Sessao = 2; 
DELETE FROM Produtos 
WHERE ID_Produto = 3; 
DELETE FROM Produtos 
WHERE ID_Produto = 2; 
DELETE FROM Produtos 
WHERE ID_Produto = 1; 
DELETE FROM Computadores 
WHERE ID_PC = 3; 
DELETE FROM Computadores 
WHERE ID_PC = 2; 
DELETE FROM Computadores 
WHERE ID_PC = 1; 
DELETE FROM Torneios 
WHERE ID_Torneio = 2; 
DELETE FROM Torneios 
WHERE ID_Torneio = 1; 
DELETE FROM Clientes 
WHERE ID_Cliente = 3; 
DELETE FROM Clientes 
WHERE ID_Cliente = 2; 
DELETE FROM Clientes 
WHERE ID_Cliente = 1;