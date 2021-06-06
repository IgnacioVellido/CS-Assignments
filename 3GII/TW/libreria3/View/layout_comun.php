<?php   // Partes compartida por todas las páginas

// --------------------------------
// --------------------------------

function PrintHead() {
echo <<< HTML
  <!DOCTYPE html>
  <html lang="es">
  <head>
    <meta charset="utf-8">
    <meta name="author" content="Ignacio Vellido Expósito"> 
    <title>La Librería</title>    
    <link rel="stylesheet" href="https://void.ugr.es/~ignaciove1819/libreria3/View/site.css">   
  </head>
HTML;
}

// --------------------------------
// --------------------------------

function PrintBodyInicio() {
echo <<< HTML
  <body>
      <div id="wrap">    
HTML;
}

// --------------------------------
// --------------------------------

function PrintHeader() {
echo <<< HTML
  <header> <!-- Encabezado -->      
    <img src="https://void.ugr.es/~ignaciove1819/libreria3/View/img/logos/logo.png" alt="Logo de La Librería"> <!-- Logo -->
    <div id="nombre_eslogan">
      <h1>La Librería</h1>
      <p>Para los fans de la lectura</p>
    </div>      
  </header>
HTML;
}

// --------------------------------
// --------------------------------

function PrintNav($logged) {
echo "<nav> <!-- Menú de navegación -->";

if ($logged) 
  $paginas = ["Inicio", "Catálogo", "Búsqueda", "Tiendas", "Añadir libro", "Borrar libro", "Editar libro"];
else
  $paginas = ["Inicio", "Catálogo", "Búsqueda", "Tiendas", "Iniciar Sesión"];

foreach ($paginas as $k => $v)
  echo "<a href='https://void.ugr.es/~ignaciove1819/libreria3/index.php?p=".($k)."'>".$v."</a>";

echo "</nav>";
}

// --------------------------------
// --------------------------------

function PrintAside($params) {
?>
  <aside>
    <div id="mas-vendidos" class="recomendaciones">
      <h4>Con libros de:</h4>
      <ul>
        <li><?php if(isset($params[0])) echo $params[0][0]; ?></li>
        <li><?php if(isset($params[1])) echo $params[1][0]; ?></li>
        <li><?php if(isset($params[2])) echo $params[2][0]; ?></li>
      </ul>
    </div>
  </aside>
<?php
}

// --------------------------------
// --------------------------------

function PrintFooter() {
echo <<< HTML
  <footer>
    <div id="tiendas">
      <ul>
        <li>
          <p class="ciudad">Barcelona</p>            
          <ul class="locales">
            <li>Park Güell, 08024, Barcelona</li>
          </ul>
        </li>
        <li>
          <p class="ciudad">Madrid</p>
          <ul class="locales">
            <li>Av. de Concha Espina, 1, 28036, Madrid</li>
            <li>Calle de Floridablanca, S/N, 28071, Madrid</li>
          </ul>
        </li>
      </ul>
    </div>

    <div id="contacto">      
      <div id="email-y-logo">
        <img src="https://void.ugr.es/~ignaciove1819/libreria3/View/img/logos/mail.png" alt="Logo dirección de correo">
        <p>lalibreria@gmail.com</p>
      </div>
      <div id="media">
        <img src="https://void.ugr.es/~ignaciove1819/libreria3/View/img/logos/twitter.png" alt="Logo de Twitter">
        <img src="https://void.ugr.es/~ignaciove1819/libreria3/View/img/logos/youtube.png" alt="Logo de Youtube">
        <img src="https://void.ugr.es/~ignaciove1819/libreria3/View/img/logos/facebook.png" alt="Logo de Facebook">
      </div>
    </div>

    <div id="informacion">
      <ul>
        <li><a href="contact">Contacto</a></li>
        <li><a href="aboutus">Sobre nosotros</a></li>
        <li><a href="map">Mapa del sitio</a></li>
      </ul>
    </div>
  </footer>
HTML;
}

// --------------------------------
// --------------------------------

function PrintBodyFin() {
echo <<< HTML
      </div>
    </body>
  </html>
HTML;
}

// --------------------------------
// --------------------------------

function mostrarResultados($params) {
  PrintHead();
  PrintBodyInicio();
  PrintHeader();

  PrintNav(true);  
  
  echo "<main class=\"indx\">";
  // echo "<main class=\"result\">";
  for ($i=0; $i<sizeof($params); $i++) {
    echo "<p class=\"result\">{$params[$i]}</p>";
  }
  echo "</main>";
  
  PrintAside();
  PrintFooter();
  PrintBodyFin();
}
?>