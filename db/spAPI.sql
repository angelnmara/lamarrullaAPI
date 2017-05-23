use dbmadeinchiconcuac;

drop procedure if exists spAPI;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spAPI` ( in metodo int, in db varchar(100),  in tabla varchar(50), in campos varchar(1000), in valores varchar(5000), in id int)
APILabel:
BEGIN

	declare salida varchar(10000);
    declare selectTabla varchar(5000);
    declare valorTabla varchar(10000);    
    
    set selectTabla = '';
    set valorTabla = '';
    set @cwhere = '';
    set @finsert = '';
    set @valortabla = '';
    set @rowAfected = 0;
    
    SET SESSION group_concat_max_len=5000;    
    
    select COLUMN_NAME into @pkey
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = db
    AND TABLE_NAME = tabla
    and COLUMN_KEY = 'PRI';			
    
    if (id != 0) then
            
		set @cwhere = concat(" where ", @pkey, " = ", id);
    
    end if;
    
    /*PUT*/
    if (metodo = 2 && id != 0) then
		set @fupdate = concat("update ", db, ".", tabla, " set ", valores, @cwhere);
        prepare stmt1 from @fupdate;
		execute stmt1;
		deallocate prepare stmt1;
    end if;
    
    /*POST*/
    
    if(metodo = 3) then
		set @finsert = concat("insert ", db, ".", tabla , "(" , campos, ") values(", valores, ");");        
        prepare stmt2 from @finsert;
		execute stmt2;
		deallocate prepare stmt2;
        
        set @flastrow = concat("select ", @pkey, " into @id from ", db, ".", tabla, " order by ", @pkey, " desc limit 1;");        
        prepare stmt4 from @flastrow;
		execute stmt4;
		deallocate prepare stmt4;
        
        set @cwhere = concat(" where ", @pkey, " = ", @id);
        
    end if;
    
    if(metodo = 4) then
    
		set @fdelete = concat("delete from ", db, ".", tabla, " ", @cwhere,  ";");        
        prepare stmt5 from @fdelete;
		execute stmt5;
        SELECT ROW_COUNT() into @rowAfected;
		deallocate prepare stmt5;        
        
        if(@rowAfected > 0) then
			set salida = concat("{\"error\":\"\"}");
            else 
            set salida = concat("{\"error\":\"No existen registros a borrar.\"}");
        end if;
        
        select salida;
        		
        LEAVE APILabel;
    
    end if;
	
    
    select  	concat("concat(", 
								group_concat(concat("\"\\\"", COLUMN_NAME, "\\\" : \", ", 
														case when DATA_TYPE = "bit" then concat("case when ", COLUMN_NAME, " = 0 then \" true \" else \"false\" end")
															when DATA_TYPE != "int" then concat("concat(\"\\\"\",", COLUMN_NAME, ",\"\\\"\")") 
															else COLUMN_NAME 
														end, 
                                                        ", \", \" ")),
														")") into @valortabla
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = db
    AND TABLE_NAME = tabla;
        
    set @valortabla = concat(substring(@valortabla, 1, length(@valortabla) -8), ")");	
    
    set @t1 = concat("select group_concat(\"{\", ", @valortabla, ", \"} \") into @salida from ", db, ".", tabla, @cwhere);
        
    prepare stmt3 from @t1;
    execute stmt3;    
    deallocate prepare stmt3;    
    
    if(@salida is not null) then
			set salida = concat("{\"", tabla, "\":[", @salida, "]}");
		else 
            set salida = concat("{\"error\":\"No existen registros a mostrar.\"}");
	end if;
    
    select salida as salida;
       
	
END$$
DELIMITER ;

begin;
	/*call spAPI (4, 'dbmadeinchiconcuac', 'tbcatcampo', '', '', 2);*/
    call spAPI (1, 'dbmadeinchiconcuac', 'tbcatcampo', 'v', 'c', 2);
rollback;