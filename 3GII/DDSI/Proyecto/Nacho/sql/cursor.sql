/* Cursor de recursos humanos - Ignacio Vellido Expósito */

-- Listado de empleados pertenecientes a un departamento y su DNI --
-- Se pasa una lista por argumento a la que se le añaden los empleados --

DELIMITER $$  /* Para que se ejecute el bloque al completo */

CREATE PROCEDURE cursorRH (INOUT listaEmpleados varchar(4000))
BEGIN
  -- Declaraciones --

  DECLARE NombreEmpleado VARCHAR(30);
  DECLARE DNIEmpleado VARCHAR(9);
  DECLARE fin INTEGER DEFAULT 0;        -- Variable %found

  DECLARE cEmpleados CURSOR FOR
    SELECT Entidad.Nombre, Empleados.DNI FROM Empleados, Pertenece, Entidad
    WHERE Pertenece.CodDep = '1' AND Pertenece.CodEnt = Empleados.CodEnt
                                 AND Entidad.CodEnt = Empleados.CodEnt;


  -- Equivalente a %found en PL/SQL --
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;

  -- Ejecución --

  OPEN cEmpleados;

  bucle: LOOP
    FETCH cEmpleados INTO NombreEmpleado, DNIEmpleado;

    IF fin = 1 THEN
      LEAVE bucle;
    END IF;

    SET listaEmpleados = CONCAT(listaEmpleados, NombreEmpleado, " con DNI: ", DNIEmpleado, "<br\\>");
  END LOOP;


  CLOSE cEmpleados;
END$$

DELIMITER ;

/* Uso:
Copiar todo lo anterior
Definir variable para guardar los resultados
  SET @listaEmpleados = "";
Llamar procedimiento
  CALL cursorRH(@listaEmpleados);
Mostrar resultados
  SELECT @listaEmpleados;
*/

-- SELECT(NombreEmpleado || ' con DNI: ' || DNIEmpleado);
-- SELECT ('Los empleados pertenecientes al departamento 1 son:');

/* PL/SQL
DECLARE
  CURSOR cEmpleados IS
    SELECT Empleados.Nombre, Empleados.DNI FROM Empleados, Pertenece
    WHERE Pertenece.CodDep = 1 AND Pertenece.CodEnt = Empleados.CodEnt;

  NombreEmpleado VARCHAR2(30);
  DNIEmpleado VARCHAR2(9);

BEGIN
  OPEN cEmpleados;

  FETCH cEmpleados INTO NombreEmpleado, DNIEmpleado;

  DBMS_OUTPUT.PUT_LINE('Los empleados pertenecientes al departamento 1 son:');

  WHILE cEmpleados%found LOOP
    DBMS_OUTPUT.PUT_LINE(NombreEmpleado || ' con DNI: ' || DNIEmpleado);
    FETCH cEmpleados INTO NombreEmpleado, DNIEmpleado;
  END LOOP;

  CLOSE cEmpleados;
END;
*/
