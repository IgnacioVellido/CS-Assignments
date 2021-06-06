;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Ignacio Vellido Expósito
;;; Ejercicio 7
;;; Definición del dominio
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Zonas, objetos y personajes definidos. Acciones de movimiento y sobre
;;; objetos. Añadido coste entre zonas. Mochila y terrenos. Puntos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Se añaden subtipos de jugador y nueva acción.
;;; Se modifican los puntos, acciones de entrega y recoger
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain Ejercicio7)  
  (:requirements :strips :typing :adl)

  (:types
    repartidor recogedor - jugador
      repartidor - repartidor
      recogedor - recogedor

    princesa principe bruja profesor leonardo - personaje
      princesa - princesa
      principe - principe
      bruja - bruja
      profesor - profesor
      leonardo - leonardo

    oscar manzana rosa algoritmo oro zapatilla bikini - objeto
      oscar - oscar
      manzana - manzana
      rosa - rosa
      algoritmo - algoritmo
      oro - oro
      zapatilla - zapatilla
      bikini - bikini

    zona - zona
    bosque agua precipicio arena piedra - terreno

    n s e o - orientacion
  )

  (:functions 
    (coste-total)
    (coste-camino ?z1 - zona ?z2 - zona)
    
    (puntos-totales)    
    (puntos-jugador ?j - repartidor)
    (conseguir-puntos ?o - objeto ?p - personaje)

    (bolsillo-maximo ?p - personaje)
    (bolsillo-actual ?p - personaje)
  )

  (:predicates
    ; ?z1 conectada con ?z2 y situada a orientación ?o de esta
    ; Acordarse de que en el problema hay que colocarlo de forma recíproca
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

    ; Indica qué objeto tiene guardado en la mochila
    (en_mochila ?o - objeto ?j - jugador)

    ; Indica de qué tipo es la zona    
    (tipo_zona ?z - zona ?t - terreno)
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
                 ; Para que no dé más giros que los necesarios                          
                 (increase (coste-total) 1)                                                                    
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
                  ; Para que no dé más giros que los necesarios                          
                  (increase (coste-total) 1)
            )
  )

; ----------------------------------------------------------------------------- 

  (:action ir_norte
    :parameters (?j - jugador ?z1 - zona ?z2 - zona)
    :precondition (and  (posicion_jugador ?j ?z1)
                        (orientacion ?j n)
                        (camino ?z2 ?z1 n)
                        (or (tipo_zona ?z2 piedra)
                            (tipo_zona ?z2 arena)      
                        )
                  )
    :effect (and  (not (posicion_jugador ?j ?z1))
                  (posicion_jugador ?j ?z2)
                  (increase (coste-total) (coste-camino ?z1 ?z2))
            )
  )

  (:action ir_este
    :parameters (?j - jugador ?z1 - zona ?z2 - zona)
    :precondition (and  (posicion_jugador ?j ?z1)
                        (orientacion ?j e)
                        (camino ?z2 ?z1 e)       
                        (or (tipo_zona ?z2 piedra)
                            (tipo_zona ?z2 arena)      
                        )                        
                  )
    :effect (and  (not (posicion_jugador ?j ?z1))
                  (posicion_jugador ?j ?z2)
                  (increase (coste-total) (coste-camino ?z1 ?z2))
            )
  )

  (:action ir_sur
    :parameters (?j - jugador ?z1 - zona ?z2 - zona)
    :precondition (and  (posicion_jugador ?j ?z1)
                        (orientacion ?j s)
                        (camino ?z2 ?z1 s)       
                        (or (tipo_zona ?z2 piedra)
                            (tipo_zona ?z2 arena)      
                        )
                  )
    :effect (and  (not (posicion_jugador ?j ?z1))
                  (posicion_jugador ?j ?z2)
                  (increase (coste-total) (coste-camino ?z1 ?z2))
            )
  )

  (:action ir_oeste
    :parameters (?j - jugador ?z1 - zona ?z2 - zona)
    :precondition (and  (posicion_jugador ?j ?z1)
                        (orientacion ?j o)
                        (camino ?z2 ?z1 o)       
                        (or (tipo_zona ?z2 piedra)
                            (tipo_zona ?z2 arena)      
                        )
                  )
    :effect (and  (not (posicion_jugador ?j ?z1))
                  (posicion_jugador ?j ?z2)
                  (increase (coste-total) (coste-camino ?z1 ?z2))                        
            )
  )    

