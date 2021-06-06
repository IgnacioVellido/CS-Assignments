-- Comparar productos con productos competidores --
-- mostrando el nombre del producto y el del competidor --


DELIMITER $$

CREATE PROCEDURE cursorFran (INOUT listaNombres varchar(4000))
BEGIN
	declare nombreProductoCompetidor varchar(50);
	declare nombreProducto varchar(50);
	declare fin integer default 0;
	declare nombres CURSOR for
		select Producto.Nombre, ProductoCompetidor.Nombre from ProductoCompetidor, Producto, Compara
		where Compara.CodProdComp = ProductoCompetidor.CodProdComp and Compara.CodProd = Producto.CodProd;

	-- Equivalente a %found en PL/SQL --
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;

	OPEN nombres;

	bucle: loop
		fetch nombres into nombreProducto, nombreProductoCompetidor;

		IF fin = 1 THEN
      LEAVE bucle;
    END IF;

		SET listaNombres =
				CONCAT(listaNombres, "Producto: ", nombreProducto," y Competidor: ",
							 nombreProductoCompetidor, " <br\/> ");
	end loop;

	close nombres;
end$$

DELIMITER ;
