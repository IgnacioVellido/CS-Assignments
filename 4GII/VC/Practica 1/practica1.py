###############################################################################
# practica1.py
# 
# Ignacio Vellido Expósito
###############################################################################

""" Imports """

from matplotlib import pyplot as plt
import cv2
import numpy as np
from sklearn.model_selection import ParameterGrid

###############################################################################
# --------------------------------------------------------------------------- #
###############################################################################

""" Funciones """

# --------------------------------------------------------------------------- #
# De la práctica 0
# --------------------------------------------------------------------------- #

def normaliza01(im):
    im = np.array(im)
    if len(im.shape) == 3:
        # Se normaliza por cada banda
        for i in range(0,3):
            mini = np.min(im[:,:,i])
            maxi = np.max(im[:,:,i])

            # Para no dividir por 0
            if mini == maxi:
                im[:,:,i] = 0
            else:
                im[:,:,i] = ((im[:,:,i] - mini) / (maxi - mini))

    # Si es monobanda
    else:    
        mini = np.min(im)
        maxi = np.max(im)

        if mini == maxi:
            im = np.zeros_like(img)
        else:
            im = ((im - mini) / (maxi - mini))

    return im

# --------------------------------------------------------------------------- #

def normalizaI(im):
    im = np.array(im)
    if len(im.shape) == 3:
        # Se normaliza por cada banda
        for i in range(0,3):
            mini = np.min(im[:,:,i])
            maxi = np.max(im[:,:,i])

            # Para no dividir por 0
            if mini == maxi:
                im[:,:,i] = 0
            else:
                im[:,:,i] = ((im[:,:,i] - mini) / (maxi - mini)) * 255    

    # Si es monobanda
    else:    
        mini = np.min(im)
        maxi = np.max(im)

        if mini == maxi:
            im = np.zeros_like(im)
        else:
            im = ((im - mini) / (maxi - mini)) * 255

    return im

# --------------------------------------------------------------------------- #

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

    # Cambiando el orden de los canales
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    
    # Pintando la imagen
    if pintar:
        plt.figure()
        plt.imshow(img)
        plt.show()

    return img.astype('float64')

# --------------------------------------------------------------------------- #

def pintaMI(vim, titulos=None, suptitle=None):
    """ Visualiza varias imágenes a la vez """
    n_images = len(vim)
    cols = 7 if len(vim) >= 7 else len(vim)

    if titulos is None:
        titulos = ['' for i in range(1, n_images+1)]

    if suptitle is None:
          suptitle = ''

    fig = plt.figure()

    for n, (image, title) in enumerate(zip(vim, titulos)):
        a = fig.add_subplot(np.ceil(n_images/float(cols)), cols, n+1)
        
        # Se debe normalizar la imagen antes de convertirla a uint8
        image = normalizaI(image)
        image = image.astype('uint8')        
        plt.imshow(image)        

        a.set_title(title)        
        a.axis('off')    

    fig.suptitle(suptitle)
    fig.set_size_inches(np.array(fig.get_size_inches()) * n_images)
    fig.subplots_adjust(bottom=0)

    plt.show()

# --------------------------------------------------------------------------- #
# 
# --------------------------------------------------------------------------- #

def pintaPiramide(img, vim, title=""):
    filas, colums, canales = img.shape

    # Se crea una imagen el doble de grande con ceros
    piramide = np.zeros((filas, colums + int(colums/2)+1, canales), dtype=img.dtype)

    # Se pinta la imagen normal sobre ella
    piramide[:filas, :colums, :] = img

    siguiente_fila = 0
    # Se pintan el resto de imágenes a la derecha de la normal
    for im in vim:
        im_fila, im_colum = im.shape[:2]
        
        # Copiamos la siguiente imagen
        piramide[siguiente_fila:siguiente_fila + im_fila, 
                 colums:colums + im_colum] = im
        siguiente_fila += im_fila

    plt.figure(figsize=(10,7))
    piramide = normalizaI(piramide)
    plt.imshow(piramide.astype('uint8'))

    plt.suptitle(title)
    plt.axis("off")

    plt.show()

# --------------------------------------------------------------------------- #

def pinta3I(img1, img2, img3, titulos=None, title=""):
    """ Ejercicio 3a """
    titulos = ["Baja", "Alta", "Híbrida"]
    pintaMI([img1,img2,img3], titulos, title)

