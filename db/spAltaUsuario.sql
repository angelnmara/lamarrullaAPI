use dbmadeinchiconcuac;

DELIMITER $$

drop procedure if exists spAltaUsuario;

$$

create procedure spAltaUsuario (in usuario varchar(20), in correo varchar(100), in contrasenna varchar(500))
BEGIN	

	declare salida varchar(500);
	declare idusuario int;        
    
    DECLARE exit HANDLER FOR sqlexception, sqlwarning
    BEGIN 		
		get diagnostics condition 1
        @err = message_text;
        if (locate('fcCorreoElectronico', @err) > 1)
        then set @err = 'Correo Electronico Existente';
        elseif locate('fcUsu', @err)
        then set @err = 'Usuario existente';
        end if;
		select 0 as salida, @err as error;
		rollback;
    END;

	start transaction;

    insert tbUsu(fcUsu, fcCorreoElectronico) values(usuario, correo);

	select fiIdUsu into @idusuario
	from tbUsu
	where fcUsu = usuario
	and fcCorreoElectronico = correo;

    insert tbUsuPassw(fiIdUsu, fcUsuPassw)values(@idusuario, contrasenna);
    
    select 1 as salida;
        	
    commit;	
    
END

$$
