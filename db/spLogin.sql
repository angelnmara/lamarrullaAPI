use dbmadeinchiconcuac;

drop procedure if exists spLogin;

delimiter //

create procedure spLogin (usuario varchar(100), contrasennia varchar(1000))
begin	
	select if(count(*) > 0, 1, 0) as autenticar
    from tbUsu a
    inner join tbusupassw b
    on a.fiIdusu = b.fiIDusu
    where (fcUsu = usuario or fcCorreoElectronico = usuario) and fcusupassw = contrasennia
    and CURRENT_TIMESTAMP between fdFecIniPassw and fdFecFinPassw
    and fnStatUsu = 1;
end // delimiter ;

call spLogin ('angelnmara@hotmail.com', 'madaver');