use dbmadeinchiconcuac;

drop procedure if exists spAPIError;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spAPIError` ( in errorcode int, in statuscode varchar(1000))
BEGIN
	declare texto varchar(1000);
    declare salida varchar(5000);
	
	set salida = concat("{\"errorcode\":", errorcode, ",", "\"statuscode\":\"", statuscode, "\"}");
    select salida;
end;$$
DELIMITER ;


	call spAPIError (0, 'error');