; -----------------------------------------------------------------------------

  (:action ir_norte_bosque
    :parameters (?j - jugador ?z1 - zona ?z2 - zona ?o - zapatilla)
    :precondition (and  (posicion_jugador ?j ?z1)
                        (orientacion ?j n)
                        (camino ?z2 ?z1 n)

                        (tipo_zona ?z2 bosque)
                        (or (cogido ?o ?j)
                            (en_mochila ?o ?j)                            
                        )
                  )
    :effect (and  (not (posicion_jugador ?j ?z1))
                  (posicion_jugador ?j ?z2)
                  (increase (coste-total) (coste-camino ?z1 ?z2))
            )
  )

  (:action ir_este_bosque
    :parameters (?j - jugador ?z1 - zona ?z2 - zona ?o - zapatilla)
    :precondition (and  (posicion_jugador ?j ?z1)
                        (orientacion ?j e)
                        (camino ?z2 ?z1 e)       

                        (tipo_zona ?z2 bosque)
                        (or (cogido ?o ?j)
                            (en_mochila ?o ?j)                            
                        )                        
                  )
    :effect (and  (not (posicion_jugador ?j ?z1))
                  (posicion_jugador ?j ?z2)
                  (increase (coste-total) (coste-camino ?z1 ?z2))
            )
  )

  (:action ir_sur_bosque
    :parameters (?j - jugador ?z1 - zona ?z2 - zona ?o - zapatilla)
    :precondition (and  (posicion_jugador ?j ?z1)
                        (orientacion ?j s)
                        (camino ?z2 ?z1 s)       
                        
                        (tipo_zona ?z2 bosque)
                        (or (cogido ?o ?j)
                            (en_mochila ?o ?j)                            
                        )                        
                  )
    :effect (and  (not (posicion_jugador ?j ?z1))
                  (posicion_jugador ?j ?z2)
                  (increase (coste-total) (coste-camino ?z1 ?z2))
            )
  )

  (:action ir_oeste_bosque
    :parameters (?j - jugador ?z1 - zona ?z2 - zona ?o - zapatilla)
    :precondition (and  (posicion_jugador ?j ?z1)
                        (orientacion ?j o)
                        (camino ?z2 ?z1 o)       
                        
                        (tipo_zona ?z2 bosque)
                        (or (cogido ?o ?j)
                            (en_mochila ?o ?j)                            
                        )                        
                  )
    :effect (and  (not (posicion_jugador ?j ?z1))
                  (posicion_jugador ?j ?z2)
                  (increase (coste-total) (coste-camino ?z1 ?z2))                        
            )
  )    

