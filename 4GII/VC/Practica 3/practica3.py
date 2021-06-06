###############################################################################
# practica3.py
# 
# Ignacio Vellido Expósito
###############################################################################

###############################################################################
# Imports ------------------------------------------------------------------- #
###############################################################################

import cv2
import random
import numpy as np
from math import atan2
from matplotlib import pyplot as plt

###############################################################################
# Funciones ----------------------------------------------------------------- #
###############################################################################

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
        img = cv2.imread(filename, cv2.IMREAD_GRAYSCALE)
    else:
        img = cv2.imread(filename)
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    
    # Pintando la imagen
    if pintar:
        plt.figure()
        plt.imshow(img)
        plt.show()

    return img.astype('float64')

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

    return convolucion(img, retval, retval, border)

# --------------------------------------------------------------------------- #

def convDerivada(img, ksize, orden, border=cv2.BORDER_DEFAULT):
    kx1, ky1 = cv2.getDerivKernels(dx=orden, dy=0, ksize=ksize, 
                                normalize=True, ktype=cv2.CV_64F)  
    kx2, ky2 = cv2.getDerivKernels(dx=0, dy=orden, ksize=ksize, 
                                normalize=True, ktype=cv2.CV_64F)  

    # Son dos vectores de col
    kx = np.transpose(kx1)
    ky = ky2
    
    return convolucion(img, kx, ky, border)

# --------------------------------------------------------------------------- #

def convDerivadaX(img, ksize, orden, border=cv2.BORDER_DEFAULT):
    kx1, ky1 = cv2.getDerivKernels(dx=orden, dy=0, ksize=ksize, 
                                normalize=True, ktype=cv2.CV_64F)  

    # Son dos vectores de col
    kx = np.transpose(kx1)
    ky = ky1
    
    return convolucion(img, kx, ky, border)

def convDerivadaY(img, ksize, orden, border=cv2.BORDER_DEFAULT):
    kx2, ky2 = cv2.getDerivKernels(dx=0, dy=orden, ksize=ksize, 
                                normalize=True, ktype=cv2.CV_64F)  

    # Son dos vectores de col
    kx = kx2
    ky = ky2
    
    return convolucion(img, kx, ky, border)

# --------------------------------------------------------------------------- #
# Funciones de dibujado
# --------------------------------------------------------------------------- #

def pintaMI(vim, titulos=None, suptitle=None):
    """ Visualiza varias imágenes a la vez """
    n_images = len(vim)
    cols = 2 if len(vim) >= 2 else len(vim)

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
        if len(image.shape) == 2: 
            plt.imshow(image, cmap="gray")
        else:
            plt.imshow(image)

        a.set_title(title)        
        a.axis('off')    

    fig.suptitle(suptitle)
    fig.set_size_inches(np.array(fig.get_size_inches()) * n_images)
    fig.subplots_adjust(bottom=0)

    plt.show()

# --------------------------------------------------------------------------- #

def pintarKeyPoints(img, keypoints):
    img = img.astype("uint8")
    out = cv2.drawKeypoints(img, keypoints, None, flags=cv2.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS)
    pintaMI([out], ["KeyPoints en todas las escalas: " + str(len(keypoints))])

# --------------------------------------------------------------------------- #

def pintarKeyPointsEnEscalas(img, keypoints):
    vim = []
    titulos = []

    for i in range(len(keypoints)):
        img = img.astype("uint8")
        vim.append(cv2.drawKeypoints(img, keypoints[i], None, flags=cv2.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS))
        titulos.append("KeyPoints en escala " + str(i+1) + ": " + str(len(keypoints[i])))

    pintaMI(vim, titulos)

# --------------------------------------------------------------------------- #

