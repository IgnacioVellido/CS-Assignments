<?php   // Main de cada página estática

// --------------------------------
// --------------------------------

function PrintIndex() {
echo <<< HTML
  <main id="indx"> <!-- Contenido principal del documento, 3 eventos -->
    <article class="evento">
      <div class="evento-cabecera">
        <div class="evento-info">
          <h3>Inauguración de La Librería</h3>
          <h5>01/01/2001</h5>
        </div>
        <img src="./View/img/eventos/inauguracion.jpg" alt="Inauguración">
      </div>
      <p>
        Lorem ipsum dolor sit amet consectetur adipisicing elit. Tempora earum ullam facilis labore minima vitae amet libero, esse laborum. Minima eaque eveniet dolor. Itaque alias molestias adipisci ea doloremque consequatur?
        Lorem ipsum, dolor sit amet consectetur adipisicing elit. Dolorum assumenda nulla quae minima est hic maxime nisi voluptatum dolor enim distinctio vitae molestiae tempore, nemo asperiores rerum. Vel, expedita veritatis.
      </p>          
    </article>

    <article class="evento">
      <div class="evento-cabecera">
        <div class="evento-info">
          <h3>Visita de Stephen King</h3>
          <h5>01/01/2001</h5>
        </div>
        <img src="./View/img/eventos/king.jpg" alt="Stephen King">
      </div>
      <p>
        Lorem ipsum dolor sit amet consectetur, adipisicing elit. Dolorum tenetur quam soluta magnam ut labore corporis voluptatem voluptate alias aut nam maxime voluptatum nesciunt excepturi ipsam aliquid, repudiandae, minus modi?
        Lorem ipsum, dolor sit amet consectetur adipisicing elit. Dolorum assumenda nulla quae minima est hic maxime nisi voluptatum dolor enim distinctio vitae molestiae tempore, nemo asperiores rerum. Vel, expedita veritatis.
      </p>        
    </article>

    <article class="evento">
      <div class="evento-cabecera">
        <div class="evento-info">
          <h3>Recordando a: Dante Alighieri</h3>
          <h5>01/01/2001</h5>        
        </div>
        <img src="./View/img/eventos/dante.jpg" alt="Dante Alighieri">        
      </div>  
      <p>
        Lorem ipsum dolor sit amet consectetur adipisicing elit. Quod eos iusto minima dolorem et nobis nisi, quisquam molestias aliquam voluptatum cum eligendi nulla eius dolores ad aliquid ipsam quidem at!
        Lorem ipsum, dolor sit amet consectetur adipisicing elit. Dolorum assumenda nulla quae minima est hic maxime nisi voluptatum dolor enim distinctio vitae molestiae tempore, nemo asperiores rerum. Vel, expedita veritatis.
      </p>
    </article>
  </main>
HTML;
}

// --------------------------------
// --------------------------------

function PrintStores() {
echo <<< HTML
  <main id="stores">
    <table id="tabla-tiendas">
      <tbody>            
          <tr>
            <td class="nombre-ciudad">Barcelona</td>
            <td class="tienda">
              <img src="./View/img/tiendas/barcelona.jpg" alt="Barcelona">
              <ul>
                <li>Park Güell, 08024, Barcelona</li>
                <li>+34 922 11 11 11</li>
                <li>lalibreria_barcelona@gmail.com</li>
              </ul>                              
            </td>
          </tr>
                        
          <tr>
            <td class="nombre-ciudad" rowspan="2">Madrid</td>
            <td class="tienda">
              <img src="./View/img/tiendas/madrid1.jpg" alt="Madrid">
              <ul>
                <li>Av. de Concha Espina, 1, 28036, Madrid</li>
                <li>+34 900 01 10 11</li>
                <li>lalibreria_madrid@gmail.com</li>
              </ul>                
            </td>
          </tr>

          <tr>
            <td class="tienda">
              <img src="./View/img/tiendas/madrid2.jpg" alt="Madrid">
              <ul>
                <li>Calle de Floridablanca, S/N, 28071, Madrid</li>
                <li>+34 913 90 60 00 </li>
                <li>lalibreria_madrid@gmail.com</li>
              </ul>                
            </td>              
          </tr>
      </tbody>        
    </table>
  </main>
HTML;
}

?>