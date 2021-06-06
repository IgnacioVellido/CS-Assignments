;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Ignacio Vellido Expósito - Ejercicio 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (domain zeno-travel)

  (:requirements
    :typing
    :fluents
    :derived-predicates
    :negative-preconditions
    :universal-preconditions
    :disjuntive-preconditions
    :conditional-effects
    :htn-expansion

    ; Requisitos adicionales para el manejo del tiempo
    :durative-actions
    :metatags
 )

  (:types aircraft person city - object)
  (:constants slow fast - object)
  (:predicates  (at ?x - (either person aircraft) ?c - city)
                (in ?p - person ?a - aircraft)

                (different ?x ?y) (igual ?x ?y)

                (hay-fuel-lento ?a ?c1 ?c2)
                (hay-fuel-rapido ?a ?c1 ?c2)
                (no-sobrepasado-fuel-lento ?a ?c1 ?c2)
                (no-sobrepasado-fuel-rapido ?a ?c1 ?c2)

                (destino ?p - person ?c - city)

                (hay-tiempo-lento ?a - aircraft ?c1 - city ?c2 - city)
                (hay-tiempo-rapido ?a - aircraft ?c1 - city ?c2 - city)

                (es-ciudad ?c - city)
  )
  (:functions (fuel ?a - aircraft)
              (capacity ?a - aircraft)

              (distance ?c1 - city ?c2 - city)
              (slow-speed ?a - aircraft)
              (fast-speed ?a - aircraft)
              (slow-burn ?a - aircraft)
              (fast-burn ?a - aircraft)

              (refuel-rate ?a - aircraft)

              (total-fuel-used)
              (fuel-limit)

              (boarding-time)
              (debarking-time)

              (num-pasajeros ?a - aircraft)  ; Número actual de pasajeros
              (max-pasajeros ?a - aircraft)  ; Número máximo de pasajeros

              (max-tiempo-vuelo ?a - aircraft) ; Máximo tiempo que puede estar volando un avión
                                               ; en minutos 
  )

  ;;; Derived ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;; El consecuente "vacío" se representa como "()" y significa "siempre verdad"
  (:derived
    (igual ?x ?x) ()
  )

  (:derived 
    (different ?x ?y) (not (igual ?x ?y))
  )
  
  ; Si no se pasa el consumo del límite
  (:derived
    (no-sobrepasado-fuel-rapido ?a - aircraft ?c1 - city ?c2 - city)
    (< (+ (total-fuel-used) (* (distance ?c1 ?c2) (fast-burn ?a))) (fuel-limit))
  )

  (:derived
    (no-sobrepasado-fuel-lento ?a - aircraft ?c1 - city ?c2 - city)
    (< (+ (total-fuel-used) (* (distance ?c1 ?c2) (slow-burn ?a))) (fuel-limit))
  )

  ; Para comprobar si hay suficiente fuel
  (:derived   
    (hay-fuel-lento ?a - aircraft ?c1 - city ?c2 - city)
    (>= (fuel ?a) (* (distance ?c1 ?c2) (slow-burn ?a)) )
  )

  (:derived   
    (hay-fuel-rapido ?a - aircraft ?c1 - city ?c2 - city)
    (>= (fuel ?a) (* (distance ?c1 ?c2) (fast-burn ?a)) )
  )

  ; Para comprobar si el avión puede hacer el vuelo en ese tiempo, en caso de que no hará escala
  (:derived
    (hay-tiempo-lento ?a - aircraft ?c1 - city ?c2 - city)
    (>= (max-tiempo-vuelo ?a) (/ (distance ?c1 ?c2) (slow-speed ?a)) )
  )

  (:derived
    (hay-tiempo-rapido ?a - aircraft ?c1 - city ?c2 - city)
    (>= (max-tiempo-vuelo ?a) (/ (distance ?c1 ?c2) (fast-speed ?a)) )
  )

  ;;; Tasks ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (:task transport-person
    :parameters (?p - person ?c - city)
    
    (:method Case1 ; si la persona está en la ciudad no se hace nada
      :precondition (at ?p ?c)
      :tasks ()
    )
    
    
    (:method Case2 ; si no está en la ciudad destino, pero avion y persona están en la misma ciudad
      :precondition (and  (at ?p - person ?c1 - city)
                          (at ?a - aircraft ?c1 - city)
                    )
              
      :tasks ( 
              (embarcar-pasajeros ?a ?c1 ?c)              
              (mover-avion ?a ?c1 ?c)
              (desembarcar-pasajeros ?a ?c)
            )
    )

    (:method Case3 ; Si el avión no está en la misma ciudad, traerlo primero
      :precondition (and 
                          (at ?p - person ?c1 - city)
                          (at ?a - aircraft ?c2 - city)
                          (not (= ?c1 ?c2))
                    )
      :tasks (
                (embarcar-pasajeros ?a ?c2 ?c1)                
                (mover-avion ?a ?c2 ?c1)                
                (desembarcar-pasajeros ?a ?c1)
                
                (embarcar-pasajeros ?a ?c1 ?c)
                (mover-avion ?a ?c1 ?c)
                (desembarcar-pasajeros ?a ?c)
            )
    )
  )

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (:task mover-avion
    :parameters (?a - aircraft ?c1 - city ?c2 - city)
    (:method rapido-no-refuel ; Al estar primero priorizamos el volar deprisa
      :precondition (and                      
                      (hay-fuel-rapido ?a ?c1 ?c2) ; Hay fuel para el vuelo
                      (no-sobrepasado-fuel-rapido ?a ?c1 ?c2) ; No sobrepasa el limite
                      (hay-tiempo-rapido ?a ?c1 ?c2) ; Hay tiempo para el vuelo
                    )      
      :tasks (
              (zoom ?a ?c1 ?c2)
            )
    )

    (:method rapido-refuel ; Probamos repostando
      :precondition (and
                      (not (hay-fuel-rapido ?a ?c1 ?c2))
                      (no-sobrepasado-fuel-rapido ?a ?c1 ?c2)
                      (hay-tiempo-rapido ?a ?c1 ?c2) 
                    )      
      :tasks (
              (refuel ?a ?c1)
              (zoom ?a ?c1 ?c2)
            )
    )

    (:method lento-no-refuel
      :precondition (and
                      (hay-fuel-lento ?a ?c1 ?c2)
                      (no-sobrepasado-fuel-lento ?a ?c1 ?c2)
                      (hay-tiempo-lento ?a ?c1 ?c2) 
                    )
      :tasks (
              (fly ?a ?c1 ?c2)
            )
    )

    (:method lento-refuel
      :precondition (and
                      (not (hay-fuel-lento ?a ?c1 ?c2))
                      (no-sobrepasado-fuel-lento ?a ?c1 ?c2)
                      (hay-tiempo-lento ?a ?c1 ?c2) 
                    )
      :tasks (
              (refuel ?a ?c1)
              (fly ?a ?c1 ?c2)
            )
    )

    (:method escala ; No puede con ninguno, probar otra ciudad
      :precondition (and 
                      (es-ciudad ?c3 - city)
                      (not (= ?c2 ?c3))
                      (not (= ?c1 ?c3))                      
                    )
      :tasks (
              (hacer-escala ?a ?c1 ?c3)
              (mover-avion ?a ?c3 ?c2)
            )
    )
  )

  ; Copia del anterior, pero sin permitir hacer escala
  (:task hacer-escala
    :parameters (?a - aircraft ?c1 - city ?c2 - city)
        (:method rapido-no-refuel ; Al estar primero priorizamos el volar deprisa
      :precondition (and                      
                      (hay-fuel-rapido ?a ?c1 ?c2) ; Hay fuel para el vuelo
                      (no-sobrepasado-fuel-rapido ?a ?c1 ?c2) ; No sobrepasa el limite
                      (hay-tiempo-rapido ?a ?c1 ?c2) ; Hay tiempo para el vuelo
                    )      
      :tasks (
              (zoom ?a ?c1 ?c2)
            )
    )

    (:method rapido-refuel ; Probamos repostando
      :precondition (and
                      (not (hay-fuel-rapido ?a ?c1 ?c2))
                      (no-sobrepasado-fuel-rapido ?a ?c1 ?c2)
                      (hay-tiempo-rapido ?a ?c1 ?c2) 
                    )      
      :tasks (
              (refuel ?a ?c1)
              (zoom ?a ?c1 ?c2)
            )
    )

    (:method lento-no-refuel
      :precondition (and
                      (hay-fuel-lento ?a ?c1 ?c2)
                      (no-sobrepasado-fuel-lento ?a ?c1 ?c2)
                      (hay-tiempo-lento ?a ?c1 ?c2) 
                    )
      :tasks (
              (fly ?a ?c1 ?c2)
            )
    )

    (:method lento-refuel
      :precondition (and
                      (not (hay-fuel-lento ?a ?c1 ?c2))
                      (no-sobrepasado-fuel-lento ?a ?c1 ?c2)
                      (hay-tiempo-lento ?a ?c1 ?c2) 
                    )
      :tasks (
              (refuel ?a ?c1)
              (fly ?a ?c1 ?c2)
            )
    )
  )
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (:task embarcar-pasajeros ; Embarca a todos los pasajeros en ?c1 con destino ?c2
    :parameters (?a - aircraft ?c1 - city ?c2 - city)
    (:method Case1
      :precondition (and
                          (at ?p - person ?c1 - city)
                          (at ?a - aircraft ?c1 - city)
                          (destino ?p - person ?c2 - city)
                    )
      :tasks (              
              (board ?p ?a ?c1)   
              (embarcar-pasajeros ?a ?c1 ?c2)           
            )
    )

    (:method Case2 ; Si no hay nadie no hace nada
      :precondition ()
      :tasks ()
    )
  )

  (:task desembarcar-pasajeros ; Desembarca a todos los pasajeros con destino ?c
    :parameters (?a - aircraft ?c - city)
    (:method Case1
      :precondition (and
                          (in ?p - person ?a - aircraft)
                          (at ?a - aircraft ?c - city)
                          (destino ?p - person ?c - city)
                    )
      :tasks (              
              (debark ?p ?a ?c)              
              (desembarcar-pasajeros ?a ?c)           
            )
    )

    (:method Case2 ; Si no hay nadie no hace nada
      :precondition ()
      :tasks ()
    )
  )

  (:import "Primitivas-Zenotravel.pddl") 
)