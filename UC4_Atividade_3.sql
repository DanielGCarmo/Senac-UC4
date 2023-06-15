-- -----------------------------------------------------
-- Atividade 3
-- -----------------------------------------------------

/* Contexto
Percebe-se que o banco de dados para o sistema de lojas enfrenta alguns “gargalos” de desempenho, de modo que as operações no sistema estão demorando mais do que o esperado – algumas delas acontecem com frequência. Você tem a tarefa de propor melhorias a algumas dessas consultas, tornando-as mais eficientes.*/
 
/* Atividade
Utilizando o banco de dados proposto para as atividades, realize as consultas expostas no arquivo UC4_Atividade_3_Script_consultas.

Para cada consulta presente no script, faça o seguinte:
 
	1. Execute o comando EXPLAIN mostrando detalhes da execução da consulta.
	2. Realize ajustes de otimização nas consultas utilizando JOINs entre as tabelas assim como removendo os asteriscos ( * ) e definindo quais colunas devem ser retornadas de cada consulta afim de otimiza-la.
	3. Crie índices que possam se beneficiar do recurso para melhorar o desempenho das consultas, considerando principalmente colunas utilizadas nas cláusulas WHERE.
	4. Execute novamente o comando EXPLAIN mostrando agora os detalhes da execução da consulta, depois das otimizações realizadas.
	5. Crie uma VIEW para cada uma das consultas ajustadas com JOINS.
	6. Armazene as consultas ajustadas e os demais comandos em scripts .sql para entrega. Utilize comentários para organizar e explicar seus scripts.*/
 
/* Dica de leitura
Para esta atividade, leia os seguintes materiais:

	* “Visão” (view): conceito, comandos de criação e manipulação, aplicação
	* Índices (index)
	* Desempenho de banco de dados: monitoramento e gerenciamento, detecção de “gargalos” de desempenho, tuning e otimização de consultas, particionamento, escalabilidade do banco de dados.*/
 
/* Avaliação
Nesta atividade, você será avaliado nos indicadores:

	* Monitora desempenho do sistema de gerenciamento de banco de dados de acordo com os parâmetros definidos para o sistema.
	* Otimiza, sob supervisão, o desempenho de consultas SQL de acordo com ferramentas de banco de dados e parâmetros de desempenho definidos para o software.
	* Aplica índices em tabelas de banco de dados, de acordo com ferramentas de banco de dados e parâmetros de desempenho definidos para o software.*/

-- -----------------------------------------------------

USE uc4atividades;

-- -----------------------------------------------------
-- 1. Execute o comando EXPLAIN mostrando detalhes da execução da consulta e tire um print.
-- -----------------------------------------------------

-- Consulta para um relatório de todas as vendas pagas em dinheiro:
EXPLAIN
SELECT *
FROM venda v, item_venda iv, produto p, cliente c, funcionario f
WHERE v.id = iv.venda_id AND c.id = v.cliente_id AND p.id = iv.produto_id AND f.id = v.funcionario_id AND tipo_pagamento = 'D';
-- Explicação:
	-- A consulta utiliza as tabelas "venda", "item_venda", "produto", "cliente" e "funcionario".
	-- A condição WHERE filtra as vendas pagas em dinheiro.
	-- O comando EXPLAIN irá fornecer informações sobre a execução da consulta, como a ordem de leitura das tabelas, o uso de índices e outras estatísticas relevantes.

-- Consulta para encontrar todas as vendas de produtos de um dado fabricante:
EXPLAIN
SELECT *
FROM produto p, item_venda iv, venda v
WHERE p.id = iv.produto_id AND v.id = iv.venda_id AND p.fabricante LIKE '%lar%'
ORDER BY p.nome;
-- Explicação:
	-- A consulta utiliza as tabelas "produto", "item_venda" e "venda".
	-- A condição WHERE filtra os produtos de um dado fabricante (utilizando o operador LIKE com um curinga '%').
	-- A ordenação é feita pelo nome do produto.
	-- O comando EXPLAIN irá fornecer informações sobre a execução da consulta, como a ordem de leitura das tabelas, o uso de índices e outras estatísticas relevantes.

