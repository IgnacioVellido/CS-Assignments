<?php
require_once('/home/alumnos/1819/ignaciove1819/public_html/libreria3/Model/dbcredenciales.php');

// --------------------------------
// --------------------------------

function DB_conexion() {
  $db = mysqli_connect(DB_HOST,DB_USER,DB_PASSWD,DB_DATABASE);

  if (!$db)
   return "Error de conexión a la base de datos (".mysqli_connect_errno().
          ") : ".mysqli_connect_error();

  // Establecer la codificación de los datos almacenados
  mysqli_set_charset($db,"utf8");
  return $db;
}


function DB_desconexion($db) {
  mysqli_close($db);
}

// --------------------------------
// --------------------------------

function DB_query($db, $query) {
  return mysqli_query($db, $query);
}

// --------------------------------
// --------------------------------

function DB_addLibro($db, $datos) {
  // Comprobamos si existe un libro con el mismo ISBN
  $query = "SELECT COUNT(*) FROM libro 
            WHERE isbn='{$datos['isbn']}'";            
  $res = DB_query($db, $query);
  $num = mysqli_fetch_row($res)[0];

  if ($num>0) {    
    $info[] = 'Ya existe libro con ese ISBN';
  }
  else {  
    $query = "INSERT INTO libro (autor, titulo, portada, editorial, precio, isbn)
              VALUES ('{$datos['autor']}','{$datos['titulo']}', '{$datos['portada']}',
              '{$datos['editorial']}', '{$datos['precio']}', '{$datos['isbn']}')";
    $res = DB_query($db, $query);

    if (!$res) {
      $info[] = 'Error en la consulta '.__FUNCTION__;
      $info[] = mysqli_error($db);
    }
  }

  if (isset($info)) {    
    return $info;
  }
  else
    return true;
}

// --------------------------------
// --------------------------------

function DB_borrarLibro($db, $datos) {
  // Comprobamos si existe un libro con el mismo ISBN
  $query = "SELECT COUNT(*) FROM libro 
            WHERE isbn='{$datos['isbn']}'";            
  $res = DB_query($db, $query);
  $num = mysqli_fetch_row($res)[0];

  if ($num==0)
    $info[] = 'No existe libro con ese ISBN';
  else {   
    $query = "DELETE FROM libro WHERE isbn='{$datos["isbn"]}'";
    $res = DB_query($db, $query);

    if (!$res) {
      $info[] = 'Error en el borrado '.__FUNCTION__;
      $info[] = mysqli_error($db);
    }
  }

  if (isset($info))
    return $info;
  else
    return true;
}

// --------------------------------
// --------------------------------

function DB_getLibro($db, $datos) {
  // Comprobamos si existe un libro con el mismo ISBN
  $query = "SELECT COUNT(*) FROM libro 
            WHERE isbn='{$datos['isbn']}'";            
  $res = DB_query($db, $query);
  $num = mysqli_fetch_row($res)[0];

  if ($num==0)
    $info[] = 'No existe libro con ese ISBN';
  else {   
    $query = "SELECT * FROM libro WHERE isbn='{$datos["isbn"]}'";
    $res = DB_query($db, $query);

    if ($res && mysqli_num_rows($res)==1) {
      $libro = mysqli_fetch_assoc($res);
      $libro["encontrado"] = true;
    }
    else {
      $info[] = 'Error en la consulta '.__FUNCTION__;
      $info[] = mysqli_error($db);
    }

    mysqli_free_result($res);
  }

  if (isset($info))
    return $info;
  else
    return $libro;
}

// --------------------------------
// --------------------------------

function DB_editarLibro($db, $datos) {
  // Comprobamos si existe un libro con el mismo ISBN
  $query = "SELECT COUNT(*) FROM libro 
            WHERE isbn='{$datos['isbn']}'";            
  $res = DB_query($db, $query);
  $num = mysqli_fetch_row($res)[0];

  if ($num==0) {    
    $info[] = 'No existe libro con ese ISBN';
  }
  else {  
    $query = "UPDATE libro SET autor='{$datos['autor']}', titulo='{$datos['titulo']}', 
              portada='{$datos['portada']}', editorial='{$datos['editorial']}', 
              precio='{$datos['precio']}' WHERE isbn='{$datos['isbn']}'";
    $res = DB_query($db, $query);

    if (!$res) {
      $info[] = 'Error en la modificación '.__FUNCTION__;
      $info[] = mysqli_error($db);
    }
  }

  if (isset($info)) {    
    return $info;
  }
  else
    return true;
}

// --------------------------------
// --------------------------------

function DB_calcularAside() {
  $db = DB_conexion();

  $query = "SELECT autor, COUNT(*) AS magnitude 
            FROM libro GROUP BY autor
            ORDER BY magnitude DESC LIMIT 3";

  $res = DB_query($db, $query);  
  $params = mysqli_fetch_all($res);
  
  mysqli_free_result($res);  

  DB_desconexion($db);

  return $params;
}

// --------------------------------
// --------------------------------

function DB_buscarLibros($db, $palabra) {
  $query = "SELECT * FROM libro
            WHERE (autor LIKE '%{$palabra}%'
            OR titulo LIKE '%{$palabra}%');";

  $res = DB_query($db, $query);  
  $results = [];

  if (!$res) {    
    $info[] = 'No se han encontrado resultados';
  }
  else {       
    $i = 0;

    while ($libro = mysqli_fetch_array($res)) {
      $results[$i] = $libro;
      $i += 1;
    }

    mysqli_free_result($res);
  }

  if (isset($info))
    return false;
  else
    return $results;
}

?>