CREATE TABLE Producto (
  CodProd    INT  PRIMARY KEY,
  Nombre    VARCHAR(20) NOT NULL,
  Familia    VARCHAR(20) NOT NULL,
  Modelo       VARCHAR(20)   NOT NULL,
  Especificaciones  VARCHAR(60),
  Piezas VARCHAR(50),
  Stock    INT,
  Precio   REAL
);
