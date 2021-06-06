/* Listado de tablas de finanzas - Juan Manuel Rubio Rodríguez */

DECLARE

CodEnt        VARCHAR2(9);

Nombre        VARCHAR2(30);

DNI           VARCHAR2(9);

Telefono      VARCHAR2(13);

Direccion     VARCHAR2(50);

Sueldo        INTEGER;

Estado        CHAR(1);


CodGes VARCHAR (9)
CodEnt VARCHAR (9)
CodIngPag VARCHAR (10)
Fecha   VARCHAR2(10)
Importe FLOAT,

   Fecha        VARCHAR2(10);

  contador INTEGER;

BEGIN
  FOR contador IN 0..9 LOOP
    SELECT * INTO CodEnt, Nombre, DNI, Telefono, Direccion, Sueldo, Estado
    FROM Gestor WHERE CodEnt = contador;

    DBMS_OUTPUT.PUT_LINE('Tabla gestores: (' || CodEnt || ', ' || Nombre || ', '
                          || DNI || ', ' || Telefono || ', ' || Direccion || ', '
                          || to_char(Sueldo) || ', '|| Estado || ')');
  END LOOP;

  FOR contador IN 0..4 LOOP
    SELECT * INTO CodGes, CodEnt, CodIngPag, Fecha, Importe
    FROM Ingresarpagar WHERE CodIngPag = contador;

    DBMS_OUTPUT.PUT_LINE('Tabla Ingresos/pagos: (' || CodGes || ', ' || CodEnt || ', '
                          || CodIngPag || ' , ' || Fecha || ' , ' || Importe || ')');
  END LOOP;
END
