SET GLOBAL group_concat_max_len=65000;

use dbmadeinchiconcuac;

drop procedure if exists spGetButacas;

DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE spGetButacas(idPelicula int, idSucursal int, idSala int, idHora int)
BEGIN	
    
    declare fecha date;
    set fecha = CURRENT_TIMESTAMP;
        
    select CONCAT(
    '{"spGetHorariosXPeliculaXSucursal": [', 
    GROUP_CONCAT(
    JSON_OBJECT('fiIdSalaButaca', a.fiIdSalaButaca, 
				'fiIdPeliculaHorario', fiIdPeliculaHorario,
                'fdBoletoFechaPelicula', fecha,
						'fcSalaButacaFila', fcSalaButacaFila, 
                        'fiSalaButacaColumna', fiSalaButacaColumna,
                        'Vendido', if(b.fiIdSalaButaca is null, 0, 1))),
    ']}'
	) as salida
	from tbSalasButacas a
	left outer join (select b.fiIdSalaButaca, a.fiIdPeliculaHorario
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
	order by 1;
    
END;;
DELIMITER ;


call spGetButacas(1,1,1,1);