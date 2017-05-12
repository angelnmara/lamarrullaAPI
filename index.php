<?php
    $serverName = "localhost";
    $userName = "dave";
    $password = "maradr";
    $dbname = "dbmadeinchiconcuac";

    $method = $_SERVER['REQUEST_METHOD'];
    $request = explode('/', trim($_SERVER['REQUEST_URI'],'/'));        
    $input = json_decode(file_get_contents('php://input'),true);

    //create connexion
    $conn = new mysqli($serverName, $userName, $password, $dbname);

    //valida conecion
    if($conn->connect_error){
        die("coneccion fallo: " . $conn->connect_error);
    }

    //valida base y tabla

    $sqlSch = "SELECT SCHEMA_NAME FROM" . " INFORMATION_SCHEMA" . ".SCHEMATA WHERE SCHEMA_NAME = '" . $request[1] . "'";
    $sqlTbl = "SELECT table_name FROM" . " information_schema.tables WHERE table_schema = '" . $request[1] . "' AND table_name = '" . $request[2] . "' LIMIT 1;";

    $result = $conn->query($sqlSch);

    if($result->num_rows > 0){
        while($row = $result->fetch_assoc()){
            echo $row["SCHEMA_NAME"];
        }
    }else{
        echo json_encode("Base de datos " . $request[1] . " inexistente");
        return;
    }

    $result = $conn->query($sqlTbl);

    if($result->num_rows > 0){
        while($row = $result->fetch_assoc()){
            echo $row["table_name"];
        }
    }else{
        echo json_encode("Tabla " . $request[2] . " no existe en base de datos");
        return;
    }

    $campos = "";
    $valores = "";
    
    header('Content-Type: application/json');

    /*print_r($method != 'POST'? 'true': 'false');*/

    if (count($request)<4 and ($method == 'GET' or $method == 'POST')){
        $request[3] = 0;
    }elseif (count($request)<4 and $method != 'POST') {
        http_response_code(400);
        $sql = "call spAPIError (400, 'InvalidUri')";
        $method = '';
    }    

    if(($method == 'PUT' or $method == 'POST') and $input == ''){
        http_response_code(400);
        $sql = "call spAPIError (400, 'MissingRequiredHeader')";
        $method = '';    
    }

    switch ($method) {
        case 'GET':

            $sql = "call spAPI (1, '" . $request[1] . "', '" . $request[2] . "', 'v', 'c'," . $request[3] . ");";
            
            print_r($sql);

            break;

        case 'PUT':                

                foreach ($input as $key => $value) {
                    $valores = $valores . $key . "=\"" . $value . "\",";
                    /*$campos = $campos . $key . ",";*/
                }                

                $valores = substr($valores, 0, strlen($valores)-1);
                /*$campos = substr($campos, 0, strlen($campos)-1);*/

                $sql = "call spAPI (2, '" . $request[1] . "', '" . $request[2] . "', '" . $campos . "', '" . $valores . "', " . $request[3] . " );";

                print_r($sql);
                        
        break;

        case 'POST':
            
            foreach ($input as $key => $value) {
                    $valores = $valores . "''". $value . "'',";
                    $campos = $campos . $key . ",";
            }                

            $valores = substr($valores, 0, strlen($valores)-1);
            $campos = substr($campos, 0, strlen($campos)-1);
                
            $sql = "call spAPI (3, '" . $request[1] . "', '" . $request[2] . "', '" . $campos . "', '" . $valores . "', " . $request[3] . " );";
            print_r($sql);

                        
        break;

        case 'DELETE':
            $sql = "call spAPI (4, '" . $request[1] . "', '" . $request[2] . "', '" . $campos . "', '" . $valores . "', " . $request[3] . " );";                        
            print_r($sql);
        break;
        
        default:
            print_r('default');
            break;
    }
    
    $result = $conn->query($sql);

    if($result->num_rows > 0){
    	while($row = $result->fetch_assoc()){            
    		echo $row["salida"];            
    	}    	
    }else{
    	echo json_encode("problema en select");
    }