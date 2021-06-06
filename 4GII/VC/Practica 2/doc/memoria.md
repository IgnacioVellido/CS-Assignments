Partiendo de las ideas del apartado anterior, se contruye el modelo ResNet
Se introduce pooling='avg' para introducir a la salida del modelo (cuando no incluye 
la última capa) un GlobalAveragePooling, y obtener la salida en una sola dimensión.

Que haya tantos elementos de train que de test parece un poco contraproducente

<!-- Extracción de características -->
(0y1) con SGD, parámetros por defecto, batch16
(2) SGD parámetros de las diapositivas, batch16
(3, 25) rmsprop por defecto

Parece que es problema del clasificador.
(4) rmsprop, b16

El error de training comienza demasiado alto.
(5) b16, drop0.8
(6) b16, drop0.8, lr=0.0005
(7,14) b16, drop0,5, lr=2e-5
(16) solo una dense final, con dropout, rmsprop -e, b16
(19) dos dense, con dropout 0.5, rmsprop 0.0005, b8
(20) dos dense, con dropout 0.5, rmsprop 0.0005, b16 -> 0,58
(21) dos dense, con dropout 0.8, rmsprop 0.0005, b16 -> 0,57
(22,23,24) dos dense, con dropout 0.8, rmsprop 0.0005, b32 -> 0.583, 0.59, 0.5

Parece que no se puede conseguir más, una vez que el training alcanza el 90% no
se mejora.

<!-- Fine tuning -->
(8) Vemos que rmsprop no funciona en este caso
(9) SGD por defecto, dos Dense de 500 a 200
(10) añadiendo dropout
(11) reentrenando solo 10 últimas capas
(12) aumentando tamaño de batch a 16
(13) añadiendo data augmentation
(15) sgd por defecto, data-augmentation, batch de 8, dos dense
(17) igual que anterior, reentrenando 19 últimas capas, sin dropout
(-) igual pero con rmsprop lr=0.0005, dropout 0.8, reentrena 40 -> tarda siglos

---------------------------------------------------------------------
---------------------------------------------------------------------

---------------------------------------------------------------------
---------------------------------------------------------------------


Nota: 
Se muestran los valores de test en cada gráfica, pero las mejoras no se valora en base
a ellos, ya que sino estaríamos filtrando información indirectamente en el
entrenamiento.

---------------------------------------------------------------------

<!-- Modelo basenet -->

La arquitectura del modelo se construye en base al guión de la práctica.
Puesto que estamos tratando con un problema de clasificación(regresión??) de múltiples clases,
se le añade una activación softmax a la última capa, de manera que el modelo
devuelva una probabilidad para cada clase.

Como optimizador se utiliza SGD, utilizando inicialmente los parámetros del 
documento de introducción a Keras.
(Más adelante se probará con otros optimizadores para comprobar la eficiencia ??)

Al contar con un número suficientemente grande de datos podemos usar un tamaño
de batch medianamente grande. En este caso se parte de 32.

Se procede a determinar el mejor número de épocas, y así poder tener una 
valor de accuracy del que partir a la hora de hacer mejoras.

Primero se lanza con un número grande 100, para poder estimar en base a la gráfica.
(1)
Vemos que el número ha sido exagerado, se ha producido demasiado overfitting.
La gráfica muestra que entre 10 y 20 cuando comienza a haber sobreajuste, se
vuelve a repetir para 20.
(2)
NOTA: HASTA ESTA PARTE EL VALOR DE ACCURACY MOSTRADO EN EL TÍTULO ERRÓNEAMENTE 
CORRESPONDE AL DE TRAINING Y NO AL DE TEST
Se sigue viendo que existe sobreajuste demasiado pronto (3 épocas). Parece que
la red aprende demasiado rápido. Se prueba con otro optimizador (rmsprop) y 25 ep
(4)
Ahora parece que con Rmsprop y 25 épocas se ha alcanzado un óptimo. Pese a ello,
se prueba añadiendo un mayor número de épocas 20.
(3)
Se lanzan varias iteraciones con ese valor para decidir la media de accuracy del
modelo 
(5y6)
Se toma por tanto el valor de accuracy a mejorar: 0,4306

La manera óptima de determinar el potencial real de un modelo sería una búsqueda
de hiperparámetros, pero ya que esa estrategia consume mucho tiempo se prueban
con diferentes modificaciones

<!-- Early stopping -->

Antes que nada, aplicar una técnica de early stopping se puede considerar como
una mejora sin (aparentes) puntos negativos, ya que solo estamos conservando la
red en su mejor momento del entrenamiento.

Para implementarlo, se utilizan los callbacks de Keras.
Es necesario por tanto implementar un callback para monitorizar la accuracy
(es mejor parámetro que la función de pérdida pues es la medida de evaluación
del modelo) y otro para guardar los pesos.

