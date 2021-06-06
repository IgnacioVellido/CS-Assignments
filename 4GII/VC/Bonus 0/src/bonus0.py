###############################################################################
# bonus0.py
# 
# Ignacio Vellido Expósito
# 
# 17/09/2019
###############################################################################

""" Imports """

from matplotlib import pyplot as plt
import cv2
import numpy as np

###############################################################################
# --------------------------------------------------------------------------- #
###############################################################################

""" Funciones """

def leeimagen(filename, pintar=False, flagColor=None):
    """ Lee la imagen a partir de la ruta y la muestra 
    
    flagColor:
        - 0: En escala de grises
        - En otro caso se muestra en color, al ser el modo por defecto
    """
    if flagColor == 0:        
        img = cv2.imread(filename, 0)
    else:
        img = cv2.imread(filename)

    # En Colab esta línea fallaba si se cargaba la imagen en blanco y negro, 
    # ya que que imread devuelve un solo canal. Por algún motivo, en Anaconda
    # funcionaba sin problemas.
    # Para solucionarlo, en Colab si se recibe el flag se carga cvtColor con flag
    # cv2.COLOR_BAYER_GR2RGB

    # Cambiando el orden de los canales
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    
    # Pintando la imagen
    if pintar:
        plt.figure()
        plt.imshow(img)
        plt.show()

    return img

# --------------------------------------------------------------------------- #

def pintaI(im):
    """ Visualiza matriz de nº reales (monobanda y tribanda) """

    im = im.astype('float64')

    # Si es tribanda
    if len(im.shape) == 3:
        # Se normaliza por cada banda
        for i in range(0,3):
            mini = np.min(im[i])
            maxi = np.max(im[i])

            # Para no dividir por 0
            if mini == maxi:
                im[i] = 0
            else:
                im[i] = ((im[i] - mini) / (mini - maxi)) / 255    

    # Si es monobanda
    else:    
        mini = np.min(im)
        maxi = np.max(im)

        if mini == maxi:
            im[i] = 0
        else:
            im = ((im - mini) / (mini - maxi)) / 255

    # Imprimiendo y devolviendo 
    print(im)
    return im


# --------------------------------------------------------------------------- #

# Para no repetir código, añado un parámetro opcional
def pintaMI(vim, titulos=None):
    """ Visualiza varias imágenes a la vez """
    
    if titulos == None:
        titulos = np.empty_like(vim, dtype="str")

    plt.figure(figsize=(12,8))
    plt.axis()

    for i in range(len(vim)):        
        plt.subplot(int(len(vim)/3)+1, 3, i+1)  # En columnas de 3
        plt.imshow(vim[i])
        plt.title(titulos[i])

        # Quitando los ejes
        plt.xticks([])
        plt.yticks([])

    plt.show()


# --------------------------------------------------------------------------- #

# Modifica la matriz de píxeles a los que recibe en el vector de colores
def cambiaColor(img, coordenadas, colores):
    """ Modifica el color de la imagen en base a la lista de coordenadas """

    for (coord, color) in zip(coordenadas, colores):        
        x = coord[0]
        y = coord[1]

        # (fila, columna) != (x,y)
        img[y,x] = color
    
    plt.figure()
    plt.imshow(img)
    plt.show()

# --------------------------------------------------------------------------- #

def pintaIMismaVentana(imgs, titulos):
    """ Representa una lista de imágenes en una misma ventana junto a sus 
    títulos """

    pintaMI(imgs, titulos)    

###############################################################################
# --------------------------------------------------------------------------- #
###############################################################################

""" Main """

# ------------------------------------------------------- # 
# Ej1: Cargando las imágenes
print("\nEjercicio 1 -------------------------------------")

img_dave = leeimagen('./images/dave.jpg')
img_cv = leeimagen('./images/logoOpenCV.jpg', True, 0)
img_messi = leeimagen('./images/messi.jpg')
img_orapple = leeimagen('./images/orapple.jpg')

list_img = [img_dave, img_cv, img_messi, img_orapple]

input(" -- Pulse cualquier tecla para continuar -- ")

# ------------------------------------------------------- #
# Ej2: Visualizando matrices de reales
print("\nEjercicio 2 -------------------------------------")

# Por cómo funciona la función cvtColor, ninguna matriz en blanco y negro es 
# monobanda, por lo que vuelvo a cargar la imagen desde cero
img_mono = cv2.imread('./images/orapple.jpg', 0)

print("Matriz monobanda:")
pintaI(img_mono)

print("\nMatriz tribanda:")
pintaI(img_orapple)

input(" -- Pulse cualquier tecla para continuar -- ")

# ------------------------------------------------------- #
# Ej3: Mostrando varias imágenes

# Con el funcionamiento de leeImagen() muestra sin problemas imágenes de 
# distinto tipo

print("\nEjercicio 3 -------------------------------------")

pintaMI(list_img)

input(" -- Pulse cualquier tecla para continuar -- ")

# ------------------------------------------------------- #
# Ej4: Modificando los colores
print("\nEjercicio 4 -------------------------------------")

c = []
r = []
for i in range(0, 100):
    r.append([i, i+200])
    c.append([139, 0, 0])

cambiaColor(img_dave, r, c)

input(" -- Pulse cualquier tecla para continuar -- ")

# ------------------------------------------------------- #
# Ej5: Mostrando varias imágenes y sus títulos
print("\nEjercicio 5 -------------------------------------")

titulos = ['Dave', 'OpenCV', 'Messi', 'Orapple']
pintaIMismaVentana(list_img, titulos)

input(" -- Pulse cualquier tecla para continuar -- ")