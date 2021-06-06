CREATE TABLE Distribuidor (
  CodEnt       INT  NOT NULL,
  Nombre VARCHAR(20),

  PRIMARY KEY (CodEnt),
  CONSTRAINT CodEnt_xd
    FOREIGN KEY (CodEnt)
    REFERENCES Entidad(CodEnt)
    ON DELETE CASCADE
);