Se pone patience a 2, indicando que solo se permite que el modelo empeore dos
veces, si tras esa vez no se recupera se detendrá el entrenamiento.
Es posible que tras modificar la arquitectura sea necesario ampliar este
hiperparámetro para evitar que caiga en máximos locales. En este caso, viendo
las gráficas del apartado anterior parece conveniente dejarlo a este valor.
Además, viendo que fluctua con facilidad es posible que se empeore
(7y8)
Esto nos afirma que nuestro mejor número de épocas era de 17/18 y el nuevo valor
a superar es: 0,4336

<!-- Normalización -->

El tener diferentes rangos en los valores hace que las redes neuronales 
funcionen peor, ya que a la hora de realizar backpropagation se pesos hace que los gradientes alcancen valores dispares y no fluyan correctamente ¿??????rly????. Se considera buena idea por tanto normalizar los datos de entrada con media cero y desviación típica uno.

Esto se realiza separadando una parte de validación a partir del conjunto de entrenamiento y añadiendo los parámetros ...
Se utilizan dos ImageGenerator de cara a los siguientes apartados, pues el
conjunto de validación no debe contener data augmentation.
Todos se entrenan sobre el conjunto de test para que reciban el mismo tipo de 
preprocesado.
(9y10)

Se consigue una mejora entorno al 1%, con un número de épocas de ????
El nuevo valor a mejorar es: 0,4438

<!-- Data augmentation -->

Primeramente con volteos verticales y horizontales, pues no cambia la 
clase de los objetos
(12y13y14)
No se consigue mejora y por tanto se prueba solo con los horizontales
(15y16)
Se aprecia una importante mejoría, se prueba con zoom_range (pequeño pues no
tiene mucho sentido, 0.3)
(17y18)
No se nota mucha diferencia, se aumeta a 0.5
(19y20)
Se prueba una última vez con un valor muy pequeño 0.15
(21y22y23)

Se aprecia la mejora y se decide proseguir con este estado de la red, el nuevo
valor a superar es de: 0,478

<!-- Red más profunda -->

La red parece que ya es suficiente para aprender el conjunto de datos, pues
simplemente con el modelo BaseNet puro se podía alcanzar un 100% en training.
Por tanto un aumento de la red no es probable que nos de gran mejora, pero se
prueba. (y resnet qué ?? Es más profunda)
(hasta la 28)
Esta última parece que si hace que mejore la red
(29y30)
Tiene bastante variabilidad y parece que fue un golpe de suerte, quizá ajustando
los hiperparámetros podemos volver a lograr ese 50%.

Más experimentos:
(31y32y33)
Pero no se aprecia mejoría, se piensa entonces que tras tantas capas de convolución
sea la falta de normalización la que haga que la profundidad no mejora, la red.
Añadiendo BatchNormalization cada cada bloque convolucional:
(34y35y36)

Vemos que el modelo sí mejora, probamos la versión sin Batch:
(37y38)
Y como se mantiene la mejora nos quedamos con el nuevo modelo de red, y un val
de: 0,488

<!-- BatchNormalization -->

Por último, probamos a alterar la posición de las capas de normalización.
Añadiéndolas antes de las capas ReLU
(39y40y41) = (0,483)
Se aprecia una mayor inestabilidad en la accuracy de validación, es posible que
se esté perdiendo el efecto de la normalización tras aplicar la capa ReLU.
La diferencia en media llega a ser mínima, y por tanto vería más sensato optar
por dejarla tras la capa ReLU

<!-- Modelo final -->
Con todos los cambios hechos, juntamos el conjunto de validación con el de
training y hacemos un entrenamiento final.
Sin explorar los hiperparámetros óptimos, podemos estimar la calidad del modelo
con el conjunto de test.
(42)
(Viendo los anteriores resultados se usa un número de épocas de 18)

---------------------------------------------------------------------
---------------------------------------------------------------------

---------------------------------------------------------------------
---------------------------------------------------------------------

Se parte del modelo BaseNet, con un nº de épocas de 64 (elección arbitraria):
Se utiliza rmsprop como optimizador por (?) (estado del arte??) con learning
rate por defecto.

Se consiguen estor resultados para varias pruebas:
epo 30 -> 1 (Vemos que es un buen valor para el ep, ya que a partir de ahí comienza el overf)
batch 32 -> 2 (Comienza a hacer overf mucho antes)
batch 256, ep20 -> 3 (Se queda corto con 20)
batch 256, ep30 -> 4 (Se queda corto con 20)

Se realzizan algunas pruebas más y se decide proseguir con batch 32, y tomar las
mejoras en base a él (46%).
---------------------------------------------------------------------
Se comienza normalizando (dsv=1, m=0)

---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
Apartado 1 ---------------------------------------------------------------------

Se implementa BaseNet siguiendo el guión de prácticas.

La red queda de la siguiente manera
(img0)

Para comprobar que funciona, estos son los resultados devueltos para un batch de
32 y 100 épocas

(img1)
(img2)
(img3)

