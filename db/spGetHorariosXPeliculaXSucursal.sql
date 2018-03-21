use dbmadeinchiconcuac;

drop procedure if exists spGetHorariosXPeliculaXSucursal;

DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE spGetHorariosXPeliculaXSucursal(pelicula int, sucursal int, diasemana int)
BEGIN
    
    if(diasemana = 0) then
		set diaSemana = DAYOFWEEK(CURRENT_TIMESTAMP);
    end if;
    
    select distinct CONCAT(
    '[', 
    GROUP_CONCAT(JSON_OBJECT('fiIdPelicula', fiIdPelicula, 
							'fiIdSucursal', fiIdSucursal,
                            'fdPeliculaHorarioSemanaHora',fdPeliculaHorarioSemanaHora)),
    ']'
	) as salida
	from tbSucursalSalaPelicula a
    inner join tbPeliculaHorarioSemana b
    on a.fiIdSucursalSalaPelicula = b.fiIdSucursalSalaPelicula
	where fiIdPelicula = pelicula
    and fiIdSucursal = sucursal
    and fiPeliculaHorarioSemanaDia = diaSemana;
    
END;;
DELIMITER ;


call spGetHorariosXPeliculaXSucursal(1, 1, 0);