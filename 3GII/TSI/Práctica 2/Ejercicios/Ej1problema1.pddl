;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Ignacio Vellido Expósito
;;; Ejercicio 1 Problema 1
;;; Definición del problema
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Se mueve hasta la zona 5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Mapa
;;;   2  -  3
;;;  |      |
;;;  1  5 - 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (problem EJERCICIO-1-Prueba_girar_y_moverse) (:domain EJERCICIO-1)
  (:objects 
    jugador_1 - jugador

    princesa_1 - princesa
    principe_1 - principe
    bruja_1 - bruja
    profesor_1 - profesor
    leonardo_1 - leonardo

    oscar_1 - oscar
    manzana_1 - manzana
    rosa_1 - rosa
    algoritmo_1 - algoritmo
    oro_1 - oro

    zona_1 zona_2 zona_3 zona_4 zona_5 - zona

    n s e o - orientacion
  )

  (:init
      (posicion_jugador jugador_1 zona_1)
      (orientacion jugador_1 n)
          
      ; El grafo es dirigido, se debe poner el camino inverso
      (camino zona_2 zona_1 n)
      (camino zona_3 zona_2 e)
      (camino zona_4 zona_3 s)
      (camino zona_5 zona_4 o)

      (camino zona_1 zona_2 s)
      (camino zona_2 zona_3 o)
      (camino zona_3 zona_4 n)
      (camino zona_4 zona_5 e)
  )

  (:goal (and (posicion_jugador jugador_1 zona_5)
              (orientacion jugador_1 e)
         )
  )
)