def pintarKeyPointsCorrectos(img, keypoints, new_keypoints):
    titulos = ["KeyPoints variados: " + str(len(keypoints))]
    vim = [img]
    suptitle = ''

    n_images = len(vim)
    cols = 7 if len(vim) >= 7 else len(vim)    

    fig = plt.figure()
    new_images = []

    for n, (image, title) in enumerate(zip(vim, titulos)):
        a = fig.add_subplot(np.ceil(n_images/float(cols)), cols, n+1)

        image = normalizaI(image)
        image = image.astype('uint8')
        image = cv2.cvtColor(image, cv2.COLOR_GRAY2RGB)

        # Pintando los puntos Harris
        num_points = 0

        # Para saber que KeyPoints son diferentes
        diff_keypoints = []
        img_copy = image.copy()

        for i in range(len(new_keypoints)):
            px = int(keypoints[i].pt[0])
            py = int(keypoints[i].pt[1])

            npx = int(new_keypoints[i][0])
            npy = int(new_keypoints[i][1])

            # Dibujando si ambos puntos son diferentes
            if (px != npx) or (py != npy):                
                image = cv2.circle(image, center=(px, py), radius=3, 
                                color=(255,0,0), thickness=1)   # Original
                image = cv2.circle(image, center=(npx, npy), radius=3, 
                                color=(0,255,0), thickness=1)   # Mejorado

                num_points += 1
                diff_keypoints.append([px, py, npx, npy])

        # Selección aleatoria de 3
        for i in range(3):
            px = diff_keypoints[i][0]
            py = diff_keypoints[i][1]
            npx = diff_keypoints[i][2]
            npy = diff_keypoints[i][3]

            new_img = img_copy.copy()

            new_img = cv2.circle(new_img, center=(px, py), radius=3, 
                            color=(255,0,0), thickness=1)   # Original
            new_img = cv2.circle(new_img, center=(npx, npy), radius=3, 
                            color=(0,255,0), thickness=1)   # Mejorado

            # Seleccionando el trozo de la imagen
            new_img = cv2.rectangle(new_img, (px-10,py-10),(px+10,py+10), (0,0,255), 1)

            # Para no tener problemas con los arrays
            sx = px-50
            sy = py-50
            sx = 0 if sx < 0 else sx
            sy = 0 if sy < 0 else sy
            
            new_img = new_img[sy:py+50, sx:px+50,:]
            new_images.append(new_img)

        title = "KeyPoints variados: " + str(num_points)

        # Se debe normalizar la imagen antes de convertirla a uint8
        if len(image.shape) == 2: 
            plt.imshow(image, cmap="gray")
        else:
            plt.imshow(image)

        a.set_title(title)        
        a.axis('off')    

    fig.suptitle(suptitle)
    fig.set_size_inches(np.array(fig.get_size_inches()) * n_images)
    fig.subplots_adjust(bottom=0)

    plt.show()    

    pintaMI(new_images)

# --------------------------------------------------------------------------- #

def pintarCorrespondencias(img1, keypoints1, img2, keypoints2, matches, title):
    img1 = img1.astype('uint8')
    img2 = img2.astype('uint8')
    shape = (len(img1) + len(img2), len(img1[0]) + len(img2[0]))
    outImg = np.zeros(shape)

    outImg = cv2.drawMatchesKnn(img1, keypoints1, img2, keypoints2, matches, outImg)

    pintaMI([outImg], [title])

# --------------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #

def no_maximos(img, mask_size):
    res = np.zeros_like(img)
    mask = np.empty((mask_size,mask_size), dtype=img.dtype)

    # Creamos un border (Replicate, pues no altera el valor del máximo)
    img_border = cv2.copyMakeBorder(img, mask_size-2, mask_size-2, 
                                    mask_size-2, mask_size-2, cv2.BORDER_REFLECT)

    for i in range(0, len(img)):
        for j in range(0, len(img[0])):
            mask = img_border[i:i+mask_size, j:j+mask_size]

            # Comprobando si máximo global            
            is_global_max = True
            for v in range(0, mask_size):
                for w in range(0, mask_size):
                    if v != 1 or w != 1:
                        is_global_max = False if mask[v,w] >= mask[1,1] else is_global_max                    

            if is_global_max:
                res[i, j] = img_border[i+1, j+1]

    return res

# --------------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #

