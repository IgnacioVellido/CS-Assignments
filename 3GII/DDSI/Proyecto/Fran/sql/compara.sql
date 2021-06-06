CREATE TABLE Compara (
  CodProdComp   INT    	NOT NULL,
  CodProd       INT    	NOT NULL,  
  CodComp       INT   	NOT NULL,
  Informe       VARCHAR(100),
  PRIMARY KEY (CodProdComp, CodProd, CodComp),
  foreign key (CodProdComp) references ProductoCompetidor(CodProdComp),
  foreign key (CodProd) references Producto(CodProd)
);
