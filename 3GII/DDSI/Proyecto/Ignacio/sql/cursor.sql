/* Cursor de producción - Ignacio Barragán Lozano */

-- Listado de productos enviados a un distribuidor y su familia --

DELIMITER $$

CREATE PROCEDURE cursorEnviados (INOUT listaEnviados varchar(4000))
BEGIN

  DECLARE NombreProducto VARCHAR(20);
  DECLARE FamiliaProducto VARCHAR(20);
  DECLARE fin INTEGER DEFAULT 0;

  DECLARE cProductos CURSOR FOR
    SELECT Producto.Nombre, Producto.Familia
    FROM Producto, Envia
    WHERE Envia.CodEnt = 1 AND Envia.CodProd = Producto.CodProd;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;

    OPEN cProductos;

    bucle: LOOP
      FETCH cProductos INTO NombreProducto, FamiliaProducto;
      IF fin = 1 THEN
        LEAVE bucle;
      END IF;

      SET listaEnviados = CONCAT(listaEnviados, NombreProducto, " de la Familia: ", FamiliaProducto, "<br\>");
    END LOOP;


    CLOSE cProductos;
END$$

DELIMITER ;
