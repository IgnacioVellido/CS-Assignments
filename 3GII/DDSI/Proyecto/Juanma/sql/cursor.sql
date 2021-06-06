/* Cursor de finanzas - Juan Manuel Rubio Rodriguez */

-- Listado de gestores de finanzas y su DNI --

DELIMITER $$

CREATE PROCEDURE cursorFinanzas (INOUT listaGestor varchar(4000))
BEGIN
  -- Declaraciones --

  DECLARE NombreGestor VARCHAR(30);
  DECLARE DNIGestor VARCHAR(9);
  DECLARE fin INTEGER DEFAULT 0;        -- Variable %found

  DECLARE cGestor CURSOR FOR
    SELECT Entidad.Nombre, Empleados.DNI FROM Empleados, Gestor, Entidad
    WHERE Gestor.CodEnt = Empleados.CodEnt AND Entidad.CodEnt = Empleados.CodEnt;


  -- Equivalente a %found en PL/SQL --
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;

  -- Ejecución --

  OPEN cGestor;

  bucle: LOOP
    FETCH cGestor INTO NombreGestor, DNIGestor;

    IF fin = 1 THEN
      LEAVE bucle;
    END IF;

    SET listaGestor = CONCAT(listaGestor, NombreGestor, " con DNI: ", DNIGestor, " <br\/> ");
  END LOOP;

  CLOSE cGestor;

END$$

DELIMITER ;
