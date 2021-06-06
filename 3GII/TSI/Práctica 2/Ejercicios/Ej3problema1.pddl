;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Ignacio Vellido Expósito
;;; Ejercicio 3 Problema 1
;;; Definición del problema
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Ir a la zona 5 por el camino más corto
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Mapa
;;;   2  - 3
;;;  | |   |
;;;  1-5 - 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define (problem EJERCICIO-3-Prueba_piedra) (:domain EJERCICIO-3)
  (:objects 
    jugador_1 - jugador

    princesa_1 - princesa
    principe_1 - principe
    bruja_1 - bruja
    profesor_1 - profesor
    leonardo_1 - leonardo

    oscar manzana rosa algoritmo oro bikini zapatilla - objeto

    oscar_1 - oscar
    manzana_1 - manzana
    rosa_1 - rosa
    algoritmo_1 - algoritmo
    oro_1 - oro

    zona_1 zona_2 zona_3 zona_4 zona_5 zona_6 - zona

    n s e o - orientacion
    bosque agua precipicio arena piedra - terreno
  )

  (:init
      (posicion_jugador jugador_1 zona_1)
      (orientacion jugador_1 n)

      (tipo_zona zona_1 piedra)
      (tipo_zona zona_2 piedra)
      (tipo_zona zona_3 piedra)
      (tipo_zona zona_4 piedra)
      (tipo_zona zona_5 piedra)
            
      ; El grafo es dirigido, se debe poner el camino inverso
      (camino zona_2 zona_1 n)
      (camino zona_3 zona_2 e)
      (camino zona_4 zona_3 s)
      (camino zona_5 zona_4 o)

      (camino zona_1 zona_2 s)
      (camino zona_2 zona_3 o)
      (camino zona_3 zona_4 n)
      (camino zona_4 zona_5 e)

      ; 2 conectada con 5, 
      (camino zona_5 zona_2 s)
      (camino zona_2 zona_5 n)

      (= (coste-camino zona_1 zona_2) 10)
      (= (coste-camino zona_2 zona_1) 10)

      (= (coste-camino zona_2 zona_3) 10)
      (= (coste-camino zona_3 zona_2) 10)

      (= (coste-camino zona_3 zona_4) 10)
      (= (coste-camino zona_4 zona_3) 10)

      (= (coste-camino zona_4 zona_5) 10)
      (= (coste-camino zona_4 zona_5) 10)

      (= (coste-camino zona_2 zona_5) 10)
      (= (coste-camino zona_5 zona_2) 10)

      (= (coste-total) 0)
  )

  (:goal (and (posicion_jugador jugador_1 zona_5)

         )
  )

  (:metric minimize (coste-total))  
)