<?php

    include('conexion/conexion.php');

	class login{

		private $usuario;
		private $correo;
		private $contrasenna;
		private $token;

		public function setUsuario($usuario){
		    $this->usuario = $usuario;
        }

        public function setContrasenna($contrasenna){
		    $this->contrasenna = $contrasenna;
        }

        public function setCorreo($correo){
            $this->correo = $correo;
        }

        public function getContrasenniaE(){
            $this->token = password_hash($this->contrasenna, PASSWORD_BCRYPT);
        	return $this->token;
        }

        public function createUser(){
            $conecta = new conecta();
            $contraseniaE = $this->getContrasenniaE();
            $sql = "call spAltaUsuario ('" . $this->usuario . "', '" .  $this->correo ."', '" . $contraseniaE . "');";
            $result = $conecta->getConsulta($sql);
            if($result->num_rows > 0){
                while($row = $result->fetch_assoc()){
                    if($row["salida"] == 1){
                        return "usuario creado satisfactoriamente";
                    }elseif ($row["salida"] == 0){
                        return json_encode($row["error"]);
                    }else{
                        return json_encode("error desconocido");
                    }
                }
            }else{
                return"problema en select";
            }
        }
	}