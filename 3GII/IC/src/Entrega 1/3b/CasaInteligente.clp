; IGNACIO VELLIDO EXPÓSITO

; 1a --------------------------------------------------------------------------
; 1a --------------------------------------------------------------------------
; 1a --------------------------------------------------------------------------
; 1a --------------------------------------------------------------------------

; (posible_pasar habitacion1 habitacion2)

(defrule posible_pasar_puerta
  (Puerta ?H1 ?H2)
  =>
  (assert (posible_pasar ?H1 ?H2))  
  (assert (posible_pasar ?H2 ?H1))
)

(defrule posible_pasar_paso
  (Paso ?H1 ?H2)
  =>
  (assert (posible_pasar ?H1 ?H2))
  (assert (posible_pasar ?H2 ?H1))
)

; 1b --------------------------------------------------------------------------
; 1b --------------------------------------------------------------------------
; 1b --------------------------------------------------------------------------
; 1b --------------------------------------------------------------------------

; (necesario_pasar habitación_aislada habitación_conectora)
; Si hay una puerta entre las dos habitaciones y no hay otra puerta con cualquier
;   otra habitación distinta de la habitación conectora

(defrule necesario_pasar_puerta
  (Puerta ?HAislada ?HConectora)
  (Habitacion ?Otra)
  (test (neq ?Otra ?HConectora))
  (not (Puerta ?HAislada ?Otra))
  =>
  (assert (necesario_pasar ?HAislada ?HConectora))
)

; 1c --------------------------------------------------------------------------
; 1c --------------------------------------------------------------------------
; 1c --------------------------------------------------------------------------
; 1c --------------------------------------------------------------------------

; Una que no tiene ventanas

(defrule habitacion_interior
  (Habitacion ?H )
  (not (Ventana ? ?H))
  =>
  (assert (habitacion_interior ?H))
)


; Facts -----------------------------------------------------------

; Habitación: (Habitacion ?Nombre)
(deffacts Habitaciones 
  (Habitacion entrada)
  (Habitacion cocina)
  (Habitacion salon)
  (Habitacion banio1)
  (Habitacion banio2)
  (Habitacion pasillo)
  (Habitacion cuarto1)
  (Habitacion cuarto2)
  (Habitacion cuarto3)  
)

; Puerta: (Puerta ?Habitación1 ?Habitación2) (En orden alfabético)
(deffacts Puertas
  (Puerta cocina entrada)
  (Puerta cocina pasillo)
  (Puerta salon pasillo)
  (Puerta cuarto1 pasillo)
  (Puerta cuarto2 pasillo)
  (Puerta cuarto3 pasillo)
  (Puerta banio1 pasillo)
  (Puerta banio2 pasillo)
)

; Paso: (Paso ?Habitación1 ?Habitación2) (En orden alfabético)
(deffacts Pasos
  (Paso entrada salon)
)

; Ventana: (Ventana ?Identificador ?Habitación)
(deffacts Ventanas
  (Ventana V1 cocina)
  (Ventana V1 salon)
  (Ventana V1 cuarto1)
  (Ventana V1 cuarto2)
  (Ventana V1 cuarto3)
)

; 2a1 -------------------------------------------------------------------------
; 2a1 -------------------------------------------------------------------------
; 2a1 -------------------------------------------------------------------------
; 2a1 -------------------------------------------------------------------------

; (valorRegistrado ?T ?Tipo ?Habitacion ?Valor)
; Registrar la señal de un sensor en un tiempo determinado
; Se almacena la hora del sistema en segundos

(defrule valor_registrado
  (valor ?Tipo ?Habitacion ?V)  
  ?Id <- (valor ?Tipo ?Habitacion ?V)  

  (hora_actual ?hora)  
  (minutos_actual ?minuto)  
  (segundos_actual ?segundo)    
  =>
  (retract ?Id)  ; Para que no haya bucle infinito
  (assert (valorRegistrado (totalsegundos ?hora ?minuto ?segundo) ?Tipo ?Habitacion ?V))
)

