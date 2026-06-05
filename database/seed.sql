-- ============================================================
-- Criação de dados iniciais do banco
USE LanGames;
SET NAMES utf8mb4;

-- Insere computadores iniciais
INSERT INTO computadores (numero, nome_pc, descricao, valor_hora) VALUES 
(1, 'Alpha', 'PC Gamer RTX 4070, 32GB RAM', 12.00),
(2, 'Beta', 'PC Gamer RTX 4060, 16GB RAM', 10.00),
(3, 'Gamma', 'PC Standard GTX 1660, 16GB RAM', 7.00),
(4, 'Delta', 'PC Standard GTX 1650, 8GB RAM', 5.00),
(5, 'Epsilon', 'PC Pro RTX 4080, 64GB RAM', 15.00),
(6, 'Zeta', 'PC Pro RTX 4090, 64GB RAM', 20.00);

-- Insere clientes iniciais
INSERT INTO clientes (nome, cpf, email, data_nascimento, telefone, saldo_creditos) VALUES 
('João Silva', '111.111.111-11', 'joao@email.com', '1995-05-10', '11999999991', 50.00),
('Maria Oliveira', '222.222.222-22', 'maria@email.com', '1998-02-15', '11999999992', 15.00),
('Carlos Souza', '333.333.333-33', 'carlos@email.com', '2001-08-22', '11999999993', 0.00),
('Ana Costa', '444.444.444-44', 'ana@email.com', '2003-11-30', '11999999994', 100.00),
('Lucas Mendes', '555.555.555-55', 'lucas@email.com', '1990-12-05', '11999999995', 10.00);

-- Insere produtos iniciais
INSERT INTO produtos (nome, descricao, categoria, preco, estoque) VALUES 
('Coca-Cola Lata', 'Refrigerante 350ml', 'Bebidas', 5.00, 100),
('Água Mineral', 'Garrafa 500ml', 'Bebidas', 3.00, 50),
('Doritos', 'Salgadinho 90g', 'Snacks', 8.00, 30),
('Misto Quente', 'Pão de forma, presunto e queijo', 'Lanches', 12.00, 20),
('Cabo USB-C', 'Cabo carregador 1m', 'Acessorios', 25.00, 10);

-- Insere sessões históricas fechadas
INSERT INTO sessoes (id_cliente, id_computador, inicio, fim, valor_total, status) VALUES 
(1, 1, '2024-05-01 14:00:00', '2024-05-01 16:30:00', 30.00, 'fechada'),
(2, 2, '2024-05-01 15:00:00', '2024-05-01 16:00:00', 10.00, 'fechada'),
(3, 3, '2024-05-02 10:00:00', '2024-05-02 12:00:00', 14.00, 'fechada'),
(4, 4, '2024-05-02 13:00:00', '2024-05-02 15:30:00', 12.50, 'fechada'),
(5, 5, '2024-05-03 18:00:00', '2024-05-03 20:00:00', 30.00, 'fechada'),
(1, 6, '2024-05-04 20:00:00', '2024-05-04 23:00:00', 60.00, 'fechada');

-- Insere histórico de consumo nas sessões
INSERT INTO consumo (id_sessao, id_produto, quantidade, preco_unitario, subtotal) VALUES 
(1, 1, 2, 5.00, 10.00),
(1, 3, 1, 8.00, 8.00),
(3, 2, 1, 3.00, 3.00),
(5, 4, 1, 12.00, 12.00),
(6, 1, 3, 5.00, 15.00);

-- Insere histórico de fluxo de caixa
INSERT INTO auditoria_caixa (tipo, valor, descricao, data_hora, id_sessao) VALUES 
('entrada', 30.00, 'Sessão #1 encerrada – cliente 1', '2024-05-01 16:30:00', 1),
('entrada', 10.00, 'Sessão #2 encerrada – cliente 2', '2024-05-01 16:00:00', 2),
('entrada', 14.00, 'Sessão #3 encerrada – cliente 3', '2024-05-02 12:00:00', 3),
('entrada', 12.50, 'Sessão #4 encerrada – cliente 4', '2024-05-02 15:30:00', 4),
('entrada', 30.00, 'Sessão #5 encerrada – cliente 5', '2024-05-03 20:00:00', 5),
('entrada', 60.00, 'Sessão #6 encerrada – cliente 1', '2024-05-04 23:00:00', 6),
('saida', 150.00, 'Reposição de estoque de bebidas e snacks', '2024-05-05 10:00:00', NULL);

-- Insere dados de torneios e inscrições
INSERT INTO torneios (data_torneio, taxa_inscricao, ganhador) VALUES 
('2024-06-15 14:00:00', 50.00, NULL);

INSERT INTO inscricoes (id_torneio, id_cliente, status_pag) VALUES 
(1, 1, 'pago'),
(1, 4, 'pendente');
