<?php     // Formularios utilizados
// Quitar hidenn si no se manda al mismo archivo

// --------------------------------
// --------------------------------

function PrintLogin() {
echo <<< HTML
  <main id="forms">
    <p class="form-title">Introduzca sus credenciales:</p>
    <form action="./Controller/login.php" method="post">
      <label><p>Usuario</p>
          <input type="text" name="usuario" placeholder="admin"/>
      </label>
      <label><p>Clave</p>
          <input type="password" name="pass" placeholder="admin"/>
      </label>      
      <input type="submit" name="login" value="Login">
    </form>     
  </main>
HTML;
}

// --------------------------------
// --------------------------------

function PrintAddLibro($params) {
  if ($params["enviado"] == false) {
    $params["autor"] = '';
    $params["errautor"] = '';
    $params["titulo"] = '';
    $params["errtitulo"] = '';
    $params["editorial"] = '';
    $params["erreditorial"] = '';
    $params["isbn"] = '';
    $params["errisbn"] = '';    
    $params["precio"] = '';
  }
  
?>
<main id="forms">
  <p class="form-title">Introduzca los datos del libro:</p>  
  <form action="https://void.ugr.es/~ignaciove1819/libreria3/Model/insertarLibro.php" method="post">
    <label><p>Autor</p>
        <input type="text" name="autor" required 
          <?php echo " value='".$params["autor"]."'"; ?>
        >      
        <?php if ($params['errautor'] != '')
                echo "<p class='error'>{$params['errautor']}</p>"; ?>
    </label>

    <label><p>Título</p>
        <input type="text" name="titulo" required 
          <?php echo " value='".$params["titulo"]."'"; ?>
        >      
        <?php if ($params['errtitulo'] != '')
                echo "<p class='error'>{$params['errtitulo']}</p>"; ?>
    </label>

    <label><p>Portada</p>
        <input type="file" name="portada">
    </label>

    <label><p>Editorial</p>
        <input type="text" name="editorial" required 
          <?php echo " value='".$params["editorial"]."'"; ?>
        >      
        <?php if ($params['erreditorial'] != '')
                echo "<p class='error'>{$params['erreditorial']}</p>"; ?>
    </label>      

    <label><p>Precio</p>
        <input type="number" min="0" step="0.01" name="precio" required
          <?php echo " value='".$params["precio"]."'"; ?>
        >
    </label>      

    <label><p>ISBN</p>
        <input type="text" name="isbn" required 
          <?php echo " value='".$params["isbn"]."'"; ?>
        >      
    </label>            
    <?php if ($params['errisbn'] != '')
            echo "<p class='error'>{$params['errisbn']}</p>"; ?>

    <input type="submit" name="add" value="Añadir">
  </form>
</main>

<?php
}

// --------------------------------
// --------------------------------

function PrintBorrarLibro($params) {
  if ($params["enviado"] == false) {    
    $params["isbn"] = '';
    $params["errisbn"] = '';    
  }

?>
  <main id="forms">
    <p class="form-title">Introduzca el ISBN del libro a borrar:</p>
    <form action="https://void.ugr.es/~ignaciove1819/libreria3/Model/borrarLibro.php" method="post">
      <label><p>ISBN</p>
        <input type="text" name="isbn" required 
          <?php echo " value='".$params["isbn"]."'"; ?>
        >      
      </label>            
      <?php if ($params['errisbn'] != '')
            echo "<p class='error'>{$params['errisbn']}</p>"; ?> 

      <input type="submit" name="borrar" value="Borrar">
    </form>     
  </main>
<?php
}

// --------------------------------
// --------------------------------

