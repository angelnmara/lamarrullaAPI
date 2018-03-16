use dbmadeinchiconcuac;

drop procedure if exists spGetSucursalesXPeliculaId;

DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE spGetSucursalesXPeliculaId(pelicula int)
BEGIN
    /*DECLARE local_variable_name INT;

    SELECT column_name FROM table_1 LIMIT 1 INTO local_variable_name;

    SELECT * FROM table_1;*/
    
    select d.*
	from tbPeliculas a
	inner join tbPelicualasCartelera b
	on a.fiIdPelicula = b.fiIdPelicula
	inner join tbCartelera c
	on b.fiIdCartelera = c.fiIdCartelera
	inner join tbSucursal d
	on c.fiIdSucursal = d.fiIdSucursal
	where a.fiIdPelicula = pelicula;
    
END;;
DELIMITER ;


call spGetSucursalesXPeliculaId(5);