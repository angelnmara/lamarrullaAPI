<?php
return array(
    'jwt' => array(
        'key'       => 'marrulla',     // Key for signing the JWT's, I suggest generate it with base64_encode(openssl_random_pseudo_bytes(64))
        'algorithm' => 'HS512' // Algorithm used to sign the token, see https://tools.ietf.org/html/draft-ietf-jose-json-web-algorithms-40#section-3
        ),
    'database' => array(
        'user'     => 'dave', // Database username
        'password' => 'maradr', // Database password
        'host'     => 'localhost', //'yashiropaintingcom.ipagemysql.com', // Database host localhost
        'name'     => 'dbmadeinchiconcuac' // Database schema name
    ),
    'serverName' => 'lamarrulla.space',
    'metodos' => array('login',
        'alta'),
    'inputs' => array('usuario', 'usuarioOcorreo', 'contrasenna', 'correo', 'contrasenna')
);