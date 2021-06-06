"use strict"

const mysql = require('mysql');
const operacionesComunes = require('../../Comun/js/operaciones');

var crearEmpleado = (nombre, dni, direccion, telefono, sueldo, estado) => {
	operacionesComunes.conectarse(function(err, con) {
		if(err)
			console.log("Hubo un error al conectarse con la BD en crearEmpleado");

		operacionesComunes.tomarMaximo(con, "CodEnt", "Entidad", (err, maximo) => {
			if(err)
				console.log("Hubo un error al hacer la consulta del máximo iden Entidad");
			else
				console.log("Realizada la consulta del máximo iden de la Entidad");

			let identificador = maximo + 1;
			let campos = ["CodEnt", "Nombre"];
			let valores = [identificador, nombre];

			operacionesComunes.insertarTupla("Entidad", campos, valores);

			campos = ["CodEnt", "DNI", "Direccion", "Telefono", "Sueldo", "Estado"];
			valores = [identificador, dni, direccion, telefono, sueldo, estado];

			operacionesComunes.insertarTupla("Empleados", campos, valores);

			con.end();
		});
	});
}

var crearDepartamento = (localizacion, area) => {
  operacionesComunes.conectarse(function(err, con) {
		if(err)
			console.log("Hubo un error al intentar conectarse a la BD en crearDepartamento");

		operacionesComunes.tomarMaximo(con, "CodDep", "Departamentos", (err, maximo) => {
      if(err)
				console.log("Hubo un error al hacer la consulta del máximo iden Departamento");
			else
				console.log("Realizada la consulta del máximo iden del Departamento");

			let idNuevo = maximo + 1;
			let valores = [idNuevo, localizacion, area];
			let campos = ["CodDep", "Localizacion", "Area"];

			operacionesComunes.insertarTupla("Departamentos", campos, valores);

      con.end();
		});
	});
}


/*
	callback será una función a la que le enviaremos
	el resultado de la consulta realizada, y este se encargará de tratar con él
*/
var consultarEmpleado = (identificador, callback) => {
	operacionesComunes.conectarse(function(err, con) {
		if(err)
			console.log("Hubo un error al conectarse con la BD en consultarEmpleado");

		let sql = "SELECT Entidad.*, Empleados.* FROM Empleados, Entidad WHERE Entidad.CodEnt = Empleados.CodEnt AND Entidad.CodEnt = " + identificador + ";";

		con.query(sql, function(err, result) {
			if(err)
				console.log("Hubo un error al hacer la consulta del empleado");
			else
				console.log("Realizada la consulta del empleado");

			callback(result);
			con.end();
		});
	});
};

var consultarDepartamento = (identificador, callback) => {
	operacionesComunes.conectarse(function(err, con) {
		if(err)
			console.log("Hubo un error al conectarse con la BD en consultarDepartamento");

		let sql = "SELECT * FROM Departamentos WHERE CodDep = " + identificador + ";";

		con.query(sql, function(err, result) {
			if(err)
				console.log("Hubo un error al hacer la consulta del departamento");
			else
				console.log("Realizada la consulta del departamento");

			callback(result);
			con.end();
		});
	});
};


var eliminarEmpleado = (identificador) => {
	operacionesComunes.eliminarTupla("Entidad", "CodEnt", identificador);
	operacionesComunes.eliminarTupla("Empleados", "CodEnt", identificador);
}

var eliminarDepartamento = (identificador) => {
	operacionesComunes.eliminarTupla("Departamentos", "CodDep", identificador);
}

var modificarEmpleado = (campos, valores, camposCondiciones, condiciones, callback) => {
	operacionesComunes.modificarTupla("Entidad, Empleados", campos, valores, camposCondiciones, condiciones, function(err, result) {
		if (callback != undefined)
			callback(err, result);
	}) ;
}

var modificarDepartamento = (campos, valores, camposCondiciones, condiciones) => {
	operacionesComunes.modificarTupla("Departamentos", campos, valores, camposCondiciones, condiciones, function(err, result) {
		if (callback != undefined)
			callback(err, result);
	}) ;
}

