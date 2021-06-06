/* Disparador de Finanzas - Juan Manuel Rubio Rodr\'edguez */

/* Insertar la fecha actual en caso de que no se introduzca una */

CREATE TRIGGER prima BEFORE INSERT ON Ingresarpagar
FOR EACH ROW BEGIN
  IF NEW.Importe > 1000 THEN
    UPDATE Empleados SET Sueldo = Sueldo + 100
    WHERE CodEnt = NEW.CodGest;
  END IF;
END