def calcularFP(lmb1, lmb2, threshold):
    """ Devuelve el valor de Harris dados lambda1 y labmda2, aplicando threshold """
    out = lmb1
    for x in range(len(lmb1)):
        for y in range(len(lmb1[0])):
            l1 = lmb1[x,y]
            l2 = lmb2[x,y]
            if (l1 + l2) == 0:  # Evitando dividir por cero
                out[x,y] = 0
            else:
                out[x,y] = ((l1*l2) / (l1+l2))

            # Añadiendo umbral
            out[x,y] = 0 if out[x,y] < threshold else out[x,y]
    
    return out

# --------------------------------------------------------------------------- #

def calcularPuntosHarris(img, blocksize=3, ksize=3, threshold=0, mask_size=3):
    """ Recorre la pirámide calculando los valores de Harris en cada nivel.
    Devuelve lista de KeyPoints detectados """
    keypoints = []
    keypoints_escalas = []
    last_level = img.astype('float32')

    # 4 niveles
    for nivel in range(1,5):
        keypoints_escalas.append([])

        # Obtener autovalores y autovectores -----------------------------------
        vals = cv2.cornerEigenValsAndVecs(last_level, blockSize=blocksize, ksize=ksize)

        # Obteniendo los lambda
        lmb1 = vals[:,:,0]
        lmb2 = vals[:,:,1]

        # Calculando el valor de Harris ----------------------------------------
        # Recorrer píxeles y calcular fp para cada uno
        fp = calcularFP(lmb1, lmb2, threshold)
        fp = fp.astype('float64')

        # Supresión de no máximos
        fp = no_maximos(fp, mask_size)

        # Calcular ángulo ------------------------------------------------------
        # Aplicar sigma de 4.5
        gau = convGaussiana(last_level.astype('float64'), ksize, 4.5, 4.5, cv2.BORDER_DEFAULT)

        # Sacar derivadas en x y en y
        sen = convDerivadaX(gau, ksize, orden=1)
        cos = convDerivadaY(gau, ksize, orden=1)

        # Obteniendo orientaciones
        pangle = np.arctan2(sen,cos) * 180 / np.pi
        pangle = (pangle + 360) % 360

        # Añadir keypoints -----------------------------------------------------
        psize = blocksize * nivel   # Escala

        for i in range(len(fp)):
            for j in range(len(fp[0])):
                # Si el píxel ha pasado el threshold
                if fp[i,j] > 0:
                    # Calculando el píxel correspondiente a escala original
                    px = j * (2**(nivel-1))
                    py = i * (2**(nivel-1))

                    # Añadir nuevo keypoint
                    keypoints.append(cv2.KeyPoint(px, py, _size=psize, _angle=pangle[i,j]))
                    keypoints_escalas[nivel-1].append(cv2.KeyPoint(px, py, 
                                                                    _size=psize,
                                                                    _angle=pangle[i,j]))

        # Bajar en la pirámide -------------------------------------------------
        last_level = cv2.pyrDown(last_level)

    return keypoints, keypoints_escalas

# --------------------------------------------------------------------------- #

def calcularPuntosHarrisCorrectos(img, keypoints):
    stop_criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 100, 0.001)
    img = img.astype('float32')

    # Guardando los puntos
    points = []
    for keypoint in keypoints:
        points.append(keypoint.pt)

    points = np.float32(points)    

    cv2.cornerSubPix(img, points, (5,5), (-1,-1), stop_criteria)

    return points

# --------------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #

def getKaze(img):
    """ Devuelve los keypoints y descriptores usando KAZE """
    img = img.astype('uint8')
    orb = cv2.AKAZE_create()
    return orb.detectAndCompute(img, None)

# --------------------------------------------------------------------------- #

def get100random(array):
    """ Devuelve 100 elementos aleatorios de un array """
    size = 100

    if len(array) > size:
        return random.sample(array, size)
    else:
        return array

# --------------------------------------------------------------------------- #

