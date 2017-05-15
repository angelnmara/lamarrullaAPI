<?php

    require_once('vendor/autoload.php');

    use Zend\Config\Factory;

    class conecta{

        private $result;

        public function getConsulta($sql)
        {
            $config = Factory::fromFile('config/config.php', true);
            $database = $config->get('database');
            $serverName = $database->get('host');
            $userName = $database->get('user');
            $password = $database->get('password');
            $dbname = $database->get('name');

            //create connexion
            $conn = new mysqli($serverName, $userName, $password, $dbname);

            //valida conecion
            if($conn->connect_error){
                die("coneccion fallo: " . $conn->connect_error);
            }

            return $this->result = $conn->query($sql);

        }

    }