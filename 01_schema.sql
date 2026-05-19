CREATE DATABASE LanHouseGW; 
USE LanHouseGW; 
 
 
CREATE TABLE Clientes ( 
    ID_Cliente INT AUTO_INCREMENT PRIMARY KEY, 
    nome VARCHAR(100) NOT NULL, 
    email VARCHAR(100) UNIQUE NOT NULL, 
    telefone VARCHAR(20), 
    data_cadastro DATE NOT NULL 
); 
 
 
CREATE TABLE Computadores ( 
    ID_PC INT AUTO_INCREMENT PRIMARY KEY, 
    modelo VARCHAR(100) NOT NULL, 
    preco_hora DECIMAL(10,2) NOT NULL, 
    status ENUM('ativo','inativo','manutencao') DEFAULT 'ativo' 
); 
 
 
CREATE TABLE Sessoes ( 
    ID_Sessao INT AUTO_INCREMENT PRIMARY KEY, 
    ID_Cliente INT NOT NULL, 
    ID_PC INT NOT NULL, 
    inicio DATETIME NOT NULL, 
    fim DATETIME, 
    valor_total DECIMAL(10,2), 
    status_pag ENUM('pago','pendente') DEFAULT 'pendente', 
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente), 
    FOREIGN KEY (ID_PC) REFERENCES Computadores(ID_PC) 
); 
 
 
CREATE TABLE Produtos ( 
    ID_Produto INT AUTO_INCREMENT PRIMARY KEY, 
    nome VARCHAR(100) NOT NULL, 
    preco_venda DECIMAL(10,2) NOT NULL, 
    estoque INT NOT NULL 
); 
 
 
CREATE TABLE Consumo ( 
    ID_Consumo INT AUTO_INCREMENT PRIMARY KEY, 
    ID_Sessao INT NOT NULL, 
    ID_Produto INT NOT NULL, 
    quantidade INT NOT NULL, 
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (quantidade * (SELECT preco_venda FROM 
Produtos WHERE Produtos.ID_Produto = Consumo.ID_Produto)) STORED, 
    FOREIGN KEY (ID_Sessao) REFERENCES Sessoes(ID_Sessao), 
    FOREIGN KEY (ID_Produto) REFERENCES Produtos(ID_Produto) 
); 
 
 
CREATE TABLE Torneios ( 
    ID_Torneio INT AUTO_INCREMENT PRIMARY KEY, 
    nome VARCHAR(100) NOT NULL, 
    data DATE NOT NULL, 
    ID_Jogo INT, 
    premio VARCHAR(100) 
); 
 
 
CREATE TABLE Inscricoes ( 
    ID_Inscricao INT AUTO_INCREMENT PRIMARY KEY, 
    ID_Cliente INT NOT NULL, 
    ID_Torneio INT NOT NULL, 
    data_inscricao DATE NOT NULL, 
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente), 
    FOREIGN KEY (ID_Torneio) REFERENCES Torneios(ID_Torneio) 
); 
 
CREATE TABLE Audit_Log ( 
    ID_Log INT AUTO_INCREMENT PRIMARY KEY, 
    tabela_afetada VARCHAR(50) NOT NULL, 
    operacao ENUM('INSERT','UPDATE','DELETE') NOT NULL, 
    usuario VARCHAR(100), 
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
); --------------------------------------------------------------------------------------------------------------- 
 
 
CREATE TRIGGER trg_clientes_insert 
AFTER INSERT ON Clientes 
FOR EACH ROW 
BEGIN 
    INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
    VALUES ('Clientes', 'INSERT', USER()); 
END; 
 
CREATE TRIGGER trg_clientes_update 
AFTER UPDATE ON Clientes 
FOR EACH ROW 
BEGIN 
    INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
    VALUES ('Clientes', 'UPDATE', USER()); 
END; 
 
CREATE TRIGGER trg_clientes_delete 
AFTER DELETE ON Clientes 
FOR EACH ROW 
BEGIN 
    INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
    VALUES ('Clientes', 'DELETE', USER()); 
END; 
 
 
CREATE TRIGGER trg_computadores_insert 
AFTER INSERT ON Computadores 
FOR EACH ROW 
BEGIN 
    INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
    VALUES ('Computadores', 'INSERT', USER()); 