# --------------------------------------------------------------------------- #
# De la práctica 1
# --------------------------------------------------------------------------- #

def convolucion(img, kx, ky, border):
    # Voltea las máscaras
    kx = np.flip(kx)
    ky = np.flip(ky)

    x = cv2.filter2D(img, ddepth=cv2.CV_64F, kernel=kx, borderType=border)   
    return cv2.filter2D(x, ddepth=cv2.CV_64F, kernel=ky, borderType=border) 

# --------------------------------------------------------------------------- #

def convGaussiana(img, ksize, sigmaX, sigmaY, border):
    retval = cv2.getGaussianKernel(sigma=sigmaX, ksize=ksize)  

    # No hace falta flip realmente, la máscara es simétrica
    return convolucion(img, retval.transpose(), retval, border)

# --------------------------------------------------------------------------- #

def convLaplacian(img, ksize, sigmaX, sigmaY, border):
    dst = convGaussiana(img, ksize, sigmaX, sigmaY, border)

    kx1, ky1 = cv2.getDerivKernels(dx=2, dy=0, ksize=ksize, 
                                normalize=True, ktype=cv2.CV_64F)  
    kx2, ky2 = cv2.getDerivKernels(dx=0, dy=2, ksize=ksize, 
                                normalize=True, ktype=cv2.CV_64F)  

    # Son dos vectores de col
    kx = np.transpose(kx1)
    ky = ky2
    
    return convolucion(img, kx, ky, border)

# --------------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #

def piramideGaussiana(img, border):
    """ Ejercicio 2.a """
    ksize = 19
    sigmaX = 3
    sigmaY = 3

    img_list = []
    level = img

    for _ in range(0, 4):
        # Aplicamos filtro
        level = convGaussiana(level, ksize, sigmaX, sigmaY, border)

        # Reducimos el tamaño
        level = downscale(level)

        img_list.append(level)

    return img_list

# --------------------------------------------------------------------------- #

def piramideLaplaciana(img, border):
    """ Ejercicio 2.b """
    ksize = 19  # 6*sigma+1
    sigmaX = 3
    sigmaY = 3

    img_list = []
    img_normal = img

    for _ in range(0, 3):
        # Aplicamos filtro gaussiano
        img_gauss = convGaussiana(img_normal, ksize, sigmaX, sigmaY, border)

        # Restamos a la imagen normal
        level = img_normal - img_gauss
        img_normal = img_gauss

        # Reducimos el tamaño
        img_normal = downscale(img_normal)
        level = downscale(level)

        img_list.append(level)

    # Añadimos último nivel (hay que bajarle el tamaño)
    level = img_gauss    
    level = downscale(downscale(level))
    img_list.append(level)    

    return img_list

# --------------------------------------------------------------------------- #

def espacioLaplaciano(img, sigma, n):
    # Matrices resultado
    res = np.zeros_like(img)
    regions = np.zeros_like(res)
    espacio = []

    for _ in range(0, n):        
        ksize = int(3*sigma)*2 + 1

        # Filtrado de Laplaciana
        actual_level = convLaplacian(img, ksize, sigma, sigma, cv2.BORDER_DEFAULT)

        actual_level *= sigma**2

        # Eliminando los negativos
        actual_level *= actual_level

        # Búsqueda de no máximos absolutos        
        actual_level = no_maximos(actual_level)

        # Pintando las regiones encontradas
        row, col, dim = actual_level.shape
        
        # Pasarlo al final, después de tener la lista de escalas con sus regiones
        x = normalizaI(actual_level)   
        for i in range(0, row):
            for j in range(0, col):
                if x[i,j,0] > 180:   # Se indica un umbral
                    regions = cv2.circle(regions, (j,i), int((sigma**2)*10), 
                                         (0,100,255))
                    
        # Guardando las respuestas
        actual_level += regions
        espacio.append(actual_level)

        # Incrementando sigma
        sigma *= 1.2        

    return espacio, regions

# --------------------------------------------------------------------------- #

def downscale(matrix):
    return matrix[::2,::2,:]

# --------------------------------------------------------------------------- #