; 2a2 -------------------------------------------------------------------------
; 2a2 -------------------------------------------------------------------------
; 2a2 -------------------------------------------------------------------------
; 2a2 -------------------------------------------------------------------------

; Registrar la señal de un sensor en un tiempo determinado

; Si no existe UltimoRegistro insertar directamente
(defrule primer_ultimo_registro
  (valorRegistrado ?T ?Tipo ?Habitacion ?)
  (not (ultimoRegistro ?Tipo ?Habitacion ?))
  =>
  (assert (ultimoRegistro ?Tipo ?Habitacion ?T))
)

; Si hay nuevo registro con ciclo superior, se modifica UltimoRegistro
(defrule ultimo_registro
  (valorRegistrado ?TNuevo ?Tipo ?Habitacion ?)
  (ultimoRegistro ?Tipo ?Habitacion ?TViejo)
  (test (> ?TNuevo ?TViejo))

  ?Id <- (ultimoRegistro ?Tipo ?Habitacion ?TViejo)
  =>
  (retract ?Id)
  (assert (ultimoRegistro ?Tipo ?Habitacion ?TNuevo))
)

; 2a3 -------------------------------------------------------------------------
; 2a3 -------------------------------------------------------------------------
; 2a3 -------------------------------------------------------------------------
; 2a3 -------------------------------------------------------------------------

; Buscamos el valor registrado de encendido e introducimos el hecho
(defrule primer_ultima_activacion
  (ultimoRegistro movimiento ?H ?T)
  (valorRegistrado ?T movimiento ?H on)

  (not (ultimaDesactivacion movimiento ?H ?))
  =>
  (assert (ultimaActivacion movimiento ?H ?T))
)

; Comprobamos que no sea el mismo hecho de la última activación y la modificamos
(defrule ultima_activacion
  (ultimoRegistro movimiento ?H ?TNuevo)
  (valorRegistrado ?TNuevo movimiento ?H on)

  (ultimaActivacion movimiento ?H ?TViejo)
  (test (> ?TNuevo ?TViejo))

  ?Id <- (ultimaActivacion movimiento ?H ?TViejo)
  =>
  (retract ?Id)
  (assert (ultimaActivacion movimiento ?H ?TNuevo))
)

; Buscamos el valor registrado de encendido e introducimos el hecho
(defrule primer_ultima_desactivacion
  (ultimoRegistro movimiento ?H ?T)
  (valorRegistrado ?T movimiento ?H off)

  (not (ultimaDesactivacion movimiento ?H ?))
  =>
  (assert (ultimaDesactivacion movimiento ?H ?T))
)

; Lo mismo pero con el estado off
(defrule ultima_desactivacion
  (ultimoRegistro movimiento ?H ?TNuevo)
  (valorRegistrado ?TNuevo movimiento ?H off)

  (ultimaDesactivacion movimiento ?H ?TViejo)
  (test (> ?TNuevo ?TViejo))

  ?Id <- (ultimaDesactivacion movimiento ?H ?TViejo)
  =>
  (retract ?Id)
  (assert (ultimaDesactivacion movimiento ?H ?TNuevo))
)

; 2b --------------------------------------------------------------------------
; 2b --------------------------------------------------------------------------
; 2b --------------------------------------------------------------------------
; 2b --------------------------------------------------------------------------

; Guardamos un hecho para recordar la fecha más alta
(defrule comenzar_informe
  ?Id <- (Informe ?H)
  (valorRegistrado ?T ?Tipo ?H ?Valor)
  (not (valorRegistrado ?T2 & : (< ?T ?T2) ? ?H ?))  
  => 
  (printout t crlf "Informe de habitacion " ?H crlf) 
  (retract ?Id)
  (assert (SeguirInforme ?H ?T))
)

