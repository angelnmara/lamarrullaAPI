use dbmadeinchiconcuac;

DELIMITER $$

drop procedure if exists getPassw;

$$

create procedure getPassw(acceso varchar(200)) 
begin
	select a.fiIdUsu, fcUsu, fcUsuPassw
	from tbusu a
	join tbusupassw b
	on a.fiIdUsu = b.fiIdUsu
	where fcUsu = acceso or fcCorreoElectronico = acceso;
        
end

$$

call getPassw('angel');