-- Relatório de vendas de produto por cliente:
EXPLAIN
SELECT SUM(iv.subtotal), SUM(iv.quantidade)
FROM produto p, item_venda iv, venda v, cliente c
WHERE p.id = iv.produto_id AND v.id = iv.venda_id AND c.id = v.cliente_id
GROUP BY c.nome, p.nome;
-- Explicação:
	-- A consulta utiliza as tabelas "produto", "item_venda", "venda" e "cliente".
	-- A condição WHERE estabelece as relações entre as tabelas.
	-- A função de agregação SUM é utilizada para calcular o valor total e a quantidade total de vendas por produto e cliente.
	-- A cláusula GROUP BY agrupa os resultados por nome do cliente e nome do produto.
	-- O comando EXPLAIN irá fornecer informações sobre a execução da consulta, como a ordem de leitura das tabelas, o uso de índices e outras estatísticas relevantes.

-- -----------------------------------------------------
-- 2. Realize ajustes de otimização nas consultas utilizando JOINs entre as tabelas assim como removendo os asteriscos ( * ) e definindo quais colunas devem ser retornadas de cada consulta afim de otimiza-la.
-- -----------------------------------------------------

-- Consulta para um relatório de todas as vendas pagas em dinheiro:
EXPLAIN
SELECT v.id, v.data, v.valor_total, p.nome AS nome_produto, iv.quantidade, iv.valor_unitario, c.nome AS nome_cliente, c.cpf, c.telefone
FROM venda v
JOIN item_venda iv ON v.id = iv.venda_id
JOIN produto p ON p.id = iv.produto_id
JOIN cliente c ON c.id = v.cliente_id
JOIN funcionario f ON f.id = v.funcionario_id
WHERE v.tipo_pagamento = 'D'
ORDER BY v.data DESC;
-- Explicação:
	-- Utilizou-se o operador JOIN para unir as tabelas relacionadas.
	-- Especificou-se as colunas a serem retornadas, evitando o uso do asterisco (*).
	-- Utilizou-se aliases para renomear as colunas, tornando o resultado mais legível.
	-- A condição WHERE filtra as vendas pagas em dinheiro.
	-- A ordenação é feita pela data de venda, das mais recentes para as mais antigas.

-- Consulta para encontrar todas as vendas de produtos de um dado fabricante:
EXPLAIN
SELECT p.nome AS nome_produto, iv.quantidade, v.data
FROM produto p
JOIN item_venda iv ON p.id = iv.produto_id
JOIN venda v ON v.id = iv.venda_id
WHERE p.fabricante LIKE '%lar%'
ORDER BY p.nome;
-- Explicação:
	-- Utilizou-se o operador JOIN para unir as tabelas relacionadas.
	-- Especificou-se as colunas a serem retornadas, evitando o uso do asterisco (*).
	-- Utilizou-se aliases para renomear as colunas, tornando o resultado mais legível.
	-- A condição WHERE filtra os produtos de um dado fabricante.
	-- A ordenação é feita pelo nome do produto.

-- Relatório de vendas de produto por cliente:
EXPLAIN
SELECT c.nome AS nome_cliente, p.nome AS nome_produto, SUM(iv.subtotal) AS valor_total_venda, SUM(iv.quantidade) AS quantidade_total_venda
FROM produto p
JOIN item_venda iv ON p.id = iv.produto_id
JOIN venda v ON v.id = iv.venda_id
JOIN cliente c ON c.id = v.cliente_id
GROUP BY c.nome, p.nome;
-- Explicação:
	-- Utilizou-se o operador JOIN para unir as tabelas relacionadas.
	-- Especificou-se as colunas a serem retornadas, evitando o uso do asterisco (*).
	-- Utilizou-se aliases para renomear as colunas, tornando o resultado mais legível.
	-- A função de agregação SUM é utilizada para calcular o valor total e a quantidade total de vendas por produto e cliente.
	-- A cláusula GROUP BY agrupa os resultados por nome do cliente e nome do produto.

-- -----------------------------------------------------
-- 3. Crie índices que possam se beneficiar do recurso para melhorar o desempenho das consultas, considerando principalmente colunas utilizadas nas cláusulas WHERE.
-- -----------------------------------------------------

# Consulta para um relatório de todas as vendas pagas em dinheiro:
-- Criação do índice na coluna tipo_pagamento da tabela venda
CREATE INDEX idx_venda_tipo_pagamento ON venda (tipo_pagamento);
-- Criação do índice na coluna id da tabela item_venda
CREATE INDEX idx_item_venda_venda_id ON item_venda (venda_id);

