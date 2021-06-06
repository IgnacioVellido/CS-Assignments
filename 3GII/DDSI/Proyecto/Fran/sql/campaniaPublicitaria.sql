CREATE TABLE CampaniaPublicitaria (
  CodEnt          INT,
  Tipo            VARCHAR(50)  NOT NULL,
  PublicoObjetivo VARCHAR(50)  NOT NULL,
  primary key (CodEnt),
  foreign key (CodEnt) references Entidad(CodEnt) on delete cascade
);
