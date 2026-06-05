-- ============================================================
-- DDL: Criação do banco e das tabelas

CREATE DATABASE IF NOT EXISTS LanGames
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE LanGames;
SET NAMES utf8mb4;

-- Tabela de clientes
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    email VARCHAR(100) UNIQUE NOT NULL,
    data_nascimento DATE,
    telefone VARCHAR(20),
    saldo_creditos DECIMAL(8,2) DEFAULT 0.00,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de computadores disponíveis
CREATE TABLE computadores (
    id_computador INT PRIMARY KEY AUTO_INCREMENT,
    numero INT NOT NULL UNIQUE,
    nome_pc VARCHAR(50),
    descricao VARCHAR(100),
    status ENUM('disponivel','ocupado','manutencao') DEFAULT 'disponivel',
    valor_hora DECIMAL(6,2) NOT NULL DEFAULT 5.00
);

-- Tabela de sessões de uso
CREATE TABLE sessoes (
    id_sessao INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_computador INT NOT NULL,
    inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
    fim DATETIME,
    valor_total DECIMAL(8,2),
    status ENUM('aberta','fechada') DEFAULT 'aberta',
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_computador) REFERENCES computadores(id_computador)
);

-- Tabela de produtos
CREATE TABLE produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    categoria VARCHAR(50),
    preco DECIMAL(6,2) NOT NULL,
    quantidade INT,
    estoque INT NOT NULL DEFAULT 0
);

-- Tabela de consumo nas sessões
CREATE TABLE consumo (
    id_consumo INT PRIMARY KEY AUTO_INCREMENT,
    id_sessao INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    preco_unitario DECIMAL(6,2) NOT NULL,
    subtotal DECIMAL(8,2),
    data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_sessao) REFERENCES sessoes(id_sessao),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

-- Tabela de log financeiro
CREATE TABLE auditoria_caixa (
    id_auditoria INT PRIMARY KEY AUTO_INCREMENT,
    tipo ENUM('entrada','saida') NOT NULL,
    valor DECIMAL(8,2) NOT NULL,
    descricao VARCHAR(255),
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_sessao INT,
    FOREIGN KEY (id_sessao) REFERENCES sessoes(id_sessao)
);

-- Tabelas extras de torneios e inscrições
CREATE TABLE torneios (
    id_torneio INT PRIMARY KEY AUTO_INCREMENT,
    data_torneio DATETIME,
    taxa_inscricao DECIMAL(8,2),
    ganhador INT,
    FOREIGN KEY (ganhador) REFERENCES clientes(id_cliente)
);

CREATE TABLE inscricoes (
    id_inscricao INT PRIMARY KEY AUTO_INCREMENT,
    data_inscricao DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_pag ENUM('pendente', 'pago') DEFAULT 'pendente',
    id_torneio INT NOT NULL,
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_torneio) REFERENCES torneios(id_torneio),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);