def correspondenciaCrossCheck(dsc1, dsc2, get_all=False):
    # Buscar matches con CrossCheck
    bf = cv2.BFMatcher.create(normType=cv2.NORM_L2, crossCheck=True)
    matches = bf.knnMatch(dsc1, dsc2, k=1)
    
    # Obteniendo resultados
    res = []
    for m in matches:
        if m:
            res.append(m)    

    # Nos vendrá bien para los mosaicos
    if get_all:
        return res
    else:
        return get100random(res)

# --------------------------------------------------------------------------- #

def correspondenciaLowe(dsc1, dsc2, ratio=0.75, get_all=False):
    # Encontrando las 2 mejores correspondencias para cada descriptor
    bf = cv2.BFMatcher.create()
    matches = bf.knnMatch(dsc1, dsc2, k=2)

    # Aplicando el ratio de Lowe
    res = []
    for first,second in matches:
        if first.distance < ratio*second.distance:
            res.append([first])
    
    if get_all:
        return res
    else:
        return get100random(res)

# --------------------------------------------------------------------------- #

def correspondenciaCrossCheckAndLowe(dsc1, dsc2, ratio=0.45):
    """ Utiliza los dos criterios previos para obtener correspondencias """
    matches1 = correspondenciaCrossCheck(dsc1, dsc2, get_all=True)
    # Bajamos el ratio para obtener más seguridad en los puntos
    matches2 = correspondenciaLowe(dsc1, dsc2, ratio=ratio, get_all=True)
        
    # Seleccionando aquellas correspondencias elegidas por los dos criterios
    true_matches = []
    for m1 in matches1:
        for m2 in matches2:
            if m1[0].queryIdx == m2[0].queryIdx and m1[0].trainIdx == m2[0].trainIdx:
                true_matches.append(m1)

    return true_matches

# --------------------------------------------------------------------------- #

def getMatches(img1, img2):
    """ Obtiene e imprime correspondencias con Lowe y CrossCheck separadamente """
    keypoints1, descriptors1 = getKaze(img1)
    keypoints2, descriptors2 = getKaze(img2)

    # Matches con cross check
    matches1 = correspondenciaCrossCheck(descriptors1, descriptors2)

    # Matches con Lowe
    matches2 = correspondenciaLowe(descriptors1, descriptors2)

    pintarCorrespondencias(img1, keypoints1, img2, keypoints2, matches1, 
                            "Correspondencias usando CrossCheck")
    pintarCorrespondencias(img1, keypoints1, img2, keypoints2, matches2, 
                            "Correspondencias usando criterio de Lowe")

# --------------------------------------------------------------------------- #

def getBestMatches(img1, img2, ratio=0.45):
    """ Obtiene e imprime correspondencias con Lowe y CrossCheck conjuntamente """
    keypoints1, descriptors1 = getKaze(img1)
    keypoints2, descriptors2 = getKaze(img2)

    matches = correspondenciaCrossCheckAndLowe(descriptors1, descriptors2, ratio)

    pintarCorrespondencias(img1, keypoints1, img2, keypoints2, matches, 
                            "Correspondencias usando CrossCheck y Lowe")

# --------------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #

def ajustarImagen(img):
    """ Elimina filas y columnas en negro """
    # Para cada fila
    index = []
    for i in range(len(img)):
        row = img[i]

        if np.count_nonzero(row) == 0:
            index.append(i)

    img = np.delete(img, index, 0)

    # Para cada columna
    index = []
    for i in range(len(img[0])):
        col = img[:,i,:]

        if np.count_nonzero(col) == 0:
            index.append(i)

    return np.delete(img, index, 1)

# --------------------------------------------------------------------------- #
# BONUS 
# --------------------------------------------------------------------------- #