def no_maximos(img):
    res = np.zeros_like(img)

    mask_size = 3
    mask = np.empty((mask_size,mask_size), dtype=img.dtype)

    # Creamos un border (Replicate, pues no altera el valor del máximo)
    img_border = cv2.copyMakeBorder(img, mask_size-2, mask_size-2, 
                                    mask_size-2, mask_size-2, cv2.BORDER_REFLECT)

    row, col, dim = img.shape

    for i in range(0, row):
        for j in range(0, col):
            mask = img_border[i:i+mask_size, j:j+mask_size, 0]

            # Comprobando si máximo global            
            is_global_max = True
            for v in range(0, mask_size):
                for w in range(0, mask_size):
                    if v != 1 or w != 1:
                        is_global_max = False if mask[v,w] >= mask[1,1] else is_global_max                    

            if is_global_max:
                res[i, j, :] = img_border[i+1, j+1, :]

    return res

# --------------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #

def mezclaImagenes(img1, sigma1, img2, sigma2, ksize):
    """ Ejercicio 3 - Devuelve la imagen de baja frecuencia de la primera, la
    alta de la segunda y la mezcla
    """
    imgs = []
    border = cv2.BORDER_DEFAULT    

    # Cogemos las frecuencias bajas de la primera
    baja = convGaussiana(img1, ksize, sigma1, sigma1, border)
    imgs.append(baja)

    # Y las altas de la segunda
    alta = convGaussiana(img2, ksize, sigma2, sigma2, border)
    alta = img2 - alta
    imgs.append(alta)

    # Las juntamos
    mezcla = alta + baja
    imgs.append(mezcla)

    return imgs

# --------------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #

def convSeparable(img, kx, ky):
    """ Bonus 1 """
    # Es convolución, volteamos las máscaras
    kx = np.flip(kx)
    ky = np.flip(ky)

    # Normalizamos las máscaras
    sum = np.sum(kx) + np.sum(ky)
    kx /= sum
    ky /= sum

    mask_size = len(kx)
    size = int(len(kx)/2)

    # Creamos imagen destino
    dst = np.empty_like(img)

    # Creamos otra imagen ampliando con 0s el tamaño de la máscara
    row, col, dim = img.shape
    img_mask = np.zeros((row+mask_size-1, col+mask_size-1, dim))    
    img_mask[size:row+size, size:col+size, :] = img

    # Por cada canal    
    for d in range(dim):
        # Pasamos las máscaras
        for x in range(row):
            for y in range(col):
                # Copiamos la imagen
                mask = img_mask[x:x+mask_size, y:y+mask_size, d]

                # Aplicamos la máscara por cada fila/columna de esta
                for w in range(mask_size):                    
                    dst[x,y,d] += np.matmul(mask[w], kx)
                    dst[x,y,d] += np.matmul(mask[:,w], ky)              
                    
    return dst

###############################################################################
# --------------------------------------------------------------------------- #
###############################################################################

""" Main """

# ------------------------------------------------------- # 
# Cargando las imágenes

img1 = leeimagen('./imagenes/motorcycle.bmp', False, 0)
img2 = leeimagen('./imagenes/bicycle.bmp', False, 0)
img3 = leeimagen('./imagenes/marilyn.bmp', False, 0)
img4 = leeimagen('./imagenes/einstein.bmp', False, 0)
img5 = leeimagen('./imagenes/dog.bmp', False, 0)
img6 = leeimagen('./imagenes/cat.bmp', False, 0)

img = img2.copy()

# ------------------------------------------------------- # 
print("\nEjercicio 1a -------------------------------------")

param_grid = {  'ksize':    [7, 25, 31],
                'sigmaXY':   [5, 10, 50],
                'border':   [cv2.BORDER_CONSTANT, cv2.BORDER_ISOLATED, 
                            cv2.BORDER_REFLECT]
            }
grid = ParameterGrid(param_grid)

img_gaussian = []
titulos = []

# Añadiendo la imagen normal
img_gaussian.append(img)
titulos.append("Normal")

# Grid Search
for params in grid:
    ksize=str(params['ksize'])
    sigma=str(params['sigmaXY'])
    border=str(params['border'])
    titulos.append(ksize + ' - ' + sigma + ' - ' + border)
    img_gaussian.append(convGaussiana(img, params['ksize'], params['sigmaXY'],
                                        params['sigmaXY'], params['border']))                                        

pintaMI(img_gaussian, titulos, 'Convolución Gaussiana\nksize - sigma - border')

input(" -- Pulse cualquier tecla para continuar -- ")

