<?php

    include('conexion/conexion.php');

    $conecta = new conecta();

	class login{
		private $usuario;
		private $contrasenna;
		private $token;

		public function setUsuario($usuario){
		    $this->usuario = $usuario;
        }

        public function setContrasenna($contrasenna){
		    $this->contrasenna = $contrasenna;
        }

        public function getToken(){
            $this->token = $this->usuario;
        	return $this->token;
        }

	}