; Se muestra el valor que toca en ese instante
(defrule seguir_informe
  (SeguirInforme ?H ?T)
  (valorRegistrado ?T2 ?Tipo ?H ?Valor)
  (test (eq ?T ?T2))
  
  =>  
  (printout t "Instante " (hora-segundos ?T) ":" (minuto-segundos ?T) ":" (segundo-segundos ?T) " - Tipo: " ?Tipo
    " - Valor: " ?Valor crlf)
)

; Busca el siguiente T
(defrule siguiente_t
  (declare (salience -5))
  (SeguirInforme ?H ?T)
  (valorRegistrado ?T2 & : (> ?T ?T2) ? ?H ?)  

  ; Que no haya mayor que el siguiente y menor o igual que el actual
  (not (valorRegistrado ?T3 & : (< ?T2 ?T3) & : (> ?T ?T3) ? ?H ?))

  ?Id <- (SeguirInforme ?H ?T)
  =>
  (retract ?Id)
  (assert (SeguirInforme ?H ?T2))
)

; Si no se decrementa más, es que no hay más valores que mostrar
(defrule terminar_informe
  (declare (salience -10))
  ?Id <- (SeguirInforme ? ?)
  =>
  (retract ?Id)
)

; 3a --------------------------------------------------------------------------
; 3a --------------------------------------------------------------------------
; 3a --------------------------------------------------------------------------
; 3a --------------------------------------------------------------------------

; En el otro archivo

; 3b -------------------------------------------------------------------------------------
; 3b -------------------------------------------------------------------------------------
; 3b -------------------------------------------------------------------------------------
; 3b -------------------------------------------------------------------------------------

; Si habitación vacía y luz encendida, apagar
(defrule apagar_luz_habitacion_vacia
  (Manejo_inteligente_luces ?H)  
  (HabitacionVacia ?H)
  
  ?Id <- (luz_encendida ?H)
  
  =>
  (assert (accion pulsador_luz ?H apagar))
  (retract ?Id)  
)

; Auxiliar, se le da prioridad para tener los datos actualizados a la hora de comprobar si vacía
(defrule definir_luminosidad
  (declare (salience 100))
  (Manejo_inteligente_luces ?H)  
  (ultimoRegistro luminosidad ?H ?T)
  (valorRegistrado ?T luminosidad ?H ?L1)

  ?Id <- (luminosidadActual ?H ?L2)

  (test (neq ?L1 ?L2))
  =>
  (retract ?Id)
  (assert (luminosidadActual ?H ?L1))
)

(defrule definir_primera_luminosidad
  (declare (salience 100))
  (Manejo_inteligente_luces ?H)  
  (ultimoRegistro luminosidad ?H ?T)
  (valorRegistrado ?T luminosidad ?H ?L1)

  (not (luminosidadActual ?H ?))  
  =>  
  (assert (luminosidadActual ?H ?L1))
)

; Si habitación no vacía y hay poca luz, encender
(defrule encender_poca_luz
  (Manejo_inteligente_luces ?H)  
  (NoHabitacionVacia ?H)

  ; Comprobar poca luz
  (luminosidadNormal ?H ?L)
  (luminosidadActual ?H ?Lux)
  (test (< ?Lux ?L))
  
  (not (luz_encendida ?H))
  
  =>
  (assert (accion pulsador_luz ?H encender))
  (assert (luz_encendida ?H))
)

; Si luz encendida y mucha luminosidad, apagar
(defrule apagar_mucha_luz
  (Manejo_inteligente_luces ?H)    
  (valor estadoluz ?H on)
  
  ; Comprobar si mucha luminosidad
  (luminosidadNormal ?H ?L)
  (luminosidadActual ?H ?Lux)
  (test (>= ?Lux (* 2 ?L)))

  ?Id <- (luz_encendida ?H)
  =>
  (assert (accion pulsador_luz ?H apagar))
  (retract ?Id)  
)


