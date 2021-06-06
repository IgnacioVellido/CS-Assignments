; Ignacio Vellido Expósito

; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------

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

; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------

; Si hay una puerta entre las dos habitaciones y no hay otra puerta con cualquier
; otra habitación distinta de la habitación conectora

; (necesario_pasar habitación_aislada habitación_conectora)

(defrule necesario_pasar_puerta
  (Puerta ?HAislada ?HConectora)
  (Habitacion ?Otra)
  (test (neq ?Otra ?HConectora))
  (not (Puerta ?HAislada ?Otra))
  =>
  (assert (necesario_pasar ?HAislada ?HConectora))
)

; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------

; Una que no tiene ventanas

(defrule habitacion_interior
  (Habitacion ?H )
  (not (Ventana ? ?H))
  =>
  (assert (habitacion_interior ?H))
)

; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------

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

; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------

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

; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------

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

; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------

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

; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------

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

; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------

; Se activa cuando el sistema alcanza la hora de la siguiente franja
(defrule es_maniana
  (declare (salience 999))
  ?Id <- (FranjaHoraria ?Actual & : (neq ?Actual Maniana))    
  (franja-horaria Maniana ?hInicio ?mInicio ?sInicio ?hFin ?mFin ?sFin)

  (hora_actual ?h)
  (minutos_actual ?m)
  (segundos_actual ?s)

  (test (eq (totalsegundos ?h ?m ?s) (totalsegundos ?hInicio ?mInicio ?sInicio)))  
  =>  
  (retract ?Id)
  (assert (FranjaHoraria Maniana))
)


(defrule es_tarde
  (declare (salience 999))
  ?Id <- (FranjaHoraria ?Actual & : (neq ?Actual Tarde))    
  (franja-horaria Tarde ?hInicio ?mInicio ?sInicio ?hFin ?mFin ?sFin)

  (hora_actual ?h)
  (minutos_actual ?m)
  (segundos_actual ?s)

  (test (eq (totalsegundos ?h ?m ?s) (totalsegundos ?hInicio ?mInicio ?sInicio)))  
  =>  
  (retract ?Id)
  (assert (FranjaHoraria Tarde))
)


(defrule es_noche
  (declare (salience 999))
  ?Id <- (FranjaHoraria ?Actual & : (neq ?Actual Noche))    
  (franja-horaria Noche ?hInicio ?mInicio ?sInicio ?hFin ?mFin ?sFin)

  (hora_actual ?h)
  (minutos_actual ?m)
  (segundos_actual ?s)

  (test (eq (totalsegundos ?h ?m ?s) (totalsegundos ?hInicio ?mInicio ?sInicio)))  
  =>  
  (retract ?Id)
  (assert (FranjaHoraria Noche))
)

; --------------------------------------------------------------------------

; Control del día de la semana en el que estamos
(defrule cambiar_dia_semana
  (declare (salience 999))

  ; Comprobar que no hayamos hecho el cambio ya
  (not (DiaCambiado))  

  ?Id <- (DiaActual ?Actual)  
  ?Lista <- (DiasSemana ?Siguiente $?Resto)  

  ; Comprobamos la hora
  (hora_actual ?h)
  (minutos_actual ?m)
  (segundos_actual ?s)

  (test (eq 23 ?h))
  (test (eq 59 ?m))
  (test (eq 59 ?s))
  =>  
  (retract ?Id)
  (retract ?Lista)

  (assert (DiaActual ?Siguiente))
  (assert (DiaCambiado))
  (assert (DiasSemana $?Resto ?Siguiente))
)

(defrule dia_cambiado  
  ?Id <- (DiaCambiado)

  (hora_actual ?h)
  (minutos_actual ?m)
  (segundos_actual ?s)

  (test (eq 24 ?h))
  (test (eq 00 ?m))
  (test (eq 00 ?s))
  =>
  (retract ?Id)
)

; --------------------------------------------------------------------------

; Si está en el horario de asistencia se almacena en un hecho
(defrule asistencia
  (declare (salience 999))
  ?Id <- (Asistencia No)

  ; Comprobamos que no sea domingo
  (DiaActual ?dia)
  (test (neq ?dia Domingo))

  (hora_actual ?h)
  (minutos_actual ?m)
  (segundos_actual ?s)

  (test (>= (totalsegundos ?h ?m ?s) (totalsegundos 10 0 0)))  
  (test (<= (totalsegundos ?h ?m ?s) (totalsegundos 14 0 0)))  
  =>  
  (retract ?Id)
  (assert (Asistencia Si))
)

