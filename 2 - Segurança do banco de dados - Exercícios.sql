-- Crie dois novos usuários e depois remova-os, utilizando apenas uma instrução DROP USER.

CREATE USER 'usuario1'@'localhost' IDENTIFIED BY 'senha1';
CREATE USER 'usuario2'@'localhost' IDENTIFIED BY 'senha2';
SELECT host, user FROM mysql.user;

DROP USER 'usuario1'@'localhost', 'usuario2'@'localhost';
SELECT host, user FROM mysql.user;

-----------------------------------------------------------------------------------------

## Criação de usuários

-- Sintaxe:
-- CREATE USER 'usuario'@'endereco' IDENTIFIED BY 'senha';

CREATE USER 'Daniel'@'localhost' IDENTIFIED BY '1a5s9d8f1g9h1j2k#';
SELECT * FROM mysql.user;

-----------------------------------------------------------------------------------------

## Permissões de usuários

-- Agora que você já sabe como conceder privilégios aos usuários do MySQL, conceda todas as permissões para o usuário que você criou com o seu nome. 
-- Após isso, cria uma nova base de dados com duas tabelas com, pelo menos, três colunas cada. 
-- Depois, crie um novo usuário chamado programador e atribua os privilégios de manipulação de dados para que ele possa selecionar, inserir e atualizar os dados de apenas uma dessas tabela.

-- Conceder todas as permissões para o usuário 'Daniel'
GRANT ALL PRIVILEGES ON *.* TO 'Daniel'@'localhost';
FLUSH PRIVILEGES;

-- Criar a nova base de dados
CREATE DATABASE minha_base_de_dados;

-- Utilizar a nova base de dados
USE minha_base_de_dados;

-- Criar a primeira tabela
CREATE TABLE tabela1 (
  id INT PRIMARY KEY,
  nome VARCHAR(50),
  idade INT
);

-- Criar a segunda tabela
CREATE TABLE tabela2 (
  id INT PRIMARY KEY,
  endereco VARCHAR(100),
  telefone VARCHAR(20)
);

SELECT * FROM mysql.user;

-- Isso criará o usuário 'Daniel' com todas as permissões e criará uma nova base de dados chamada 'minha_base_de_dados' com duas tabelas: 'tabela1' e 'tabela2', cada uma com três colunas.
-- Para criar um novo usuário chamado 'programador' e atribuir os privilégios de manipulação de dados para apenas uma das tabelas, pode-se executar os seguintes comandos:

-- Criar o novo usuário 'programador'
CREATE USER 'programador'@'localhost' IDENTIFIED BY 'senha_do_programador';

-- Conceder privilégios de manipulação de dados para a tabela1 apenas
GRANT SELECT, INSERT, UPDATE ON minha_base_de_dados.tabela1 TO 'programador'@'localhost';
FLUSH PRIVILEGES;
SELECT * FROM mysql.user;

-- Isso criará o usuário 'programador' com a senha 'senha_do_programador' e concederá os privilégios de selecionar, inserir e atualizar os dados apenas na tabela 'tabela1' da base de dados 'minha_base_de_dados'.
-- Certifique-se de substituir 'senha_do_programador' pela senha real que você deseja definir para o usuário 'programador'.