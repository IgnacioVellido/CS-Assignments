<?php // Agrupa funciones de la vista

require "/home/alumnos/1819/ignaciove1819/public_html/libreria3/Model/db.php";
require "/home/alumnos/1819/ignaciove1819/public_html/libreria3/View/html.php";

// --------------------------------
// --------------------------------

function PrintUpMain() {  
  PrintHead();
  PrintBodyInicio();
  PrintHeader();

  if (isset($_SESSION["valid"]) && $_SESSION["valid"])
    PrintNav(true);
  else
    PrintNav(false);
}

// --------------------------------
// --------------------------------

function PrintDownMain() {
  $params = DB_calcularAside();
  PrintAside($params);
  
  PrintFooter();
  PrintBodyFin();    
}


// --------------------------------
// --------------------------------

function msgCount($msg) {
  if (is_array($msg))
    if (count($msg)==0)
      return 0;
    else
      return msgCount($msg[0])+
            msgCount(array_slice($msg,1));
  else if (!is_bool($msg))
    return 1;
  else
    return 0;
}

// --------------------------------
// --------------------------------

function msgError($msg) {
  if (is_array($msg))
    foreach ($msg as $v)
      msgError($v);
  else
    echo "<p>$msg</p>";
}

// --------------------------------
// --------------------------------

function mostrarError($msg, $tipo='msgerror') {
  PrintUpMain();
  
  echo "<main class=\"indx\">";
  // echo "<main class='$tipo'>";
  msgError($msg);
  echo "</main>";
  
  PrintDownMain();
}

?>