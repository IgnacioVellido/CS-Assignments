const http = require('http');
const url = require('url');
const operaciones = require('./operacionesFinanzas');
const devolverRespuesta = require('../../Comun/js/operaciones').devolverRespuesta;

var server = http.createServer((req, res) => {
	var uri = url.parse(req.url, true);
	var path = uri.pathname;
	var query = uri.query;
	var params = [];
	var solicitud = "Se ha solicitado la operación de ";
	var respuesta = "";

	while(path.indexOf('/') == 0)
		path = path.slice(1);

	params.push(path);

	for(let x in query)
		params.push(query[x]);

	console.log(params);
	console.log("Valor de los parámetros enviados: ", params);

	switch(Number(params[0])) {
		/*
			Los parámetros deben estar en el mismo orden que la emisión de la petición
		*/
		case 1000:	// registrar ingreso
			console.log(solicitud + "registrar un ingreso");
			operaciones.crearIngreso(params[1], params[2], params[3], params[4]);

			respuesta += "Operación realizada con éxito";


			res.writeHead(200, {"Content-Type": "text/html"});
			res.write(respuesta);
			res.end();
		break;

		case 1001:	// registrar pago
			console.log(solicitud + "registrar un pago");
			operaciones.crearPago(params[1], params[2], params[3], params[4]);

			respuesta += "Operación realizada con éxito";


			res.writeHead(200, {"Content-Type": "text/html"});
			res.write(respuesta);
			res.end();
		break;

		case 1002:	// Consultar ingreso
			console.log(solicitud + "consultar un ingreso");

			operaciones.consultarIngreso(params[1], function(consulta) {
				var camposValores = consulta[0];

				console.log("Consulta: ", consulta);
				respuesta += "El ingreso consultado contiene estos valores<br/><ul>";

				for(let x in camposValores)
					respuesta += "<li>" + x + ": " + camposValores[x] + "</li>";

				respuesta += "</ul>";

				res.writeHead(200, {"Content-Type": "text/html"});
				res.write(respuesta);
				res.end();
			});
		break;

		case 1003:	// Consultar pago
			console.log(solicitud + "consultar un ingreso");

			operaciones.consultarPago(params[1], function(consulta) {
				var camposValores = consulta[0];

				console.log("Consulta: ", consulta);
				respuesta += "El pago consultado contiene estos valores<br/><ul>";

				for(let x in camposValores)
					respuesta += "<li>" + x + ": " + camposValores[x] + "</li>";

				respuesta += "</ul>";

				res.writeHead(200, {"Content-Type": "text/html"});
				res.write(respuesta);
				res.end();
			});
		break;

		case 1004:	// Eliminar un pago
			console.log(solicitud + "eliminar un pago");
			operaciones.eliminarPago(params[1]);
			respuesta += "Operación realizada con éxito";

			//devolverRespuesta(res, respuesta);
		break;

		case 1005:
			console.log(solicitud + " listar nombres y DNI de gestores");

			operaciones.consultarGestor((consulta) => {
				var camposValores = consulta[0]['@listaGestor'];
				var arrayModificado = camposValores.replace(/>/g, '>&');
				var arrayCadena = arrayModificado.split('&');
				
				arrayCadena.splice(-1, 1);
				
				console.log("Consulta: ", consulta);
				console.log("Array modificado: ", arrayModificado);
				console.log("Array cadena: ", arrayCadena);
				
				respuesta += "Listado de los nombres y DNI de gestores<br/><ul>";
				
				arrayCadena.forEach((value, index, array) => {
					respuesta += "<li>" + value + "</li>";
				});
				
				respuesta += "</ul>";

				console.log("Respuesta: ", respuesta);
				devolverRespuesta(res, respuesta);
			});
		break;
		default:
			console.log("Código de operación no válido");

			respuesta += "Se ha introducido un código de operación erróneo"
			devolverRespuesta(res, respuesta);
	}
});

server.listen(8083);
console.log("Servicio HTTP iniciado en el puerto 8083");
