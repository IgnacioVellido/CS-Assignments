<?php
require "/home/alumnos/1819/ignaciove1819/public_html/libreria3/Controller/page.php";

// --------------------------------
// --------------------------------

// Si no tiene privilegios lo mandamos a login
session_start();

if (!isset($_SESSION["valid"]) || !$_SESSION["valid"])  
  header("Location: ../index.php?p=4");

if (isset($_POST["accion"])) {    
  if ($_POST["accion"] == "ver") {  // Solicita un libro
    $params = validarGetLibro($_POST);
  
    if ($params["enviado"] == true && $params["hayerror"] == false) {
      $res = getLibro($params);  
      
      if (isset($res["error"]))
        mostrarError($res);
      else {
        PrintUpMain();
        
        // Para que sepa que los datos vienen sin errores
        $res["recuperado"] = true;
        PrintEditarLibro($res);

        PrintDownMain();
      }
    }
    else {
      PrintUpMain();
      PrintGetLibro($params);
      PrintDownMain();
    }
  }
  else {  // Editar el libro
    $params = validarEditarLibro($_POST);
      
    if ($params["enviado"] == true && $params["hayerror"] == false) {
      $res = editarLibro($params);  
    
      if (isset($res) && msgCount($res)>0)
        mostrarError($res);
      else
        mostrarResultados($res);
    }
    else {
      PrintUpMain();
      PrintEditarLibro($params);
      PrintDownMain();         
    }    
  }
}
else {  // Acaba de abrir la página
  $params = validarGetLibro($_POST);

  PrintUpMain();  
  PrintGetLibro($params);
  PrintDownMain();  
}


// --------------------------------
// --------------------------------
// --------------------------------
// --------------------------------
  
function validarGetLibro($post) {  
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

function validarEditarLibro($post) {  
  // Si formulario enviado
  if (isset($post["isbn"])) {
    $res = $post;
    $res["enviado"] = true;
    $res["hayerror"] = false;

    $res["errautor"] = '';
    $res["errtitulo"] = '';
    $res["erreditorial"] = '';
    $res["errisbn"] = '';    
    
    // Los datos vienen obligatoriamente rellenos por 
    // poner "required" en el formulario

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

function editarLibro($datos) {    
  $db = DB_conexion();
  $res = DB_editarLibro($db, $datos);
  DB_desconexion($db);

  if (is_bool($res) && $res == true)
    $info[] = 'Libro modificado correctamente';
  else    
    $info[] = $res;  

  return $info;
}

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
?>