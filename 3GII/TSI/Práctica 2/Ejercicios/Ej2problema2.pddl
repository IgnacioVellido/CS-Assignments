;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Ignacio Vellido Expósito
;;; Ejercicio 2 Problema 2
;;; Definición del problema
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 25 zonas y 5 personajes, le entrega un objeto a cada uno
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Mapa
;;; 01  02  03  04  05
;;; 06  07  08  09  10
;;; 11  12  13  14  15
;;; 16  17  18  19  20
;;; 21  22  23  24  25
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (problem EJERCICIO-2-Apartado_b) (:domain EJERCICIO-2)
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
    zona_6 zona_7 zona_8 zona_9 zona_10 - zona
    zona_11 zona_12 zona_13 zona_14 zona_15 - zona
    zona_16 zona_17 zona_18 zona_19 zona_20 - zona
    zona_21 zona_22 zona_23 zona_24 zona_25 - zona

    n s e o - orientacion
  )

  (:init
      (posicion_jugador jugador_1 zona_1)
      (orientacion jugador_1 n)

      (posicion_objeto oscar_1 zona_23)
      (posicion_objeto rosa_1 zona_15)
      (posicion_objeto oro_1 zona_2)
      (posicion_objeto manzana_1 zona_1)
      (posicion_objeto algoritmo_1 zona_15)

      (posicion_personaje bruja_1 zona_1)
      (posicion_personaje profesor_1 zona_2)
      (posicion_personaje princesa_1 zona_7)
      (posicion_personaje principe_1 zona_13)
      (posicion_personaje leonardo_1 zona_22)
            
      ; El grafo es dirigido, se debe poner el camino inverso
      ; Horizontal
      (camino zona_1 zona_2 o)
      (camino zona_2 zona_1 e)
      (camino zona_2 zona_3 o)
      (camino zona_3 zona_2 e)
      (camino zona_3 zona_4 o)
      (camino zona_4 zona_3 e)
      (camino zona_4 zona_5 o)
      (camino zona_5 zona_4 e)

      (camino zona_6 zona_7 o)
      (camino zona_7 zona_6 e)
      (camino zona_7 zona_8 o)
      (camino zona_8 zona_7 e)
      (camino zona_8 zona_9 o)
      (camino zona_9 zona_8 e)
      (camino zona_9 zona_10 o)
      (camino zona_10 zona_9 e)

      (camino zona_11 zona_12 o)
      (camino zona_12 zona_11 e)
      (camino zona_12 zona_13 o)
      (camino zona_13 zona_12 e)
      (camino zona_13 zona_14 o)
      (camino zona_14 zona_13 e)
      (camino zona_14 zona_15 o)
      (camino zona_15 zona_14 e)

      (camino zona_16 zona_17 o)
      (camino zona_17 zona_16 e)
      (camino zona_17 zona_18 o)
      (camino zona_18 zona_17 e)
      (camino zona_18 zona_19 o)
      (camino zona_19 zona_18 e)
      (camino zona_19 zona_20 o)
      (camino zona_20 zona_19 e)

      (camino zona_21 zona_22 o)
      (camino zona_22 zona_21 e)
      (camino zona_22 zona_23 o)
      (camino zona_23 zona_22 e)
      (camino zona_23 zona_24 o)
      (camino zona_24 zona_23 e)
      (camino zona_24 zona_25 o)
      (camino zona_25 zona_24 e)

      ; Vertical
      (camino zona_1 zona_6 n)
      (camino zona_6 zona_1 s)
      (camino zona_6 zona_11 n)
      (camino zona_11 zona_6 s)
      (camino zona_11 zona_16 n)
      (camino zona_16 zona_11 s)
      (camino zona_16 zona_21 n)
      (camino zona_21 zona_16 s)

      (camino zona_2 zona_7 n)
      (camino zona_7 zona_2 s)
      (camino zona_7 zona_12 n)
      (camino zona_12 zona_7 s)
      (camino zona_12 zona_17 n)
      (camino zona_17 zona_12 s)
      (camino zona_17 zona_22 n)
      (camino zona_22 zona_17 s)

      (camino zona_3 zona_8 n)
      (camino zona_8 zona_3 s)
      (camino zona_8 zona_13 n)
      (camino zona_13 zona_8 s)
      (camino zona_13 zona_18 n)
      (camino zona_18 zona_13 s)
      (camino zona_18 zona_23 n)
      (camino zona_23 zona_18 s)

      (camino zona_4 zona_9 n)
      (camino zona_9 zona_4 s)
      (camino zona_9 zona_14 n)
      (camino zona_14 zona_9 s)
      (camino zona_14 zona_19 n)
      (camino zona_19 zona_14 s)
      (camino zona_19 zona_24 n)
      (camino zona_24 zona_19 s)

      (camino zona_5 zona_10 n)
      (camino zona_10 zona_5 s)
      (camino zona_10 zona_15 n)
      (camino zona_15 zona_10 s)
      (camino zona_15 zona_20 n)
      (camino zona_20 zona_15 s)
      (camino zona_20 zona_25 n)
      (camino zona_25 zona_20 s)

      ; Costes -------------------
      (= (coste-total) 0)
      
      ; Horizontal
      (= (coste-camino zona_1 zona_2) 10)
      (= (coste-camino zona_2 zona_1) 5)
      (= (coste-camino zona_2 zona_3) 10)
      (= (coste-camino zona_3 zona_2) 5)
      (= (coste-camino zona_3 zona_4) 10)
      (= (coste-camino zona_4 zona_3) 5)
      (= (coste-camino zona_4 zona_5) 10)
      (= (coste-camino zona_5 zona_4) 5)

      (= (coste-camino zona_6 zona_7) 10)
      (= (coste-camino zona_7 zona_6) 5)
      (= (coste-camino zona_7 zona_8) 10)
      (= (coste-camino zona_8 zona_7) 5)
      (= (coste-camino zona_8 zona_9) 10)
      (= (coste-camino zona_9 zona_8) 5)
      (= (coste-camino zona_9 zona_10) 10)
      (= (coste-camino zona_10 zona_9) 5)

      (= (coste-camino zona_11 zona_12) 10)
      (= (coste-camino zona_12 zona_11) 5)
      (= (coste-camino zona_12 zona_13) 10)
      (= (coste-camino zona_13 zona_12) 5)
      (= (coste-camino zona_13 zona_14) 10)
      (= (coste-camino zona_14 zona_13) 5)
      (= (coste-camino zona_14 zona_15) 10)
      (= (coste-camino zona_15 zona_14) 5)

      (= (coste-camino zona_16 zona_17) 10)
      (= (coste-camino zona_17 zona_16) 5)
      (= (coste-camino zona_17 zona_18) 10)
      (= (coste-camino zona_18 zona_17) 5)
      (= (coste-camino zona_18 zona_19) 10)
      (= (coste-camino zona_19 zona_18) 5)
      (= (coste-camino zona_19 zona_20) 10)
      (= (coste-camino zona_20 zona_19) 5)

      (= (coste-camino zona_21 zona_22) 10)
      (= (coste-camino zona_22 zona_21) 5)
      (= (coste-camino zona_22 zona_23) 10)
      (= (coste-camino zona_23 zona_22) 5)
      (= (coste-camino zona_23 zona_24) 10)
      (= (coste-camino zona_24 zona_23) 5)
      (= (coste-camino zona_24 zona_25) 10)
      (= (coste-camino zona_25 zona_24) 5)

      ; Vertical
      (= (coste-camino zona_1 zona_6) 3)
      (= (coste-camino zona_6 zona_1) 7)
      (= (coste-camino zona_6 zona_11) 3)
      (= (coste-camino zona_11 zona_6) 7)
      (= (coste-camino zona_11 zona_16) 3)
      (= (coste-camino zona_16 zona_11) 7)
      (= (coste-camino zona_16 zona_21) 3)
      (= (coste-camino zona_21 zona_16) 7)

      (= (coste-camino zona_2 zona_7) 3)
      (= (coste-camino zona_7 zona_2) 7)
      (= (coste-camino zona_7 zona_12) 3)
      (= (coste-camino zona_12 zona_7) 7)
      (= (coste-camino zona_12 zona_17) 3)
      (= (coste-camino zona_17 zona_12) 7)
      (= (coste-camino zona_17 zona_22) 3)
      (= (coste-camino zona_22 zona_17) 7)

      (= (coste-camino zona_3 zona_8) 3)
      (= (coste-camino zona_8 zona_3) 7)
      (= (coste-camino zona_8 zona_13) 3)
      (= (coste-camino zona_13 zona_8) 7)
      (= (coste-camino zona_13 zona_18) 3)
      (= (coste-camino zona_18 zona_13) 7)
      (= (coste-camino zona_18 zona_23) 3)
      (= (coste-camino zona_23 zona_18) 7)

      (= (coste-camino zona_4 zona_9) 3)
      (= (coste-camino zona_9 zona_4) 7)
      (= (coste-camino zona_9 zona_14) 3)
      (= (coste-camino zona_14 zona_9) 7)
      (= (coste-camino zona_14 zona_19) 3)
      (= (coste-camino zona_19 zona_14) 7)
      (= (coste-camino zona_19 zona_24) 3)
      (= (coste-camino zona_24 zona_19) 7)

      (= (coste-camino zona_5 zona_10) 3)
      (= (coste-camino zona_10 zona_5) 7)
      (= (coste-camino zona_10 zona_15) 3)
      (= (coste-camino zona_15 zona_10) 7)
      (= (coste-camino zona_15 zona_20) 3)
      (= (coste-camino zona_20 zona_15) 7)
      (= (coste-camino zona_20 zona_25) 3)
      (= (coste-camino zona_25 zona_20) 7)

  )

  (:goal (and 
              (entregado manzana_1 bruja_1)
              (entregado rosa_1 princesa_1)
              (entregado oro_1 principe_1)
              (entregado oscar_1 leonardo_1)
              (entregado algoritmo_1 profesor_1)
         )
  )

  (:metric minimize (coste-total))  
)