# Consulta para encontrar todas as vendas de produtos de um dado fabricante:
-- Criação do índice na coluna fabricante da tabela produto
CREATE INDEX idx_produto_fabricante ON produto (fabricante);
-- Criação do índice na coluna produto_id da tabela item_venda
CREATE INDEX idx_item_venda_produto_id ON item_venda (produto_id);
-- Criação do índice na coluna id da tabela venda
CREATE INDEX idx_venda_id ON venda (id);

# Relatório de vendas de produto por cliente:
-- Criação do índice na coluna id da tabela produto
CREATE INDEX idx_produto_id ON produto (id);
-- Criação do índice na coluna id da tabela cliente
CREATE INDEX idx_cliente_id ON cliente (id);
-- Criação do índice na coluna cliente_id da tabela venda
CREATE INDEX idx_venda_cliente_id ON venda (cliente_id);
-- Criação do índice na coluna cliente_id da tabela cliente
CREATE INDEX idx_cliente_cliente_id ON cliente (id);

-- -----------------------------------------------------
-- 4. Execute novamente o comando EXPLAIN mostrando agora os detalhes da execução da consulta, depois das otimizações realizadas e tire um print.
-- -----------------------------------------------------

-- Consulta para um relatório de todas as vendas pagas em dinheiro:
EXPLAIN
SELECT v.data, v.valor_total, p.nome AS nome_produto, iv.quantidade, iv.valor_unitario, c.nome AS nome_cliente, c.cpf, c.telefone
FROM venda v
JOIN item_venda iv ON v.id = iv.venda_id
JOIN produto p ON p.id = iv.produto_id
JOIN cliente c ON c.id = v.cliente_id
WHERE v.tipo_pagamento = 'D'
ORDER BY v.data DESC;

-- Consulta para encontrar todas as vendas de produtos de um dado fabricante:
EXPLAIN
SELECT p.nome, iv.quantidade, v.data
FROM produto p
JOIN item_venda iv ON p.id = iv.produto_id
JOIN venda v ON v.id = iv.venda_id
WHERE p.fabricante LIKE '%lar%'
ORDER BY p.nome;

-- Relatório de vendas de produto por cliente:
EXPLAIN
SELECT c.nome AS nome_cliente, p.nome AS nome_produto, SUM(iv.subtotal) AS valor_total, SUM(iv.quantidade) AS quantidade_total
FROM cliente c
JOIN venda v ON c.id = v.cliente_id
JOIN item_venda iv ON v.id = iv.venda_id
JOIN produto p ON p.id = iv.produto_id
GROUP BY c.nome, p.nome;

-- -----------------------------------------------------
-- 5. Crie uma view para cada uma das consultas ajustadas com JOINS.
-- -----------------------------------------------------

-- VIEW para o relatório de todas as vendas pagas em dinheiro:
CREATE VIEW relatorio_vendas_dinheiro AS
SELECT v.data, v.valor_total, p.nome AS nome_produto, iv.quantidade, iv.valor_unitario, c.nome AS nome_cliente, c.cpf, c.telefone
FROM venda v
JOIN item_venda iv ON v.id = iv.venda_id
JOIN produto p ON p.id = iv.produto_id
JOIN cliente c ON c.id = v.cliente_id
WHERE v.tipo_pagamento = 'D'
ORDER BY v.data DESC;

SELECT * FROM relatorio_vendas_dinheiro;

-- VIEW para encontrar todas as vendas de produtos de um dado fabricante:
CREATE VIEW vendas_por_fabricante AS
SELECT p.nome, iv.quantidade, v.data
FROM produto p
JOIN item_venda iv ON p.id = iv.produto_id
JOIN venda v ON v.id = iv.venda_id
WHERE p.fabricante LIKE '%lar%'
ORDER BY p.nome;

SELECT * FROM vendas_por_fabricante;

-- VIEW para o relatório de vendas de produto por cliente:
CREATE VIEW relatorio_vendas_por_cliente AS
SELECT c.nome AS nome_cliente, p.nome AS nome_produto, SUM(iv.subtotal) AS valor_total, SUM(iv.quantidade) AS quantidade_total
FROM cliente c
JOIN venda v ON c.id = v.cliente_id
JOIN item_venda iv ON v.id = iv.venda_id
JOIN produto p ON p.id = iv.produto_id
GROUP BY c.nome, p.nome;

SELECT * FROM relatorio_vendas_por_cliente;
