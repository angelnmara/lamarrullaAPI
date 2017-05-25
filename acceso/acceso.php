<?php

    require_once('vendor/autoload.php');

    use Zend\Config\Factory;
    use Firebase\JWT\JWT;

    include('conexion/conexion.php');

	class login{

		private $usuario;
		private $correo;
		private $contrasenna;
		private $token;
		private $usuarioOcorreo;
		private $contrasennaE;

		public function setToken($token){
		    $this->token = $token;
        }

		public function setusuarioOcorreo($usuarioOcorreo){
		    $this->usuarioOcorreo = $usuarioOcorreo;
        }

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
            $this->contrasennaE = $this->getContrasenniaE();
            $sql = "call spAltaUsuario ('" . $this->usuario . "', '" .  $this->correo ."', '" . $this->contrasennaE . "');";
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

        public function loginUser(){

            $config = Factory::fromFile('config/config.php', true);

            $conecta = new conecta();
            $sql = "call getPassw('". $this->usuarioOcorreo . "');";
            $result = $conecta->getConsulta($sql);
            if($result->num_rows > 0){
                while ($row = $result->fetch_assoc()){
                    $usrId = $row["fiIdUsu"];
                    $usr = $row["fcUsu"];
                    $passwdb = $row["fcUsuPassw"];
                }
            }else{
                return json_encode("problema en select");
            }

            if(password_verify($this->contrasenna, $passwdb)){
                $tokenId    = base64_encode(mcrypt_create_iv(32));
                $issuedAt   = time();
                $notBefore  = $issuedAt + 10;  //Adding 10 seconds
                $expire     = $notBefore + (60 * 60); // Adding 60 seconds
                $serverName = $config->get('serverName');

                /*
                 * Create the token as an array
                 */
                $data = [
                    'iat'  => $issuedAt,         // Issued at: time when the token was generated
                    'jti'  => $tokenId,          // Json Token Id: an unique identifier for the token
                    'iss'  => $serverName,       // Issuer
                    'nbf'  => $notBefore,        // Not before
                    'exp'  => $expire,           // Expire
                    'data' => [                  // Data related to the signer user
                        'userId'   => $usrId, // userid from the users table
                        'userName' => $usr, // User name
                    ]
                ];

                header('Content-type: application/json');

                /*
                 * Extract the key, which is coming from the config file.
                 *
                 * Best suggestion is the key to be a binary string and
                 * store it in encoded in a config file.
                 *
                 * Can be generated with base64_encode(openssl_random_pseudo_bytes(64));
                 *
                 * keep it secure! You'll need the exact key to verify the
                 * token later.
                 */
                $secretKey = base64_decode($config->get('jwt')->get('key'));

                /*
                 * Extract the algorithm from the config file too
                 */
                $algorithm = $config->get('jwt')->get('algorithm');

                /*
                 * Encode the array to a JWT string.
                 * Second parameter is the key to encode the token.
                 *
                 * The output string can be validated at http://jwt.io/
                 */
                $jwt = JWT::encode(
                    $data,      //Data to be encoded in the JWT
                    $secretKey, // The signing key
                    $algorithm  // Algorithm used to sign the token, see https://tools.ietf.org/html/draft-ietf-jose-json-web-algorithms-40#section-3
                );

                $unencodedArray = ['jwt' => $jwt];
                return $unencodedArray;
            }else{
                return "contraseña incorrecta";
            }
        }

        public function validaToken(){

            if($this->token){
                list($jwt) = sscanf($this->token->toString(), 'Token :%s');
            }

            if($jwt){
                try {
                    $config = Factory::fromFile('config/config.php', true);

                    /*
                     * decode the jwt using the key from config
                     */
                    $secretKey = base64_decode($config->get('jwt')->get('key'));

                    $token = JWT::decode($jwt, $secretKey, [$config->get('jwt')->get('algorithm')]);

                    return [1, $token];

                } catch (Exception $e) {
                    /*
                     * the token was not able to be decoded.
                     * this is likely because the signature was not able to be verified (tampered token)
                     */
                    return [0, $e];
                    header('HTTP/1.0 401 Unauthorized');
                }
            }else{
                header('HTTP/1.0 400 Bad Request');
                //return 0;
            }

            //return 1;

        }

	}