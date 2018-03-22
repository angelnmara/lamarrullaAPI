use dbmadeinchiconcuac;

drop procedure if exists spGetHorariosXPeliculaXSucursal;

DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE spGetHorariosXPeliculaXSucursal(pelicula int, sucursal int)
BEGIN
        
    select distinct CONCAT(
    '{"spGetHorariosXPeliculaXSucursal": [', 
    GROUP_CONCAT(JSON_OBJECT('fiIdSucursal', fiIdSucursal, 
						'fiIdPelicula', fiIdPelicula, 
                        'fiIdHora', c.fiIdHora, 
                        'fdHora', fdHora)),
    ']}'
	) as salida
	from tbSucursalSalaPelicula a
    inner join tbPeliculaHorario b
    on a.fiIdSucursalSalaPelicula = b.fiIdSucursalSalaPelicula
    inner join tbhoras c
    on b.fiIdHora = c.fiIdHora
    where fiIdSucursal = sucursal
    and fiIdPelicula = pelicula;
    
END;;
DELIMITER ;


call spGetHorariosXPeliculaXSucursal(2, 3);