drop view if exists vSucursalesXPeliculaId;


	create view vSucursalesXPeliculaId as 
	select d.*, a.fiIdPelicula
	from tbPeliculas a
	inner join tbPelicualasCartelera b
	on a.fiIdPelicula = b.fiIdPelicula
	inner join tbCartelera c
	on b.fiIdCartelera = c.fiIdCartelera
	inner join tbSucursal d
	on c.fiIdSucursal = d.fiIdSucursal;
    
    
    
    select *
    from vSucursalesXPeliculaId
    where fiIdPelicula = 3;
    
    
