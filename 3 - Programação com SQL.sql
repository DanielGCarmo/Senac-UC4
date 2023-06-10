-- -----------------------------------------------------
# PROGRAMAÇÃO COM SQL: TRIGGERS, STORED PROCEDURES E STORED FUNCTIONS
-- -----------------------------------------------------

-- Para executar os exemplos desse conteúdo, execute o seguinte script SQL.
CREATE DATABASE senac_terrenos;

USE senac_terrenos;

CREATE TABLE vendedores (
   id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
   nome VARCHAR(25) NOT NULL
);

CREATE TABLE cidades (
   id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
   nome VARCHAR(25) NOT NULL,
   UF CHAR(2) NOT NULL,
   custo_metro_quadrado DECIMAL(6,2) NOT NULL
);

CREATE TABLE terrenos(
   id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
   id_cidade INT(6) UNSIGNED,
   largura DECIMAL(8,2) NOT NULL,
   comprimento DECIMAL(8,2) NOT NULL,
   vendido BOOL NOT NULL DEFAULT FALSE,
   FOREIGN KEY(id_cidade) REFERENCES cidades(id)
);

CREATE TABLE vendas(
   id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
   id_terreno INT(6) UNSIGNED,
   id_vendedor INT(6) UNSIGNED,
   vendido_em DATETIME NOT NULL,
   valor_total DECIMAL(24,2) NOT NULL,
   FOREIGN KEY(id_terreno) REFERENCES terrenos(id),
   FOREIGN KEY(id_vendedor) REFERENCES vendedores(id)
);

INSERT INTO vendedores(nome) VALUES ("Fulano");
INSERT INTO vendedores(nome) VALUES ("Ciclano");
INSERT INTO vendedores(nome) VALUES ("Beltrano");

INSERT INTO cidades (nome, UF, custo_metro_quadrado)
VALUES ("Porto Alegre", "RS", 6416.49);

INSERT INTO terrenos (id_cidade, largura, comprimento, vendido)
VALUES (1, 12, 4, false);

-- -----------------------------------------------------
-- Declarando variáveis
-- -----------------------------------------------------
DELIMITER $$
CREATE PROCEDURE buscar_resultado_prova ()
BEGIN
    DECLARE aluno VARCHAR(25) DEFAULT "Fulano";
    DECLARE id_prova INT UNSIGNED DEFAULT 12;
    DECLARE nota DECIMAL(3, 1) DEFAULT 9.5;
    DECLARE finalizada_em DATETIME DEFAULT "2022-01-14 10:32:35";
    SELECT aluno, id_prova, nota, finalizada_em;
END $$
DELIMITER ;

-- -----------------------------------------------------
-- Atribuindo novos valores a uma variável
-- -----------------------------------------------------
DELIMITER //
CREATE PROCEDURE buscar_nome_vendedor ()
BEGIN
    DECLARE variavel_nome VARCHAR(25);
    SELECT nome INTO variavel_nome FROM vendedores WHERE id = 1;  -- Com o comando INTO, é possível direcionar o valor de uma das colunas informadas no comando SELECT para uma variável local declarada.
    SELECT variavel_nome;  -- Nesse exemplo, declara-se a variável "variavel_nome", do tipo VARCHAR(25), direcionando o resultado da coluna "nome" para dentro da variável.
END//
DELIMITER ;

-- Além do comando INTO, também se admite a utilização do comando SET:
DELIMITER //
CREATE PROCEDURE buscar_nome_vendedor ()
BEGIN
    DECLARE variavel_nome VARCHAR(25);
    SET variavel_nome := (SELECT nome FROM vendedores WHERE id = 1);
    SELECT variavel_nome;
END//
DELIMITER ;

-- -----------------------------------------------------
-- Armazenando múltiplas colunas – Comando INTO
-- -----------------------------------------------------
