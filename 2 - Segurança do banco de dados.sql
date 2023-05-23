#Usuários e permissões de acesso

#Criação de usuários
-- Sintaxe:
-- CREATE USER 'usuario'@'endereco' IDENTIFIED BY 'senha';

CREATE USER 'teste'@'localhost' IDENTIFIED BY 'q1w2e3r4';
CREATE USER 'Daniel'@'localhost' IDENTIFIED BY '1a5s9d8f1g9h1j2k#';
SELECT * FROM mysql.user;

--------------------------------------------------

## Exclusão de usuários
-- Sintaxe:
-- DROP USER 'usuario'@'endereco';

CREATE USER 'teste2'@'localhost' IDENTIFIED BY '';
SELECT host, user FROM mysql.user;
DROP USER 'teste2'@'localhost';
SELECT host, user FROM mysql.user;

-- Crie dois novos usuários e depois remova-os, utilizando apenas uma instrução DROP USER.
CREATE USER 'usuario1'@'localhost' IDENTIFIED BY 'senha1';
CREATE USER 'usuario2'@'localhost' IDENTIFIED BY 'senha2';
SELECT host, user FROM mysql.user;
DROP USER 'usuario1'@'localhost', 'usuario2'@'localhost';
SELECT host, user FROM mysql.user;

----------------------------------------------------------------------------------------------------

#Permissões de usuários

#GRANT

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

-- Recupere as informações de privilégio do usuário “teste3” com a seguinte instrução:
SHOW GRANTS FOR 'teste3'@'localhost';

--------------------------------------------------

#REVOKE

-- Sintaxe:
-- REVOKE privilegios ON nome_banco.nome_tabela FROM usuario@endereco;

-- Para revogar todos os privilégios de um usuário, execute o seguinte comando:
REVOKE ALL PRIVILEGES ON *.* FROM 'teste'@'localhost';
-- Aqui também é preciso utilizar o comando FLUSH para atualizar as alterações.
FLUSH PRIVILEGES;
-- Por fim, confira se as permissões realmente foram removidas com o comando:
SHOW GRANTS FOR 'teste'@'localhost';
-- Remova as permissões CREATE, SELECT, INSERT e UPDATE ao usuário “teste3”.
REVOKE CREATE, SELECT, INSERT, UPDATE ON *.* FROM 'teste3'@'localhost';
-- Execute o comando FLUSH para aplicar as alterações e verificar se está tudo correto com o comando SHOW GRANTS:
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'teste3'@'localhost';

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

--------------------------------------------------

#Roles

-- Para criar as roles, utilize a instrução CREATE ROLE:
CREATE ROLE 'app_developer', 'app_read', 'app_write';
-- Foram definidas então três roles: 
	-- app_developer, destinada para desenvolvedores, 
    -- app_read, para usuários que poderão realizar apenas leitura no BD, e 
    -- app_write, para usuários que poderão realizar escrita.

-- Para definir as permissões de cada role, utilize a seguinte instrução GRANT:
GRANT ALL ON app_db.* TO 'app_developer';
GRANT SELECT ON app_db.* TO 'app_read';
GRANT INSERT, UPDATE, DELETE ON app_db.* TO 'app_write';

-- Vincule a conta de usuário à role desejada. Primeiro, crie os seguintes usuários:
CREATE USER 'usuario_developer'@'localhost';
CREATE USER 'usuario_read'@'localhost';
CREATE USER 'usuario_write'@'localhost';

-- Agora, vincule cada usuário a uma role diferente:
GRANT 'app_developer' TO 'usuario_developer'@'localhost';
GRANT 'app_read' TO 'usuario_read'@'localhost';
GRANT 'app_read', 'app_write' TO 'usuario_write'@'localhost';
-- A instrução GRANT do usuário “usuario_write” (terceira linha do script) concede as roles de leitura e gravação, que se combinam para fornecer os privilégios de leitura e gravação necessários.

----------------------------------------------------------------------------------------------------
#Encriptação de dados

	#Criptografia no MySQL

		#MD5

-- Crie uma tabela de usuário que será utilizada para fazer a autenticação em um sistema. 
-- Será preciso uma Id, um nome de usuário e uma senha.
CREATE DATABASE criptografia_exemplos;
USE criptografia_exemplos;

CREATE TABLE cadastro_usuarios (
id int PRIMARY KEY AUTO_INCREMENT,
usuario varchar(30),
senha text
);
-- Você estará criando a tabela com a coluna “senha”, com o tipo TEXT, para ter um limite de caracteres a fim de aproveitar essa mesma tabela nos exemplos seguintes. 
-- Em um cenário real, melhor seria que a coluna “senha” tivesse apenas o número de caracteres necessários para guardar as informações.
-- Caso essa coluna fosse usada para armazenar hashs MD5, por exemplo, ela deveria ser criada para armazenar apenas 16 caracteres, 
-- a fim de evitar desperdício de bits no armazenamento em disco do servidor de banco de dados.

