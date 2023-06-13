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
    SELECT nome INTO variavel_nome FROM vendedores WHERE id = 1;	-- Com o comando INTO, é possível direcionar o valor de uma das colunas informadas no comando SELECT para uma variável local declarada.
    SELECT variavel_nome; 											-- Nesse exemplo, declara-se a variável "variavel_nome", do tipo VARCHAR(25), direcionando o resultado da coluna "nome" para dentro da variável.
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

DELIMITER //
CREATE PROCEDURE buscar_dados_vendedor ()
BEGIN
    DECLARE v_nome VARCHAR(25);
    DECLARE v_email VARCHAR(255);
    SELECT nome, email INTO v_nome, v_email 
        FROM vendedores WHERE id = 1;
    SELECT v_nome, v_email;
END//
DELIMITER ;

-- -----------------------------------------------------
-- Declarando variáveis de usuário
-- -----------------------------------------------------

SET @ola = "Olá mundo";
SELECT @ola;

SELECT @variavelInexistente;

-- -----------------------------------------------------
-- Atribuindo novos valores a variáveis de usuário
-- -----------------------------------------------------

SET @ola = "Hello world";
SELECT @ola;

-- Também se pode armazenar resultados de consultas em variáveis de usuário
SELECT id, nome INTO @v_id, @v_nome 
FROM vendedores 
WHERE id = 1;

-- Armazene o valor de uma consulta por meio do comando SET:
SET @v_nome := (SELECT nome FROM vendedores WHERE id = 1);  

-- -----------------------------------------------------
-- Condicional
-- -----------------------------------------------------

-- IF statement

DELIMITER $$
CREATE PROCEDURE buscar_terrenos (id_vendedor INT)
BEGIN
    DECLARE id_encontrado INT;
    SELECT id INTO id_encontrado FROM vendedores 
        WHERE id = id_vendedor;
    IF id_encontrado IS NULL THEN -- IF = "se" / THEN = "então"
        SELECT "Sem acesso";
    ELSE -- ELSE = "senão"
        SELECT * FROM terrenos;
    END IF; -- END IF = "fim se"
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE buscar_comissao (id_vendedor INT)
BEGIN
    DECLARE comissao DECIMAL(2,1) DEFAULT 1.0;
    DECLARE nome_vendedor VARCHAR(25);
    SELECT nome INTO nome_vendedor
        FROM vendedores
        WHERE id = id_vendedor;
        IF nome_vendedor = "Fulano" THEN
        SET comissao := 1.3;
    ELSEIF nome_vendedor = "Ciclano" THEN -- ELSEIF = "senão" e "se", respectivamente.
        SET comissao := 1.2;
    ELSE
        SET comissao := 1.1;
    END IF; -- 
    SELECT comissao;
END$$
DELIMITER ;

-- -----------------------------------------------------
-- Laço de repetição WHILE (enquanto)
-- -----------------------------------------------------

DELIMITER $$
CREATE PROCEDURE inserindo_vendedores ()
BEGIN
    DECLARE v1 INT DEFAULT 5;
    WHILE v1 > 0 DO -- WHILE = enquanto / DO = fazer
        INSERT INTO vendedores (nome)
            VALUES (CONCAT("Vendedor ", v1));
        SET v1 = v1 - 1;
    END WHILE; -- = fim enquanto
END$$
DELIMITER ;

-- -----------------------------------------------------
-- Stored procedures
-- -----------------------------------------------------

DELIMITER //
CREATE PROCEDURE minha_procedure ()
BEGIN
    DECLARE variavel INT DEFAULT 15;
    SELECT variavel;
END//
DELIMITER ;

-- Nomes únicos / não se pode executar duas vezes / para atualizar, deve-se antes excluí-lo:
DROP PROCEDURE minha_procedure;

-- Parâmetros:
DELIMITER //
CREATE PROCEDURE soma1 (INOUT numero INT) -- INOUT Parâmetro de entrada e de saída
BEGIN
    SET numero := numero + 1;
END//
DELIMITER ;

SET @numero := 2;
CALL soma1(@numero);
SELECT @numero;

DROP PROCEDURE buscar_nome_vendedor;

DELIMITER //
CREATE PROCEDURE buscar_nome_vendedor (
    id_vendedor INT,
    OUT nome_vendedor VARCHAR(25)
)
BEGIN
    SELECT nome INTO nome_vendedor
        FROM vendedores
    WHERE id = id_vendedor;
END//
DELIMITER ;


-- Executando um stored procedure
CALL buscar_nome_vendedor(1, @meu_vendedor);

-- -----------------------------------------------------
-- EXERCÍCIOS
-- -----------------------------------------------------
-- Crie um stored procedure que liste os top 10 dos vendedores que realizaram mais vendas em um dado período.
-- A lista deverá apresentar o nome do vendedor e o total de vendas realizadas, além de estar ordenada pelo maior número de vendas.

