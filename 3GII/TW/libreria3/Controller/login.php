<?php

if (isset($_POST["usuario"]) && isset($_POST["pass"])) {
  // Aquí se podría comprobar código no malicioso en las entradas  

  // Comprobar si están correctos los credenciales
  if ($_POST["usuario"] == "admin" && $_POST["pass"] == "admin") {
    session_start();
    $_SESSION["usuario"] = "admin";
    $_SESSION["valid"] = true;
  }
  else
    // Se podría hacer un formulario sticky (que mantenga el usuario)
    header('Location: .');    
}

header('Location: ../index.php');
?>