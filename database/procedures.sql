-- ============================================================
-- Functions, Procedures, Triggers e Views

USE LanGames;
SET NAMES utf8mb4;

DELIMITER //

-- Função para calcular a duração em minutos entre duas datas
CREATE FUNCTION fn_duracao_minutos(p_inicio DATETIME, p_fim DATETIME)
RETURNS INT DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(MINUTE, p_inicio, p_fim);
END //

-- Função para calcular o valor cobrado com base na duração e valor da hora
CREATE FUNCTION fn_calcular_valor(p_inicio DATETIME, p_fim DATETIME, p_valor_hora DECIMAL(6,2))
RETURNS DECIMAL(8,2) DETERMINISTIC
BEGIN
    DECLARE v_minutos INT;
    SET v_minutos = fn_duracao_minutos(p_inicio, p_fim);
    RETURN ROUND((v_minutos / 60.0) * p_valor_hora, 2);
END //

-- Procedure para abrir uma nova sessão
CREATE PROCEDURE sp_abrir_sessao(IN p_id_cliente INT, IN p_id_computador INT)
BEGIN
    DECLARE v_status VARCHAR(20);
    
    SELECT status INTO v_status FROM computadores WHERE id_computador = p_id_computador;
    
    IF v_status != 'disponivel' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Computador não está disponível.';
    END IF;
    
    START TRANSACTION;
        INSERT INTO sessoes (id_cliente, id_computador, inicio, status) 
        VALUES (p_id_cliente, p_id_computador, NOW(), 'aberta');
        
        UPDATE computadores SET status = 'ocupado' WHERE id_computador = p_id_computador;
    COMMIT;
END //

-- Procedure para fechar uma sessão ativa e realizar cobranças
CREATE PROCEDURE sp_fechar_sessao(IN p_id_sessao INT)
BEGIN
    DECLARE v_inicio DATETIME;
    DECLARE v_id_computador INT;
    DECLARE v_valor_hora DECIMAL(6,2);
    DECLARE v_status_sessao VARCHAR(20);
    DECLARE v_valor_sessao DECIMAL(8,2);
    DECLARE v_valor_consumo DECIMAL(8,2);
    DECLARE v_valor_total DECIMAL(8,2);
    
    SELECT inicio, id_computador, status INTO v_inicio, v_id_computador, v_status_sessao 
    FROM sessoes WHERE id_sessao = p_id_sessao;
    
    IF v_status_sessao IS NULL OR v_status_sessao != 'aberta' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sessão não encontrada ou já encerrada.';
    END IF;
    
    SELECT valor_hora INTO v_valor_hora FROM computadores WHERE id_computador = v_id_computador;
    SET v_valor_sessao = fn_calcular_valor(v_inicio, NOW(), v_valor_hora);
    SELECT COALESCE(SUM(subtotal), 0) INTO v_valor_consumo FROM consumo WHERE id_sessao = p_id_sessao;
    SET v_valor_total = v_valor_sessao + v_valor_consumo;
    
    START TRANSACTION;
        UPDATE sessoes SET fim = NOW(), valor_total = v_valor_total, status = 'fechada' WHERE id_sessao = p_id_sessao;
        UPDATE computadores SET status = 'disponivel' WHERE id_computador = v_id_computador;
    COMMIT;
END //

-- Trigger para registrar entrada no caixa ao fechar uma sessão
CREATE TRIGGER trg_auditoria_sessao
AFTER UPDATE ON sessoes
FOR EACH ROW
BEGIN
    IF NEW.status = 'fechada' AND OLD.status = 'aberta' THEN
        INSERT INTO auditoria_caixa (tipo, valor, descricao, id_sessao)
        VALUES ('entrada', NEW.valor_total, CONCAT('Sessão #', NEW.id_sessao, ' encerrada – cliente ', NEW.id_cliente), NEW.id_sessao);
    END IF;
END //

-- Trigger para reduzir o estoque ao registrar consumo
CREATE TRIGGER trg_atualiza_estoque
AFTER INSERT ON consumo
FOR EACH ROW
BEGIN
    UPDATE produtos SET estoque = estoque - NEW.quantidade WHERE id_produto = NEW.id_produto;
END //

-- Trigger para impedir vendas sem estoque suficiente e calcular subtotal
CREATE TRIGGER trg_valida_estoque
BEFORE INSERT ON consumo
FOR EACH ROW
BEGIN
    DECLARE v_estoque INT;
    SELECT estoque INTO v_estoque FROM produtos WHERE id_produto = NEW.id_produto;
    IF v_estoque < NEW.quantidade THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estoque insuficiente para a venda.';
    END IF;
    SET NEW.subtotal = NEW.quantidade * NEW.preco_unitario;
END //