(defrule fin_asistencia
  (declare (salience 999))
  ?Id <- (Asistencia Si)

  (hora_actual ?h)
  (minutos_actual ?m)
  (segundos_actual ?s)

  (test (>= (totalsegundos ?h ?m ?s) (totalsegundos 14 0 1)))  
  =>  
  (retract ?Id)
  (assert (Asistencia No))
)

; --------------------------------------------------------------------------
; Cumpliendo los requisitos del sistema
; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; Salida a la calle --------------------------------------------------------

; Si se detecta que se abre la puerta de la calle comprueba si la persona sigue en casa
(defrule posible_salida_calle
  (ultimoRegistro magnetico calle ?T)
  (valorRegistrado ?T magnetico calle abierto) ; De ON a OFF    
  =>
  (assert (PosibleSalidaCalle))
  (assert (ComprobarNomovimiento10s entrada ?T))
  (assert (ComprobarPasoReciente3s entrada ?T))  
)

; Si se abre la puerta, la entrada se queda vacía y ninguna habitación contigua está ocupada
(defrule asegurar_salida_calle
  (HabitacionVacia entrada)

  ?Id <- (PosibleSalidaCalle)
  
  (not (NoHabitacionVacia ?H))
  (posible_pasar ?H entrada)
  =>
  (retract ?Id)
  (printout t crlf "AVISO - Ha salido a la calle" crlf) 
  (assert (AVISO SalidaCalle))
)

; --------------------------------------------------------------------------
; 3h sin movimiento --------------------------------------------------------

; Es de día y no se ha registrado movimiento en las últimas 3 horas
(defrule no_movimiento_maniana
  (declare (salience -30)) ; Para que no se active antes de comenzar la simulación
  (FranjaHoraria Maniana)

  ; Para que no avise continuamente
  (not (AVISO NoMovimiento3h))

  (hora_actual ?h)
  (minutos_actual ?m)
  (segundos_actual ?s)

  (not (valorRegistrado ?T2 & : (>= ?T2 (- (totalsegundos ?h ?m ?s) 10800)) movimiento ? on))
  =>
  (printout t crlf "AVISO: Tiempo prolongado sin movimiento" crlf) 
  (assert (AVISO NoMovimiento3h))
)

(defrule no_movimiento_tarde
  (declare (salience -30)) ; Para que no se active antes de comenzar la simulación
  (FranjaHoraria Tarde)

  ; Para que no avise continuamente
  (not (AVISO NoMovimiento3h))

  (hora_actual ?h)
  (minutos_actual ?m)
  (segundos_actual ?s)  

  (not (valorRegistrado ?T2 & : (>= ?T2 (- (totalsegundos ?h ?m ?s) 10800)) movimiento ? on))
  =>
  (printout t crlf "AVISO: Tiempo prolongado sin movimiento" crlf) 
  (assert (AVISO NoMovimiento3h))
)

; --------------------------------------------------------------------------
; Baño 20 min --------------------------------------------------------------

; Si detecta movimiento en el baño (fuera del horario de asistencia), 
; comprobamos si está en él durante más de 20 min
(defrule comprobar_banio_20min  
  (Asistencia No)

  (ultimoRegistro movimiento banio ?T)
  (valorRegistrado ?T movimiento banio on)

  =>
  (assert (ComprobarBanio20min ?T))
)

; Comprobar si en 20 min no detecta movimiento en otra habitación 
(defrule comprobar_20_min
  ?Id <- (ComprobarBanio20min ?T1)  
  (not (valorRegistrado ?T2 & : (>= ?T2 (+ ?T1 1200)) movimiento banio off))

  (hora_actual ?h)
  (minutos_actual ?m)
  (segundos_actual ?s)    
  (test (eq (totalsegundos ?h ?m ?s) (+ ?T1 1200)))

  ; Para que no avise continuamente
  (not (AVISO Banio20min))
  =>
  (retract ?Id)  
  (printout t crlf "AVISO: Tiempo prolongado en el banio" crlf) 
  (assert (AVISO Banio20min))
)

; Si sale del baño en esos 20min quitamos el hecho
(defrule comprobar_20_min_falla
  ?Id <- (ComprobarBanio20min ?T1)  
  (valorRegistrado ?T2 movimiento banio off)
  (test (<= ?T2 (+ ?T1 1200)))
  =>
  (retract ?Id)
)

; --------------------------------------------------------------------------
; 12 horas sin baño --------------------------------------------------------