; -----------------------------------------------------------------------------

  (:action ir_norte_agua
    :parameters (?j - jugador ?z1 - zona ?z2 - zona ?o - bikini)
    :precondition (and  (posicion_jugador ?j ?z1)
                        (orientacion ?j n)
                        (camino ?z2 ?z1 n)

                        (tipo_zona ?z2 agua)
                        (or (cogido ?o ?j)
                            (en_mochila ?o ?j)                            
                        )
                  )
    :effect (and  (not (posicion_jugador ?j ?z1))
                  (posicion_jugador ?j ?z2)
                  (increase (coste-total) (coste-camino ?z1 ?z2))
            )
  )

  (:action ir_este_agua
    :parameters (?j - jugador ?z1 - zona ?z2 - zona ?o - bikini)
    :precondition (and  (posicion_jugador ?j ?z1)
                        (orientacion ?j e)
                        (camino ?z2 ?z1 e)       

                        (tipo_zona ?z2 agua)
                        (or (cogido ?o ?j)
                            (en_mochila ?o ?j)                            
                        )                        
                  )
    :effect (and  (not (posicion_jugador ?j ?z1))
                  (posicion_jugador ?j ?z2)
                  (increase (coste-total) (coste-camino ?z1 ?z2))
            )
  )

  (:action ir_sur_agua
    :parameters (?j - jugador ?z1 - zona ?z2 - zona ?o - bikini)
    :precondition (and  (posicion_jugador ?j ?z1)
                        (orientacion ?j s)
                        (camino ?z2 ?z1 s)       
                        
                        (tipo_zona ?z2 agua)
                        (or (cogido ?o ?j)
                            (en_mochila ?o ?j)                            
                        )                        
                  )
    :effect (and  (not (posicion_jugador ?j ?z1))
                  (posicion_jugador ?j ?z2)
                  (increase (coste-total) (coste-camino ?z1 ?z2))
            )
  )

  (:action ir_oeste_agua
    :parameters (?j - jugador ?z1 - zona ?z2 - zona ?o - bikini)
    :precondition (and  (posicion_jugador ?j ?z1)
                        (orientacion ?j o)
                        (camino ?z2 ?z1 o)       
                        
                        (tipo_zona ?z2 agua)
                        (or (cogido ?o ?j)
                            (en_mochila ?o ?j)                            
                        )                        
                  )
    :effect (and  (not (posicion_jugador ?j ?z1))
                  (posicion_jugador ?j ?z2)
                  (increase (coste-total) (coste-camino ?z1 ?z2))                        
            )
  )    

; -----------------------------------------------------------------------------

  (:action coger
    :parameters (?j - recogedor ?z - zona ?o1 - objeto)
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
    :parameters (?j - recogedor ?z - zona ?o - objeto)
    :precondition (and (cogido ?o ?j)
                       (posicion_jugador ?j ?z)
                  )
    :effect (and (posicion_objeto ?o ?z)
                 (not (cogido ?o ?j))
            )
  )

  (:action entregar
    :parameters (?j - repartidor ?z - zona ?o - objeto ?p - personaje)
    :precondition (and (posicion_jugador ?j ?z)
                       (posicion_personaje ?p ?z)
                       (cogido ?o ?j)
                       (< (bolsillo-actual ?p) (bolsillo-maximo ?p))
                  )
    :effect (and  (not (cogido ?o ?j))
                  (entregado ?o ?p)
                  (increase (puntos-totales) (conseguir-puntos ?o ?p))
                  (increase (puntos-jugador ?j) (conseguir-puntos ?o ?p))
                  (increase (bolsillo-actual ?p) 1)
            )
  )

; -----------------------------------------------------------------------------

  (:action guardar_en_mochila
    :parameters (?j - jugador ?o1 - objeto)
    :precondition (and  (cogido ?o1 ?j)
                        (forall (?o2 - objeto)                         
                              (not (en_mochila ?o2 ?j))
                        )
                  )
    :effect (and (en_mochila ?o1 ?j)
                 (not (cogido ?o1 ?j))
            )
  )

  (:action sacar_de_mochila
    :parameters (?j - jugador ?o1 - objeto)
    :precondition (and  (en_mochila ?o1 ?j)
                        (forall (?o2 - objeto)                         
                              (not (cogido ?o2 ?j))
                        )
                  )
    :effect (and (cogido ?o1 ?j)
                 (not (en_mochila ?o1 ?j))
            )
  )  

; -----------------------------------------------------------------------------  

  ; j1 se lo da a j2
  (:action traspasar_objeto
    :parameters (?j1 - jugador ?j2 - jugador ?o1 - objeto)
    :precondition (and  (cogido ?o1 ?j1)
                        (forall (?o2 - objeto)                         
                                (not (cogido ?o2 ?j2))
                        )
                  )
    :effect (and (cogido ?o1 ?j2)
                 (not (cogido ?o1 ?j1))
            )
  )  
)