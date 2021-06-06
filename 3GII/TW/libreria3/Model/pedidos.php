<?php
require "/home/alumnos/1819/ignaciove1819/public_html/libreria3/Controller/page.php";

// --------------------------------
// --------------------------------

session_start();

if (isset($_POST["accion"])) {    
  if ($_POST["accion"] == "ver") {  // Solicita pedir un libro
    $params = validarGetLibro($_POST);    
    $res = getLibro($params);
  
    if (isset($res["error"]))
      mostrarError($res);
    else {
      PrintUpMain();
      PrintOrders($res);
      PrintDownMain();
    }
  }
  else {  // Ha enviado el comprar el libro
    $params = validarPedido($_POST);
  
    $res = getLibro($params);  
    $params = array_merge($params, $res);
      
    if ($params["enviado"] == true && $params["hayerror"] == false) {
      PrintUpMain();
      PrintCompra($params);
      PrintDownMain();
    }
    else {  // Error, se vuelve a mostrar la página
  
      if (isset($res["error"]))
        mostrarError($res);
      else {
        $params["hayerror"] = true;

        PrintUpMain();
        PrintOrders($params);
        PrintDownMain();
      }
    }    
  }
}
else {
  // Si se ha llegado por otros medios, envía a la página inicial
  header("Location: ../index.php");
}

// --------------------------------
// --------------------------------
// --------------------------------
// --------------------------------

function getLibro($datos) {    
  $db = DB_conexion();
  $res = DB_getLibro($db, $datos);
  DB_desconexion($db); 

  if (isset($res["encontrado"]) && $res["encontrado"] == true)
    $info = $res;  
  else    
    $info["error"] = 'No se encuentra el libro solicitado';

  return $info;
}

// --------------------------------
// --------------------------------

function validarGetLibro($post) {  
  // Si formulario enviado
  if (isset($post["isbn"])) {
    $res = $post;
    $res["enviado"] = true;
    $res["hayerror"] = false;
    
    $res["errisbn"] = '';    
        
    // Cogido de internet
    $regex = '/\b(?:ISBN(?:: ?| ))?((?:97[89])?\d{9}[\dx])\b/i';

    if (!preg_match($regex, str_replace('-', '', $post["isbn"]))) {
      $res['errisbn'] = "El ISBN no sigue el formato oficial. <br> Ejemplos: 978-92-95055-02-5, 978 10 596 52068 7, 978-0-596-52068-7";
      $res["hayerror"] = true;      
    }
    
  }
  else {
    $res["enviado"] = false;
    $res["hayerror"] = false;
  }

  return $res;
}

// --------------------------------
// --------------------------------

// Cogido de internet
function is_valid_luhn($number) {
  $sum = '';
  $revNumber = strrev($number);
  $len = strlen($number);

  for ($i = 0; $i < $len; $i++) {
      $sum .= $i & 1 ? $revNumber[$i] * 2 : $revNumber[$i];
  }

  return array_sum(str_split($sum)) % 10 === 0;
}

// --------------------------------
// --------------------------------

function validarPedido($post) {
  // Si formulario enviado
  if (isset($post["isbn"])) {
    $res = $post;
    $res["enviado"] = true;
    $res["hayerror"] = false;

    $regex = '/[a-zA-Z]/';

    if (!preg_match($regex, str_replace(' ', '', $res["nombre"])))  {
      $res['errnombre'] = "Solo se admiten letras y espacios";
      $res["hayerror"] = true;  
    }      
    else 
      $res["errnombre"] = '';

    if (!ctype_digit($res["tarjeta"]) || !is_valid_luhn($res["tarjeta"])) {
      $res['errtarjeta'] = "No es un número de tarjeta válido";
      $res["hayerror"] = true;  
    }
    else 
      $res["errtarjeta"] = '';

    if (strlen($res["cvc"]) != 3 || !ctype_digit($res["cvc"])) { // Tres dígitos
      $res['errcvc'] = "Debe introducir 3 dígitos";
      $res["hayerror"] = true;  
    }
    else 
      $res["errcvc"] = '';
  }
  else {
    $res["enviado"] = false;
    $res["hayerror"] = false;
  }

  return $res;
}

// --------------------------------
// --------------------------------

function comprarLibro($params) {
  $db = DB_conexion();
  $res = DB_buscarLibros($db, $params["palabra"]);
  DB_desconexion($db);

  if (is_bool($res) && !$res)
    $info["error"] = 'No se encuentran resultados';
  else    
    $info = $res;  

  return $info;
}
?>