"use strict"

const fs = require('fs');
const operacionesComunes = require('./operaciones')

var rutaEntidad		= '../sql/';
var rutaFran 		= '../../Fran/sql/';
var rutaNacho 		= '../../Nacho/sql/';
var rutaIgnacio		= '../../Ignacio/sql/';
var rutaJuanma		= '../../Juanma/sql/';

const leer = (ruta, nomFichero) => {
	return new Promise((resolve, reject) => {
		console.log("Ruta: ", ruta + nomFichero);

		fs.readFile(ruta + nomFichero, 'utf-8', function(err, data) {
			if(err)
				reject("Hubo un error al leer " + ruta + nomFichero);

			//console.log("Datos: ", data);

			resolve(data);
		});
	});
}

const crearTabla = (tabla) => {
	return new Promise((resolve, reject) => {
		operacionesComunes.conectarse(function(err, con) {
			if(err)
				reject("Error al intentar conectarse a la BD");
			else {
				con.query(tabla, (err) => {
					if(err)
						reject("Hubo un error en la creación de la tabla: " , tabla);
					else
						resolve("Creada la tabla: ", tabla);
				});

				con.end();
			}
		});
	});
}

const crearTupla = (consulta) => {
	return new Promise((resolve, reject) => {
		operacionesComunes.conectarse((err, con) => {
			if(err)
				reject("Hubo un error al intentar conectarse con la BD");

			con.query(consulta, (err, result) => {
				if(err) {
					reject("Hubo un error al crear las tuplas", consulta);
					console.log(err);
				} else
					resolve("La tabla se creó correctamente");

				con.end();
			});
		});
	});
}

const eliminarTodasLasTablas = () => {
	operacionesComunes.conectarse(function(err, con) {
		var oper = "drop table ";

		// Ponemos aquí nuestras tablas en cascada
		oper += "Gestor, Ingresarpagar" + "Pertenece, Departamentos, Empleados, " +
						"Promociona, Compara, ProductoCompetidor, CampaniaPublicitaria, Entidad, Producto" + "Distribuidor, Envia, Producto";

		con.query(oper, (err, result) => {
			if(err)
				console.log("Hubo un error al intentar eliminar las tablas");

			con.end();
		});
	});
}

const crearTodasLasTablas = async () => {
	const ficheros = [ [rutaEntidad, "entidad.sql"],			// rutas comunes
		[rutaFran, "campaniaPublicitaria.sql"], [rutaFran,
		"productoCompetidor.sql"], [rutaIgnacio, "producto.sql"],	// ATENTO IGNACIO
		[rutaFran, "promociona.sql"], [rutaFran, "compara.sql"],	// hasta aquí las rutas de Fran
		[rutaNacho, "empleado.sql"], [rutaNacho, "departamento.sql"],
		[rutaNacho, "pertenece.sql"],
		[rutaJuanma, "gestor.sql"],
		[rutaJuanma, "ingpag.sql"],
		[rutaIgnacio, "distribuidor.sql"],
		[rutaIgnacio, "envia.sql"] ];					// hasta aquí las rutas de nacho

	for(let i = 0; i < ficheros.length; ++i) {
		let lecturaFichero = await leer(ficheros[i][0], ficheros[i][1]);
		console.log("Lectura fichero: ", lecturaFichero);
		await crearTabla(lecturaFichero);
	}
}

const crearTodasLasTuplas = async () => {
	const ficheros = [ [rutaEntidad, "tuplasEntidad.sql"],			// rutas comunes
		[rutaFran, "tuplasCamp.sql"], [rutaFran,
		"tuplasCompet.sql"], [rutaIgnacio, "tuplasProd.sql"],	// ATENTO IGNACIO
		[rutaFran, "tuplasPromo.sql"], [rutaFran, "tuplasComp.sql"],	// hasta aquí las rutas de Fran
		[rutaNacho, "tuplasEmpleado.sql"], [rutaNacho, "tuplasDepartamento.sql"],
		[rutaNacho, "tuplasPertenece.sql"],
		[rutaJuanma, "tuplasGestor.sql"],
		[rutaJuanma, "tuplasIngPag.sql"],
		[rutaIgnacio, "tuplasDist.sql"],
		[rutaIgnacio, "tuplasEnvia.sql"] ];

	for(let i = 0; i < ficheros.length; ++i) {
		let lecturaFichero = await leer(ficheros[i][0], ficheros[i][1], crearTabla);
		console.log("Lectura fichero: ", lecturaFichero);
		await crearTupla(lecturaFichero);
	}
}


/*
const llamarCursores = () => {
	operacionesComunes.conectarse(function(err, con) {
		if(err)
			console.log("Hubo un error al conectarse con la BD en consultarPertenece");

		let sql = "SET @listaEmpleados = \"\";" +
						  "CALL cursorRH(@listaEmpleados);";

		con.query(sql, function(err, result) {
			if(err)
				console.log("Hubo un error al llamar a los cursores");
			else
				console.log("Cursores inicializados");

			con.end();
		});
	});
};
*/

//eliminarTodasLasTablas();
//crearTodasLasTablas();
//crearTodasLasTuplas();


//llamarCursores(); Por quitar
/*
module.exports.crearTabla = crearTabla;
module.exports.crearTodasLasTablas = crearTodasLasTablas;
*/
