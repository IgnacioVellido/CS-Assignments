<?php
require "/home/alumnos/1819/ignaciove1819/public_html/libreria3/Controller/page.php";

// --------------------------------
// --------------------------------

// Si no tiene privilegios lo mandamos a login
session_start();

if (!isset($_SESSION["valid"]) || !$_SESSION["valid"])  
  header("Location: ../index.php?p=4");

$params = validarInsertarLibro($_POST);
  
if ($params["enviado"] == true && $params["hayerror"] == false) {
  $res = insertarLibro($params);  

  if (isset($res) && msgCount($res)>0)
    mostrarError($res);
  else
    mostrarResultados($res);
}
else {
  PrintUpMain();
  PrintAddLibro($params);
  PrintDownMain();
}

// --------------------------------
// --------------------------------
// --------------------------------
// --------------------------------
  
function validarInsertarLibro($post) {  
  // Si formulario enviado
  if (isset($post["isbn"])) {
    $res = $post;
    $res["enviado"] = true;
    $res["hayerror"] = false;

    $res["errautor"] = '';
    $res["errtitulo"] = '';
    $res["erreditorial"] = '';
    $res["errisbn"] = '';    
    
    // Comprobación de los datos (vienen obligatoriamente rellenos por 
    // poner "required" en el formulario)

    // Expresión regular cogida de internet
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

function insertarLibro($datos) {    
  $db = DB_conexion();
  $res = DB_addLibro($db, $datos);
  DB_desconexion($db);

  if (is_bool($res) && $res == true)
    $info[] = 'Añadido libro correctamente';
  else    
    $info[] = $res;  

  return $info;
}
?>