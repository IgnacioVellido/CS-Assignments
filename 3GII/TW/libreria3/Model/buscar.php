<?php
require "/home/alumnos/1819/ignaciove1819/public_html/libreria3/Controller/page.php";

// --------------------------------
// --------------------------------

session_start();

$params = validarBuscarLibros($_GET);

if ($params["enviado"] == true && $params["hayerror"] == false) {
  $res = buscarLibros($params);

  if (isset($res["error"]))
    mostrarError($res);
  else {
    PrintUpMain();
    PrintResultadosBusqueda($res);
    PrintDownMain();
  }
}
else {
  PrintUpMain();
  /* Si quisiéramos que los géneros se incluyeran de forma dinámica,
    se haría una consulta a la BBDD y se pasaría el resultado como
    argumento a la siguiente función */
  PrintSearch();
  PrintDownMain();
}

// --------------------------------
// --------------------------------
// --------------------------------
// --------------------------------

function validarBuscarLibros($get) {
  // Si formulario enviado
  if (isset($get["palabra"])) {
    $res = $get;
    $res["enviado"] = true;
    $res["hayerror"] = false;
  }
  else {
    $res["enviado"] = false;
    $res["hayerror"] = false;
  }

  return $res;
}

// --------------------------------
// --------------------------------

function buscarLibros($params) {
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