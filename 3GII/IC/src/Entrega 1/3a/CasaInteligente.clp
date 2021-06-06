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

; Para que se activen las reglas, es imprescindible que esté definido el hecho
; (Manejo_inteligente_luces ?Habitacion)
; Se envía la modificación a (accion pulsador_luz ?Habitacion ?accion)

; Si el último registro de movimiento es on, no apagar,
; puesto que dentro de 60 segundos dirá off y se activará la regla

; Si se detecta movimiento y es interior, encender
(defrule encender_luz_interior
  (Manejo_inteligente_luces ?H)  
  (habitacion_interior ?H)

  (ultimoRegistro movimiento ?H ?T)
  (valorRegistrado ?T movimiento ?H on) 

  (not (luz_encendida ?H))  
  =>
  (assert (accion pulsador_luz ?H encender))
  (assert (luz_encendida ?H))  
)

; Si se detecta movimiento y no es interior, pero es de noche (suponemos entre las 21 a 8)
;   => encender
(defrule encender_luz
  (Manejo_inteligente_luces ?H)  
  (not (habitacion_interior ?H))

  (ultimoRegistro movimiento ?H ?T)
  (valorRegistrado ?T movimiento ?H on) 

  (not (luz_encendida ?H))

  ; Falta pasar ese T a hora y que sea dentro dentro del rango
  (hora_actual ?hora)  
  (test (or (>= ?hora 21) (<= ?hora 8)))
  =>
  (assert (accion pulsador_luz ?H encender))
  (assert (luz_encendida ?H))  
)

; Si no detecta, pero si hubo movimiento en alguna contigua (antes de que ya no detectara movimiento), apagar
(defrule apagar_luz
  (Manejo_inteligente_luces ?H)
  (ultimoRegistro movimiento ?H ?T)
  (valorRegistrado ?T movimiento ?H off)

  (posible_pasar ?H ?H2)
  (ultimoRegistro movimiento ?H2 ?T2)  
  (valorRegistrado ?T2 movimiento ?H2 on)

  ?Id <- (luz_encendida ?H)
  =>
  (assert (accion pulsador_luz ?H apagar))
  (retract ?Id)  
)

; 3b -------------------------------------------------------------------------------------
; 3b -------------------------------------------------------------------------------------
; 3b -------------------------------------------------------------------------------------
; 3b -------------------------------------------------------------------------------------

; En el otro archivo

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