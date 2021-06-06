;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Ignacio Vellido Expósito
;;; Ejercicio 3 Problema 1
;;; Definición del problema
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Pruebas con la mochila
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Mapa
;;; 1 - 2 - 3 - 4 - 5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (problem EJERCICIO-3-Prueba_mochila) (:domain EJERCICIO-3)
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
    bikini_1 - bikini
    zapatilla_1 - zapatilla

    zona_1 zona_2 zona_3 zona_4 zona_5 - zona

    n s e o - orientacion
    bosque agua precipicio arena piedra - terreno
  )

  (:init
      (posicion_jugador jugador_1 zona_1)
      (orientacion jugador_1 n)

      (posicion_objeto zapatilla_1 zona_1)
      (posicion_objeto bikini_1 zona_3)
      (posicion_objeto oscar_1 zona_4)

      (tipo_zona zona_1 piedra)
      (tipo_zona zona_2 bosque)
      (tipo_zona zona_3 piedra)
      (tipo_zona zona_4 agua)
      (tipo_zona zona_5 arena)
                  
      (camino zona_1 zona_2 o)
      (camino zona_2 zona_1 e)
      (camino zona_2 zona_3 o)
      (camino zona_3 zona_2 e)
      (camino zona_3 zona_4 o)
      (camino zona_4 zona_3 e)
      (camino zona_4 zona_5 o)
      (camino zona_5 zona_4 e)

      (= (coste-camino zona_1 zona_2) 10)
      (= (coste-camino zona_2 zona_1) 10)

      (= (coste-camino zona_2 zona_3) 10)
      (= (coste-camino zona_3 zona_2) 10)

      (= (coste-camino zona_3 zona_4) 10)
      (= (coste-camino zona_4 zona_3) 10)

      (= (coste-camino zona_4 zona_5) 10)
      (= (coste-camino zona_5 zona_4) 10)

      (= (coste-total) 0)
  )

  (:goal (and (posicion_jugador jugador_1 zona_3)

              (cogido oscar_1 jugador_1)
              (en_mochila bikini_1 jugador_1)

              (posicion_objeto zapatilla_1 zona_3)
         )
  )

  (:metric minimize (coste-total))  
)