CREATE TABLE Gestor(
	CodEnt		INT		NOT NULL,

	PRIMARY KEY (CodEnt),
	FOREIGN KEY (CodEnt)
	REFERENCES Empleados(CodEnt)

);

