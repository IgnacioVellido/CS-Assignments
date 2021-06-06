<?php
require "/home/alumnos/1819/ignaciove1819/public_html/libreria3/Controller/page.php";

// --------------------------------
// --------------------------------

session_start();

PrintUpMain();

// Vemos qué página concreta mostrar
$num_pag = 0;
if (isset($_GET["p"]) && ($_GET["p"] >= 0 || $_GET["p"] <= 6)) {
  $num_pag = $_GET["p"];

  // Comprobamos si estaba logueado
  if (isset($_SESSION["valid"]) && $_SESSION["valid"]) {
    switch ($num_pag) {
      case 0: PrintIndex(); break;
      case 1: 
        header("Location: ./Model/buscar.php?palabra=");
        break;
      case 2: 
        header("Location: ./Model/buscar.php");
        break;
      case 3: PrintStores(); break;
      case 4: 
        header("Location: ./Model/insertarLibro.php"); 
        break;
      case 5: 
        header("Location: ./Model/borrarLibro.php"); 
        break;
      case 6: 
        header("Location: ./Model/editarLibro.php"); 
        break;
      default:
        header("Location: .");
        break;
    }
  }
  else {
    switch ($num_pag) {
      case 0: PrintIndex(); break;
      case 1: 
        header("Location: ./Model/buscar.php?palabra=");
        break;
      case 2: PrintSearch(); break;
      case 3: PrintStores(); break;
      case 4: PrintLogin(); break;
      default:
        PrintLogin();
        break;
    }
  }
}
else {
  PrintIndex();
}

PrintDownMain();
?>