# ------------------------------------------------------- #
print("\nEjercicio 1b -------------------------------------")

param_grid = {  'ksize':    [5, 15, 25],
                'sigma':    [1,3],
                'border':   [cv2.BORDER_CONSTANT, cv2.BORDER_ISOLATED, 
                             cv2.BORDER_REFLECT]
            }
grid = ParameterGrid(param_grid)

img_laplacian = []
titulos = []

# Añadiendo la imagen normal
img_laplacian.append(img)
titulos.append("Normal")

# Grid Search
for params in grid:
    ksize=str(params['ksize'])
    sigma=str(params['sigma'])
    border=str(params['border'])
    titulos.append(ksize + ' - ' + sigma + ' - ' + border)
    img_laplacian.append(convLaplacian(img, params['ksize'], params['sigma'], 
                                        params['sigma'], params['border']))

pintaMI(img_laplacian, titulos, 'Convolución Laplaciana\nksize - sigma - border')

input(" -- Pulse cualquier tecla para continuar -- ")

# ------------------------------------------------------- # 
# ------------------------------------------------------- #
print("\nEjercicio 2a -------------------------------------")

border = cv2.BORDER_DEFAULT
img_pirGau = []

# Añadiendo la imagen normal
img_pirGau.append(img)
img_pirGau = piramideGaussiana(img, border)

pintaPiramide(img, img_pirGau, "Pirámide Gaussiana")

input(" -- Pulse cualquier tecla para continuar -- ")

# ------------------------------------------------------- #
print("\nEjercicio 2b -------------------------------------")

border = cv2.BORDER_DEFAULT
img_pirLap = []

# Añadiendo la imagen normal
img_pirLap.append(img)
img_pirLap = piramideLaplaciana(img, border)

pintaPiramide(img, img_pirLap, "Pirámide Laplaciana")

input(" -- Pulse cualquier tecla para continuar -- ")

# ------------------------------------------------------- #
print("\nEjercicio 2c -------------------------------------")

img = img4.copy()
sigma = 1
n = 4

res, regions = espacioLaplaciano(img, sigma, n)

# Juntando en una sola imagen
x = np.zeros_like(res[0])
for i in res:
    x += i

pintaMI(res)
pintaMI([x])

input(" -- Pulse cualquier tecla para continuar -- ")

# ------------------------------------------------------- # 
# ------------------------------------------------------- #
print("\nEjercicio 3 -------------------------------------")

# Primera pareja
# La diferencia de colores no hace que quede del todo bien

sigma1 = 5
sigma2 = 15
ksize = 31

imgs = mezclaImagenes(img1, sigma1, img2, sigma2, ksize)
img_hib = piramideGaussiana(imgs[2], cv2.BORDER_DEFAULT)
pinta3I(imgs[0], imgs[1], imgs[2])
pintaPiramide(imgs[2], img_hib, "Pirámide Gaussiana de imagen híbrida 1")

# ------------------------------------------------------- #
# Segunda pareja

sigma1 = 3.5
sigma2 = 7
ksize = 31  

imgs = mezclaImagenes(img3, sigma1, img4, sigma2, ksize)
img_hib = piramideGaussiana(imgs[2], cv2.BORDER_DEFAULT)
pinta3I(imgs[0], imgs[1], imgs[2])
pintaPiramide(imgs[2], img_hib, "Pirámide Gaussiana de imagen híbrida 2")

# ------------------------------------------------------- #
# Tercera pareja

sigma1 = 10
sigma2 = 7
ksize = 21

imgs = mezclaImagenes(img5, sigma1, img6, sigma2, ksize)
img_hib = piramideGaussiana(imgs[2], cv2.BORDER_DEFAULT)
pinta3I(imgs[0], imgs[1], imgs[2])
pintaPiramide(imgs[2], img_hib, "Pirámide Gaussiana de imagen híbrida 3")


input(" -- Pulse cualquier tecla para continuar -- ")

# ------------------------------------------------------- # 
# ------------------------------------------------------- #
print("\nBonus 1      -------------------------------------")

kx = [0.066414,0.079465,0.091364,0.100939,0.107159,0.109317,0.107159,0.100939,0.091364,0.079465,0.066414]
ky = [0.066414,0.079465,0.091364,0.100939,0.107159,0.109317,0.107159,0.100939,0.091364,0.079465,0.066414]

