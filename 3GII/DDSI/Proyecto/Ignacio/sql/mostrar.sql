/* Listado de tablas de producción - Ignacio Barragán Lozano */

DECLARE
  CodProd             INTEGER; 
  Nombre              VARCHAR(20);  
  Familia             VARCHAR(20); 
  Modelo              VARCHAR(20); 
  Especificaciones    VARCHAR(60);
  Piezas              VARCHAR(50);
  Stock               INTEGER;
  Precio              INTEGER;
  
  CodEnt              INTEGER;
  NombreD              VARCHAR(20);
  
  Fecha               VARCHAR(10);
  Cantidad            INTEGER;

  contador INTEGER;

BEGIN
  FOR contador IN 0..9 LOOP
    SELECT * INTO CodProd, Nombre, Familia, Modelo, Especificaciones, Piezas, Stock, Precio
    FROM Productos WHERE CodProd = contador;

    DBMS_OUTPUT.PUT_LINE('Tabla productos: (' || to_char(Codprod) || ', ' || Nombre || ', '
                          || Familia || ', ' || Modelo || ', ' || Especificaciones || ', '
                          || Piezas || ', ' || to_char(Stock) || ', '|| to_char(Precio) || ')');
  END LOOP;

  FOR contador IN 0..9 LOOP
    SELECT * INTO CodEnt, Nombre
    FROM Distribuidores WHERE CodEnt = contador;

    DBMS_OUTPUT.PUT_LINE('Tabla distribuidores: (' || to_char(CodEnt) || ', ' || Nombre || ')');
  END LOOP;

  FOR contador IN 0..4 LOOP
    SELECT * INTO CodProd, CodEnt, Fecha, Cantidad
    FROM Envia WHERE CodProd = contador;

    DBMS_OUTPUT.PUT_LINE('Tabla envia: (' || to_char(CodProd) || ', ' || to_char(CodEnt) || ', '
                          || Fecha || ', ' || to_char(Cantidad) ')');    
  END LOOP;
END;
/
