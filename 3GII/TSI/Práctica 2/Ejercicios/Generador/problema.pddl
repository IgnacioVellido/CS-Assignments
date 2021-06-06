(define (problem EJERCICIO-GENERADO) (:domain EJERCICIO-7)
 	(:objects
 		bosque agua precipicio arena piedra - terreno
 		n s e o - orientacion

		zona_1 zona_2 zona_3 zona_4 zona_5 zona_6 zona_7 - zona

		bruja1 - bruja

		oro1 - oro

		zapatilla1 - zapatilla

		bikini1 - bikini

		manzana1 - manzana

		oscar1 - oscar

		princesa1 - princesa

		player3 - recogedor
		player1 - repartidor
		player2 - repartidor
	)
 
	(:init
		(posicion_personaje bruja1 zona_1)
		(posicion_objeto oro1 zona_1)
		(posicion_jugador player2 zona_3) 
		(orientacion player2 n)
		(posicion_objeto zapatilla1 zona_6)
		(posicion_jugador player1 zona_2) 
		(orientacion player1 n)
		(posicion_objeto bikini1 zona_3)
		(posicion_objeto manzana1 zona_4)
		(posicion_objeto oscar1 zona_5)
		(posicion_jugador player3 zona_4) 
		(orientacion player3 n)
		(posicion_personaje princesa1 zona_7)

		(tipo_zona zona_3 arena)
		(tipo_zona zona_5 piedra)
		(tipo_zona zona_4 piedra)
		(tipo_zona zona_6 piedra)
		(tipo_zona zona_7 agua)
		(tipo_zona zona_3 bosque)
		(tipo_zona zona_1 piedra)
		(tipo_zona zona_2 piedra)

		(camino zona_1 zona_3 n)
		(= (coste-camino zona_1 zona_3 ) 10)
		(camino zona_3 zona_1 s)
		(= (coste-camino zona_3 zona_1 ) 10)
		(camino zona_3 zona_6 n)
		(= (coste-camino zona_3 zona_6 ) 5)
		(camino zona_6 zona_3 s)
		(= (coste-camino zona_6 zona_3 ) 5)
		(camino zona_2 zona_3 o)
		(= (coste-camino zona_2 zona_3 ) 10)
		(camino zona_3 zona_2 e)
		(= (coste-camino zona_3 zona_2 ) 10)
		(camino zona_3 zona_4 o)
		(= (coste-camino zona_3 zona_4 ) 5)
		(camino zona_4 zona_3 e)
		(= (coste-camino zona_4 zona_3 ) 5)
		(camino zona_5 zona_4 o)
		(= (coste-camino zona_5 zona_4 ) 10)
		(camino zona_4 zona_5 e)
		(= (coste-camino zona_4 zona_5 ) 10)
		(camino zona_4 zona_7 o)
		(= (coste-camino zona_4 zona_7 ) 5)
		(camino zona_7 zona_4 e)
		(= (coste-camino zona_7 zona_4 ) 5)

		(= (bolsillo-actual bruja1) 0)
 		(= (bolsillo-maximo bruja1) 4)

		(= (bolsillo-actual princesa1) 0)
 		(= (bolsillo-maximo princesa1) 5)

		(= (conseguir-puntos zapatilla1 bruja1) 0)
		(= (conseguir-puntos zapatilla1 princesa1) 0)
		(= (conseguir-puntos manzana1 bruja1) 10)
		(= (conseguir-puntos manzana1 princesa1) 1)
		(= (conseguir-puntos oscar1 bruja1) 5)
		(= (conseguir-puntos oscar1 princesa1) 5)

		(= (puntos-jugador player1) 0)
		(= (puntos-jugador player2) 0)

		(= (puntos-totales) 0)
		(= (coste-total) 0)
	) 
	(:goal (and
							(>= (puntos-totales) 15)
							(>= (puntos-jugador player1) 2)
							(>= (puntos-jugador player2) 7)
					)
	)

	(:metric minimize (coste-total))  
)