# Quien-es-Quien
Práctica de Estructuras de Datos, creación del juego "Quién es Quién"

## 1ª versión (sin mejora) 
- ~~Por el planteamiento del método "crearArbol" no hace falta hacer "nodosRedundantes".~~
- Utilizaremos el BinTree.
- "iniciarJuego" corresponde al juego en sí (al transcurso del juego).
- Hay que realizar una memoria.

### Métodos:
- crear_arbol :heavy_check_mark:
  - Al comienzo, lee un personaje y crea un árbol según sus atributos.
  - Se lee un personaje, se realizan preguntas y se inserta donde le corresponda
  - Se puede probar con un "preorder iterator": si tiene hijo donde nos interesa -> nos movemos; en caso de que no los tenga, se crea -- No creo que sirva.
  - Da igual el método que utilicemos, siempre va a haber nodos redundantes, por tanto habrá que crear el método.

- eliminar_nodos_redundantes :heavy_check_mark:

- limpiar
  - "clear" de cada atributo, es decir, de los vectores y del bintree.

- iniciar_juego :heavy_check_mark:
  - Mientras no sea una hoja
    - Leer el nodo (pregunta).
    - Preguntar (la información del nodo): 
      - Si -> nodo = hijoIzq
      - No -> nodo= hijoDrc
    
    - Si hemos llegado a la hoja -> encontrado = true
    - En otro caso leer otro nodo y repetir.
    
  - Añadida:
    - La opción de jugar otra vez, reiniciando al punto superior del árbol.

- profundidad_promedio

- informacion_jugada

- esHoja (auxiliar) :heavy_check_mark:

- Constructor por defecto
- Constructor de copia
- Operador de asignación
- Destructor

Adicionales:
- preguntas_formuladas (en proceso)
- aniade_personaje
- elimina_personaje
