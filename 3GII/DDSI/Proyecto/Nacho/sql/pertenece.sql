CREATE TABLE Pertenece (
  CodEnt INT           NOT NULL,
  CodDep INT           NOT NULL,
  Fecha  VARCHAR(10)   NOT NULL,

  PRIMARY KEY (CodEnt, Fecha),
  CONSTRAINT CodEnt_Pertenece_fk
    FOREIGN KEY (CodEnt)
    REFERENCES Empleados(CodEnt)
    ON DELETE CASCADE,
  CONSTRAINT CodDep_fk
    FOREIGN KEY (CodDep)
    REFERENCES Departamentos(CodDep)
    ON DELETE CASCADE
);
