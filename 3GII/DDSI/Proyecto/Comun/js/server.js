const operacionesComunes = require('./operaciones');
const fs = require('fs');
var express = require('express');

const contenidoTabla = (con, nombreTabla) => {
	return new Promise((resolve, reject) => {
		let respuesta = "";
		let sql = "select * from " + nombreTabla + ";";
		
		con.query(sql, (err, result) => {
			if(err) {
				respuesta = "Hubo un error en la consulta a la tabla " + nombreTabla;
				console.log(respuesta);
				console.log("Error: ", err);
				
				reject(respuesta);
			} else {
				respuesta += "<h2>" + nombreTabla + "</h2>";
				respuesta += "<table class=\"table table-hover table-dark table-bordered\"><thead class=\"thead-dark\"><tr>";
				
				for(let x in result[0])
					respuesta += "<th scope=\"col\">" + x + "</th>";
				
				respuesta += "</tr></thead><tbody>";
				
				for(let y of result) {
					respuesta += "<tr>";
					
					for(let z in y)
						respuesta += "<td>" + y[z] + "</td>";
					
					respuesta += "</tr>";
				}
				
				respuesta += "</tbody></table>";
				
				resolve(respuesta);
			}
		});
	});
}

var app = express();

app.use((req, res, next) => {
	console.log("Ruta a leer: ", req.path);
	next();
});

app.get("*mostrarBD.html*", (req, res, next) => {
	let respuesta = [];
	
	operacionesComunes.conectarse((err, con) => {
		if(err)
			console.log("Hubo un error al conectarse a la BD");
		
		let nombresTablas = [];
		let sql = "show tables;";
		
		con.query(sql, (err, result) => {
			for(let x of result)
				for(let y in x)
					nombresTablas.push(x[y]);
			
			let promesas = [];
			
			for(let z of nombresTablas)
				promesas.push(contenidoTabla(con, z));
				
			Promise.all(promesas).then((values) => {
				for(let x of values)
					respuesta += x;
				
				operacionesComunes.devolverRespuesta(res, respuesta);
			});
		});
	});
});

app.get(["*Fran/html/*", "*Juanma/html/*", "*Ignacio/html/*", "*Nacho/html/*"], (req, res, next) => {
	let respuesta = "";
	fs.readFile("Comun/html/comun.html", 'utf8', (err, comun) => {
		if(err) {
			console.log("Hubo un error al leer el fichero común");
			console.log("Error: ", err);
			
			respuesta += "No se pudo leer el fichero común";
		} else {
			fs.readFile("." + req.path, "utf8", (err, especifico) => {
				fs.readFile("./Comun/html/cabecera.html", "utf8", (err, cab) => {
					if(err) {
						console.log("Hubo un error al leer: ", req.path, " o la cabecera");
						console.log("Error: ", err);
						
						respuesta += "No se pudo leer el fichero, " + req.path;
						operacionesComunes.devolverRespuesta(res, respuesta);
					} else {
						let bloqueACambiar = "<div id=\"diferente\">";
						let cambiarCabecera = "<div id=\"cabecera\">";
						
						let promesa = new Promise((resolve, reject) => {
							resolve(comun.replace(bloqueACambiar, bloqueACambiar + especifico));
						});
						
						promesa.then((resolve) => {
							comun = resolve;
							
							promesa = new Promise((resolve, reject) => {
								resolve(comun.replace(cambiarCabecera, cambiarCabecera + cab));
							});
							
							promesa.then((resolve) => {
								comun = resolve;
								
								console.log("Valor de común: ", comun);
								res.send(comun);
							});
						});
					}
				});
			});
		}
	});
});

app.get("*", (req, res, next) => {
	const options = {
		root: "."
	};
	
	console.log("Camino a leer: ", req.path);
	
	res.sendFile(req.path, options, (err) => {
		if(err) {
			console.log("Hubo un error al leer el fichero");
			console.log("Error: ", err);
		} else {
			console.log("Leído con éxito");		
		}
	});
});

app.listen(8080, () => {
	console.log("Servidor abierto en el puerto 8080");
});