function PrintGetLibro($params) {
  if ($params["enviado"] == false) {    
    $params["isbn"] = '';
    $params["errisbn"] = '';    
  }

?>
  <main id="forms">
    <p class="form-title">Introduzca el ISBN del libro a editar:</p>
    <form action="https://void.ugr.es/~ignaciove1819/libreria3/Model/editarLibro.php" method="post">
      <input type="hidden" name="accion" value="ver">

      <label><p>ISBN</p>
        <input type="text" name="isbn" required 
          <?php echo " value='".$params["isbn"]."'"; ?>
        >      
      </label>            
      <?php if ($params['errisbn'] != '')
            echo "<p class='error'>{$params['errisbn']}</p>"; ?> 

      <input type="submit" name="buscar" value="Buscar">
    </form>     
  </main>
<?php
}

// --------------------------------
// --------------------------------

function PrintEditarLibro($params) {
  if ($params["recuperado"] == true) {
    $params["errautor"] = '';    
    $params["errtitulo"] = '';
    $params["erreditorial"] = '';
    $params["errisbn"] = '';    
  }
  
?>
<main id="forms">
  <p class="form-title">Introduzca los datos del libro:</p>  
  <form action="https://void.ugr.es/~ignaciove1819/libreria3/Model/editarLibro.php" method="post">
    <input type="hidden" name="accion" value="editar">
    <label><p>Autor</p>
        <input type="text" name="autor" required 
          <?php echo " value='".$params["autor"]."'"; ?>
        >      
        <?php if ($params['errautor'] != '')
                echo "<p class='error'>{$params['errautor']}</p>"; ?>
    </label>

    <label><p>Título</p>
        <input type="text" name="titulo" required 
          <?php echo " value='".$params["titulo"]."'"; ?>
        >      
        <?php if ($params['errtitulo'] != '')
                echo "<p class='error'>{$params['errtitulo']}</p>"; ?>
    </label>

    <label><p>Portada</p>
        <input type="file" name="portada" default="generica.jpg">
    </label>

    <label><p>Editorial</p>
        <input type="text" name="editorial" required 
          <?php echo " value='".$params["editorial"]."'"; ?>
        >      
        <?php if ($params['erreditorial'] != '')
                echo "<p class='error'>{$params['erreditorial']}</p>"; ?>
    </label>      

    <label><p>Precio</p>
        <input type="number" min="0" step="0.01" name="precio" required
          <?php echo " value='".$params["precio"]."'"; ?>
        >
    </label>      

    <label><p>ISBN</p>
        <input type="text" name="isbn" required readonly
          <?php echo " value='".$params["isbn"]."'"; ?>
        >      
    </label>            
    <?php if ($params['errisbn'] != '')
            echo "<p class='error'>{$params['errisbn']}</p>"; ?>

    <input type="submit" name="editar" value="Editar">
  </form>
</main>

<?php
}

// --------------------------------
// --------------------------------

function PrintSearch() {
echo <<< HTML
  <main id="search">
    <form id="form-search" action="https://void.ugr.es/~ignaciove1819/libreria3/Model/buscar.php" method="GET">
      <label><p>Palabra de búsqueda</p>
        <input type="text" name="palabra"/>
      </label>      
      
      <!-- Recibiendo parámetros se podría construir de forma dinámica -->
      <label>
        <p>Género</p>
        <select name="genero">
          <option value="" disabled selected>- Elija el género -</option>        
          <option value="fantastica">Fantástica</option>
          <option value="historica">Histórica</option>          
          <option value="humor">Humor</option>    
          <option value="romantica">Romántica</option>      
          <option value="terror">Terror</option>
        </select>
      </label>        
            
      <input type="submit" value="Buscar"/>
    </form>
  </main>
HTML;
}

// --------------------------------
// --------------------------------

function PrintResultadosBusqueda($params) {
  echo "<main id=\"catalogue\">"; 

  foreach ($params as $p) {
    ?>
    <section class="libro">
      <img src="https://void.ugr.es/~ignaciove1819/libreria3/View/img/libros/<?php echo $p["portada"]; ?>" alt="Imagen no disponible">
      <h4><?php echo $p["titulo"]; ?></h4>
      <p><?php echo $p["autor"]; ?></p>
      <p class="precio"><?php echo $p["precio"]; ?>€</p>
      <form action="https://void.ugr.es/~ignaciove1819/libreria3/Model/pedidos.php" method="post">
        <input type="hidden" name="isbn" value="<?php echo $p["isbn"]; ?>">
        <input type="hidden" name="accion" value="ver">
        <input type="submit" name="pedido" value="Comprar">
      </form>
    </section>
    <?php
  }

  echo "</main>";
}