var crearInfProdComp = (nombre, precio, rendimiento, informe, idProducto) => {
	operacionesComunes.conectarse(function(err, con) {
		if(err)
			console.log("Hubo un error al intentar conectarse a la BD en crearInfProdComp");

		operacionesComunes.tomarMaximo(con, "CodProdComp", "ProductoCompetidor", (err, maximo) => {
			if(err)
				console.log("Hubo un error al consultar el máximo de CodProdComo en ProductoCompetidor");

			let idNuevo = maximo + 1;
			let valores = [idNuevo, precio, nombre, rendimiento];
			let campos = ["CodProdComp", "Precio", "Nombre", "Rendimiento"];

			operacionesComunes.insertarTupla("ProductoCompetidor", campos, valores);

			operacionesComunes.tomarMaximo(con, "CodComp", "Compara", (err, maximo) => {
				if(err)
					console.log("Hubo un error al consultar el máximo de CodComp en Compara");

				let idNuevoComp = maximo + 1;
				campos = ["CodProdComp", "CodProd", "CodComp", "Informe"];

				if(informe = '')
					informe = "null";

				valores = [idNuevo, idProducto, idNuevoComp, informe];

				operacionesComunes.insertarTupla("Compara", campos, valores);
				con.end();
			});
		});
	});
}

var crearPertenece = (idEnt, idDep) => {
	operacionesComunes.conectarse(function(err, con) {
		if(err)
			console.log("Hubo un error al conectarse con la BD en crearPertenece");

		let sql= "INSERT INTO Pertenece VALUES ('" + idEnt + "', '" + idDep + "', CONVERT(CURRENT_DATE(), CHAR(10)));"

		con.query(sql, function(err, result) {
			if(err)
				console.log("Hubo un error al insertar en Pertenece");
			else
				console.log("Insertada tupla en Pertenece");

			con.end();
		});
	});
}

var consultarPertenece = (identificador, callback) => {
	operacionesComunes.conectarse(function(err, con) {
		if(err)
			console.log("Hubo un error al conectarse con la BD en consultarPertenece");

		let sql1 = "SET @listaEmpleados = \"\";" +
						  "CALL cursorRH(@listaEmpleados);";

		let sql2 = "SELECT @listaEmpleados;";

		con.query(sql1, function(err, result) {
			if(err)
				console.log("Hubo un error al llamar a los cursores");
			else
				console.log("Cursores inicializados");

			con.query(sql2, function(err, result) {
				if(err)
					console.log("Hubo un error al hacer la consulta de la lista de pertenece");
				else
					console.log("Realizada la consulta del empleado");

				callback(result);
				con.end();
			});

	//		con.end();
		});
	});
};


/* Definir cursor
let sql = "DELIMITER $$" +

					"CREATE PROCEDURE cursorRH (INOUT listaEmpleados varchar(4000))" +
					"BEGIN" +

						"DECLARE NombreEmpleado VARCHAR(30);" +
						"DECLARE DNIEmpleado VARCHAR(9);" +
						"DECLARE fin INTEGER DEFAULT 0;"

						"DECLARE cEmpleados CURSOR FOR" +
							"SELECT Entidad.Nombre, Empleados.DNI FROM Empleados, Pertenece, Entidad" +
							"WHERE Pertenece.CodDep = '1' AND Pertenece.CodEnt = Empleados.CodEnt" +
																					 "AND Entidad.CodEnt = Empleados.CodEnt;" +

						"DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;" +

						"OPEN cEmpleados;" +

						"bucle: LOOP" +
							"FETCH cEmpleados INTO NombreEmpleado, DNIEmpleado;" +

							"IF fin = 1 THEN" +
								"LEAVE bucle;" +
							"END IF;" +

							"SET listaEmpleados = CONCAT(NombreEmpleado, \" con DNI: \", DNIEmpleado);" +
						"END LOOP;" +


						"CLOSE cEmpleados;" +
					"END$$" +

					"DELIMITER ;";
*/

module.exports.crearEmpleado = crearEmpleado;
module.exports.consultarEmpleado = consultarEmpleado;
module.exports.modificarEmpleado = modificarEmpleado;
module.exports.eliminarEmpleado = eliminarEmpleado;

module.exports.crearDepartamento = crearDepartamento;
module.exports.consultarDepartamento = consultarDepartamento;
module.exports.modificarDepartamento = modificarDepartamento;
module.exports.eliminarDepartamento = eliminarDepartamento;

module.exports.crearPertenece = crearPertenece;
module.exports.consultarPertenece = consultarPertenece;
