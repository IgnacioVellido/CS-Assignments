;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Ignacio Vellido Expósito
;;; Ejercicio 5 Problema 1
;;; Definición del problema
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Pruebas con el bolsillo, no debería encontrar solución
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Mapa
;;; 1 - 2 - 3 - 4 - 5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (problem EJERCICIO-5-Prueba_bolsillo_falla) (:domain EJERCICIO-5)
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

      (posicion_personaje bruja_1 zona_4)
      (posicion_personaje leonardo_1 zona_1)

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

      ; Caminos
      (= (coste-total) 0)

      (= (coste-camino zona_1 zona_2) 10)
      (= (coste-camino zona_2 zona_1) 10)

      (= (coste-camino zona_2 zona_3) 10)
      (= (coste-camino zona_3 zona_2) 10)

      (= (coste-camino zona_3 zona_4) 10)
      (= (coste-camino zona_4 zona_3) 10)

      (= (coste-camino zona_4 zona_5) 10)
      (= (coste-camino zona_5 zona_4) 10)

      ; Puntos
      (= (puntos) 0)

      (= (conseguir-puntos oscar_1 leonardo_1) 10)
      (= (conseguir-puntos oscar_1 princesa_1) 5)
      (= (conseguir-puntos oscar_1 bruja_1) 4)
      (= (conseguir-puntos oscar_1 profesor_1) 3)
      (= (conseguir-puntos oscar_1 principe_1) 1)

      (= (conseguir-puntos rosa_1 leonardo_1) 1)
      (= (conseguir-puntos rosa_1 princesa_1) 10)
      (= (conseguir-puntos rosa_1 bruja_1) 5)
      (= (conseguir-puntos rosa_1 profesor_1) 4)
      (= (conseguir-puntos rosa_1 principe_1) 3)

      (= (conseguir-puntos manzana_1 leonardo_1) 3)
      (= (conseguir-puntos manzana_1 princesa_1) 1)
      (= (conseguir-puntos manzana_1 bruja_1) 10)
      (= (conseguir-puntos manzana_1 profesor_1) 5)
      (= (conseguir-puntos manzana_1 principe_1) 4)

      (= (conseguir-puntos algoritmo_1 leonardo_1) 4)
      (= (conseguir-puntos algoritmo_1 princesa_1) 3)
      (= (conseguir-puntos algoritmo_1 bruja_1) 1)
      (= (conseguir-puntos algoritmo_1 profesor_1) 10)
      (= (conseguir-puntos algoritmo_1 principe_1) 5)

      (= (conseguir-puntos oro_1 leonardo_1) 5)
      (= (conseguir-puntos oro_1 princesa_1) 4)
      (= (conseguir-puntos oro_1 bruja_1) 3)
      (= (conseguir-puntos oro_1 profesor_1) 1)
      (= (conseguir-puntos oro_1 principe_1) 10)

      ; Bolsillos
      (= (bolsillo-actual leonardo_1) 0)
      (= (bolsillo-actual bruja_1) 0)

      (= (bolsillo-maximo leonardo_1) 0)
      (= (bolsillo-maximo bruja_1) 5)
  )

  (:goal (and 
              (>= (puntos) 10)
         )
  )

  (:metric minimize (coste-total))  
)