; Si estaba vacía y detecta movimiento
(defrule no_habitacion_vacia
  ?Id <- (HabitacionVacia ?H)
  (ultimoRegistro movimiento ?H ?T)
  (valorRegistrado ?T movimiento ?H on)
  =>
  (retract ?Id)
  (assert (NoHabitacionVacia ?H))  
)

; Se detecta movimiento -> Pasa a activa
(defrule no_habitacion_posiblemente_vacia
  ?Id <- (PosibleHabitacionVacia ?H)
  (ultimoRegistro movimiento ?H ?T)
  (valorRegistrado ?T movimiento ?H on)
  =>
  (retract ?Id)  
  (assert (NoHabitacionVacia ?H))
)

; Si no estaba vacía y no detecta movimiento, puede no estar vacía (comprobamos 10 segundos)
; Comprobar 10 segundos a partir de ?T: (Comprobar10s ?H ?T)
(defrule posible_habitacion_vacia
  ?Id <- (NoHabitacionVacia ?H)

  (ultimoRegistro movimiento ?H ?T)
  (valorRegistrado ?T movimiento ?H off)  
  =>
  (retract ?Id)
  (assert (PosibleHabitacionVacia ?H))
  (assert (ComprobarNomovimiento10s ?H ?T))
  (assert (ComprobarPasoReciente3s ?H ?T))  
)

; Si no detecta movimiento en 10s confirmamos vacía
(defrule habitacion_vacia_10s
  ?Id <- (PosibleHabitacionVacia ?H)
  ?Id2 <- (Nomovimiento10s ?H)  
  =>
  (retract ?Id)  
  (retract ?Id2)  
  (assert (HabitacionVacia ?H))  
)

; Si hubo un paso reciente desde una habitación posiblemente inactiva, confirmamos inactiva 
(defrule habitacion_vacia_3s
  ?Id <- (PosibleHabitacionVacia ?H)
  ?Id2 <- (PasoReciente3s ?H)  
  =>
  (retract ?Id)  
  (retract ?Id2)  
  (assert (HabitacionVacia ?H))
)

; Poner regla para quitar Nomovimiento10s y PasoReciente3s por si una de las dos confirma antes que la otra
(defrule eliminar_hechos_si_vacia1
  (HabitacionVacia ?H)
  ?Id <- (PasoReciente3s)
  =>
  (retract ?Id)  
)

(defrule eliminar_hechos_si_vacia2
  (HabitacionVacia ?H)
  ?Id <- (Nomovimiento10s ?H)
  =>
  (retract ?Id)  
)

; ----------

; Comprobar si hubo movimiento en 10 segundos
(defrule comprobar_10_s
  ?Id <- (ComprobarNomovimiento10s ?H ?T1)  
  (not (valorRegistrado ?T2 & : (>= ?T2 (+ ?T1 10)) movimiento ?H on))
  =>
  (retract ?Id)
  (assert (Nomovimiento10s ?H))
)

; Si se detecta movimiento en esos 10s quitamos el hecho (ya otra regla dirá que está activa)
(defrule comprobar_10_s_falla
  ?Id <- (ComprobarNomovimiento10s ?H ?T1)  
  (valorRegistrado ?T2 movimiento ?H on)
  (test (>= ?T2 (+ ?T1 10)))
  =>
  (retract ?Id)
)

; ----------

; Comprobamos si alguien ha pasado
(defrule comprobar_paso_reciente_3_s
  ?Id <- (ComprobarPasoReciente3s ?H ?T1)  
  ?Id2 <- (Transicion ?H ? ?T2 & : (<= ?T2 (+ ?T1 3)))
  =>
  (retract ?Id)
  (retract ?Id2)
  (assert (PasoReciente3s ?H))
)

; Si hemos asegurado que está vacía antes de terminar de comprobar el paso
(defrule quitar_comprobar_paso
  ?Id <- (ComprobarPasoReciente3s ?H ?T1)  
  (HabitacionVacia ?H)
  =>
  (retract ?Id)
)