Vemos que se alcanza el óptimo en torno a la época número 15, a partir de ahí la
red comienza a sobreajustar y a adaptarse demasiado a los datos de entrada.

Tambien se aprecia que existe un gran margen de mejora, pues el porcentaje de 
acierto que se consigue es de un 40%

---------------------------------------------------------------------

Subiendo el tamaño de batch a 512 conseguimos mejores resultados.
El nº de épocas óptimo gira en torno a 80.
En este apartado no se ha buscado el mejor modelo posible, simplemente la 
construcción de BaseNet.

(img0,1,2)

---------------------------------------------------------------------

EL HECHO DE VALIDAR USANDO IMAGEDATAGENERATOR DA PEORES RESULTADOS (2%)

Apartado 2 ---------------------------------------------------------------------

Antes de añadir mejoras, se añade un bucle para que, en vez de evaluar con un solo lanzamiento de la red, utilizar la media de varias pruebas.

<!-- Antes de añadir mejoras, se añade una Grid Search para que, en vez de evaluar con un solo lanzamiento de la red, utilizar la media de varias pruebas con diferentes
hiperparámetros. -->

Una vez hecho esto, se considera comenzar normalizando los datos:

Normalización
------------------
El tener rangos dispersos entre los valores de los datos complica el 
entrenamiento (?).

Para solucionarlo, se utiliza la clase ImageGenerator...

Tras varios experimentos, se determina que el número de épocas necesario es de 16.
Se lanza la red 3 veces con ese número de épocas.

(img4-6)

Vemos que se mejora en un 7%, acosta de tener unas fluctuaciones altas en el error
de validación. Esto se debe a que al ser el conjunto de validación de tamaño
pequeño...

---------------------------------------------------------------------

Subiendo el tamaño de batch a 512 conseguimos mejores resultados.
En este caso el número de épocas óptimo ronda el 30, consiguiendo..

(img3)

De todas maneras, queda claro que esta mejora es importante para la red.
Los resultados son similares, no queda claro que merezca la pena.
Empeorar no la empeora y por tanto se deja, puede que tras hacer BatchNormalization
se mantega la normalización entre capas y de mejores resultados

---------------------------------------------------------------------

https://stats.stackexchange.com/questions/211436/why-normalize-images-by-subtracting-datasets-image-mean-instead-of-the-current

Subtracting the dataset mean serves to "center" the data. Additionally, you ideally would like to divide by the sttdev of that feature or pixel as well if you want to normalize each feature value to a z-score.

The reason we do both of those things is because in the process of training our network, we're going to be multiplying (weights) and adding to (biases) these initial inputs in order to cause activations that we then backpropogate with the gradients to train the model.

We'd like in this process for each feature to have a similar range so that our gradients don't go out of control (and that we only need one global learning rate multiplier).

Another way you can think about it is deep learning networks traditionally share many parameters - if you didn't scale your inputs in a way that resulted in similarly-ranged feature values (ie: over the whole dataset by subtracting mean) sharing wouldn't happen very easily because to one part of the image weight w is a lot and to another it's too small.

You will see in some CNN models that per-image whitening is used, which is more along the lines of your thinking.

---------------------------------------------------------------------

Siguiendo con BatchNormalization, obteniendo n.e. de 24, vemos que seguimos sin
obtener mejora.

(img5,6)

Quitando la normalización previa, n.e. de 25, tampoco mejora.
Pero si añadimos una capa Dense inicial y hacemos BatchNormalization antes de
cada resultado, vemos que sí se optiene una mejora (pero pequeña)

(img7,8)

Cambiando la salida de Dense a 16

---------------------------------------------------------------------

Partiendo de lo anterior, añadiendo data augmentation a un n.e. de 30

(img9,10)

Con regularización empeora bastante

Data Augmentation
------------------
Para hacer que nuestro modelo sea capaz de generalizar en mayor medida, y que no
se pegue demasiado a los datos, se procede a probar con técnicas de aumento de
datos, principalmente con varios rangos de zoom y giros.

El hecho de proporcionar datos redundantes al modelo fomenta a que discrimine
información irrelevante de las imágenes, buscando los datos concretos que definen
la clase concreta.

(Probar con colores ??)

En este caso se alcanza el óptimo en torno a la época número 20, volviendo a
experimentar

(img7-9)

Aquí el margen de mejora espequeño (3-4%), es posible que con una red más
profunda y aplicando regularización más adelante se pueda exprimir mejor estos
resultados.

Red más profunda
------------------

...

También se añade una capa Dropout al final para conseguir una mayor regularización

BatchNormalization
------------------
Puesto que se normaliza al principio, resulta apropiado volver a hacerlo tras cada
capa, pues al convolucionar los rangos pueden volver a ponerse dispares.

Ahora es necesario dejarlo hasta épocas de 34. Se experimenta 3 veces:
(img10-12)


Apartado 3 ---------------------------------------------------------------------