def calcularHomografia(matches, keypoints1, keypoints2):
    """ Recibe vector con cuatro matches """
    ph = []
    pt1 = np.empty((2), dtype=np.float32)
    pt2 = np.empty((2), dtype=np.float32)

    for i in range(len(matches)):
        pt1[0] = keypoints1[matches[i][0].queryIdx].pt[0]
        pt1[1] = keypoints1[matches[i][0].queryIdx].pt[1]
        pt2[0] = keypoints2[matches[i][0].trainIdx].pt[0]
        pt2[1] = keypoints2[matches[i][0].trainIdx].pt[1]

        # Añadimos dos filas más a la matriz PH
        """ [-x1, -y1, -1,   0,   0,  0, x1x2, y1x2, x2]
            [  0,   0,  0, -x1, -y1, -1, x1y2, y1y2, y2] """
        a1 = [-pt1[0], -pt1[1], -1, 0, 0, 0,
               pt1[0] * pt2[0], 
               pt1[1] * pt2[0], 
               pt2[0]]
        a2 = [0, 0, 0, -pt1[0], -pt1[1], -1,
              pt1[0] * pt2[1], 
              pt1[1] * pt2[1], 
              pt2[1]]

        ph.append(a1)
        ph.append(a2)

    ph = np.matrix(ph)

    # Descomposición en valores singulares
    _, _, v = np.linalg.svd(ph)

    # Nos quedamos con el último autovalor
    autovalor = v[8]

    # Convertimos el autovalor en la homografía
    homography = np.reshape(autovalor, (3, 3))    

    return homography

def evaluarMatches(homography, matches, keypoints1, keypoints2, epsilon):
    """ Calcula la distancia de la correspondencia al aplicar la homografía """
    pt1 = np.empty((2), dtype=np.float32)
    pt2 = np.empty((2), dtype=np.float32)
    points = []

    for i in range(len(matches)):
        # Obteniendo las coordenadas
        pt1[0] = keypoints1[matches[i][0].queryIdx].pt[0]
        pt1[1] = keypoints1[matches[i][0].queryIdx].pt[1]
        pt2[0] = keypoints2[matches[i][0].trainIdx].pt[0]
        pt2[1] = keypoints2[matches[i][0].trainIdx].pt[1]

        # Calculando los nuevos puntos aplicando la homografía
        p1 = [pt1[0], pt1[1], 1]        
        p1_2 = np.dot(homography, p1)
        lmbda = p1_2[0,2]
        p1_2 = (1/lmbda) * p1_2

        p2 = [pt2[0], pt2[1], 1]

        # Calculando distancia
        distance = np.linalg.norm(p2 - p1_2)

        # Solo se añade si está por debajo de un umbral
        if distance < epsilon:
            points.append([pt1,pt2])

    return points
        

def ransac(matches, keypoints1, keypoints2, max_iter=100, epsilon=3):
    best_homography = None
    best_len_points = 0
    best_points = None

    for _ in range(max_iter):
        # Elegir 4 puntos de forma aleatoria
        pts = random.sample(matches, 4)
        
        # Calcular homografía que generan
        h = calcularHomografia(pts, keypoints1, keypoints2)

        # Evaluar homografía con el resto de puntos
        points = evaluarMatches(h, matches, keypoints1, keypoints2, epsilon)

        # Guardar la mejor encontrada
        if len(points) > best_len_points:
            best_homography = h
            best_points = points
            best_len_points = len(points)

    return best_homography, best_points

# --------------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #

# --------------------------------------------------------------------------- #

