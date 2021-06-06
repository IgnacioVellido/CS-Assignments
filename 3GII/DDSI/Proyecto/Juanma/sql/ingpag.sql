CREATE TABLE Ingresarpagar (
	CodGest 	INT			NOT NULL,	
	CodEnt	INT			NOT NULL,
	CodIngPag	INT			NOT NULL,
	Fecha		VARCHAR(10)  	NOT NULL,
	Importe FLOAT,

	PRIMARY KEY (CodEnt, CodIngPag),
	FOREIGN KEY (CodEnt)
	REFERENCES Entidad(CodEnt),
	FOREIGN KEY (CodGest)
	REFERENCES Gestor(CodEnt)
);
