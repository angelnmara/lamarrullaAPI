use dbmadeinchiconcuac;

drop procedure if exists spGetHorariosXPeliculaXSucursal;

DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE spGetHorariosXPeliculaXSucursal(pelicula int, sucursal int)
BEGIN
        
    select distinct CONCAT(
    '[', 
    GROUP_CONCAT(JSON_OBJECT('fiIdSucursal', fiIdSucursal, 
						'fiIdPelicula', fiIdPelicula, 
                        'fiIdHora', c.fiIdHora, 
                        'fdHora', fdHora)),
    ']'
	) as salida
	from tbSucursalSalaPelicula a
    inner join tbPeliculaHorario b
    on a.fiIdSucursalSalaPelicula = b.fiIdSucursalSalaPelicula
    inner join tbhoras c
    on b.fiIdHora = c.fiIdHora
    where fiIdSucursal = 1
    and fiIdPelicula = 1;
    
END;;
DELIMITER ;


call spGetHorariosXPeliculaXSucursal(1, 1);