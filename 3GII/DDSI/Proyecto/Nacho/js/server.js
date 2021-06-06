/* Códigos
	1000: Crear empleado
	1001: Crear departamento
	1002: Consultar empleado
	1003: Consultar departamento
	1004: Modificar empleado
	1005: Modificar departamento
	1006: Eliminar empleado
	1007: Eliminar departamento
	1008: Añadir empleado a departamento
	1009: Listar empleados de un departamento (el 1) (cursor)
*/
const http = require('http');
const url = require('url');
const operaciones = require('./operacionesRecursosHumanos');
const operacionesComunes = require('../../Comun/js/operaciones');
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
		case 1000:	// Crear empleado
			console.log(solicitud + "crear una empleado");
			operaciones.crearEmpleado(params[1], params[2], params[3], params[4],
																					 params[5], params[6]);

			respuesta += "Operación realizada con éxito";

			devolverRespuesta(res, respuesta);

		break;

		case 1001:	// Crear departamento
			console.log(solicitud + "crear un departamento");
			operaciones.crearDepartamento(params[1], params[2]);

			respuesta += "Operación realizada con éxito";

			devolverRespuesta(res, respuesta);

		break;

		case 1002:	// Consultar empleado
			console.log(solicitud + "consultar un empleado");

			operaciones.consultarEmpleado(params[1], function(consulta) {
				var camposValores = consulta[0];

				if (consulta.length > 0){
					var camposValores = consulta[0];

					console.log("Consulta: ", consulta);
					respuesta += "El empleado consultado contiene estos valores<br/><ul>";

					for(let x in camposValores)
						respuesta += "<li>" + x + ": " + camposValores[x] + "</li>";

					respuesta += "</ul>";
				}
				else {
					respuesta += "Ha introducido un identificador que no se encuentra en la BD";
				}

				devolverRespuesta(res, respuesta);
			});
		break;

		case 1003:	// Consultar departamento
			console.log(solicitud + "consultar un departamento");

			operaciones.consultarDepartamento(params[1], function(consulta) {

				if (consulta.length > 0){
					var camposValores = consulta[0];

					console.log("Consulta: ", consulta);
					respuesta += "El departamento consultado contiene estos valores<br/><ul>";

					for(let x in camposValores)
						respuesta += "<li>" + x + ": " + camposValores[x] + "</li>";

					respuesta += "</ul>";
				}
				else {
					respuesta += "Ha introducido un identificador que no se encuentra en la BD";
				}

				devolverRespuesta(res, respuesta);
			});
		break;

		case 1004:	// Modificar empleado
			console.log(solicitud + "modificar un empleado");

			let tam = params.length;
			let campos = [];
			let valores = [];
			let camposCondiciones;
			let valoresCondiciones = [];
			let paramsValidos = [];
			let i;
			let tamQuery = query.length;

			operacionesComunes.modificarTupla("Entidad", ["Nombre"], [params[1]], ["CodEnt"], [params[tam-1]]);

			for(i = 2; i < tam - 1; ++i)
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

			camposCondiciones = ["Empleados.CodEnt"];
			valoresCondiciones = [params[tam - 1]];

			console.log("Campos que se envían: ", campos);
			console.log("Valores que se envían: ", valores);
			console.log("Campos de las condiciones: ", camposCondiciones);
			console.log("Valores de las condiciones: ", valoresCondiciones);

			operaciones.modificarEmpleado(campos, valores, camposCondiciones, valoresCondiciones, function(err, result) {	// CAMBIAR PARA QUE MODIFIQUE ENTIDAD !!!!!!!!!!!!!!!!!!!!!!!!!!!!
				if (err)
					respuesta += "No se insertó ningún campo a modificar";
				else if (result.affectRows == 0)
					respuesta += "Introdujo un identificador queno se encuentra en la BD";
				else
					respuesta += "No se insertó ningún campo a modificar";

					devolverRespuesta(res, respuesta);
			});
		break;


		case 1005:	// Modificar departamento
			console.log(solicitud + "modificar un empleado");

			let tam2 = params.length;
			let campos2 = [];
			let valores2 = [];
			let camposCondiciones2;
			let valoresCondiciones2 = [];
			let paramsValidos2 = [];
			let i2;
			let tamQuery2 = query.length;

			for(i2 = 1; i2 < tam2 - 1; ++i2)
				if(params[i2] != "") {
					valores2.push(params[i2]);
					paramsValidos2.push(i2);
				}

			let tamValidos2 = paramsValidos2.length;

			i2 = 1;

			for(let x in query) {
				if(paramsValidos2.includes(i2))
					campos2.push(x);

				++i2;
			}

			camposCondiciones2 = ["CodDep"];
			valoresCondiciones2 = [params[tam2 - 1]];

			console.log("Campos que se envían: ", campos2);
			console.log("Valores que se envían: ", valores2);
			console.log("Campos de las condiciones: ", camposCondiciones2);
			console.log("Valores de las condiciones: ", valoresCondiciones2);

			operaciones.modificarDepartamento(campos2, valores2, camposCondiciones2, valoresCondiciones2, function(err, result) {
				if (err)
					respuesta += "No se insertó ningún campo a modificar";
				else if (result.affectRows == 0)
					respuesta += "Introdujo un identificador que no se encuentra en la BD";
				else
					respuesta += "No se insertó ningún campo a modificar";

					devolverRespuesta(res, respuesta);
			});
		break;

		case 1006:	// Eliminar empleado
			console.log(solicitud + "eliminar un empleado");
			operaciones.eliminarEmpleado(params[1]);
			respuesta += "Operación realizada con éxito, la tupla se eliminó correctamente";

			devolverRespuesta(res, respuesta);
		break;

		case 1007:	// Eliminar departamento
			console.log(solicitud + "eliminar un departamento");
			operaciones.eliminarDepartamento(params[1]);
			respuesta += "Operación realizada con éxito, la tupla se eliminó correctamente";

			devolverRespuesta(res, respuesta);
		break;

		case 1008:	// Añadir empleado a departamento
			console.log(solicitud + "añadir empleado a departamento");
			operaciones.crearPertenece(params[1], params[2]);

			respuesta += "Operación realizada con éxito";

			devolverRespuesta(res, respuesta);
		break;

		case 1009:	// Listar empleados de un departamento
			console.log(solicitud + "listar empleados de un departamento");

			operaciones.consultarPertenece(params[1], function(consulta) {
				var camposValores = consulta[0]['@listaEmpleados'];
				var arrayModificado = camposValores.replace(/>/g, '>&')
				var arrayCadena = arrayModificado.split('&');
				arrayCadena.splice(-1,1);	// Quitamos el último elemento (el último <br>)

				console.log("Consulta: ", consulta);
				respuesta += "Los empleado pertenecientes al departamento 1 son:<br/><ul>";

				for(let x in arrayCadena)
					respuesta += "<li>" + x + ": " + arrayCadena[x] + "</li>";

				respuesta += "</ul>";

				devolverRespuesta(res, respuesta);
			});
		break;
	}
});

server.listen(8084);
console.log("Servicio HTTP iniciado en el puerto 8084");
