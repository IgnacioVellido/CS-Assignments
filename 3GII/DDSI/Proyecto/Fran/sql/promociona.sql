CREATE TABLE Promociona (
  CodEnt          INT NOT NULL,
  CodProd         INT NOT NULL,
  foreign key (CodEnt) references CampaniaPublicitaria(CodEnt),
  foreign key (CodProd) references Producto(CodProd)
);