; Cuando se dispara el sensor de una habitación y solo es accesible por otra que está activa
; Alguien ha ido de ?H1 a ?H2: (Transicion ?H1 ?H2) (Paso se utiliza para anexos sin puerta)
(defrule transicion
  (ComprobarPasoReciente3s ?H1 ?)
  (NoHabitacionVacia ?H2)
  (necesario_pasar ?H1 ?H2)  
  
  (hora_actual ?hora)
  (minutos_actual ?minuto)
  (segundos_actual ?segundo)
  =>
  (assert (Transicion ?H1 ?H2 (totalsegundos ?hora ?minuto ?segundo)))
)

; Se puede pasar a varias habitaciones pero solo una está activa
(defrule transicion2
  (ComprobarPasoReciente3s ?H1 ?)
  (NoHabitacionVacia ?H2)

  (posible_pasar ?H1 ?H2)
  (posible_pasar ?H1 ?H3)
  
  (not (NoHabitacionVacia ?H3 & : (neq ?H2 ?H3))) 

  (hora_actual ?hora)
  (minutos_actual ?minuto)
  (segundos_actual ?segundo)
  =>  
  (assert (Transicion ?H1 ?H2 (totalsegundos ?hora ?minuto ?segundo)))
)

; Si es accesible desde más de una habitación (y al menos dos están activas) puede haber transitado alguien
; Se activa para todas las posibles habitaciones que están activas
; Posible transición a H1 desde H2
(defrule posible_transicion
  (ComprobarPasoReciente3s ?H1 ?)
  (NoHabitacionVacia ?H1)
  (NoHabitacionVacia ?H2)
  (NoHabitacionVacia ?H3)

  (posible_pasar ?H1 ?H2)
  (posible_pasar ?H1 ?H3)  

  (hora_actual ?hora)
  (minutos_actual ?minuto)
  (segundos_actual ?segundo)
  =>
  (assert (PosibleTransicion ?H1 ?H2 (totalsegundos ?hora ?minuto ?segundo)))
)

; Cuando solo queda una PosibleTransición de una habitación, la cambiamos por Transicion
(defrule asegurar_transicion
  ?Id <- (PosibleTransicion ?H1 ?H2)
  (not (PosibleTransicion ?H1 ?H3 & : (eq ?H2 ?H3)))
  
  (hora_actual ?hora)
  (minutos_actual ?minuto)
  (segundos_actual ?segundo)
  =>
  (retract ?Id)
  (assert (Transicion ?H1 ?H2 (totalsegundos ?hora ?minuto ?segundo)))
)


; Descartamos cuando se pase de los 3 segundos, si no se da la anterior
(defrule paso_reciente_pasados_3_s  
  ?Id <- (PosibleTransicion ?H ? ?T1)

  (hora_actual ?hora)  
  (minutos_actual ?minuto)  
  (segundos_actual ?segundo)      
  
  (test (> (totalsegundos ?hora ?minuto ?segundo) (+ ?T1 3)))
  =>  
  (retract ?Id)  
)

; Facts -----------------------------------------------------------

; POR AHORA LO HACE EL SIMULADOR
; Habitacioness con luz inteligente: (ManejoInteligenteLuces ?Habitacion)
; ; Ver donde se utilizará
; (deffacts LucesInteligentes
;   (Manejo_inteligente_luces cocina)
; )

; luminosidad normal de cada habitación (luminosidad ?Habitacion ?Lux)
(deffacts luminosidadesNormales
  (luminosidadNormal salon 300)
  ; Pongo las de cada cuarto
  (luminosidadNormal cuarto1 250)
  (luminosidadNormal cuarto2 250)
  (luminosidadNormal cuarto3 250)
  (luminosidadNormal cocina 200)
  (luminosidadNormal banio 200)
  (luminosidadNormal pasillo 200)
  (luminosidadNormal entrada 200)
  (luminosidadNormal despacho 500)
)

; Situación inicial de la casa ?
(deffacts SituacionCasa
  (HabitacionVacia cocina)
  (HabitacionVacia pasillo)
)