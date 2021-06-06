"use strict"

const mysql = require('mysql');
const fs = require('fs');

/*
	Función para conectarse a la base de datos
	
	A la función callback se le pasa como argumentos el posible
	error al conectarse y la conexión de la base de datos
*/

const conectarse = (callback) => {
	var con = mysql.createConnection({
		multipleStatements: true,
		host: 		"localhost",
		user: 		"iscoct",
		password: "Vamos a aprobar DDSI de 3",
		database:	"aux"
	});

	con.connect((err) => {
		callback(err, con);
	});
}

/*
	Ningún argumento debe tener ' ', por ejemplo, si el identificador es
	0, la función lo transforma a '0' para realizar la operación correctamente
*/

const eliminarTupla = function(nombreTabla, nombreIdentificador, identificador) {
	conectarse(function(err, con) {
		if(err)
			console.log("Error al intentar conectar con la base de datos en eliminarTupla");

		var sql = "delete from " + nombreTabla + " where " + nombreIdentificador +
			" = \'" + identificador + "\'";

		con.query(sql, function(err, result) {
			if(err)
				console.log("Error al intentar eliminar la tupla con identificador, " +
					identificador + ", en la tabla, " + nombreTabla);
			else
				console.log("Se eliminó la tupla correctamente");
		});

		con.end();
	});
}

/*
	Prueba del método eliminarTupla

eliminarTupla("Entidad", "CodEnt", "2");
eliminarTupla("CampaniaPublicitaria", "CodEnt", "2");
*/

/*
	Campos debe ser un array donde cada uno de sus campos se corresponda con un campo
	en la tabla introducida
	Valores debe ser un array donde cada uno de sus campos se corresponda con el valor de cada
	uno de los campos introducidos
*/

const insertarTupla = function(nombreTabla, campos, valores, callback) {
	conectarse(function(err,con) {
		if(err)
			console.log("Error al intentar conectar con la base de datos en insertarTupla");

		var tam = campos.length;	// == valores.length
		var i;
		var sql = "insert into " + nombreTabla + "(" + campos[0];

		for(i = 1; i < tam; ++i)
			sql += "," + campos[i];

		sql += ") values (\'" + valores[0];

		for(i = 1; i < tam; ++i)
			sql += "\','" + valores[i];

		sql += "\');";

		console.log(sql);

		con.query(sql, function(err, result) {
			if(err) {
				console.log("Hubo un error al intentar introducir en la tabla", nombreTabla);
				console.log(err);
			}
			else
				console.log("Se insertó la tupla correctamente");
				
			if(callback != undefined)
				callback(err, result);
		});

		con.end();
	});
}

/*
	Prueba de la función insertar tupla funciona

var camposEntidad = ["CodEnt", "Nombre"];
var valoresEntidad = ["1", "B"];
var camposCampania = ["CodEnt", "Tipo", "PublicoObjetivo"];
var valoresCampania = ["1", "B", "B"];

insertarTupla("Entidad", camposEntidad, valoresEntidad);
insertarTupla("CampaniaPublicitaria", camposCampania, valoresCampania);
*/

/*
	Pre: campos.length = valores.length && camposCondiciones.length = condiciones.length

	campos: Campos a modificar sus valores (Array)
	valores: Valores de los campos a modificar (Array)
	camposCondiciones: Campos de los que se tiene que cumplir la condición (Array)
	condiciones: Valores a los campos que se tienen que cumplir (Array)

	TRUCO PARA PODER REUTILIZAR modificarTupla

	Si hay alguna condición extraordinaria podremos ponerla en el primer parámetro de camposCondiciones,
	ejemplo:
		update Entidad, CampaniaPublicitaria set Entidad.Nombre = 'X' where <condicionEspecial and>
			<condicionesNormales>;

		Donde condicionEspecial puede ser igual a Entidad.CodEnt = CampaniaPublicitaria.CodEnt
		y condicionesNormales puede ser igual a Entidad.Nombre = 'Z'.
*/

const modificarTupla = (nombreTabla, campos, valores, camposCondiciones, condiciones, callback) => {
	conectarse(function(err, con) {
		if(err)
			console.log("Error al intentar conectarse a la BD en modificarTupla");

		var sql = "UPDATE " + nombreTabla + " SET ";
		var i;
		var tam = campos.length;

		sql += campos[0] + " = \'" + valores[0] + "\'";

		for(i = 1; i < tam; ++i)
			sql += ", " + campos[i] + " = \'" + valores[i] + "\'";

		tam = camposCondiciones.length;

		if(tam > 0)
			sql += " WHERE " + camposCondiciones[0] + " = \'" + condiciones[0] + "\'";

		for(i = 1; i < tam; ++i)
			sql += " AND " + camposCondiciones[i] + " = \'" + condiciones[i] + "\'";

		sql += ";";

		console.log(sql);

		con.query(sql, function(err, result) {
			if(err)
				console.log("Hubo un error al intentar modificar los datos de la tabla "
					+ nombreTabla);
			else
				console.log("Modificada con éxito");

			if(callback != undefined)
				callback(err, result);

			con.end();
		});
	});
}

/*
	Prueba de que modificar tupla funciona correctamente

var campos = ["Nombre"];
var valores = ["A"];
var camposCondicion = ["CodEnt"];
var condiciones = ["1"];

modificarTupla("Entidad", campos, valores, camposCondicion, condiciones);
*/

/*
	Dado un campo y una tabla toma el máximo de ese campo
	@param	con Conexión abierta con la BD
	@return	Devuelve el máximo de dicho campo con tipo Number o -1 sino hay ninguna
		tupla insertada aún
*/

const tomarMaximo = (con, campo, tabla, callback) => {
	campo = "MAX(" + campo +")";
	var sql = "select " + campo + " from " + tabla + ";";
	var maximo;

	con.query(sql, (err, result) => {
		maximo = (result[0][campo] != null) ? Number(result[0][campo]) : Number("-1");

		callback(err, maximo);
	});
}

/*
	Prueba de que tomarSigMaximo funciona

conectarse((err, con) => {
	tomarMaximo(con, "CodEnt", "Entidad", (result) => {
		console.log("Resultado: ", result);
		con.end();
	});
});
*/

const devolverRespuesta = (res, respuesta) => {
	fs.readFile("./Comun/html/respuesta.html", "utf-8", (err, data) => {
		if(err) {
			console.log("Error al intentar leer el fichero");
			console.log("Error: ", err);
		}
		let bloque = "id=\"respuesta\">";

		data = data.replace(bloque, bloque + respuesta);

		res.writeHead(200, {"Content-Type": "text/html"});
		res.write(data);
		res.end();
	});
}

module.exports.tomarMaximo = tomarMaximo;
module.exports.conectarse = conectarse;
module.exports.modificarTupla = modificarTupla;
module.exports.eliminarTupla = eliminarTupla;
module.exports.insertarTupla = insertarTupla;
module.exports.devolverRespuesta = devolverRespuesta;
