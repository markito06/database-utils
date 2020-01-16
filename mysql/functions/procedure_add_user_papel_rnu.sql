CREATE DEFINER=`root`@`%` PROCEDURE `ADD_USUARIO_PAPEL_RNU`(IN id_app  int, IN id_user_papel int ,  IN user_rnu int)
BEGIN

	declare last_id_usuario_rnu_papel bigint default 0;
	declare finished int default 0;
    DECLARE v_id_user bigint default 0;
    DECLARE v_user_login varchar(100) DEFAULT "";
	declare cursor_usuarios CURSOR FOR SELECT distinct(usuario.ID_USUARIO_RNU), usuario.LOGIN 
		FROM USUARIO_RNU usuario 
		INNER JOIN USUARIO_RNU_PAPEL usuario_papel ON usuario_papel.ID_USUARIO_RNU = usuario.ID_USUARIO_RNU
		INNER JOIN PAPEL_APLICACAO app_papel on usuario_papel.ID_PAPEL_APLICACAO = app_papel.ID_PAPEL_APLICACAO
		WHERE usuario.CD_UNIMED IN (511, 515, 852, 854, 855, 860, 865, 950, 960, 962, 970, 971, 972, 973, 974, 975, 976, 977, 978 ,981 , 984, 988 , 989, 990, 994, 999 )
		AND app_papel.ID_APLICACAO_RNU = id_app;	
	
	
	
	
	declare continue handler for not found set finished = 1; 

	open cursor_usuarios;

	get_id_loop: loop 
		fetch cursor_usuarios into v_id_user, v_user_login;
			
		if finished = 1 then leave get_id_loop;
		end if;
		
		

		insert into USUARIO_RNU_PAPEL (
			ID_USUARIO_RNU,
			 ID_PAPEL_APLICACAO)
			  values (v_id_user,
			   id_user_papel);
		
		insert into AUDITORIA_RNU (
			ID_USUARIO_RNU,
			 DATA_HORA,
			  DETALHES,
			   IP,
			    ID_OPERACAO_RNU ) 
			values (user_rnu,
				 SYSDATE(),
				  CONCAT("Atualização dos papéis do usuário '", v_user_login, "'. Papéis: ['painel_gerencial_federacao']"),
				   'SCRIPT DBA',
				    6);

	end loop get_id_loop;
	close cursor_usuarios;
	
	update QUIDFW_MYSQL_SEQUENCE destino, (select MAX(urp.ID_USUARIO_RNU_PAPEL) maxid from USUARIO_RNU_PAPEL urp) source 
		set destino.VALOR = source.maxid 
		where destino.NOME = 'USUARIO_RNU_PAPEL_SEQUENCE';
END