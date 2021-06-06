"use strict"

const mysql = require('mysql');
const operacionesComunes = require('../../Comun/js/operaciones');

/*
	callback será una función a la que le enviaremos 
	el resultado de la consulta realizada, y este se encargará de tratar con él
*/

var consultarCampania = (identificador, callback) => {		// Otra manera de declarar funciones
	operacionesComunes.conectarse(function(err, con) {
		if(err)
			console.log("Hubo un error al conectarse con la BD");

		let sql = "select Entidad.nombre, CampaniaPublicitaria.Tipo, " + 
			"CampaniaPublicitaria.PublicoObjetivo from Entidad, CampaniaPublicitaria" +
			" where Entidad.CodEnt = \'" + identificador + "\' and " +
			" CampaniaPublicitaria.CodEnt = " + identificador + ";";

		con.query(sql, function(err, result) {
			if(err)
				console.log("Hubo un error al hacer la consulta de la " +
					" campaña publicitaria");
			else
				console.log("Realizada la consulta de la campaña publicitaria");
			
			if(callback != undefined)
				callback(result);
				
			con.end();
		});
	});
};

/*
	Prueba de que consultarCampania está bien

var tratamientoConsulta = (consulta) => {
	var camposValores = consulta[0];
	
	for(let x in camposValores)
		console.log(x, ": ", camposValores[x]);
}

consultarCampania(5, tratamientoConsulta);

*/

var eliminarCampania = (identificador) => {
	operacionesComunes.eliminarTupla("Promociona", "CodEnt", identificador);
	operacionesComunes.eliminarTupla("CampaniaPublicitaria", "CodEnt", identificador);
	operacionesComunes.eliminarTupla("Entidad", "CodEnt", identificador);

}

/*
	Prueba de que eliminarCampania funciona correctamente

eliminarCampania(3);

*/

/*
	Para crear una campaña primero voy a consultar todos los códigos
	y voy a sacar el máximo identificador de tal manera que el identificador que utilicemos
	sea uno mayor al máximo de los CodEnt existentes
	
	Luego crearemos primero la Entidad y luego la Campaña publicitaria
*/

var crearCampania = (nombre, tipo, publicoObjetivo) => {
	operacionesComunes.conectarse(function(err, con) {
		if(err)
			console.log("Hubo un error al conectarse con la BD");
		
		operacionesComunes.tomarMaximo(con, "CodEnt", "Entidad", (err, maximo) => {
			if(err)
				console.log("Hubo un error al hacer la consulta del máximo iden Entidad");
			else
				console.log("Realizada la consulta del máximo iden de la Entidad");
			
			let identificador = maximo + 1;
			let campos = ["CodEnt", "Nombre"];
			let valores = [identificador, nombre];
			
			operacionesComunes.insertarTupla("Entidad", campos, valores);
			
			campos = ["CodEnt", "Tipo", "PublicoObjetivo"];
			valores = [identificador, tipo, publicoObjetivo];
			
			operacionesComunes.insertarTupla("CampaniaPublicitaria", campos, valores);
		
			con.end();
		});
	});
}

/*
	Prueba de que crearCampania funciona
	
crearCampania("K", "K", "K");
*/

/*
	Para modificar la campaña habrá que poner CampaniaPublicitaria.x || Entidad.y
	para poder modificar los campos deseados
	
	Igual para las condiciones
*/

var modificarCampania = (campos, valores, camposCondiciones, condiciones, callback) => {
	operacionesComunes.modificarTupla("Entidad, CampaniaPublicitaria", campos, 
		valores, camposCondiciones, condiciones, (err, result) => {
			if(callback != undefined)
				callback(err, result);
		});
}

/*
	Prueba de que modificacionCampania funciona

var campos = ["Entidad.Nombre"];
var valores = "V";
var camposCondiciones = ["CampaniaPublicitaria.CodEnt = Entidad.CodEnt and CampaniaPublicitaria.Tipo"];
var condiciones = ["Z"];

modificarCampania(campos, valores, camposCondiciones, condiciones);
*/

var crearInfProdComp = (nombre, precio, rendimiento, informe, idProducto, callback) => {
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

				operacionesComunes.insertarTupla("Compara", campos, valores, (err, result) => {
					if(err) {
						console.log("Hubo un error al crear compara");
						operacionesComunes.eliminarTupla("ProductoCompetidor", "CodProdComp", idNuevo);
					}
					
					if(callback != undefined)
						callback(err, result);
				});
				
				con.end();
			});
		});
	});			
}

var consultarNombres = (callback) => {
	operacionesComunes.conectarse((err, con) => {
		if(err)
			console.log("Hubo un error al conectarse con la BD en consultarNombres");
		
		let sql1 = "set @listaNombres = \"\"; call cursorFran(@listaNombres);";
		let sql2 = "select @listaNombres;";
		
		con.query(sql1, (err, result) => {
			if(err)
				console.log("Hubo un error al llamar al cursor de marketing");
			else
				console.log("Cursor de marketing inicializado");
				
			con.query(sql2, (err, result) => {
				if(err)
					console.log("Hubo un error al hacer la consulta de la lista de nombres de productos");
				else
					console.log("Realizada la consulta del nombre de los productos");
				
				if(callback != undefined)
					callback(result);
					
				con.end();
			});
		});
	});
}

/*
	Prueba de que crearInfProdComp funciona

crearInfProdComp("A", "100", "0.4", "Es mejor el nuestro", "0");
*/

module.exports.modificarCampania = modificarCampania;
module.exports.crearCampania = crearCampania;
module.exports.eliminarCampania = eliminarCampania;
module.exports.consultarCampania = consultarCampania;
module.exports.crearInfProdComp = crearInfProdComp;
module.exports.consultarNombres = consultarNombres;