def generarMosaico(vim, mode_ransac=False):
    """ Genera un mosaico dado un vector de imágenes ordenadas """
    # Calculando valores auxiliares
    pos_central = int(len(vim) / 2)
    width  = int(sum([len(im) for im in vim]))
    height = int(len(vim[0][0]) * 1.5)

    # Definiendo la imagen sobre la que pintar el mosaico
    shape = (width, height)
    out = np.zeros(shape)    

    # Calculamos homografías entre imágenes ------------------------------------
    homographies = []

    for j in range(len(vim)):        
        img1 = vim[j]

        if j <= pos_central:    # Calcular homografía respecto siguiente
            img2 = vim[j+1]
        else:                   # Calcular respecto anterior
            img2 = vim[j-1]

        # Obtener correspondencias entre las imágenes
        keypoints1, descriptors1 = getKaze(img1)
        keypoints2, descriptors2 = getKaze(img2)

        # Diferentes criterios para las correspondencias
        # matches = correspondenciaCrossCheck(descriptors1, descriptors2, get_all=True)
        # matches = correspondenciaLowe(descriptors1, descriptors2, ratio=0.5, get_all=True)
        matches = correspondenciaCrossCheckAndLowe(descriptors1, descriptors2)

        pt1 = np.empty((len(matches),2), dtype=np.float32)
        pt2 = np.empty((len(matches),2), dtype=np.float32)

        # Asignando los pares de puntos
        for i in range(len(matches)):
            pt1[i,0] = keypoints1[matches[i][0].queryIdx].pt[0]
            pt1[i,1] = keypoints1[matches[i][0].queryIdx].pt[1]
            pt2[i,0] = keypoints2[matches[i][0].trainIdx].pt[0]
            pt2[i,1] = keypoints2[matches[i][0].trainIdx].pt[1]

        # Definir homografías
        if mode_ransac:  # Usando RANSAC - Versión bonus
            h, _ = ransac(matches, keypoints1, keypoints2)
        else:
            h = cv2.findHomography(pt1, pt2)[0]

            # RANSAC de findHomography
            # h = cv2.findHomography(pt1, pt2, method=cv2.RANSAC)[0]

        homographies.append(h)

    # Calculando homografía central a la imagen (centrada en X y en Y)
    w_central = (width / 2)  - (len(vim[pos_central][0]) / 2)
    h_central = (height / 2) - (len(vim[pos_central]) / 2)
    h = np.array([[1, 0, w_central],    # Traslación
                  [0, 1, h_central], 
                  [0, 0,         1]], dtype=np.float32)

    # Pintando imagen central --------------------------------------------------
    out = cv2.warpPerspective(vim[pos_central], M=h, dsize=shape, dst=out)
    homographies[pos_central] = h
    
    # Colocando las que están a la izquierda -----------------------------------
    for i in range(pos_central-1, -1, -1):
        homography = np.dot(homographies[i+1], homographies[i])
        homographies[i] = homography

        # Trasladar imagen al mosaico
        out = cv2.warpPerspective(vim[i], M=homography, dsize=shape, dst=out, 
                                    borderMode=cv2.BORDER_TRANSPARENT)

    # Colocando las que están a la derecha -------------------------------------
    for i in range(pos_central+1, len(vim)):
        homography = np.dot(homographies[i-1], homographies[i])
        homographies[i] = homography

        # Trasladar imagen al mosaico
        out = cv2.warpPerspective(vim[i], M=homography, dsize=shape, dst=out, 
                                    borderMode=cv2.BORDER_TRANSPARENT)

    # Quitando zonas sobrantes ------------------------------------------------- 
    out = ajustarImagen(out)

    # Pintando el mosaico ------------------------------------------------------ 
    pintaMI([out])

###############################################################################
# Main ---------------------------------------------------------------------- #
###############################################################################

# Cargando las imágenes
imgY1 = leeimagen('./imagenes/yosemite1.jpg', False, 0)
imgY2 = leeimagen('./imagenes/yosemite2.jpg', False, 0)
imgY3 = leeimagen('./imagenes/yosemite3.jpg', False, 0)
imgY4 = leeimagen('./imagenes/yosemite4.jpg', False, 0)
imgY5 = leeimagen('./imagenes/yosemite5.jpg', False, 0)
imgY6 = leeimagen('./imagenes/yosemite6.jpg', False, 0)
imgY7 = leeimagen('./imagenes/yosemite7.jpg', False, 0)

imgT1 = leeimagen('./imagenes/Tablero1.jpg', False, 1)
imgT2 = leeimagen('./imagenes/Tablero2.jpg', False, 1)

imgM2  = leeimagen('./imagenes/mosaico002.jpg', False, 1).astype('uint8')
imgM3  = leeimagen('./imagenes/mosaico003.jpg', False, 1).astype('uint8')
imgM4  = leeimagen('./imagenes/mosaico004.jpg', False, 1).astype('uint8')
imgM5  = leeimagen('./imagenes/mosaico005.jpg', False, 1).astype('uint8')
imgM6  = leeimagen('./imagenes/mosaico006.jpg', False, 1).astype('uint8')
imgM7  = leeimagen('./imagenes/mosaico007.jpg', False, 1).astype('uint8')
imgM8  = leeimagen('./imagenes/mosaico008.jpg', False, 1).astype('uint8')
imgM9  = leeimagen('./imagenes/mosaico009.jpg', False, 1).astype('uint8')
imgM10 = leeimagen('./imagenes/mosaico010.jpg', False, 1).astype('uint8')
imgM11 = leeimagen('./imagenes/mosaico011.jpg', False, 1).astype('uint8')

