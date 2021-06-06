"use strict"

const operaciones = require('./operacionesMarketing');
const devolverRespuesta = require('../../Comun/js/operaciones').devolverRespuesta;
const express = require('express');

const app = express();
var params = [];
var respuesta = "";

app.use((req, res, next) => {
	console.log("Se ha solicitado la operación con código de operación ", req.path);
	
	for(const p in req.query)
		params.push(req.query[p]);
	
	console.log("Array params: ", params);
	
	next();
});

// Los parámetros deben estar en el orden Nombre, Tipo, PublicoObjetivo en la emisión

app.get("/1000*", (req, res) => {
	operaciones.crearCampania(params[0], params[1], params[2]);
	respuesta += "Operación realizada con éxito";
	devolverRespuesta(res, respuesta);
});

app.get("/1001*", (req, res) => {
	operaciones.consultarCampania(params[0], function(consulta) {
		if(consulta.length > 0) {
			var camposValores = consulta[0];

			respuesta += "La campaña publicitaria consultada contiene estos valores<br/><ul>";

			for(let x in camposValores)
				respuesta += "<li>" + x + ": " + camposValores[x] + "</li>";

			respuesta += "</ul>";
		} else
			respuesta += "Introdujo un identificador que no existe en la base de datos";

		devolverRespuesta(res, respuesta);
	});
});

app.get("/1002*", (req, res) => {
	let tam = params.length;
	let campos = [];
	let valores = [];
	let camposCondiciones;
	let valoresCondiciones = [];
	let paramsValidos = [];
	let i;
	let tamQuery = query.length;

	for(i = 1; i < tam - 1; ++i)
		if(params[i] != "") {
			valores.push(params[i]);
			paramsValidos.push(i);
		}

	let tamValidos = paramsValidos.length;

	i = 1;

	for(let x in query) {
		if(paramsValidos.includes(i))
			campos.push(x);

		++i;
	}

	camposCondiciones = ["CampaniaPublicitaria.CodEnt = Entidad.CodEnt and Entidad.CodEnt"];
	valoresCondiciones = [params[tam - 1]];
	
	operaciones.modificarCampania(campos, valores, camposCondiciones, valoresCondiciones, (err, result) => {
		if (err)
			respuesta += "No insertó ningún campo a modificar";
		else if(result.affectedRows == 0)
			respuesta += "Introdujo un identificador que no se encuentra en la base de datos";
		else
			respuesta += "Se realizó la modificación de la tupla con éxito";

		devolverRespuesta(res, respuesta);
	});
});

app.get("/1003*", (req, res) => {
	operaciones.eliminarCampania(params[1]);
	respuesta += "La tupla con dicho identificador ya no se encuentra en la base de datos";

	devolverRespuesta(res, respuesta);
});

app.get("/1004*", (req, res) => {
	operaciones.crearInfProdComp(params[1], params[2], params[3], params[4], params[5], (err, result) => {
		if(err)
			respuesta += "El id introducido de Producto no existe";
		else
			respuesta += "Se insertó la tupla con éxito";
		
		devolverRespuesta(res, respuesta);
	});
});

app.get("/1005*", (req, res) => {
	operaciones.consultarNombres((consulta) => {
		var camposValores = consulta[0]['@listaNombres'];
		var arrayModificado = camposValores.replace(/>/g, '>&');
		var arrayCadena = arrayModificado.split('&');
		
		arrayCadena.splice(-1, 1);
		
		respuesta += "Listado de los nombres de los productos comparados<br/><ul>";
		
		arrayCadena.forEach((value, index, array) => {
			respuesta += "<li>" + value + "</li>";
		});
		
		respuesta += "</ul>";

		devolverRespuesta(res, respuesta);
	});
});

app.get("*", (req, res) => {
	respuesta += "Se ha introducido un código de operación erróneo"
	devolverRespuesta(res, respuesta);
});

app.listen(8081, () => {
	console.log("Servicio HTTP iniciado en el puerto 8081");
});
