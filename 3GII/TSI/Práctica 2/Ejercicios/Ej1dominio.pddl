;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Ignacio Vellido Expósito
;;; Ejercicio 1
;;; Definición del dominio
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Zonas, objetos y personajes definidos. Acciones de movimiento y sobre
;;; objetos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain Ejercicio1)  
  (:requirements :strips :typing)

  (:types
    jugador - jugador

    princesa principe bruja profesor leonardo - personaje
      princesa - princesa
      principe - principe
      bruja - bruja
      profesor - profesor
      leonardo - leonardo

    oscar manzana rosa algoritmo oro - objeto
      oscar - oscar
      manzana - manzana
      rosa - rosa
      algoritmo - algoritmo
      oro - oro

    zona - zona

    n s e o - orientacion
  )

  (:functions 

  )

  (:predicates
    ; ?z1 conectada con ?z2 y situada a orientación ?o de esta
    ; Acordarse de que el grafo es dirigido, se deben representar las dos 
    ; direcciones
    (camino ?z1 - zona ?z2 - zona ?o - orientacion)

    ; Indica la orientación del jugador
    (orientacion ?j - jugador ?o - orientacion)

    ; Indican la posición de un personaje, jugador y objeto
    (posicion_personaje ?p - personaje ?z - zona)
    (posicion_jugador ?j - jugador ?z - zona)
    (posicion_objeto ?o - objeto ?z - zona)

    ; Indica que el jugador tiene un objeto
    (cogido ?o - objeto ?j - jugador)

    ; Indica qué objetos se han entregado a qué personaje
    (entregado ?o - objeto ?p - personaje)
  )

; -----------------------------------------------------------------------------
  ; Acciones

  (:action girar-izquierda
    :parameters (?j - jugador ?o - orientacion)
    :precondition (and 
                       (orientacion ?j ?o)
                  )
    :effect (and (not (orientacion ?j ?o))
                 (when (= ?o n)
                       (orientacion ?j o)
                 )
                 (when (= ?o e)
                       (orientacion ?j n)
                 )
                 (when (= ?o s)
                       (orientacion ?j e)
                 )
                 (when (= ?o o)
                       (orientacion ?j s)
                 )                                                                    
            )
  )

  (:action girar-derecha
    :parameters (?j - jugador ?o - orientacion)
    :precondition (and 
                       (orientacion ?j ?o)
                  )
    :effect (and  (not (orientacion ?j ?o))
                  (when (= ?o n)
                        (orientacion ?j e)
                  )
                  (when (= ?o e)
                        (orientacion ?j s)
                  )
                  (when (= ?o s)
                        (orientacion ?j o)
                  )
                  (when (= ?o o)
                        (orientacion ?j n)
                  )                                                   
            )
  )

; ----------------------------------------------------------------------------- 

  (:action ir_norte
    :parameters (?j - jugador ?z1 - zona ?z2 - zona)
    :precondition (and  (posicion_jugador ?j ?z1)
                        (orientacion ?j n)
                        (camino ?z2 ?z1 n)       
                  )
    :effect (and  (not (posicion_jugador ?j ?z1))
                  (posicion_jugador ?j ?z2)
            )
  )

  (:action ir_este
    :parameters (?j - jugador ?z1 - zona ?z2 - zona)
    :precondition (and  (posicion_jugador ?j ?z1)
                        (orientacion ?j e)
                        (camino ?z2 ?z1 e)       
                  )
    :effect (and  (not (posicion_jugador ?j ?z1))
                  (posicion_jugador ?j ?z2)
            )
  )

  (:action ir_sur
    :parameters (?j - jugador ?z1 - zona ?z2 - zona)
    :precondition (and  (posicion_jugador ?j ?z1)
                        (orientacion ?j s)
                        (camino ?z2 ?z1 s)       
                  )
    :effect (and  (not (posicion_jugador ?j ?z1))
                  (posicion_jugador ?j ?z2)
            )
  )

  (:action ir_oeste
    :parameters (?j - jugador ?z1 - zona ?z2 - zona)
    :precondition (and  (posicion_jugador ?j ?z1)
                        (orientacion ?j o)
                        (camino ?z2 ?z1 o)       
                  )
    :effect (and  (not (posicion_jugador ?j ?z1))
                  (posicion_jugador ?j ?z2)
            )
  )    

; -----------------------------------------------------------------------------

  (:action coger
    :parameters (?j - jugador ?z - zona ?o1 - objeto ?o2 - objeto)
    :precondition (and  (posicion_objeto ?o1 ?z)
                        (posicion_jugador ?j ?z)
                        (forall (?o2 - objeto)                         
                              (not (cogido ?o2 ?j))
                        )                       
                  )
    :effect (and (not (posicion_objeto ?o1 ?z))
                 (cogido ?o1 ?j)
            )
  )
  
  (:action dejar
    :parameters (?j - jugador ?z - zona ?o - objeto)
    :precondition (and (cogido ?o ?j)
                       (posicion_jugador ?j ?z)
                  )
    :effect (and (posicion_objeto ?o ?z)
                 (not (cogido ?o ?j))
            )
  )

  (:action entregar
    :parameters (?j - jugador ?z - zona ?o - objeto ?p - personaje)
    :precondition (and (posicion_jugador ?j ?z)
                       (posicion_personaje ?p ?z)
                       (cogido ?o ?j)
    )
    :effect (and (not (cogido ?o ?j))
                  (entregado ?o ?p)
            )
  )
)