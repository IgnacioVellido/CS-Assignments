(define (problem Ejercicio1) (:domain Problema1)
 	(:objects
 		bosque agua precipicio arena piedra - terreno
 		n s e o - orientacion

		zona_1 zona_2 zona_3 zona_4 zona_5 zona_6 zona_7 - zona

		oscar1 - oscar

		player1 - repartidor
		player2 - repartidor
	)
 
	(:init
		(posicion_jugador player1 zona_2) 
		(orientacion player1 n)
		(posicion_objeto oscar1 zona_5)

		(tipo_zona zona_5 piedra)
		(tipo_zona zona_2 piedra)


		(= (bolsillo-actual bruja1) 0)
 		(= (bolsillo-maximo bruja1) 4)

		(= (bolsillo-actual princesa1) 0)
 		(= (bolsillo-maximo princesa1) 5)


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