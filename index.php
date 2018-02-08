<?php

    require_once('vendor/autoload.php');
    include('acceso/acceso.php');

    use Zend\Http\PhpEnvironment\Request;
    use Zend\Config\Factory;

    $config = Factory::fromFile('config/config.php', true);
    $metodos = $config->get('metodos');
    $inputs = $config->get('inputs');

    $method = $_SERVER['REQUEST_METHOD'];
    $request = explode('/', trim($_SERVER['REQUEST_URI'],'/'));        
    $input = json_decode(file_get_contents('php://input'),true);

    header('Content-Type: application/json');

    $acceso = new login();
    $conecta = new conecta();
    $reqhead = new Request();

    //valida base y tabla

    if(count($request) <= 1){
        echo json_encode("Se tiene que ingresar metodo o base de datos");
        return;
    }else{
        if(count($request) <= 2){
            switch($request[1]){
                /*login*/
                case $metodos->toArray()[0]:
                    if($method != 'POST'){
                        echo json_encode("Metodo no permitido para " . $metodos->toArray()[0]);
                    }elseif($input==null){
                        echo json_encode("Se requieren parametros de entrada para metodo " . $metodos->toArray()[0]);
                    }
                    elseif(!array_key_exists('usuarioOcorreo', $input)){
                        echo json_encode("Se tiene que proporcionar usuario o correo");
                    }elseif(!array_key_exists('contrasenna', $input)){
                        echo json_encode("Se tiene que proporcionar contraseña");
                    }else{
                        $acceso->setContrasenna($input[$inputs->toArray()[2]]);
                        $acceso->setusuarioOcorreo($input[$inputs->toArray()[1]]);
                        echo json_encode($acceso->loginUser());
                    }
                    break;
                /*alta*/
                case $metodos->toArray()[1]:
                    if($method != 'POST'){
                        echo json_encode("Metodo no permitido para " . $metodos->toArray()[1]);
                    }
                    elseif($input == null || count($input) != 3){
                        echo json_encode("Parametros de entrada incorrectos");
                    }
                    elseif(!array_key_exists('usuario', $input)){
                        echo json_encode("Usuario es requerido");
                    }elseif(!array_key_exists('correo', $input)){
                        echo json_encode("Correo es requerido");
                    }elseif(!array_key_exists('contrasenna', $input)){
                        echo json_encode("Contraseña es requerida");
                    }
                    else{
                        $acceso->setUsuario($input[$inputs->toArray()[0]]);
                        $acceso->setCorreo($input[$inputs->toArray()[3]]);
                        $acceso->setContrasenna($input[$inputs->toArray()[4]]);
                        echo json_encode($acceso->createUser());
                    }
                    break;
                default:
                    echo json_encode("Se tiene que ingresar una tabla");
                    break;
            }
            return;
        }
        $sqlSch = "SELECT SCHEMA_NAME FROM" . " INFORMATION_SCHEMA" . ".SCHEMATA WHERE SCHEMA_NAME = '" . $request[1] . "'";
        $sqlTbl = "SELECT table_name FROM" . " information_schema.tables WHERE table_schema = '" . $request[1] . "' AND table_name = '" . $request[2] . "' LIMIT 1;";
    }

    //print_r($acceso->validaToken());

    $authHeader = $reqhead->getHeader('token');

    /*valida si se envio un token en la peticion*/
    if($authHeader!=null){
        $acceso->setToken($authHeader);
        $token = $acceso->validaToken();
    } else{
        echo json_encode("se tiene que enviar un token para la consulta");
        return;
    }

    /*si regresa error la consulta*/
    if($token[0] == 0){
        echo json_encode($token[1]->getMessage());
        return;
    }

    $result = $conecta->getConsulta($sqlSch);

    if($result->num_rows > 0){
        while($row = $result->fetch_assoc()){
            /*echo json_encode($row["SCHEMA_NAME"]);*/
            error_log($row["SCHEMA_NAME"]);
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
                };

                $valores = substr($valores, 0, strlen($valores)-1);
                /*$campos = substr($campos, 0, strlen($campos)-1);*/

                $sql = "call spAPI (2, '" . $request[1] . "', '" . $request[2] . "', '" . $campos . "', '" . $valores . "', " . $request[3] . " );";

                print_r($sql);
                        
        break;

        case 'POST':
            
            foreach ($input as $key => $value) {
                    $valores = $valores . "''". $value . "'',";
                    $campos = $campos . $key . ",";
            };

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

    echo  json_encode("consulta: " . $sql);
    $result = $conecta->getConsulta($sql);

    if($result->num_rows > 0){
    	while($row = $result->fetch_assoc()){            
    		echo $row["salida"];            
    	}    	
    }else{
    	echo json_encode("problema en select");
    }