# --------------------------------------------------------------------------- #
# Apartado 1a --------------------------------------------------------------- #
# --------------------------------------------------------------------------- #

blocksize = 7       # Igual para todos los niveles de la pirámide, pequeño
ksize = 3
threshold = 65      # Umbral Harris
mask_size = 3       # No máximos

keypoints1, keypoints_escalas1 = calcularPuntosHarris(imgY1, blocksize, ksize, 
                                                    threshold, mask_size)

keypoints2, keypoints_escalas2 = calcularPuntosHarris(imgY2, blocksize, ksize, 
                                                    threshold, mask_size)

# --------------------------------------------------------------------------- #
# Apartado 1b --------------------------------------------------------------- #
# --------------------------------------------------------------------------- #

pintarKeyPoints(imgY1, keypoints1)
pintarKeyPoints(imgY2, keypoints2)

# --------------------------------------------------------------------------- #
# Apartado 1c --------------------------------------------------------------- #
# --------------------------------------------------------------------------- #

pintarKeyPointsEnEscalas(imgY1, keypoints_escalas1)
pintarKeyPointsEnEscalas(imgY2, keypoints_escalas2)

# --------------------------------------------------------------------------- #
# Apartado 1d --------------------------------------------------------------- #
# --------------------------------------------------------------------------- #

new_keypoints = calcularPuntosHarrisCorrectos(imgY1, keypoints1)
pintarKeyPointsCorrectos(imgY1, keypoints1, new_keypoints)

# --------------------------------------------------------------------------- #
# Apartado 2 ---------------------------------------------------------------- #
# --------------------------------------------------------------------------- #

imgY1 = leeimagen('./imagenes/yosemite1.jpg', False, 1).astype('uint8')
imgY2 = leeimagen('./imagenes/yosemite2.jpg', False, 1).astype('uint8')
imgY3 = leeimagen('./imagenes/yosemite3.jpg', False, 1).astype('uint8')
imgY4 = leeimagen('./imagenes/yosemite4.jpg', False, 1).astype('uint8')
imgY5 = leeimagen('./imagenes/yosemite5.jpg', False, 1).astype('uint8')
imgY6 = leeimagen('./imagenes/yosemite6.jpg', False, 1).astype('uint8')
imgY7 = leeimagen('./imagenes/yosemite7.jpg', False, 1).astype('uint8')

getMatches(imgT1, imgT2)
getBestMatches(imgT1, imgT2, 0.75)

getMatches(imgY1, imgY2)
getBestMatches(imgY1, imgY2)

# --------------------------------------------------------------------------- #
# Apartado 3 y 4 ------------------------------------------------------------ #
# --------------------------------------------------------------------------- #

mosaico = [imgM2, imgM3, imgM4, imgM5, imgM6, imgM7, imgM8, imgM9, imgM10, imgM11]
generarMosaico(mosaico)

mosaico = [imgY1, imgY2, imgY3, imgY4]
generarMosaico(mosaico)

mosaico = [imgY5, imgY6, imgY7]
generarMosaico(mosaico)

# --------------------------------------------------------------------------- #
# Bonus --------------------------------------------------------------------- #
# --------------------------------------------------------------------------- #

mosaico = [imgM2, imgM3, imgM4, imgM5, imgM6, imgM7, imgM8, imgM9, imgM10, imgM11]
generarMosaico(mosaico, mode_ransac=True)

mosaico = [imgY1, imgY2, imgY3, imgY4]
generarMosaico(mosaico, mode_ransac=True)

mosaico = [imgY5, imgY6, imgY7]
generarMosaico(mosaico, mode_ransac=True)