DELIMITER //
CREATE PROCEDURE TopVendedores(IN data_inicio DATE, IN data_fim DATE)
BEGIN
    SELECT vendedores.nome, COUNT(vendas.id) AS total_vendas
    FROM vendedores
    JOIN vendas ON vendedores.id = vendas.id_vendedor
    WHERE vendas.vendido_em BETWEEN data_inicio AND data_fim
    GROUP BY vendedores.id
    ORDER BY total_vendas DESC
    LIMIT 10;
END //
DELIMITER ;

CALL TopVendedores('2023-01-01', '2023-06-30');

-- Crie ao menos um dos stored procedures da seção “IF statement” e o procedure da seção “While”, do subtítulo “Laço de repetição”, deste conteúdo.
DROP PROCEDURE minha_procedure_if;
DROP PROCEDURE inserindo_vendedores;
DELIMITER //

-- Stored procedure da seção "IF statement"
CREATE PROCEDURE minha_procedure_if ()
BEGIN
    DECLARE numero INT DEFAULT 1;
    IF numero = 1 THEN
        SET numero := 2;
    END IF;
    SELECT numero;
END //

-- Stored procedure da seção "WHILE"
CREATE PROCEDURE inserindo_vendedores ()
BEGIN
    DECLARE v1 INT DEFAULT 5;
    WHILE v1 > 0 DO
        INSERT INTO vendedores (nome)
            VALUES (CONCAT("Vendedor ", v1));
        SET v1 = v1 - 1;
    END WHILE;
END //

DELIMITER ;

-- Chamada do stored procedure "minha_procedure_if"
CALL minha_procedure_if();

-- Chamada do stored procedure "inserindo_vendedores"
CALL inserindo_vendedores();

-- -----------------------------------------------------
-- Stored functions
-- -----------------------------------------------------

DELIMITER //
CREATE FUNCTION buscar_preco (
    id_terreno INT
) RETURNS DECIMAL(24,2) DETERMINISTIC
BEGIN
    DECLARE v_custo_m2 DECIMAL(6,2);
    DECLARE v_largura INT;
    DECLARE v_comprimento INT;
    SELECT c.custo_metro_quadrado, t.largura, t.comprimento
    INTO v_custo_m2, v_largura, v_comprimento
    FROM terrenos t
        LEFT JOIN cidades c ON c.id = t.id_cidade
    WHERE t.id = id_terreno;
    RETURN (v_comprimento * v_largura) * v_custo_m2;
END//
DELIMITER ;

-- Executando uma stored function
SELECT buscar_preco(1);

INSERT INTO vendas (
    id_terreno,
    id_vendedor,
    vendido_em,
    valor_total
) values (1, 1, "2022-02-07 10:00:00", buscar_preco(1));

-- -----------------------------------------------------
-- EXERCÍCIOS
-- -----------------------------------------------------

-- Crie uma função que retorne o valor total de uma venda específica, descontando 10%.
DELIMITER //
CREATE FUNCTION CalcularValorTotalComDesconto(
    venda_id INT
) RETURNS DECIMAL(24,2) DETERMINISTIC
BEGIN
    DECLARE valor_total DECIMAL(24,2);
    SELECT valor_total INTO valor_total
    FROM vendas
    WHERE id = venda_id;
    SET valor_total = valor_total * 0.9;
    RETURN valor_total;
END //
DELIMITER ;

SELECT CalcularValorTotalComDesconto(1); -- Lembre-se de ajustar o número "1" para o ID da venda específica que você deseja calcular o valor com desconto.

-- Adapte o código do procedure "buscar_nome_vendedor()" para que seja declarado como uma stored function.
DELIMITER //
CREATE FUNCTION BuscarNomeVendedor(
    id_vendedor INT
) RETURNS VARCHAR(25) DETERMINISTIC
BEGIN
    DECLARE nome_vendedor VARCHAR(25);
    SELECT nome INTO nome_vendedor
    FROM vendedores
    WHERE id = id_vendedor;
    RETURN nome_vendedor;
END //
DELIMITER ;

SELECT BuscarNomeVendedor(1); -- Lembre-se de ajustar o número "1" para o ID do vendedor que você deseja buscar o nome.

-- -----------------------------------------------------
-- Triggers (gatilhos)
-- -----------------------------------------------------

-- Criando um trigger
DELIMITER //
CREATE TRIGGER marcar_venda AFTER INSERT -- criar uma TRIGGER "depois de" INSERT
ON vendas -- qual tabela o gatilho estará observando
FOR EACH ROW -- "para cada linha"
BEGIN
    UPDATE terrenos
    SET vendido = true
    WHERE id = NEW.id_terreno; -- id_terreno" do novo registro inserido
END// -- 
DELIMITER ;

-- -----------------------------------------------------
-- EXERCÍCIO
-- -----------------------------------------------------

-- Crie um trigger que adicione uma comissão de 10% ao valor total de uma venda antes da inserção de um registro na tabela "vendas".
DELIMITER //
CREATE TRIGGER AdicionarComissao BEFORE INSERT
ON vendas
FOR EACH ROW
BEGIN
    SET NEW.valor_total = NEW.valor_total * 1.1;
END //
DELIMITER ;