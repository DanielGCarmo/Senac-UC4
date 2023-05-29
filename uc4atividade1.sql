USE `uc4atividades`;
DROP USER IF EXISTS `user_relatorio`@`localhost`, `user_relatorio`@`uc4atividades`, `user_funcionario`@`localhost`, `user_funcionario`@`uc4atividades`;
DROP ROLE IF EXISTS `role_relatorio`, `role_funcionario`;
FLUSH PRIVILEGES;

/* 1.	Crie um usuário chamado `user_relatorio`. 
		Crie role para ele, com acesso ao comando SELECT de todas tabelas da base de dados `uc4atividades`. 
		Não pode ser definido pare este usuário nenhum outro comando DDL ou DML, além do SELECT.*/

-- Criar um novo usuário chamado `user_relatorio`:
CREATE USER `user_relatorio`@`uc4atividades` IDENTIFIED BY 's1e2n3h4a5';

-- Criar uma role chamada `role_relatorio`:
CREATE ROLE `role_relatorio`;

-- Conceder permissões de SELECT em todas as tabelas do banco de dados `uc4atividades` para a role `role_relatorio`:
GRANT SELECT ON `uc4atividades`.* TO `role_relatorio`;

-- Restringir outras operações DDL ou DML para a role `role_relatorio`:
REVOKE ALL PRIVILEGES ON *.* FROM `role_relatorio`;

-- Conceder à role `role_relatorio` permissão para executar SELECT nas tabelas do banco de dados `uc4atividades`:
GRANT SELECT ON `uc4atividades`.* TO `role_relatorio`;

-- Atribuir a role role_relatorio ao usuário user_relatorio:
GRANT `role_relatorio` TO `user_relatorio`@`uc4atividades`;

-- Atualizar as permissões para refletir as alterações:
FLUSH PRIVILEGES;
SHOW GRANTS FOR `role_relatorio`;

/* 2.	Crie usuário chamado user_funcionario. 
		Crie role para este usuário, ele vai poder manipular as tabelas de venda, cliente e produto da base de dados uc4atividades,
	ou seja, pode fazer apenas os comandos de SELECT, INSERT, UPDATE E DELETE.*/
    
-- Criar um novo usuário chamado `user_funcionario`:
CREATE USER `user_funcionario`@`uc4atividades` IDENTIFIED BY 's5e4n3h2a1';

-- Criar uma role chamada `role_funcionario`:
CREATE ROLE `role_funcionario`;

-- Conceder permissões específicas para a role `role_funcionario` nas tabelas de venda, cliente e produto:
GRANT SELECT, INSERT, UPDATE, DELETE ON `uc4atividades`.`venda` TO `role_funcionario`;
GRANT SELECT, INSERT, UPDATE, DELETE ON `uc4atividades`.`cliente` TO `role_funcionario`;
GRANT SELECT, INSERT, UPDATE, DELETE ON `uc4atividades`.`produto` TO `role_funcionario`;

-- Atribuir a role `role_funcionario` ao usuário `user_funcionario`:
GRANT `role_funcionario` TO `user_funcionario`@`uc4atividades`;

-- Atualizar as permissões para refletir as alterações:
FLUSH PRIVILEGES;
SHOW GRANTS FOR `role_funcionario`;