; No se detecta movimiento en el baño en 12 horas
(defrule no_banio_dia
  (declare (salience -30)) ; Para que no se active antes de comenzar la simulación

  ; Para que no avise continuamente
  (not (AVISO NoBanio12h))

  (hora_actual ?h)
  (minutos_actual ?m)
  (segundos_actual ?s)

  (not (valorRegistrado ?T2 & : (>= ?T2 (- (totalsegundos ?h ?m ?s) 43200)) movimiento banio on))
  =>
  (printout t crlf "AVISO: Tiempo prolongado sin ir al banio" crlf) 
  (assert (AVISO NoBanio12h))
)

; --------------------------------------------------------------------------
; Baño continuo ------------------------------------------------------------

; Se detecta dos veces movimiento en el baño en menos de 3h
(defrule banio_continuado
  ; Para que no avise continuamente
  (not (AVISO MultipleBanio3h))

  (ultimoRegistro movimiento banio ?T)
  (valorRegistrado ?T movimiento banio on)

  ; Otro ON distinto anterior
  (valorRegistrado ?T2 movimiento banio on)
  (test (neq ?T ?T2))

  ; Un OFF en medio (como ?T es el último, solo se comprueba off)
  (valorRegistrado ?T3 & : (>= ?T3 ?T2) & : (<= ?T (+ ?T3 10800)) movimiento banio off)
  =>
  (printout t crlf "AVISO: Multiples visitas al banio" crlf) 
  (assert (AVISO MultipleBanio3h))
)

; --------------------------------------------------------------------------
; Asistencia no llega ------------------------------------------------------

(defrule no_asistencia
  ; Es día de asistencia, y son las 10:15
  (Asistencia Si)

  (hora_actual ?h)
  (minutos_actual ?m)
  (segundos_actual ?s)

  (test (eq 10 ?h))
  (test (eq 15 ?m))
  (test (eq 00 ?s))

  ; No se ha abierto la puerta
  (not (valorRegistrado ?T & : (< ?T (totalsegundos 10 15 0)) magnetico calle abierto))
  =>
  (printout t crlf "AVISO: No ha llegado la ayuda a domicilio" crlf) 
  (assert (AVISO NoAsistencia))
)

; --------------------------------------------------------------------------
; No duerme ----------------------------------------------------------------

; La última habitación ocupada al llegar la noche ha sido el cuarto
(defrule dormir
  (FranjaHoraria Noche)  

  ; El último ON haya sido en el cuarto
  (valorRegistrado ?T movimiento cuarto on)
  (not (valorRegistrado ?T2 & : (< ?T ?T2) movimiento cuarto on))  
  (not (valorRegistrado ?T3 & : (< ?T ?T3) movimiento ?H & : (neq ?H cuarto) on))  
  =>
  (assert (Durmiendo))
)

(defrule despierta
  (Durmiendo)
  (valorRegistrado ?T movimiento ?H on)
  (test (neq ?H cuarto))
  =>
  (assert (ComprobarDespierta ?T))
)

; Si a los 20 min sigue habiendo movimiento afirma despierta
(defrule afirmar_despierta
  (ComprobarDespierta ?T)
  ?Id <- (Durmiendo)

  (valorRegistrado ?T2 & : (> ?T2 (+ 900 ?T)) movimiento ?H on)
  (test (neq ?H cuarto))
  =>
  (retract ?Id)
)

(defrule no_duerme_antes_de_las_doce
  (declare (salience -30)) ; Para que no se active antes de comenzar la simulación
  (not (Durmiendo))

  ; Para que se avise continuamente
  (not (AVISO NoDuerme))

  ; Comprobar que ha pasado de la hora permitida
  (hora_actual ?h)
  (minutos_actual ?m)
  (segundos_actual ?s)

  (HoraMaximaDormir ?h2 ?m2 ?s2)

  (test (> (totalsegundos ?h ?m ?s) (totalsegundos ?h2 ?m2 ?s2)))
  =>
  (printout t crlf "AVISO: Persona sin acostarse" crlf) 
  (assert (AVISO NoDuerme))
)

(defrule no_duerme_despues_de_las_doce
  (declare (salience -30)) ; Para que no se active antes de comenzar la simulación
  (not (Durmiendo))

  ; Para que se avise continuamente
  (not (AVISO NoDuerme))

  ; Comprobar que ha pasado de la hora permitida
  (hora_actual ?h)
  (minutos_actual ?m)
  (segundos_actual ?s)

  (test (< (totalsegundos ?h ?m ?s) (totalsegundos 5 0 0)))
  =>
  (printout t crlf "AVISO: Persona sin acostarse" crlf) 
  (assert (AVISO NoDuerme))
)

; --------------------------------------------------------------------------
; Desplazamiento anormal ---------------------------------------------------