// --------------------------------
// --------------------------------

function PrintOrders($p) {
  if (!isset($p["hayerror"])) {
    $p["nombre"] = '';    
    $p["direccion"] = '';   
    $p["email"] = '';    
    $p["caducidad"] = '';    
    $p["tarjeta"] = '';    
    $p["cvc"] = '';    

    $p["errnombre"] = '';    
    $p["errtarjeta"] = '';    
    $p["errcvc"] = '';    
  }
  
?>
  <main id="orders">
    <div id="info-pedido">
      <div id="datos-libro">
          <img src="https://void.ugr.es/~ignaciove1819/libreria3/View/img/libros/<?php echo $p["portada"]; ?>" alt="Carátula del libro">                
          <ul id="datos-pedido">
            <li>
              <h4 class="categoria">Título</h4>
              <p class="valor"><?php echo $p["titulo"]; ?></p>
            </li>
            <li>
              <h4 class="categoria">Autor</h4>
              <p class="valor"><?php echo $p["autor"]; ?></p>
            </li>
            <li>
              <h4 class="categoria">ISBN</h4>
              <p class="valor"><?php echo $p["isbn"]; ?></p>
            </li>
            <li>
              <h4 class="categoria">Editorial</h4>
              <p class="valor"><?php echo $p["editorial"]; ?></p>
            </li>
          </ul>     
      </div>          

      <p id="descripcion-pedido">
        Lorem ipsum dolor sit amet consectetur adipisicing elit. Nesciunt consectetur dolor quis maxime voluptatibus autem culpa ipsam nobis minima iste tempore, non odit, excepturi blanditiis minus veritatis aliquam expedita sapiente!
      </p>
      <div id="precio-pedido">
        <h4>PRECIO</h4>
        <p><?php echo $p["precio"]; ?>€</p>
      </div>
    </div>

    <form id="form-orders" action="https://void.ugr.es/~ignaciove1819/libreria3/Model/pedidos.php" method="POST">
        <!-- Añadimos el isbn del libro para poder hacerlo sticky -->
        <input type="hidden" name="isbn" value="<?php echo $p["isbn"]; ?>">

        <label><p>Nombre y apellidos</p>
          <input type="text" name="nombre" required
            <?php echo " value='".$p["nombre"]."'"; ?>
          >
        </label>
        <?php if ($p['errnombre'] != '')
              echo "<p class='error'>{$p['errnombre']}</p>"; ?>

        <label><p>Dirección de envío</p>
          <textarea name="direccion"><?php echo $p["direccion"]; ?></textarea>
        </label>

        <label><p>Email</p>
          <input type="email" name="email"
            <?php echo " value='".$p["email"]."'"; ?>
          >
        </label>

        <label><p>Número de tarjeta</p>
          <input type="text" name="tarjeta" required
            <?php echo " value='".$p["tarjeta"]."'"; ?>
          >
        </label>
        <?php if ($p['errtarjeta'] != '')
              echo "<p class='error'>{$p['errtarjeta']}</p>"; ?>

        <label><p>Fecha de caducidad</p>
          <input type="month" min="2019-05" name="caducidad"
            <?php echo " value='".$p["caducidad"]."'"; ?>
          >
        </label>

        <label><p>CVC</p>
          <input type="text" name="cvc"
            <?php echo " value='".$p["cvc"]."'"; ?>
          >
        </label>          
        <?php if ($p['errcvc'] != '')
              echo "<p class='error'>{$p['errcvc']}</p>"; ?>

        <div class="radio">
          <p class="form-subtitle">Marque si procede</p>
          <div class="radio-options">
            <label><input type="checkbox" name="condiciones" value="condiciones"/>
              <p class="radio-text">He leído y acepto las condiciones de compra</p>
            </label>
            <label><input type="checkbox" name="maillist" value="maillist"/>
              <p class="radio-text">Deseo recibir información sobre novedades</p>
            </label>
            <label><input type="checkbox" name="regalo" value="regalo"/>
              <p class="radio-text">Deseo el envío envuelto para regalo</p>
            </label>            
          </div>
        </div>

        <input type="hidden" name="accion" value="comprar">
        <input type="submit" value="Hacer pedido"/>
      </form>
  </main>
<?php
}

