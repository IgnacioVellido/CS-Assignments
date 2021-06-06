CREATE TABLE Empleados (
  CodEnt    INT          NOT NULL,
  DNI       VARCHAR(9)   NOT NULL,
  Telefono  VARCHAR(13)  NOT NULL,
  Direccion VARCHAR(50),
  Sueldo    INT,
  Estado    CHAR(1),

  PRIMARY KEY (CodEnt),
  CONSTRAINT CodEnt_fk
    FOREIGN KEY (CodEnt)
    REFERENCES Entidad(CodEnt)
    ON DELETE CASCADE
);