-- Agora, efetue uma inserção nessa tabela. A instrução de inserção (INSERT) terá a seguinte sintaxe:
INSERT INTO cadastro_usuarios (usuario, senha) VALUES ('Usuário Normal', 'SenacEAD_2022 ');
-- Porém, quando cadastrados os usuários dessa maneira, a senha fica amostra nos registros da tabela.
-- Se os dados dessa tabela forem acessados por alguém não autorizado, todos os usuários estarão comprometidos.

-- Portanto, utilize o MD5 para criptografar a senha. Para isso, chame a função md5() e, como argumento, informe a string da senha que você quer cadastrar:
INSERT INTO cadastro_usuarios (usuario, senha) VALUES ('Usuário MD5 ', md5('SenacEAD_2022 '));

-- Se você executou os dois comandos de inserção, verá que existem os seguintes dados na tabela:
SELECT * FROM cadastro_usuarios;

--------------------------------------------------
		#SHA-1

-- Produz um texto criptografado de 160 bits, equivalente a 20 caracteres. Por conter o número de caracteres maior que o MD5, pode ser considerada mais segura.
-- A função sha1() receberá um texto como argumento e gerará um novo texto criptografado. 
-- Seu uso é idêntico ao da função md5(), mudando apenas o nome da função que está sendo chamada:
INSERT INTO cadastro_usuarios (usuario, senha) VALUES ('Usuário SHA-1', sha1('SenacEAD_2022'));

-- SHA1 é a primeira versão da hash SHA, por isso você chamar a função no MySQL como sha():
INSERT INTO cadastro_usuarios (usuario, senha) VALUES ('Usuário SHA', sha('SenacEAD_2022'));

-- Por fim, consulte se está tudo certo na tabela:
SELECT * FROM cadastro_usuarios;

--------------------------------------------------
		#SHA-2

-- Enquanto o SHA-1 contém 20 caracteres, o SHA-2 oferece diferentes opções de tamanhos:
		-- 224 bits: 28 caracteres
		-- 256 bits: 32 caracteres
		-- 384 bits: 48 caracteres
		-- 512 bits: 64 caracteres
        
-- É preciso passar dois argumentos para a função sha2() do MySQL. O primeiro argumento com o que se quer criptografar e o segundo com o tamanho da criptografia em bits:
INSERT INTO cadastro_usuarios (usuario, senha) VALUES ('Usuário SHA-2 ', sha2('SenacEAD_2022', 224));

-- Consulte a tabela “cadastro_usuarios”:
SELECT * FROM cadastro_usuarios;

--------------------------------------------------
		#AES

-- Chama-se a função AES_ENCRYPT e passam-se dois argumentos: o texto que será criptografado e a senha para descriptografar, respectivamente:
INSERT INTO cadastro_usuarios (usuario, senha) VALUES ('Usuário AES', AES_ENCRYPT('SenacEAD_2022', 'Minha senha secreta'));

-- Não funcionou porque a criptografia gerada pelo AES não combina com o tipo de dado da coluna “senha”. 
-- Então, para utilizar a criptografia, crie uma nova coluna chamada “senha_aes” do tipo VARBINARY(100), e faça a inserção nessa coluna da senha criptografada:
ALTER TABLE cadastro_usuarios ADD COLUMN senha_aes varbinary(100);
INSERT INTO cadastro_usuarios (usuario, senha_aes) VALUES ('Usuário AES', AES_ENCRYPT('SenacEAD_2022', 'Minha senha secreta' ));
SELECT * FROM cadastro_usuarios;

-- A coluna “senha_aes” retorna um BLOB (binary large object, ou “grande objeto binário, em português). 
-- Para visualizar a informação nesse dado, clique com o botão direito do mouse sobre ele e selecione a opção Open Value in Editor.
-- Clicando na guia Text, você visualizará a criptografia gerada pela função AES.

-- Para descriptografar o texto, utilize a função AES_DECRYPT(), na qual você deve informar dois argumentos (qual dado você está tentando descriptografar e qual é a senha) para realizar o processo de descriptografia:
SELECT
	AES_DECRYPT(senha_aes, 'Minha senha secreta')
	FROM cadastro_usuarios
	WHERE senha_aes is not null;

-- Para converter esses dados binários (BLOB) para caracteres CHAR, utilize o método CAST():
SELECT
	CAST(AES_DECRYPT(senha_aes, 'Minha senha secreta') AS CHAR(255))
	FROM cadastro_usuarios
	WHERE senha_aes is not null;