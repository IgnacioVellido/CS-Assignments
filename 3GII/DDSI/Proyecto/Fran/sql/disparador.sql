/* Disparador de marketing -- Francisco José Cotán López */

/*
	Sólo puede haber 1 campañia con un solo tipo de esta.
	Si no es así, elimina la campaña antigua
*/

-- PRECIO PRODUCTO ES INT Y ProductoCompetidor ES FLOAT!!!!!!!! ---

-- Rebaja el precio de un producto si el de competidor es más barato --

CREATE TRIGGER rebaja BEFORE INSERT ON Compara
FOR EACH ROW
  UPDATE Producto, ProductoCompetidor SET Producto.Precio = ProductoCompetidor.Precio
  WHERE NEW.CodProd = Producto.CodProd AND NEW.CodProdComp = ProductoCompetidor.CodProdComp
          AND Producto.Precio > ProductoCompetidor.Precio;

/*
CREATE OR REPLACE TRIGGER crearCampaniaPublicitaria
BEFORE INSERT ON CampaniaPublicitaria
FOR EACH ROW
BEGIN
  DELETE FROM CampaniaPublicitaria
  WHERE Tipo = :new.Tipo;
END;
/
*/
