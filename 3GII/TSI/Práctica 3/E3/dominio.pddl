;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Ignacio Vellido Expósito - Ejercicio 3
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
  )
  (:functions (fuel ?a - aircraft)
              (distance ?c1 - city ?c2 - city)

              (slow-speed ?a - aircraft)
              (fast-speed ?a - aircraft)
              (slow-burn ?a - aircraft)
              (fast-burn ?a - aircraft)

              (capacity ?a - aircraft)
              (refuel-rate ?a - aircraft)

              (boarding-time)
              (debarking-time)

              (total-fuel-used)
              (fuel-limit)
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
    (>= (fuel ?a) (/ (distance ?c1 ?c2) (slow-burn ?a)) )
  )

  (:derived   
    (hay-fuel-rapido ?a - aircraft ?c1 - city ?c2 - city)
    (>= (fuel ?a) (/ (distance ?c1 ?c2) (slow-burn ?a)) )
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
              (board ?p ?a ?c1)
              (mover-avion ?a ?c1 ?c)
              (debark ?p ?a ?c )
            )
    )

    (:method Case3 ; Si el avión no está en la misma ciudad, traerlo primero
      :precondition (and 
                          (at ?p - person ?c1 - city)
                          (at ?a - aircraft ?c2 - city)
                          (different ?c1 ?c2)
                    )
      :tasks (
                (mover-avion ?a ?c2 ?c1)                
                (board ?p ?a ?c1)
                (mover-avion ?a ?c1 ?c)
                (debark ?p ?a ?c)
            )
    )
  )

  (:task mover-avion
    :parameters (?a - aircraft ?c1 - city ?c2 - city)
    (:method rapido-no-refuel ; Al estar primero priorizamos el volar deprisa
      :precondition (and                      
                      (hay-fuel-rapido ?a ?c1 ?c2) ; Hay fuel para el vuelo
                      (no-sobrepasado-fuel-rapido ?a ?c1 ?c2) ; No sobrepasa el limite
                    )      
      :tasks (
              (zoom ?a ?c1 ?c2)
            )
    )

    (:method rapido-refuel ; Probamos repostando
      :precondition (and
                      (not (hay-fuel-rapido ?a ?c1 ?c2))
                      (no-sobrepasado-fuel-rapido ?a ?c1 ?c2)
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
                    )
      :tasks (
              (fly ?a ?c1 ?c2)
            )
    )

    (:method lento-refuel
      :precondition (and
                      (not (hay-fuel-lento ?a ?c1 ?c2))
                      (no-sobrepasado-fuel-lento ?a ?c1 ?c2)
                    )
      :tasks (
              (refuel ?a ?c1)
              (fly ?a ?c1 ?c2)
            )
    )
  )
  
  (:import "Primitivas-Zenotravel.pddl") 
)