/* Disparador de producci�n - Ignacio Barrag�n Lozano */

/* Modificar el stock de un producto cuando este se env�a a un distribuidor */

CREATE TRIGGER modificarStock BEFORE INSERT ON Envia
FOR EACH ROW
DECLARE
  tStock INTEGER;
BEGIN
  SELECT Stock INTO tStock
  FROM Producto
  WHERE CodProd = :new.CodProd;

  IF tStock >= :new.Cantidad THEN
    UPDATE Producto
    SET Stock = tStock - :new.Cantidad
    WHERE CodProd = :new.CodProd;
  ELSE
    UPDATE Producto
    SET Stock = 0
    WHERE CodProd = :new.CodProd;
  END IF;
END;
