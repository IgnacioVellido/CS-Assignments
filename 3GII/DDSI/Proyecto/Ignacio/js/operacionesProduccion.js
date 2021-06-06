"use strict"

const mysql = require('mysql');
const operacionesComunes = require('../../Comun/js/operaciones');

var anadirProducto = (nombre, familia, modelo, especificaciones, piezas, precio) => {
  operacionesComunes.conectarse(function(err, con){
    if (err)
      console.log("Hubo un error al conectarse con la BD en anadirProducto");

    operacionesComunes.tomarMaximo(con, "CodProd", "Producto", (err, maximo) => {
			if(err)
				console.log("Hubo un error al hacer la consulta del máximo iden Entidad");
			else
				console.log("Realizada la consulta del máximo iden de la Entidad");

      let identificador = maximo + 1;
      let campos = ["CodProd", "Nombre", "Familia", "Modelo", "Especificaciones", "Piezas", "Precio"];
      let valores = [identificador, nombre, familia, modelo, especificaciones, piezas, precio];

      operacionesComunes.insertarTupla("Producto", campos, valores);

      con.end();
    });
  });
}

var registrarProduccion = function(idProducto, cantidad) => {
  operacionesComunes.conectarse(function(err, con){
    if (err)
      console.log("Hubo un error al conectarse con la BD en registrarProduccion");

    var stock;
    var sql = "select Stock from Producto where CodProd = " + idProducto + ";";

    con.query(sql, (err, result) => {
      stock = Number(result[0]);
    });
    stock += cantidad;
    let campos = ["Stock"];
    let valores = [stock];
    let camposCondiciones = ["CodProd"];
    let valoresCondiciones = [idProducto];

    operacionesComunes.modificarTupla("Producto", campos, valores, camposCondiciones, valoresCondiciones, function(err, result){
      if (callback != undefined)
  			callback(err, result);
    });
  });
}
var eliminarProducto = (identificador) => {
	operacionesComunes.eliminarTupla("Producto", "CodProd", identificador);
}

var anadirDistribuidor = (nombre) => {
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
			operacionesComunes.insertarTupla("CampaniaPublicitaria", campos, valores);

			con.end();
		});
	});
}

var registrarEnvio = (producto, distribuidor, fecha, cantidad) =>{
  operacionesComunes.conectarse(function(err, con) {
		if(err)
			console.log("Hubo un error al conectarse con la BD");

    let campos = ["CodProd", "CodEnt", "Fecha", "Cantidad"];
    let valores = [producto, distribuidor, fecha, cantidad];

    operacionesComunes.insertarTupla("Envia", campos, valores);

    con.end();
  });
}

var eliminarDistribuidor = (identificador) => {
	operacionesComunes.eliminarTupla("Entidad", "CodEnt", identificador);
	operacionesComunes.eliminarTupla("Distribuidor", "CodEnt", identificador);
}

var consultarEnvios = (distribuidor, callback) => {
  operacionesComunes.conectarse(function(err, con) {
		if(err)
			console.log("Hubo un error al conectarse con la BD en consultarEnvios");

    let sql1 = "SET @listaProductos = \"\";" +
						  "CALL cursorEnviados(@listaProductos);";

		let sql2 = "SELECT @listaProductos;";

    con.query(sql1, function(err, result) {
			if(err)
				console.log("Hubo un error al llamar a los cursores");
			else
				console.log("Cursores inicializados");

			con.query(sql2, function(err, result) {
				if(err)
					console.log("Hubo un error al hacer la consulta de la lista de envios");
				else
					console.log("Realizada la consulta de los envios");

				callback(result);
				con.end();
			});

		});
	});
};
