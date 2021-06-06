/* Listado de tablas de marketing - Francisco José Cotán López */

DECLARE

  CodEnt            VARCHAR(9);
  Tipo              VARCHAR(50);
  PublicoObjetivo   VARCHAR(50);

  CodProd           VARCHAR(9);

  CodProdComp       VARCHAR(9);
  Precio            REAL;
  Nombre            VARCHAR(2),;
  Rendimiento       REAl;

  CodComp           VARCHAR(10);
  Informe           VARCHAR(100);

  contador INTEGER;

BEGIN
  FOR contador IN 0..9 LOOP
    SELECT * INTO CodProdComp, CodPord, CodComp, Informe
      FROM Compara WHERE CodProdComp = contador;

      DBMS_OUTPUT.PUT_LINE('Tabla compara: (' || CodProdComp || ', ' || CodProd ||
        ', ' || CodComp || ', ' || Informe || ')');

  END LOOP;

  FOR contador IN 0..9 LOOP
    SELECT * INTO CodProdComp, Precio, Nombre, Rendimiento
    FROM ProductoCompetidor WHERE CodProdComp = contador;

    DBMS_OUTPUT.PUT_LINE('Tabla producto competidor: (' || CodProdComp || ', ' || to_char(Precio) ||
                          || ', ' || Nombre || ', ' || to_char(Rendimiento) || ')');
  END LOOP;

  FOR contador IN 0..9 LOOP 
    SELECT * INTO CodEnt, Tipo, PublicoObjetivo
      FROM CampaniaPublicitaria WHERE CodEnt = contador;

    DBMS_OUTPUT.PUT_LINE('Tabla campaña publicitaria: (' || CodEnt || ', ' ||
                        Tipo || ', ' || PublicoObjetivo || ')');
  END LOOP;

  FOR contador IN 0..9 LOOP
    SELECT * INTO CodEnt, CodProd
    FROM Promociona WHERE CodEnt = contador;

    DBMS_OUTPUT.PUT_LINE('Tabla promociona: (' || CodEnt || ', ' || CodProd || ')');
  END LOOP;

END;
/
