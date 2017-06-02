use dbmadeinchiconcuac;

DELIMITER $$

DROP PROCEDURE IF EXISTS getPassw;

$$

CREATE PROCEDURE getPassw(acceso varchar(200))
BEGIN
DECLARE exit HANDLER FOR sqlexception, sqlwarning
    BEGIN
      get diagnostics condition 1
          @err = message_text;
      select @err as error;
    END;

  SELECT IF(EXISTS (SELECT a.fiIdUsu, fcUsu, fcUsuPassw
                  FROM tbUsu a
                  JOIN tbUsuPassw b
                  ON a.fiIdUsu = b.fiIdUsu
                  WHERE fcUsu = acceso or fcCorreoElectronico = acceso), 1, 0) into @existe;

  if (@existe = 1)
    then
      SELECT a.fiIdUsu, fcUsu, fcUsuPassw
                  FROM tbUsu a
                  JOIN tbUsuPassw b
                  ON a.fiIdUsu = b.fiIdUsu
                  WHERE fcUsu = acceso or fcCorreoElectronico = acceso;
    else
      select 0 fiIdUsu, 0 fcUsu, 0 fcUsuPassw;
  end if;
END;

$$

call getPassw('angel');