END; 
 
CREATE TRIGGER trg_computadores_update 
AFTER UPDATE ON Computadores 
FOR EACH ROW 
BEGIN 
    INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
    VALUES ('Computadores', 'UPDATE', USER()); 
END; 
 
CREATE TRIGGER trg_computadores_delete 
AFTER DELETE ON Computadores 
FOR EACH ROW 
BEGIN 
    INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
    VALUES ('Computadores', 'DELETE', USER()); 
END; 
 
CREATE TRIGGER trg_sessoes_insert 
AFTER INSERT ON Sessoes 
FOR EACH ROW 
BEGIN 
    INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
    VALUES ('Sessoes', 'INSERT', USER()); 
END; 
 
CREATE TRIGGER trg_sessoes_update 
AFTER UPDATE ON Sessoes 
FOR EACH ROW 
BEGIN 
    INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
    VALUES ('Sessoes', 'UPDATE', USER()); 
END; 
 
CREATE TRIGGER trg_sessoes_delete 
AFTER DELETE ON Sessoes 
FOR EACH ROW 
BEGIN 
    INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
    VALUES ('Sessoes', 'DELETE', USER()); 
END; 
 
 
CREATE TRIGGER trg_produtos_insert 
AFTER INSERT ON Produtos 
FOR EACH ROW 
BEGIN 
    INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
    VALUES ('Produtos', 'INSERT', USER()); 
END; 
 
CREATE TRIGGER trg_produtos_update 
AFTER UPDATE ON Produtos 
FOR EACH ROW 
BEGIN 
    INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
    VALUES ('Produtos', 'UPDATE', USER()); 
END; 
 
CREATE TRIGGER trg_produtos_delete 
AFTER DELETE ON Produtos 
FOR EACH ROW 
BEGIN 
    INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
    VALUES ('Produtos', 'DELETE', USER()); 
END; 
 
 
CREATE TRIGGER trg_consumo_insert 
AFTER INSERT ON Consumo 
FOR EACH ROW 
BEGIN 
    INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
    VALUES ('Consumo', 'INSERT', USER()); 
END; 
 
CREATE TRIGGER trg_consumo_update 
AFTER UPDATE ON Consumo 
FOR EACH ROW 
BEGIN 
    INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
    VALUES ('Consumo', 'UPDATE', USER()); 
END; 
 
CREATE TRIGGER trg_consumo_delete 
AFTER DELETE ON Consumo 
FOR EACH ROW 
BEGIN 
    INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
    VALUES ('Consumo', 'DELETE', USER()); 
END; 
 
CREATE TRIGGER trg_torneios_insert 
AFTER INSERT ON Torneios 
FOR EACH ROW 
BEGIN 
    INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
    VALUES ('Torneios', 'INSERT', USER()); 
END; 
 
CREATE TRIGGER trg_torneios_update 
AFTER UPDATE ON Torneios 
FOR EACH ROW 
BEGIN 
    INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
    VALUES ('Torneios', 'UPDATE', USER()); 
END; 
 
CREATE TRIGGER trg_torneios_delete 
AFTER DELETE ON Torneios 
FOR EACH ROW 
BEGIN 
    INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
    VALUES ('Torneios', 'DELETE', USER()); 
END; 
 
 
CREATE TRIGGER trg_inscricoes_insert 
AFTER INSERT ON Inscricoes 
FOR EACH ROW 
BEGIN 
INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
VALUES ('Inscricoes', 'INSERT', USER()); 
END; 
CREATE TRIGGER trg_inscricoes_update 
AFTER UPDATE ON Inscricoes 
FOR EACH ROW 
BEGIN 
INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
VALUES ('Inscricoes', 'UPDATE', USER()); 
END; 
CREATE TRIGGER trg_inscricoes_delete 
AFTER DELETE ON Inscricoes 
FOR EACH ROW 
BEGIN 
INSERT INTO Audit_Log (tabela_afetada, operacao, usuario) 
VALUES ('Inscricoes', 'DELETE', USER()); 
END; 