; Si se encuentra en una habitación no típica de la franja horaria
(defrule desplazamiento_anormal
  (NoHabitacionVacia ?H)
  (FranjaHoraria ?F)
  (not (HabitacionFrecuentada ?F ?H))
  =>
  (printout t crlf "AVISO: Desplazamiento anomalo" crlf) 
  (assert (AVISO DesplazamientoAnormal))
)

; --------------------------------------------------------------------------
; --------------------------------------------------------------------------
; Guardar aviso en la base de conocimiento ---------------------------------

; Guardamos el aviso con la hora que le corresponde
(defrule guardar_aviso 
  (AVISO ?X)
  (not (EliminarAviso ?X ?T))
  
  (hora_actual ?h)
  (minutos_actual ?m)
  (segundos_actual ?s)
  =>
  (assert (EliminarAviso ?X (totalsegundos ?h ?m ?s)))
  (assert (AVISO ?X (totalsegundos ?h ?m ?s)))
)

; Elimina el aviso del sistema pasados 10min, para que vuelva a avisar si es necesario
(defrule eliminar_aviso
  ?Id <- (EliminarAviso ?X ?T)
  ?Id2 <- (AVISO ?X)

  (hora_actual ?h)
  (minutos_actual ?m)
  (segundos_actual ?s)

  (test (eq (+ ?T 600) (totalsegundos ?h ?m ?s)))
  =>
  (retract ?Id)
  (retract ?Id2)
)


; -----------------------------------------------------------------
; -----------------------------------------------------------------
; -----------------------------------------------------------------
; Facts -----------------------------------------------------------

; -----------------------------------------------------------------
; Mapa de la casa -------------------------------------------------

; Habitación: (Habitacion ?Nombre)
(deffacts Habitaciones 
  (Habitacion entrada)
  (Habitacion cocina)
  (Habitacion salon)
  (Habitacion banio)
  (Habitacion pasillo)
  (Habitacion cuarto)
)

; Puerta: (Puerta ?Habitación1 ?Habitación2)
(deffacts Puertas
  (Puerta cocina entrada)
  (Puerta cocina pasillo)
  (Puerta salon pasillo)
  (Puerta cuarto pasillo)
  (Puerta banio pasillo)  
)

; Paso: (Paso ?Habitación1 ?Habitación2)
(deffacts Pasos
  (Paso entrada salon)
)

; Ventana: (Ventana ?Identificador ?Habitación)
(deffacts Ventanas
  (Ventana V1 cocina)
  (Ventana V1 salon)
  (Ventana V1 cuarto)
)

; ----------------------------------------------

; Situación inicial de la casa
(deffacts SituacionCasa
  (HabitacionVacia entrada)
  (HabitacionVacia cocina)
  (HabitacionVacia salon)
  (HabitacionVacia banio)
  (HabitacionVacia pasillo)
  (HabitacionVacia cuarto) 
)

; ------------------------------------------------------------

; Hora a partir de la cuál es de día, tarde y noche
(deffacts franjas_horarias
  (franja-horaria Maniana 8 0 1  17 0 0)
  (franja-horaria Tarde   17 0 1  21 0 0)
  (franja-horaria Noche   21 0 1  8 0 0)

  ; Hora máxima a la que se acuesta
  (HoraMaximaDormir 22 0 0)

  ; Poner la franja en la que se empieza
  (FranjaHoraria Maniana)
  
  ; Si la simulación comienza en horario de asistencia poner si
  (Asistencia Si)

  ; Poner día de la semana en el que comienza
  (DiaActual Lunes)
  (DiasSemana Martes Miercoles Jueves Viernes Sabado Domingo Lunes)

  ; Descomentar si queremos indicar que la persona duerme al 
  ; comienzo de la simulación
  ; (Durmiendo)
)

; Habitaciones que suele frecuentar por la casa
(deffacts habitaciones_frecuentadas
  (HabitacionFrecuentada Maniana cuarto)
  (HabitacionFrecuentada Maniana pasillo)
  (HabitacionFrecuentada Maniana cocina)
  (HabitacionFrecuentada Maniana entrada)
  (HabitacionFrecuentada Maniana salon)
  (HabitacionFrecuentada Maniana banio)

  (HabitacionFrecuentada Tarde cocina)
  (HabitacionFrecuentada Tarde cuarto)
  (HabitacionFrecuentada Tarde salon)
  (HabitacionFrecuentada Tarde pasillo)
  (HabitacionFrecuentada Tarde banio)

  (HabitacionFrecuentada Noche pasillo)
  (HabitacionFrecuentada Noche cuarto)
  (HabitacionFrecuentada Noche salon)
  (HabitacionFrecuentada Noche banio)
)