gau = convGaussiana(img, 11, 5, 5, cv2.BORDER_DEFAULT)
res = convSeparable(img, kx, ky)

pintaMI([res, gau])

input(" -- Pulse cualquier tecla para continuar -- ")

# ------------------------------------------------------- # 
# ------------------------------------------------------- #
print("\nBonus 2      -------------------------------------")

img1 = leeimagen('./imagenes/motorcycle.bmp')
img2 = leeimagen('./imagenes/bicycle.bmp')
img4 = leeimagen('./imagenes/einstein.bmp')
img3 = leeimagen('./imagenes/marilyn.bmp')
img5 = leeimagen('./imagenes/dog.bmp')
img6 = leeimagen('./imagenes/cat.bmp')
img7 = leeimagen('./imagenes/bird.bmp')
img8 = leeimagen('./imagenes/plane.bmp')
img9 = leeimagen('./imagenes/fish.bmp')
img10 = leeimagen('./imagenes/submarine.bmp')

# ------------------------------------------------------- # 
# ------------------------------------------------------- #

# Primera pareja

sigma1 = 5
sigma2 = 11
ksize = 31

imgs = mezclaImagenes(img1, sigma1, img2, sigma2, ksize)
img_hib = piramideGaussiana(imgs[2], cv2.BORDER_DEFAULT)
pinta3I(imgs[0], imgs[1], imgs[2])
pintaPiramide(imgs[2], img_hib, "Pirámide Gaussiana de imagen híbrida 1")

# ------------------------------------------------------- #
# Segunda pareja

sigma1 = 3.5
sigma2 = 7 # Si se sube mucho se ve demasiado
ksize = 31  

imgs = mezclaImagenes(img3, sigma1, img4, sigma2, ksize)
img_hib = piramideGaussiana(imgs[2], cv2.BORDER_DEFAULT)
pinta3I(imgs[0], imgs[1], imgs[2])
pintaPiramide(imgs[2], img_hib, "Pirámide Gaussiana de imagen híbrida 2")

# ------------------------------------------------------- #
# Tercera pareja

sigma1 = 10
sigma2 = 7
ksize = 21

imgs = mezclaImagenes(img5, sigma1, img6, sigma2, ksize)
img_hib = piramideGaussiana(imgs[2], cv2.BORDER_DEFAULT)
pinta3I(imgs[0], imgs[1], imgs[2])
pintaPiramide(imgs[2], img_hib, "Pirámide Gaussiana de imagen híbrida 3")

# ------------------------------------------------------- #
# Cuarta pareja

sigma1 = 15
sigma2 = 3
ksize = 21

imgs = mezclaImagenes(img7, sigma1, img8, sigma2, ksize)
img_hib = piramideGaussiana(imgs[2], cv2.BORDER_DEFAULT)
pinta3I(imgs[0], imgs[1], imgs[2])
pintaPiramide(imgs[2], img_hib, "Pirámide Gaussiana de imagen híbrida 4")

# ------------------------------------------------------- #
# Quinta pareja

sigma1 = 1
sigma2 = 20
ksize = 31

imgs = mezclaImagenes(img10, sigma1, img9, sigma2, ksize)
img_hib = piramideGaussiana(imgs[2], cv2.BORDER_DEFAULT)
pinta3I(imgs[0], imgs[1], imgs[2])
pintaPiramide(imgs[2], img_hib, "Pirámide Gaussiana de imagen híbrida 5")

input(" -- Pulse cualquier tecla para continuar -- ")

# ------------------------------------------------------- # 
# ------------------------------------------------------- #
print("\nBonus 3      -------------------------------------")

# Leemos las imágenes
img11 = leeimagen("./imagenes/putin.png")
img12 = leeimagen("./imagenes/dog.png")

# Las recortamos para que tengan la misma forma
row_size = 500
col_size = 600
img11 = img11[0:350, 0:340, :]
img12 = img12[0:350, 50:390, :]

# Creamos la imagen híbrida
sigma1 = 6.5
sigma2 = 10
ksize = 31

imgs = mezclaImagenes(img12, sigma1, img11, sigma2, ksize)
img_hib = piramideGaussiana(imgs[2], cv2.BORDER_DEFAULT)
pinta3I(imgs[0], imgs[1], imgs[2])
pintaPiramide(imgs[2], img_hib, "Pirámide Gaussiana de imagen híbrida 6")