// --------------------------------
// --------------------------------

function PrintCompra($p) {
?>
  <main id="orders">
    <div id="info-pedido">
      <div id="datos-libro">
          <img src="https://void.ugr.es/~ignaciove1819/libreria3/View/img/libros/<?php echo $p["portada"]; ?>" alt="Carátula del libro">                
          <ul id="datos-pedido">
            <li>
              <h4 class="categoria">Título</h4>
              <p class="valor"><?php echo $p["titulo"]; ?></p>
            </li>
            <li>
              <h4 class="categoria">Autor</h4>
              <p class="valor"><?php echo $p["autor"]; ?></p>
            </li>
            <li>
              <h4 class="categoria">ISBN</h4>
              <p class="valor"><?php echo $p["isbn"]; ?></p>
            </li>
            <li>
              <h4 class="categoria">Editorial</h4>
              <p class="valor"><?php echo $p["editorial"]; ?></p>
            </li>
          </ul>     
      </div>          

      <p id="descripcion-pedido">
        Lorem ipsum dolor sit amet consectetur adipisicing elit. Nesciunt consectetur dolor quis maxime voluptatibus autem culpa ipsam nobis minima iste tempore, non odit, excepturi blanditiis minus veritatis aliquam expedita sapiente!
      </p>
      <div id="precio-pedido">
        <h4>PRECIO</h4>
        <p><?php echo $p["precio"]; ?>€</p>
      </div>
    </div>

    <form id="form-orders" action="" method="POST">
        <label><p>Nombre y apellidos</p>
          <input type="text" name="nombre" readonly
            <?php echo " value='".$p["nombre"]."'"; ?>
          >
        </label>

        <label><p>Dirección de envío</p>
          <textarea name="direccion" readonly>
            <?php echo $p["direccion"]; ?>
          </textarea>
        </label>

        <label><p>Email</p>
          <input type="email" name="email" readonly
            <?php echo " value='".$p["email"]."'"; ?>
          >
        </label>

        <label><p>Número de tarjeta</p>
          <input type="text" name="tarjeta" readonly
            <?php echo " value='".$p["tarjeta"]."'"; ?>
          >
        </label>

        <label><p>Fecha de caducidad</p>
          <input type="month" min="2019-05" name="caducidad" readonly
            <?php echo " value='".$p["caducidad"]."'"; ?>
          >
        </label>
        
        <label><p>CVC</p>
          <input type="text" name="cvc" readonly
            <?php echo " value='".$p["cvc"]."'"; ?>
          >
        </label>          

        <div class="radio">
          <p class="form-subtitle">Marque si procede</p>
          <div class="radio-options">
            <label><input type="checkbox" name="condiciones" value="condiciones"
              onclick="return false;"
              <?php if (isset($p['condiciones'])) echo " checked"; ?>
            >
              <p class="radio-text">He leído y acepto las condiciones de compra</p>
            </label>

            <label><input type="checkbox" name="maillist" value="maillist"
              onclick="return false;"
              <?php if (isset($p['maillist'])) echo " checked"; ?>
            >
              <p class="radio-text">Deseo recibir información sobre novedades</p>
            </label>

            <label><input type="checkbox" name="regalo" value="regalo"
              onclick="return false;"
              <?php if (isset($p['regalo'])) echo " checked"; ?>
            >
              <p class="radio-text">Deseo el envío envuelto para regalo</p>
            </label>            
          </div>
        </div>

      </form>
      <p class="error">Compra realizada</p>
  </main>
<?php
}
?>