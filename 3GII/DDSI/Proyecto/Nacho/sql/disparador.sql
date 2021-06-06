/* Disparador de recursos humanos - Ignacio Vellido Expósito */

-- Aumentar salario a los empleados que entren en el departamento 1 --

CREATE TRIGGER subirSueldo BEFORE INSERT ON Pertenece
FOR EACH ROW
  UPDATE Empleados SET Sueldo = Sueldo + 500
  WHERE CodEnt = NEW.CodEnt AND NEW.CodDep = '1';
