# NPIPracticas

## __Parte móvil__

Dividir la app en 3 partes:
 - __Visita__: Se mostraría las zonas a visitar, aquellas con más gente actualmente, 
y se podrían seleccionar rutas para indicarle al usuario las zonas a visitar
 - __Juegos__: Diferentes actividades para entretener a los usuarios.
     - Búsqueda del tesoro
     - Cuestionarios
 - __Servicios__: Información de utilidad.
     - Aseos
     - Puestos de información.
     - Restaurantes (debería abrir Google Map)
     - Salidas de emergencia.

## Layout inicial

Se abre un mapa inicialmente solo con la posición de la persona y a lo Google Maps se
activen diferentes funcionalidades (mediante un desplegable):
  - Rutas: Abre otra mini-ventana, pudiendo seleccionar entre una lista 
    predeterminada de opciones.
  - Juegos
  - Aseos
  - Información
  - Emergencia
  - Restaurantes

``` Todos las opciones anteriores se seleccionarían mediante menús, pero con la idea de que se complemente mediante una interfaz de voz más adelante (también podemos intentar lo de las pupilas como recurso adicional) ```

## Interactividad
- Tiramos de GPS para las zonas abiertas y así tenemos la localización exacta.
Cada zona cerrada (habitaciones) contaría con unos sensores a la entrada que
complementan al GPS y ayudan a contabilizar el número de personas. 

  También serviría para saber si un baño está ocupado y el número de personas
  en cola.

  ```Estos sensores se colocarían dentro de unos palos```

- Para los juegos/WC tendríamos códigos QR o sensores NFC que activarían cierta
funcionalidad.

- Adicionalmente, necesitamos vibración para los juegos (notificaciones de cosas
que aparezcan en pantalla)

- Para la interfaz en el móvil, similar a la Google Maps (uno o dos dedos)

- Sensor de luz para las visitas nocturas, que active el modo nocturno en la app