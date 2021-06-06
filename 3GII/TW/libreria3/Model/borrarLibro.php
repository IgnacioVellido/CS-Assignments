<?php
require "/home/alumnos/1819/ignaciove1819/public_html/libreria3/Controller/page.php";

// --------------------------------
// --------------------------------

// Si no tiene privilegios lo mandamos a login
session_start();

if (!isset($_SESSION["valid"]) || !$_SESSION["valid"])  
  header("Location: ../index.php?p=4");

$params = validarBorrarLibro($_POST);
  
if ($params["enviado"] == true && $params["hayerror"] == false) {
  $res = borrarLibro($params);  

  if (isset($res) && msgCount($res)>0)
    mostrarError($res);
  else
    mostrarResultados($res);
}
else {
  PrintUpMain();
  PrintBorrarLibro($params);
  PrintDownMain();
}


// --------------------------------
// --------------------------------
// --------------------------------
// --------------------------------
  
function validarBorrarLibro($post) {  
  // Si formulario enviado
  if (isset($post["isbn"])) {
    $res = $post;
    $res["enviado"] = true;
    $res["hayerror"] = false;
    
    $res["errisbn"] = '';    
        
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

function borrarLibro($datos) {    
  $db = DB_conexion();
  $res = DB_borrarLibro($db, $datos);
  DB_desconexion($db);

  if (is_bool($res) && $res == true)
    $info[] = 'Libro eliminado correctamente';
  else    
    $info[] = $res;  

  return $info;
}

?>