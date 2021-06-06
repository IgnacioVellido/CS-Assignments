; Ignacio Vellido Expósito

; Ejercicio 1 ---------------------------------------------------------

; Apartado a -----------------------------
(defrule primer_contar_hechos
  (declare (salience 100))  
  (ContarHechos XXX)
  (not (NumeroHechos XXX ?))
  =>  
  (assert (NoBorrar))     ; Para que solo se active una vez al principio
  (assert (NumeroHechos XXX 0))
)

(defrule no_primer_contar_hechos
  (declare (salience 100))  
  (ContarHechos XXX)
  ?Id <- (NumeroHechos XXX ?)
  (not (NoBorrar))  
  =>
  (retract ?Id)
  (assert (NoBorrar))
  (assert (NumeroHechos XXX 0))
)

; Aprovechamos el que no se pueda activar una regla con los mismos hechos varias veces
(defrule contar
  (ContarHechos XXX)  
  (XXX ?)
  =>  
  (assert (IncrementarHechos XXX))
)

(defrule incrementar_hechos
  (declare (salience 9999))
  ?Id <- (NumeroHechos XXX ?n)
  ?Id2 <- (IncrementarHechos XXX)
  =>
  (retract ?Id)
  (retract ?Id2)
  (assert (NumeroHechos XXX (+ ?n 1)))
)

(defrule parar_contar
  (declare (salience -1000))
  ?Id <- (ContarHechos XXX)
  ?Id2 <- (NoBorrar)
  =>
  (retract ?Id)
  (retract ?Id2)
)

; Apartado b -----------------------------

; Inicializando
(defrule numero_0
  (not (NumeroHechos XXX ?))
  =>
  (assert (NumeroHechos XXX 0))
)

; Se debe sustituir assert por el hecho Aniadir
(defrule aniadir
  ?Id <- (Aniadir XXX ?a)
  ?Id2 <- (NumeroHechos XXX ?n)
  (not (XXX ?a))
  =>
  (assert (XXX ?a))
  (retract ?Id)
  (retract ?Id2)
  (assert (NumeroHechos XXX (+ ?n 1)))
)

; Se debe sustituir retract por el hecho Quitar
(defrule quitar
  ?Id <- (Quitar XXX ?a)
  ?Id2 <- (NumeroHechos XXX ?n)
  ?Id3 <- (XXX ?a)
  =>
  (retract ?Id)
  (retract ?Id2)
  (retract ?Id3)
  (assert (NumeroHechos XXX (- ?n 1)))
)

; Ejercicio 2 ---------------------------------------------------------

; Apartado a -----------------------------

(defrule get_min
  ?Id <- (BuscarMin T)
  (T (S ?s))
  (not (T (S ?s2 & : (> ?s ?s2))))
  =>   
  (retract ?Id)
  (assert (minSdeT ?s))
)

; Apartado b -----------------------------

(defrule buscar_min
  ?Id <- (BuscarMin T)
  (T ? ?x ?)
  (not (T ? ?x2 & : (> ?x ?x2) ?))  
  =>   
  (retract ?Id)
  (assert (minXideT ?x))
)

; Ejercicio 3 ---------------------------------------------------------

; Apartado a -----------------------------

; Guardamos un hecho para recordar el máximo
(defrule buscar_max
  ?Id <- (Imprimir T)
  (T ?a ?x ?b)
  (not (T ? ?x2 & : (< ?x ?x2) ?))  
  =>   
  (retract ?Id)  
  (assert (SeguirBusqueda T ?x))

  ; Abrimos el archivo
  (open "DatosT.txt" file "w")
)

; Se muestra el valor que toca en ese instante
(defrule guardar
  (SeguirBusqueda T ?x)
  (T ?a ?x ?b)
  =>  
  (printout file ?a " " ?x " " ?b crlf)
)

; Busca el siguiente
(defrule siguiente_x
  (declare (salience -5))
  (SeguirBusqueda T ?x)
  (T ?a ?x2 & : (> ?x ?x2) ?b)  

  ; Que no haya mayor que el siguiente y menor o igual que el actual
  (not (T ? ?x3 & : (< ?x2 ?x3) & : (> ?x ?x3) ?))

  ?Id <- (SeguirBusqueda T ?x)
  =>
  (retract ?Id)
  (assert (SeguirBusqueda T ?x2))
)

; Si no se decrementa más, es que hemos llegado al mínimo
(defrule terminar_busqueda
  (declare (salience -10))
  ?Id <- (SeguirBusqueda T ?x)
  =>
  (retract ?Id)
  (close)
)

; Apartado b -----------------------------

; Abre el archivo
(defrule abrir
  ?Id <- (Leer T)
  =>
  (retract ?Id)
  (open "DatosT.txt" file)

  (bind ?linea (readline file))
  (assert (SeguirLeyendo ?linea))
)

; Comprueba si es EOF
(defrule comprobar
  ?Id <- (SeguirLeyendo ?linea)
  (test (neq ?linea EOF))
  =>
  (retract ?Id)
  (assert (GuardarLinea ?linea))
)

; Añade el hecho
(defrule guardarLinea
  ?Id <- (GuardarLinea ?linea)
  =>
  (retract ?Id)
  (assert-string(str-cat "(T " ?linea ")"))

  (bind ?linea2 (readline file))
  (assert (SeguirLeyendo ?linea2))
)

; Cierra el archivo
(defrule parar
  (declare (salience -5))
  ?Id <- (SeguirLeyendo ?)
  =>
  (retract ?Id)
  (close)
)

(deffacts hola
  (Leer T)
)

; Ejercicio 4 ---------------------------------------------------------

; Escribe cada minuto un mensaje por la terminal

(defrule iniciar_contador
  (declare (salience 9999))
  (not (Contador ?))    
  =>
  (assert (Contador (time)))
  (assert (TimeActual (time)))  
)

; Toca imprimir por pantalla
(defrule contador
  (declare (salience 9998))
  ?Id <- (Contador ?T1)  
  (TimeActual ?T2)
  (test (>= ?T2 (+ ?T1 60)))
  =>
  (retract ?Id)
  (assert (Contador ?T2))
  (printout t crlf "Estoy esperando nueva informacion" crlf) 
)

; Para que sea un bucle infinito
(defrule no_parar
  (declare (salience -9999))
  ?Id <- (TimeActual ?)
  =>  
  (retract ?Id)
  (assert (TimeActual (time)))
)
