SET GLOBAL group_concat_max_len=65000;

use dbmadeinchiconcuac;

drop procedure if exists spGetButacas;

DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE spGetButacas(idPelicula int, idSucursal int, idSala int, idHora int, fecha date)
BEGIN
        
    select fcSalaButacaFila, fiSalaButacaColumna, if(b.fiIdSalaButaca is null, 0, 1) as Vendido
	from tbSalasButacas a
	left outer join (select b.fiIdSalaButaca
					from tbpeliculahorario a
					inner join tbBoletos b
					on a.fiIdPeliculaHorario = b.fiIdPeliculaHorario
					inner join tbsucursalsalapelicula c
					on a.fiIdSucursalSalaPelicula = c.fiIdSucursalSalaPelicula
					where fiIdPelicula = idPelicula
					and fiIdPelicula = idSucursal
					and fiIdSala = idSala
					and fiIdHora = idHora
					and fdBoletoFechaPelicula = fecha) b
	on a.fiIdSalaButaca = b.fiIdSalaButaca
	where fiIdSala = idSala
	order by 1,2;
    
END;;
DELIMITER ;


call spGetButacas(1,1,1,1,'20180324');