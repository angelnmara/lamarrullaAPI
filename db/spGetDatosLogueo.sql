drop procedure if exists spGetDatosLogueo;

delimiter ///

create procedure spGetDatosLogueo (usuario varchar(100))
begin
	select fcUsu
    from tbUsu
    where (fcUsu = usuario or fcCorreoElectronico = usuario);
    
    if (select exists(select * from tbUsuCveApi) = 1) then
    begin
		
        select 'entra', CURRENT_TIMESTAMP;
        
		update tbUsuCveApi a
        inner join tbUsu b
        on a.fiIdUsu = b.fiIdUsu        
        set a.fcCveAPI = '1234',
			a.fdFecIniCveAPI = CURRENT_TIMESTAMP,
            a.fdFecFinCveAPI = date_add(CURRENT_TIMESTAMP, interval 1 day)
		where (fcUsu = usuario or fcCorreoElectronico = usuario);
        
                
    end;
    end if;
end; /// delimiter ;

call spGetDatosLogueo ('daver');