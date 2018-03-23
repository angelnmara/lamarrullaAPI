SET GLOBAL group_concat_max_len=65000;

use dbmadeinchiconcuac;

drop procedure if exists spGetHorariosXPeliculaXSucursal;

DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE spGetHorariosXPeliculaXSucursal(pelicula int, sucursal int)
BEGIN
        
    select 
    CONCAT(
    '{"spGetHorariosXPeliculaXSucursal": [', 
    GROUP_CONCAT(
    JSON_OBJECT('fiIdSucursal', fiIdSucursal, 
						'fiIdPelicula', fiIdPelicula, 
                        'fcSalaNom', fcSalaNom,
                        'fiIdHora', c.fiIdHora, 
                        'fdHora', date_format(fdHora, '%H:%i'))),
    ']}'
	) as salida
	from tbSucursalSalaPelicula a
    inner join tbPeliculaHorario b
    on a.fiIdSucursalSalaPelicula = b.fiIdSucursalSalaPelicula
    inner join tbhoras c
    on b.fiIdHora = c.fiIdHora
    inner join tbSalas d
    on a.fiIdSala = d.fiIdSala
    where fiIdSucursal = sucursal
    and fiIdPelicula = pelicula
    order by fdHora;
    
END;;
DELIMITER ;


call spGetHorariosXPeliculaXSucursal(3,3);