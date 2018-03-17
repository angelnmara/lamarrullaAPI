use dbmadeinchiconcuac;

drop procedure if exists spGetHorariosXPeliculaXSucursal;

DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE spGetHorariosXPeliculaXSucursal(pelicula int, sucursal int)
BEGIN
    
    declare diaSemana int;
    
    set diaSemana = DAYOFWEEK(CURRENT_TIMESTAMP);
    
    select *
	from tbPeliculaHorarioSemana
	where fiIdPelicula = pelicula
    and fiIdSucursal = sucursal
    and fiPeliculaHorarioSemanaDia = diaSemana;
    
END;;
DELIMITER ;


call spGetHorariosXPeliculaXSucursal(1, 1);