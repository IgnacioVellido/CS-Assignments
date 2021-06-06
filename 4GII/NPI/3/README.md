# UGR-NPI-3
## Creación
- Files, logs, reports
  - New Directory inside www

- Application Manager
  - Add application
    - Voice phone calls
    - Europe
    - VoiceXML
    - Nuance    
___
### Para poner en la memoria
Sistema para la gestión de venta de entradas del museo, capaz de informar sobre las distintas tarifas y realizar la compra de una de ellas.

Características:
- Multilingüe (inglés/castellano...portugués,francés ?)
- Con funcionalidad DTMF en selección de idioma
- Pedir ayuda en cualquier momento
- Información sobre los tickets/rutas (precio, detalles)
- Realización de compra de cualquiera de los tickets
___
### To do
- Duplicar formularios y gramáticas para varios idiomas (mínimo español)
___
### Preguntas
- Repetir en gramática (ejemplo de dígitos) ? No se puede
- Se puede contar ? O se fuerza en la gramática a que haya un nº específico? Se fuerza
- Cómo hacerlo multilingüe ? Repitiendo código
___
### Notas
- Para el número de cuenta permitir que se introduzca con teclas (usar dtmf pag 40)
- Para pedir ayuda ver pag 41
- No poner paréntesis en la gramática
- Para dtmf, el next ?
- LOS LINKS SOLO FUNCIONAN SI ESTÁ DENTRO DE UN FIELD
- GRAMMARS INLINE TAMPOCO TIRAN
- NO FUNCIONA LO DE LAS DIAPOSITIVAS :joy: :joy: :joy: :joy:
- Filled tiene que ser hijo de field para ejecutarse cuando se rellena ese campo,
si es hijo de form se tiene que rellenar el formulario entero (es mode=all por defecto)
- Podemos hacer de interacción mixta al cancelar la compra, dejando que elija qué
comprar.
___
- Que funcione, que no de errores -> Importante
- Que el usuario pueda solicitar ayuda en cualquier momento -> Importante
- Que el sistema puede decir frases completas (bien estructuradas, interacción mixta) -> más nota
- Hacer SMS HTTP Post Interface -> más nota
____

### SIP CODE
Alberto SIP: 9990520855@sip.lhr.aspect-cloud.net
Nacho SIP: 9990520671@sip.lhr.aspect-cloud.net
