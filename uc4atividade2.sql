-- -----------------------------------------------------
-- Atividade 2
 -- -----------------------------------------------------
 
/* Contexto
-- Ainda no contexto do sistema para lojas, após os ajustes de segurança, observaram-se outras necessidades, para as quais devem ser criadas sub-rotinas em banco de dados (stored functions, stored procedures e triggers).*/
 
/* Atividade
Utilizando o banco de dados disponível no script em Conteúdos > Material complementar, realize as seguintes ações:
 
	1. Crie um stored procedure que receba  id de cliente, data inicial e data final e que mostre a lista de compras realizadas pelo referido cliente entre as datas informadas (incluindo essas datas), mostrando nome do cliente, id da compra, total, nome e quantidade de cada produto comprado. No script, inclua o código de criação e o comando de chamada da procedure.
	2. Crie uma stored function que receba id de cliente e retorne se o cliente é “PREMIUM” ou “REGULAR”. Um cliente é “PREMIUM” se já realizou mais de R$ 10 mil em compras nos últimos dois anos. Um cliente é “REGULAR” se ao contrário. No script, inclua o código de criação e o comando de chamada da function.
	3. Crie um trigger que atue sobre a tabela “usuário” de modo que, ao incluir um novo usuário, aplique automaticamente MD5() à coluna “senha”, utilize nesta atividade variáveis com New.

Dica: Para buscar entre datas solicitadas nas atividades você pode usar Between e o DATE_SUB().*/

/* Entrega
Envie, no local destinado à entrega da atividade, até a data indicada no cronograma de estudos, os scripts .sql com os comandos de criação e execução dos procedures, das functions e dos triggers desenvolvidos.*/

/* Dica de leitura
Para esta atividade, leia os seguintes materiais:
 
	* Programação com SQL
	* Segurança do banco de dados*/
 
/* Avaliação
Nesta atividade, você será avaliado nos indicadores:
 
	* Programa stored procedures em SQL de acordo com os requisitos do sistema.
	* Programa triggers em SQL de acordo com os requisitos do sistema.*/

USE uc4atividades;
DROP PROCEDURE IF EXISTS lista_compras_cliente;
DROP FUNCTION IF EXISTS tipo_cliente;

-- ----------------------------------------------------- 
-- 	1.	Crie um stored procedure que receba  id de cliente, data inicial e data final e que mostre a lista de compras realizadas pelo referido cliente entre as datas informadas (incluindo essas datas),
-- 		mostrando nome do cliente, id da compra, total, nome e quantidade de cada produto comprado.
-- 		No script, inclua o código de criação e o comando de chamada da procedure.
-- -----------------------------------------------------

-- Criação do stored procedure:
DELIMITER //
CREATE PROCEDURE lista_compras_cliente(
  IN cliente_id INT,
  IN data_inicial DATETIME,
  IN data_final DATETIME
)
BEGIN
  SELECT c.nome AS nome_cliente, v.id AS id_compra, v.valor_total,
         p.nome AS nome_produto, iv.quantidade
  FROM cliente c
  INNER JOIN venda v ON c.id = v.cliente_id
  INNER JOIN item_venda iv ON v.id = iv.venda_id
  INNER JOIN produto p ON iv.produto_id = p.id
  WHERE c.id = cliente_id
    AND v.data BETWEEN data_inicial AND data_final;
END //
DELIMITER ;

-- Chamar o stored procedure:
CALL lista_compras_cliente(1, '2022-01-01', '2023-12-31');

-- ----------------------------------------------------- 
-- 	2.	Crie uma stored function que receba id de cliente e retorne se o cliente é “PREMIUM” ou “REGULAR”.
-- 		Um cliente é “PREMIUM” se já realizou mais de R$ 10 mil em compras nos últimos dois anos. 
-- 		Um cliente é “REGULAR” se ao contrário.
-- 		No script, inclua o código de criação e o comando de chamada da function.
-- -----------------------------------------------------

-- Criação da stored function:
DELIMITER //
CREATE FUNCTION tipo_cliente(cliente_id INT) RETURNS VARCHAR(10) DETERMINISTIC
BEGIN
  DECLARE total_compras DECIMAL(9, 2);
  SET total_compras = (
    SELECT SUM(v.valor_total)
    FROM cliente c
    INNER JOIN venda v ON c.id = v.cliente_id
    WHERE c.id = cliente_id
      AND v.data >= DATE_SUB(NOW(), INTERVAL 2 YEAR)
  );
    IF total_compras > 10000 THEN
    RETURN 'PREMIUM';
  ELSE
    RETURN 'REGULAR';
  END IF;
END //
DELIMITER ;

-- Chamar a stored function:
SELECT tipo_cliente(1); -- Onde "1" é o ID do cliente.

-- ----------------------------------------------------- 
-- 	3. Crie um trigger que atue sobre a tabela “usuário” de modo que, ao incluir um novo usuário, aplique automaticamente MD5() à coluna “senha”, utilize nesta atividade variáveis com New.
-- -----------------------------------------------------

DELIMITER //
CREATE TRIGGER hash_senha BEFORE INSERT ON usuario
FOR EACH ROW
BEGIN
  SET NEW.senha = MD5(NEW.senha);
END //
DELIMITER ;