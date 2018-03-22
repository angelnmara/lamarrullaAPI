use dbmadeinchiconcuac;

drop procedure if exists spGetSucursalesXPeliculaId;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spGetSucursalesXPeliculaId`(pelicula int)
BEGIN
    /*DECLARE local_variable_name INT;

    SELECT column_name FROM table_1 LIMIT 1 INTO local_variable_name;

    SELECT * FROM table_1;*/    
    SELECT CONCAT('{"spGetSucursalesXPeliculaId": [', 
    GROUP_CONCAT(JSON_OBJECT('fiIdSucursal', d.fiIdSucursal, 
							'fcSucursalDesc', d.fcSucursalDesc,
                            'fcSucursalDir',d.fcSucursalDir,
                            'fdSucursalLat',d.fdSucursalLat,
                            'fdSucursalLong',d.fdSucursalLong)),
    ']}'
	) as salida
	from tbPeliculas a
	inner join tbPelicualasCartelera b
	on a.fiIdPelicula = b.fiIdPelicula
	inner join tbCartelera c
	on b.fiIdCartelera = c.fiIdCartelera
	inner join tbSucursales d
	on c.fiIdSucursal = d.fiIdSucursal
	where a.fiIdPelicula = pelicula;	
    
END$$
DELIMITER ;


call spGetSucursalesXPeliculaId(2);