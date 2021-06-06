;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Ignacio Vellido Expósito
;;; Ejercicio 1 Problema 2
;;; Definición del problema
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Coge el óscar, lo deja en la zona 5,
;;; vuelve a la zona 2 y entrega la rosa a la bruja
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Mapa
;;;   2  - 3
;;;  | |   |
;;;  1 5 - 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (problem EJERCICIO-1-Prueba_coger_dejar_y_entregar) (:domain EJERCICIO-1)
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

    zona_1 zona_2 zona_3 zona_4 zona_5 zona_6 - zona

    n s e o - orientacion
  )

  (:init
      (posicion_jugador jugador_1 zona_1)
      (orientacion jugador_1 n)

      (posicion_objeto oscar_1 zona_3)
      (posicion_objeto rosa_1 zona_5)

      (posicion_personaje bruja_1 zona_2)
            
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

  (:goal (and (posicion_jugador jugador_1 zona_2)
              (orientacion jugador_1 e)

              (posicion_objeto oscar_1 zona_5)

              (entregado rosa_1 bruja_1)
         )
  )
)