"use strict"

const mysql = require('mysql');
const operacionesComunes = require('../../Comun/js/operaciones');

var crearIngreso = (gestor, entidad, fecha, importe) => {
	operacionesComunes.conectarse(function(err, con) {
		if(err)
			console.log("Hubo un error al conectarse con la BD en crearIngreso");

		operacionesComunes.tomarMaximo(con, "CodIngPag", "Ingresarpagar", (err, maximo) => {
			if(err)
				console.log("Hubo un error al hacer la consulta del máximo iden IngresarPagar");
			else
				console.log("Realizada la consulta del máximo iden de la IngresarPagar");

			let identificador = maximo + 1;

			let campos = ["CodGest", "CodEnt", "CodIngPag", "Fecha", "Importe"];
			let valores = [gestor, entidad, identificador, fecha, importe];

			operacionesComunes.insertarTupla("Ingresarpagar", campos, valores);

			con.end();
		});
	});
}


var crearPago = (gestor, entidad, fecha, importe) => {
	operacionesComunes.conectarse(function(err, con) {
		if(err)
			console.log("Hubo un error al conectarse con la BD en crearPago");

		operacionesComunes.tomarMaximo(con, "CodIngPag", "Ingresarpagar", (err, maximo) => {
			if(err)
				console.log("Hubo un error al hacer la consulta del máximo iden IngresarPagar");
			else
				console.log("Realizada la consulta del máximo iden de la IngresarPagar");

			let identificador = maximo + 1;

			let campos = ["CodGest", "CodEnt", "CodIngPag", "Fecha", "Importe"];
			let valores = [gestor, entidad, identificador, fecha, importe];

			operacionesComunes.insertarTupla("Ingresarpagar", campos, valores);

			con.end();
		});
	});
}


var consultarIngreso = (identificador, callback) => {
	operacionesComunes.conectarse(function(err, con) {
		if(err)
			console.log("Hubo un error al conectarse con la BD en consultarIngreso");

		let sql = "SELECT Ingresarpagar.* FROM Ingresarpagar WHERE Ingresarpagar.CodIngPag = " + identificador + ";";

		con.query(sql, function(err, result) {
			if(err)
				console.log("Hubo un error al hacer la consulta del ingreso");
			else
				console.log("Realizada la consulta del ingreso");

			callback(result);
			con.end();
		});
	});
};


var consultarPago = (identificador, callback) => {
	operacionesComunes.conectarse(function(err, con) {
		if(err)
			console.log("Hubo un error al conectarse con la BD en consultarPago");

		let sql = "SELECT Ingresarpagar.* FROM Ingresarpagar WHERE Ingresarpagar.CodIngPag = " + identificador + ";";

		con.query(sql, function(err, result) {
			if(err)
				console.log("Hubo un error al hacer la consulta del pago");
			else
				console.log("Realizada la consulta del pago");

			callback(result);
			con.end();
		});
	});
};


var eliminarPago = (identificador) => {
	operacionesComunes.eliminarTupla("Ingresarpagar", "CodIngPag", identificador);
}


var consultarGestor = (callback) => {
	operacionesComunes.conectarse(function(err, con) {
		if(err)
			console.log("Hubo un error al conectarse con la BD en consultarPertenece");

		let sql1 = "SET @listaGestor = \"\"; CALL cursorFinanzas(@listaGestor);";

		let sql2 = "SELECT @listaGestor;";

		con.query(sql1, function(err, result) {
			if(err)
				console.log("Hubo un error al llamar a los cursores");
			else
				console.log("Cursores inicializados");

			con.query(sql2, function(err, result) {
				if(err)
					console.log("Hubo un error al hacer la consulta de la lista de gestores");
				else
					console.log("Realizada la consulta del gestor");

				if(callback != undefined)
					callback(result);
					
				con.end();
			});

	//		con.end();
		});
	});
};


module.exports.crearIngreso = crearIngreso;
module.exports.crearPago = crearPago;

module.exports.consultarIngreso = consultarIngreso;
module.exports.consultarPago = consultarPago;

module.exports.eliminarPago = eliminarPago;
module.exports.consultarGestor = consultarGestor;
