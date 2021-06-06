;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; FUNCIONES UTILES PARA MANEJAR LA HORA EN CLIPS  ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;se ofrecen para facilitar el proceso de añadir timestamp a eventos ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;; DEPENDERA DEL SISTEMA OPERATIVO (elegir comentando o descomentando a continuacion ;;;;;;;

(defglobal ?*SO* = 1)              ;;; Windows (valor 1)    comentar si tu SO es linux o macos

;(defglobal ?*SO* = 0)             ;;; Linux o MacOs (valor 0)    descoemntar si tu SO es linux o macos


;; Funcion que transforma ?h:?m:?s  en segundos transcurridos desde las 0h en punto ;;;

(deffunction totalsegundos (?h ?m ?s)
   (bind ?rv (+ (* 3600 ?h) (* ?m 60) ?s))
   ?rv)
   
;;;;;; Funcion que devuelve la salida de ejecutar  ?arg en linea de comandos del sistema ;;;
	  
   (deffunction system-string (?arg)
   (bind ?arg (str-cat ?arg " > temp.txt"))
   (system ?arg)
   (open "temp.txt" temp "r")
   (bind ?rv (readline temp))
   (close temp)
   ?rv)
   
;;;;;; Funcion que devuelve el nº de horas de la hora del sistema, si en el sistema son las ?h:?m:?s, devuelve ?h  ;;;;;;;;;;;;
   
   (deffunction horasistema ()
   (if (= ?*SO* 1) 
      then
         (bind ?rv (integer (string-to-field (sub-string 1 2  (system-string "time /t")))))
	   else 
	     (bind ?rv (string-to-field  (system-string "date +%H"))) 
         )    	 	  
   ?rv)
   
;;;;;; Funcion que devuelve el nº de minutos de la hora del sistema, si en el sistema son las ?h:?m:?s, devuelve ?m  ;;;;;;;;;;;; 
 
   (deffunction minutossistema ()
   (if (= ?*SO* 1) 
       then
          (bind ?rv (integer (string-to-field (sub-string 4 5  (system-string "time /t")))))
	   else 
	     (bind ?rv (string-to-field  (system-string "date +%M")))	  )
   ?rv)
   
;;;;;; Funcion que devuelve el nº de segundos de la hora del sistema, si en el sistema son las ?h:?m:?s, devuelve ?s  ;;;;;;;;;;;;
   
   (deffunction segundossistema ()
   (if (= ?*SO* 1) 
       then
          (bind ?rv (integer (string-to-field (sub-string 7 8  (system-string "@ECHO.%time:~0,8%")))))
	   else 
	     (bind ?rv (string-to-field  (system-string "date +%S")))	  )
   ?rv)
   
;;;;;; Funcion que devuelve el valor de ?h  al pasar ?t segundos al formato ?h:?m:?s  ;;;;;;;;;;
   
    (deffunction hora-segundos (?t)
   (bind ?rv  (div ?t 3600))
   ?rv)
   
;;;;;; Funcion que devuelve el valor de ?m  al pasar ?t segundos al formato ?h:?m:?s  ;;;;;;;;;;   
   (deffunction minuto-segundos (?t)
   (bind ?rv (- ?t (* (hora-segundos ?t) 3600)))
   (bind ?rv (div ?rv 60))
   ?rv)

;;;;;; Funcion que devuelve el valor de ?s  al pasar ?t segundos al formato ?h:?m:?s  ;;;;;;;;;;     
   (deffunction segundo-segundos (?t)
   (bind ?rv (- ?t (* (hora-segundos ?t) 3600)))
   (bind ?rv (- ?rv (* (minuto-segundos ?t) 60)))
   ?rv)

 