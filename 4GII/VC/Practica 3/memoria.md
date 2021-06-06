Según los samples a veces da mejores homografías
Epsilon 3 por ser el valor por defecto de findHomography
El último autovalor es una matriz 3x3, que cogemos como homografía
_____________________________________________________________________________
3.
Los matches se devuelven en cualquier orden, por lo que hay que 
a findHomography hay que pasarle los queryIdx ordenados por matches y luego los 
trainIdx

Explicar que queryIdx es el índice en del keypoint en la primera imagen y 
trainIdx en la segunda
_____________________________________________________________________________
2.
Usar AKAZE para sacar los descriptores (KeyPoints) de dos imágenes
Criterios para hacer matching
    - Fuerza bruta + Xcheck, de cada uno coger el más cercano de img1 a img2. 
    Luego con los de img2 a img1, y dejar cuando ambos coinciden
    - Para cada punto de img1 los dos más cercanos. Para no coger matches ambiguos
    se elige el más cercano si la distancia entre los dos de la img2 están
    a una cierta distancia (radio variable, argumentando vale cualquiera). Si están demasiado cerca no coge ninguno.
    RATIO 0.7 por ser el recomendado en el paper de Lowe -- EXPLICAR POR QUÉ

Coger 100 ALEATORIAMENTE y con drawMatches() mostrarlos (hay que pasarle como param una 
imágen los suficiente grande para que pueda pintar las dos img con las líneas)

Explicar cómo funcionan y cuál de los dos criterios funciona mejor.

Todos los parámetros que se le pasan a las funciones tienen que estar argumentados

ES LA MISMA IMAGEN GIRADA UN POCO HACIA LA DERECHA
PROBAR CON OTRA IMAGEN
_____________________________________________________________________________

1.
a) Pirámide Gaussiana a distintos niveles, el número de niveles depende de la 
imagen. -> cv.pyrDown()
pyrDown() ya hace el suavizado

Calcular los puntos Harris en cada nivel de la pirámide, con la función
cv.cornerEigenValsAndVecs(imagen, blocksize, ksize) 
Devuelve -> lambda1, lambda2,x1,y1,x2,y2 (lambda, autovalores y autovectores)
(Usa los valores singulares para ver si hay gradientes en los dos ejes, usa
las derivadas de la imagen)

7x7 es grande, poner valor pequeño pues es común a todos los niveles de la
pirámide

El valor de Harris es: fp = det(M)/traza(M) = lambda1*lambda2/lambda1+lambda2

La función y el valor anterior se calcula para cada pixel de la imagen,
lambdas pueden ser 0, poner 0 al valor de Harris

Convolución con gaussiana con derivada (con la función de la práctica1)

Meter umbral fp > threshold, si es menor poner 0.
Empezar sin umbral, subir en función de los puntos que detecta
Supresión de no máximos a los fp que hayan aguantado (usar función de practica1),
hacer el vecindario variable
(De cara a la memoria, ver como varia en los resultados el vecindario, el threshold)

El fp con no-maximos se calcula para todos los niveles de la imagen, hay que
guardar los distintos de 0 como KeyPoints(x,y,escala,orientación) (clase de OpenCV)
Las fp de niveles inferiores de la pirámide son relativos al nivel, hay que 
guardar en KeyPoints las coordenadas relativas a la imagen original, por lo que
hay que transformarlo (multiplicar por 2 cada eje por cada nivel)

Poner fórmula M de: https://docs.opencv.org/4.1.0/dd/d1a/group__imgproc__feature.html#ga4055896d9ef77dd3cacf2c5f60e13f1c

escala = blocksize(el de cornerEigen) * nivel de la pirámide

sacar derivada en x, y en y de la imagen,
aplicar sigma de 4.5
bajar por la pirámide

ángulo de orientacion = sigma tal que (cos,sen) = u/det(u) = (u1,u2) (primero cos, segundo sen)
    Sacar gradiente de la imagen = derivada img respecto de x, dI/dy (Gaussiana ?)
    Pasar alisamiento con sigma de 4.5 (guassiana)
    A cada una de las imagenes derivadas saco sus piramide gaussiana, hay que 
        conseguir el gradiente en el nivel que le corresponde
    Teniendo cos y seno para sacar el ángulo: arctng(sen/cos) = sigma
        La función arctng debe devolver en los cuatro cuadrantes (no solo en los
        positivos), si no cambiar según el signo del sen y del cos

        Se ve al mostrar los keypoints (primer cuadrante sen+ y cos+), si solo da
        en los primeros hay que sumarle pi

el u1 y el u2 es de x e y y dependiente de cada píxel
u1 y u2 es de la derivada, el valor del gradiente en el pixel en el que esté

Supresión de no-máximos en cada escala, independientes

Hacerlo en funciones
Explicar qué se hace en la memoria en todo momento

a) Lista de Keypoints

b) Decir porque el conjunto de puntos es representativo en cada escala.
Mostrarlos usando: cv.drawKeyPoints()

Sacar en la img original (no en cada escala) una con los puntos de la primer
nivel de la pirámide, otra con lo de la segunda... y una con todos a la vez

d) Refinar los (x,y) de los KeyPoints (puede no coger la esquina exactamente)
usar cv.cornerSubPix() -> coordenadas de las esquinas
Experimentar con parámetros y contar lo que hace

Coger 3 puntos donde no coincidan y pintar un cuadrado de 10x10, hacer zoom de 5
y mostrar separadamente, con el punto nuevo y el previamente calculado
(usar cv.circle con colores distintos, decir en la memoria cuál es cuál)