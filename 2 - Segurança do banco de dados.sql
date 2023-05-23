# Usuários e permissões de acesso

## Criação de usuários

-- Sintaxe:
-- CREATE USER 'usuario'@'endereco' IDENTIFIED BY 'senha';

CREATE USER 'teste'@'localhost' IDENTIFIED BY 'q1w2e3r4';

SELECT * FROM mysql.user;

CREATE USER 'Daniel'@'localhost' IDENTIFIED BY '1a5s9d8f1g9h1j2k#';

## Exclusão de usuários

-- Sintaxe:
-- DROP USER 'usuario'@'endereco';

CREATE USER 'teste2'@'localhost' IDENTIFIED BY '';
SELECT host, user FROM mysql.user;

DROP USER 'teste2'@'localhost';
SELECT host, user FROM mysql.user;

## Permissões de usuários

### GRANT

-- Sintaxe:
-- GRANT privilegios ON nome_banco.nome_tabela TO usuario@endereco;

-- Para garantir todos os privilégios do banco de dados a um usuário, execute o seguinte comando:

GRANT ALL PRIVILEGES ON *.* TO 'teste'@'localhost';

-- Apesar de já estarem definidos os privilégios para o usuário no qual você está trabalhando agora, ainda será preciso executar o comando FLUSH para que as mudanças tenham efeito. 
-- Então, execute o seguinte comando:

FLUSH PRIVILEGES;

SELECT * FROM mysql.user;

-- Atribuindo os privilégios de CREATE para manipulação de tabelas e SELECT, INSERT e UPDATE para manipulação de dados em todas as tabelas de todas as bases de dados para um novo usuário chamado “teste3”.
-- Inicialmente, crie o usuário com o comando CREATE USER:

CREATE USER 'teste3'@'localhost' IDENTIFIED BY '';

-- Defina as permissões específicas com o comando GRANT:

GRANT CREATE, SELECT, INSERT, UPDATE ON *.* TO 'teste3'@'localhost';

-- Solicite ao servidor para recarregar as configurações de privilégios, pois você acabou de atualizar as permissões do usuário “teste3”. Utilize este comando:

FLUSH PRIVILEGES;

-- Confira na tabela “mysql.user” se está tudo correto:

SELECT * FROM mysql.user;

-- Para visualizar os privilégios atribuídos para um usuário é por meio do comando:

SHOW GRANTS;

-- recupere as informações de privilégio do usuário “teste3” com a seguinte instrução:

SHOW GRANTS FOR 'teste3'@'localhost';
