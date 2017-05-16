<?php

    require_once('vendor/autoload.php');
    include('acceso/acceso.php');

    use Zend\Config\Factory;
    $config = Factory::fromFile('config/config.php', true);
    $metodos = $config->get('metodos');

    $method = $_SERVER['REQUEST_METHOD'];
    $request = explode('/', trim($_SERVER['REQUEST_URI'],'/'));        
    $input = json_decode(file_get_contents('php://input'),true);

    $acceso = new login();
    $conecta = new conecta();

    //valida base y tabla

    if(count($request) <= 1){
        echo json_encode("Se tiene que ingresar metodo o base de datos");
        return;
    }else{
        if(count($request) <= 2){
            if(in_array($request[1], $metodos->toArray())){
                $acceso->setUsuario('Dave');
                $acceso->setContrasenna('123');
                $acceso->getToken();
                return;
            }else{
                echo json_encode("Se tiene que ingresar una tabla");
                return;
            }            
        }
        $sqlSch = "SELECT SCHEMA_NAME FROM" . " INFORMATION_SCHEMA" . ".SCHEMATA WHERE SCHEMA_NAME = '" . $request[1] . "'";
        $sqlTbl = "SELECT table_name FROM" . " information_schema.tables WHERE table_schema = '" . $request[1] . "' AND table_name = '" . $request[2] . "' LIMIT 1;";
    }

    $result = $conecta->getConsulta($sqlSch);

    if($result->num_rows > 0){
        while($row = $result->fetch_assoc()){
            echo $row["SCHEMA_NAME"];
        }
    }else{
        echo json_encode("Base de datos " . $request[1] . " inexistente");
        return;
    }

    $result = $conecta->getConsulta($sqlTbl);

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

    $result = $conecta->getConsulta($sql);

    if($result->num_rows > 0){
    	while($row = $result->fetch_assoc()){            
    		echo $row["salida"];            
    	}    	
    }else{
    	echo json_encode("problema en select");
    }