-- Trigger para registrar saída no caixa ao cadastrar um novo produto com estoque
CREATE TRIGGER trg_compra_produto_novo
AFTER INSERT ON produtos
FOR EACH ROW
BEGIN
    IF NEW.estoque > 0 THEN
        INSERT INTO auditoria_caixa (tipo, valor, descricao)
        VALUES ('saida', NEW.preco * NEW.estoque, CONCAT('Compra de estoque inicial: ', NEW.nome));
    END IF;
END //

-- Trigger para registrar saída no caixa ao repor o estoque de um produto existente
CREATE TRIGGER trg_reposicao_estoque
AFTER UPDATE ON produtos
FOR EACH ROW
BEGIN
    IF NEW.estoque > OLD.estoque THEN
        INSERT INTO auditoria_caixa (tipo, valor, descricao)
        VALUES ('saida', (NEW.estoque - OLD.estoque) * NEW.preco, CONCAT('Reposição de estoque: ', NEW.nome));
    END IF;
END //

-- Trigger para registrar entrada no caixa ao criar inscrição já paga
CREATE TRIGGER trg_inscricao_paga_insert
AFTER INSERT ON inscricoes
FOR EACH ROW
BEGIN
    DECLARE v_taxa DECIMAL(8,2);
    IF NEW.status_pag = 'pago' THEN
        SELECT taxa_inscricao INTO v_taxa FROM torneios WHERE id_torneio = NEW.id_torneio;
        INSERT INTO auditoria_caixa (tipo, valor, descricao)
        VALUES ('entrada', v_taxa, CONCAT('Pagamento de inscrição - Torneio #', NEW.id_torneio, ' - Cliente #', NEW.id_cliente));
    END IF;
END //

-- Trigger para registrar entrada no caixa ao atualizar inscrição para paga
CREATE TRIGGER trg_inscricao_paga_update
AFTER UPDATE ON inscricoes
FOR EACH ROW
BEGIN
    DECLARE v_taxa DECIMAL(8,2);
    IF NEW.status_pag = 'pago' AND OLD.status_pag != 'pago' THEN
        SELECT taxa_inscricao INTO v_taxa FROM torneios WHERE id_torneio = NEW.id_torneio;
        INSERT INTO auditoria_caixa (tipo, valor, descricao)
        VALUES ('entrada', v_taxa, CONCAT('Pagamento de inscrição - Torneio #', NEW.id_torneio, ' - Cliente #', NEW.id_cliente));
    END IF;
END //

DELIMITER ;

-- View para listar sessões ativas
CREATE VIEW vw_sessoes_ativas AS
SELECT 
    s.id_sessao, 
    cl.nome AS cliente, 
    co.numero AS computador, 
    co.descricao AS descricao_computador, 
    s.inicio, 
    TIMESTAMPDIFF(MINUTE, s.inicio, NOW()) AS minutos_em_uso, 
    (fn_calcular_valor(s.inicio, NOW(), co.valor_hora) + 
     COALESCE((SELECT SUM(subtotal) FROM consumo WHERE id_sessao = s.id_sessao), 0)) AS valor_parcial
FROM sessoes s
JOIN clientes cl ON s.id_cliente = cl.id_cliente
JOIN computadores co ON s.id_computador = co.id_computador
WHERE s.status = 'aberta';

-- View para listar o ranking de clientes por gasto
CREATE VIEW vw_ranking_clientes AS
SELECT 
    cl.id_cliente, 
    cl.nome, 
    COUNT(s.id_sessao) AS total_sessoes, 
    COALESCE(SUM(s.valor_total), 0) AS total_gasto, 
    COALESCE(AVG(s.valor_total), 0) AS gasto_medio
FROM clientes cl
LEFT JOIN sessoes s ON cl.id_cliente = s.id_cliente AND s.status = 'fechada'
GROUP BY cl.id_cliente, cl.nome
ORDER BY total_gasto DESC;

-- View para listar os produtos mais vendidos
CREATE VIEW vw_produtos_mais_vendidos AS
SELECT 
    p.nome, 
    p.categoria, 
    COALESCE(SUM(c.quantidade), 0) AS total_vendido, 
    COALESCE(SUM(c.subtotal), 0) AS receita_total
FROM produtos p
JOIN consumo c ON p.id_produto = c.id_produto
GROUP BY p.id_produto, p.nome, p.categoria
ORDER BY total_vendido DESC;

-- View para consolidar totais do caixa
CREATE VIEW vw_caixa_totais AS
SELECT 
    COALESCE(SUM(CASE WHEN tipo = 'entrada' THEN valor ELSE 0 END), 0) AS total_entrada,
    COALESCE(SUM(CASE WHEN tipo = 'saida' THEN valor ELSE 0 END), 0) AS total_saida,
    COALESCE(SUM(CASE WHEN tipo = 'entrada' THEN valor ELSE -valor END), 0) AS saldo
FROM auditoria_caixa;
