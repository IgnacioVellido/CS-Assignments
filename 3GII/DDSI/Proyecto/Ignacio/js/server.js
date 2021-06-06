/* Códigos
	1000: Añadir producto
	1001: Crear departamento
	1002: Consultar empleado
	1003: Consultar departamento
	1004: Modificar empleado
	1005: Modificar departamento
	1006: Eliminar empleado
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

  switch (Number(params[0])) {
    case 1000: //Añadir producto
      console.log(solicitud + "añadir un producto");
      operaciones.anadirProducto(params[1],params[2],params[3],params[4],params[5],params[6]);

      respuesta += "Operación realizada con éxito";

      devolverRespuesta(res, respuesta);
    break;
    case 1001: //Registrar producción
      console.log(solicitud + "registrar la producción");
      operaciones.registrarProduccion(params[1], params[2]);

    break;
    case 1002: //Eliminar producto
    console.log(solicitud + "eliminar un producto");
    operaciones.eliminarProducto(params[1]);
    respuesta += "La tupla con dicho identificador ya no se encuentra en la base de datos";

    devolverRespuesta(res, respuesta);
    break;
    case 1003: //Añadir distribuidor
      console.log(solicitud + "añadir un distribuidor");
      operaciones.anadirDistribuidor(params[1]);

      respuesta += "Operación realizada con éxito";

      devolverRespuesta(res, respuesta);
    break;
    case 1004: //Registrar envío
      console.log(solicitud + "registrar un envio");
      operaciones.registrarEnvio(params[1],params[2],params[3],params[4]);

      respuesta += "Operación realizada con éxito";

      devolverRespuesta(res, respuesta);
    break;
    case 1005: //Eliminar distribuidor
      console.log(solicitud + "eliminar un distribuidor");
      operaciones.eliminarDistribuidor(params[1]);
      respuesta += "La tupla con dicho identificador ya no se encuentra en la base de datos";

      devolverRespuesta(res, respuesta);
    break;
    case 1006: //Cursor
      console.log(solicitud + "listar empleados de un departamento");

      operaciones.consultarPertenece(params[1], function(consulta) {
        var camposValores = consulta[0]['@listaProductos'];
        var arrayModificado = camposValores.replace(/>/g, '>&')
        var arrayCadena = arrayModificado.split('&');
        arrayCadena.splice(-1,1);	// Quitamos el último elemento (el último <br>)

        console.log("Consulta: ", consulta);
        respuesta += "Los productos enviados al distribuidor 1 son:<br/><ul>";

        for(let x in arrayCadena)
          respuesta += "<li>" + x + ": " + arrayCadena[x] + "</li>";

        respuesta += "</ul>";

        devolverRespuesta(res, respuesta);
      });
    break;
    default:
      console.log("Código de operación no válido");
      respuesta += "Se ha introducido un código de operación erróneo";
      devolverRespuesta(res, respuesta);
  }
});

server.listen(8082);
console.log("Servicio HTTP iniciado en el puerto 8082");
