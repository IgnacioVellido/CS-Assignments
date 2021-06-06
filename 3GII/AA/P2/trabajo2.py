# -*- coding: utf-8 -*-
"""
TRABAJO 2
Nombre Estudiante: Ignacio Vellido Expósito
"""
import numpy as np
import matplotlib.pyplot as plt


# Fijamos la semilla
np.random.seed(1)

def simula_unif(N, dim, rango):
	return np.random.uniform(rango[0],rango[1],(N,dim))

def simula_gaus(N, dim, sigma):
    media = 0    
    out = np.zeros((N,dim),np.float64)        
    for i in range(N):
        # Para cada columna dim se emplea un sigma determinado. Es decir, para 
        # la primera columna (eje X) se usará una N(0,sqrt(sigma[0])) 
        # y para la segunda (eje Y) N(0,sqrt(sigma[1]))
        out[i,:] = np.random.normal(loc=media, scale=np.sqrt(sigma), size=dim)
    
    return out


def simula_recta(intervalo):
    points = np.random.uniform(intervalo[0], intervalo[1], size=(2, 2))
    x1 = points[0,0]
    x2 = points[1,0]
    y1 = points[0,1]
    y2 = points[1,1]
    
    # y = a*x + b
    a = (y2-y1)/(x2-x1) # Calculo de la pendiente.
    b = y1 - a*x1       # Calculo del termino independiente.
    
    return a, b


# EJERCICIO 1.1: Dibujar una gráfica con la nube de puntos de salida correspondiente

x = simula_unif(50, 2, [-50,50])

# Pintar --------------------------------
plt.figure(1)
plt.scatter(x[:, 0], x[:, 1], label="", color='goldenrod', edgecolor='k')

plt.title("Apartado 1.a - simula_unif")
plt.show()

##################

x = simula_gaus(50, 2, np.array([5,7]))

# Pintar --------------------------------
plt.figure(2)
plt.scatter(x[:, 0], x[:, 1], label="", color='green', edgecolor='k')

plt.title("Apartado 1.b - simula_gaus")
plt.show()

input("\n--- Pulsar tecla para continuar ---\n")


###############################################################################
###############################################################################
###############################################################################


# EJERCICIO 1.2: Dibujar una gráfica con la nube de puntos de salida correspondiente

# La funcion np.sign(0) da 0, lo que nos puede dar problemas
def signo(x):
	if x >= 0:
		return 1
	return -1

def f(x, y, a, b):
	return signo(y - a*x - b)


x = simula_unif(50, 2, [-50,50])
recta = simula_recta([-50,50])

# Asignamos las etiquetas
labels = np.array([[0,0]])
labels = np.delete(labels, (0), axis=0)

for (a,b) in zip(x[:,0], x[:,1]): 
  labels = np.append(labels, f(a, b, recta[0], recta[1]))  

# Guardamo los datos para los ejercicios siguientes
data2a = x.copy()
labels2a = labels.copy()

# Pintar --------------------------------
plt.figure(3)

# La recta
lx = np.linspace(-50, 50, 50)
ly = (recta[0] * lx) + recta[1]

plt.plot(lx, ly, color="r")

# Los puntos
a = np.where(labels==1)
b = np.where(labels==-1)

plt.scatter(x[a][:, 0], x[a][:, 1], label="", color='green', edgecolor='k')
plt.scatter(x[b][:, 0], x[b][:, 1], label="", color='goldenrod', edgecolor='k')

plt.title("Apartado 2a")
plt.show()

input("\n--- Pulsar tecla para continuar ---\n")

# 1.2.b. Dibujar una gráfica donde los puntos muestren el resultado de su etiqueta, junto con la recta usada para ello
# Array con 10% de indices aleatorios para introducir ruido

"""
No suele ser exactamente un 10%, pero considero que esta es una forma más 
relista de simular el ruido
"""
# Cambiamos el signo con un 10% de probabilidad
for i, l in enumerate(labels):
  n = np.random.choice(2, 1, p=[0.9, 0.1])
  if n == 1:
    labels[i] = -l     

# Comprobamos el nº de puntos mal clasificados
misclassified = 0

truelabels = np.array([[0,0]])
truelabels = np.delete(truelabels, (0), axis=0)

for (a,b) in zip(x[:,0], x[:,1]): 
  truelabels = np.append(truelabels, f(a, b, recta[0], recta[1]))  
  
for (a,b) in zip(labels, truelabels):
  if a != b:
    misclassified += 1

misclassified /= len(truelabels)
misclassified = int(100*misclassified)

text = "Porcentaje mal clasificados: " + str(misclassified) +"%"

# Guardamo los datos para los ejercicios siguientes
data2b = x.copy()
labels2b = labels.copy()

# Pintar --------------------------------
fig, ax = plt.subplots()

# La recta
lx = np.linspace(-50, 50, 50)
ly = (recta[0] * lx) + recta[1]

ax.plot(lx, ly, color="r")

# Los puntos
a = np.where(labels==1)
b = np.where(labels==-1)

ax.scatter(x[a][:, 0], x[a][:, 1], label="", color='green', edgecolor='k')
ax.scatter(x[b][:, 0], x[b][:, 1], label="", color='goldenrod', edgecolor='k')

props = dict(boxstyle='round', facecolor='wheat', alpha=0.5)
ax.text(0.05, 0.95, text, transform=ax.transAxes, fontsize=9,
        verticalalignment='top', bbox=props)


plt.title("Apartado 2b")
plt.show()

input("\n--- Pulsar tecla para continuar ---\n")

###############################################################################
###############################################################################
###############################################################################

# EJERCICIO 1.3: Supongamos ahora que las siguientes funciones definen la frontera de clasificación de los puntos de la muestra en lugar de una recta

def plot_datos_cuad(X, y, fz, title='Point cloud plot', xaxis='x axis', yaxis='y axis'):
    #Preparar datos
    min_xy = X.min(axis=0)
    max_xy = X.max(axis=0)
    border_xy = (max_xy-min_xy)*0.01
    
    #Generar grid de predicciones
    xx, yy = np.mgrid[min_xy[0]-border_xy[0]:max_xy[0]+border_xy[0]+0.001:border_xy[0], 
                      min_xy[1]-border_xy[1]:max_xy[1]+border_xy[1]+0.001:border_xy[1]]
    grid = np.c_[xx.ravel(), yy.ravel(), np.ones_like(xx).ravel()]
    pred_y = fz(grid)
    # pred_y[(pred_y>-1) & (pred_y<1)]
    pred_y = np.clip(pred_y, -1, 1).reshape(xx.shape)
    
    #Plot
    f, ax = plt.subplots(figsize=(8, 6))
    contour = ax.contourf(xx, yy, pred_y, 50, cmap='RdBu',vmin=-1, vmax=1)
    ax_c = f.colorbar(contour)
    ax_c.set_label('$f(x, y)$')
    ax_c.set_ticks([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1])
    ax.scatter(X[:, 0], X[:, 1], c=y, s=50, linewidth=2, 
                cmap="RdYlBu", edgecolor='white')
    
    XX, YY = np.meshgrid(np.linspace(round(min(min_xy)), round(max(max_xy)),X.shape[0]),np.linspace(round(min(min_xy)), round(max(max_xy)),X.shape[0]))
    positions = np.vstack([XX.ravel(), YY.ravel()])
    ax.contour(XX,YY,fz(positions.T).reshape(X.shape[0],X.shape[0]),[0], colors='black')
    
    ax.set(
       xlim=(min_xy[0]-border_xy[0], max_xy[0]+border_xy[0]), 
       ylim=(min_xy[1]-border_xy[1], max_xy[1]+border_xy[1]),
       xlabel=xaxis, ylabel=yaxis)
    plt.title(title)
    plt.show()
    
    
def f1(X):
  return (X[:,0] - 10)**2 + (X[:,1] - 20)**2 - 400
    
def f2(X):
  return .5*((X[:,0] + 10)**2) + (X[:,1] - 20)**2 - 400

def f3(X):
  return .5*((X[:,0] - 10)**2) + (X[:,1] + 20)**2 - 400

def f4(X):
  return X[:,1] - 20*(X[:,0]**2) - 5*X[:,0] + 3


print("Ejercicio 1.3\n")

#######################################
  
plot_datos_cuad(x, labels2b, f1)

# Mostrar porcentaje de fallos al clasificar
valoresF1 = f1(x)

labels = np.array([[0,0]])
labels = np.delete(truelabels, (0), axis=0)

for i in valoresF1: 
  labels = np.append(labels, signo(i))  


truelabels = np.array([[0,0]])
truelabels = np.delete(truelabels, (0), axis=0)

for (a,b) in zip(x[:,0], x[:,1]): 
  truelabels = np.append(truelabels, f(a, b, recta[0], recta[1]))  


# Comprobamos el nº de malas clasificiaciones
misclassified = 0 

for (a,b) in zip(labels, truelabels):
  if a != b:
    misclassified += 1  

misclassified /= len(truelabels)
misclassified = int(100*misclassified)

print("F1 - Porcentaje mal clasificados: " + str(misclassified) +"%")

############################################

plot_datos_cuad(x, labels2b, f2)

# Mostrar porcentaje de fallos al clasificar
valoresF2 = f2(x)

labels = np.array([[0,0]])
labels = np.delete(truelabels, (0), axis=0)

for i in valoresF2: 
  labels = np.append(labels, signo(i))  


truelabels = np.array([[0,0]])
truelabels = np.delete(truelabels, (0), axis=0)

for (a,b) in zip(x[:,0], x[:,1]): 
  truelabels = np.append(truelabels, f(a, b, recta[0], recta[1]))  


# Comprobamos el nº de malas clasificiaciones
misclassified = 0 

for (a,b) in zip(labels, truelabels):
  if a != b:
    misclassified += 1  

misclassified /= len(truelabels)
misclassified = int(100*misclassified)

print("F2 - Porcentaje mal clasificados: " + str(misclassified) +"%")

############################################

plot_datos_cuad(x, labels2b, f3)

# Mostrar porcentaje de fallos al clasificar
valoresF3 = f3(x)

labels = np.array([[0,0]])
labels = np.delete(truelabels, (0), axis=0)

for i in valoresF3: 
  labels = np.append(labels, signo(i))  


truelabels = np.array([[0,0]])
truelabels = np.delete(truelabels, (0), axis=0)

for (a,b) in zip(x[:,0], x[:,1]): 
  truelabels = np.append(truelabels, f(a, b, recta[0], recta[1]))  


# Comprobamos el nº de malas clasificiaciones
misclassified = 0 

for (a,b) in zip(labels, truelabels):
  if a != b:
    misclassified += 1  

misclassified /= len(truelabels)
misclassified = int(100*misclassified)

print("F3 - Porcentaje mal clasificados: " + str(misclassified) +"%")

############################################

plot_datos_cuad(x, labels2b, f4)

# Mostrar porcentaje de fallos al clasificar
valoresF4 = f4(x)

labels = np.array([[0,0]])
labels = np.delete(truelabels, (0), axis=0)

for i in valoresF4: 
  labels = np.append(labels, signo(i))  


truelabels = np.array([[0,0]])
truelabels = np.delete(truelabels, (0), axis=0)

for (a,b) in zip(x[:,0], x[:,1]): 
  truelabels = np.append(truelabels, f(a, b, recta[0], recta[1]))  


# Comprobamos el nº de malas clasificiaciones
misclassified = 0 

for (a,b) in zip(labels, truelabels):
  if a != b:
    misclassified += 1  

misclassified /= len(truelabels)
misclassified = int(100*misclassified)

print("F4 - Porcentaje mal clasificados: " + str(misclassified) +"%")

input("\n--- Pulsar tecla para continuar ---\n")

###############################################################################
###############################################################################
###############################################################################

# EJERCICIO 2.1: ALGORITMO PERCEPTRON

def ajusta_PLA(datos, label, max_iter, vini):
    # Variables auxiliares
    w = vini.copy()
    w_old = w.copy()
    noChange = False
    iterations = 0
    
    while (not noChange) and iterations < max_iter:
      for (x,y) in zip(datos, label):
        iterations += 1
        h = w.transpose().dot(x)
        
        if signo(h) != y:          
          w = w + np.dot(y, x)          
      
      # Comprobamos si se han modificado los pesos
      if np.array_equal(w_old,w):            
        noChange = True
        
      # Guardamos el valor de w en esta iteración      
      w_old = w.copy()
    
    return (w, iterations)

# Apartado a
print("Ejercicio 2.1.a\n")

# Añadir columna de unos
c0 = np.full(len(data2a),1)
data2a = np.column_stack((c0, data2a))
    
# Con vector 0 ---------------------------------------------------------
max_iter = 50_000
# Creamos array con tantas columnas como las de la matriz de datos
vini = np.zeros(np.size(data2a,1))
w_cero, iteration = ajusta_PLA(data2a, labels2a, max_iter, vini)

print("Comenzando con vector de ceros")
print('Valor de iteraciones necesarias para converger: ' + str(iteration))
print("\n-----------\n")

# Random initializations -----------------------------------------------
print("Comenzando con vector de números aleatorios\n")

iterations = []
for i in range(0,10):
    vini = np.random.uniform(low=0, high=1, size=np.size(data2a,1))    
  
    w_rand, iteration = ajusta_PLA(data2a, labels2a, max_iter, vini)
    print("\tIteración: " + str(iteration))
            
    iterations.append(iteration)
    
  
print('\nValor medio de iteraciones necesario para converger: {}'\
      .format(np.mean(np.asarray(iterations))))

# Pintar --------------------------------
x = data2a.copy()
labels = labels2a.copy()

fig, ax = plt.subplots()

# La recta
lx = np.linspace(-50, 50, 50)
ly = -(w_cero[0] + w_cero[1]*lx) / w_cero[2]

plt.plot(lx, ly, color="b")

# Los puntos
a = np.where(labels==1)
b = np.where(labels==-1)

plt.scatter(data2a[a][:, 1], data2a[a][:, 2], label="", color='green', edgecolor='k')
plt.scatter(data2a[b][:, 1], data2a[b][:, 2], label="", color='goldenrod', edgecolor='k')

ax.set_xlim([-55,55])
ax.set_ylim([-55,55])

plt.title("Apartado 2.1 - Datos separables linealmente")
plt.show()

input("\n--- Pulsar tecla para continuar ---\n")

# Ahora con los datos del ejercicio 1.2.b ------------
print("Ejercicio 2.1.b\n")

# Añadir columna de unos
c0 = np.full(len(data2b),1)
data2b = np.column_stack((c0, data2b))

# Con vector 0 -------------------
max_iter = 30000
# Creamos array con tantas columnas como las de la matriz de datos
vini = np.zeros(np.size(data2b,1))
w_cero, iteration = ajusta_PLA(data2b, labels2b, max_iter, vini)

print("Comenzando con vector de ceros")
print('Valor de iteraciones necesarias para converger: ' + str(iteration))
print("\n-----------\n")

# Random initializations-----------
print("Comenzando con vector de números aleatorios\n")
iterations = []
for i in range(0,10):
    vini = np.random.uniform(low=0, high=1, size=np.size(data2b,1))    
  
    w_rand, iteration = ajusta_PLA(data2b, labels2b, max_iter, vini)
      
    iterations.append(iteration)
    
print('Valor medio de iteraciones necesario para converger: {}'\
      .format(np.mean(np.asarray(iterations))))

# Pintar --------------------------------
x = data2b.copy()
labels = labels2b.copy()

fig, ax = plt.subplots()

# La recta
lx = np.linspace(-50, 50, 50)
ly = -(w_cero[0] + w_cero[1]*lx) / w_cero[2]

plt.plot(lx, ly, color="b")

# Los puntos
a = np.where(labels==1)
b = np.where(labels==-1)

plt.scatter(data2b[a][:, 1], data2b[a][:, 2], label="", color='green', edgecolor='k')
plt.scatter(data2b[b][:, 1], data2b[b][:, 2], label="", color='goldenrod', edgecolor='k')

ax.set_xlim([-55,55])
ax.set_ylim([-55,55])

plt.title("Apartado 2.1 - Datos no separables linealmente")
plt.show()


input("\n--- Pulsar tecla para continuar ---\n")

###############################################################################
###############################################################################
###############################################################################

# EJERCICIO 3: REGRESIÓN LOGÍSTICA CON STOCHASTIC GRADIENT DESCENT

from sklearn.utils import shuffle # Para ordenar los minibatch de sgd

# Cálculo del gradiente, derivada de Ein
def dEin(x, y, w):    
    N = len(x)        
    yx = np.dot(y, x)           # yn * xn    
    den = 1 + (np.e)**(np.dot(yx, w.transpose()))
    sumatoria = np.dot(yx, (1/den))
    
    return np.dot(-(1/N), sumatoria)     
  
def Ein(x, y, w):
    N = len(x)
    ein = 0
    for (a,b) in zip(x,y):
      yx = np.dot(a,b)
      ein += np.log(1 + np.e**(-np.dot(yx, w.transpose())))      
      
    return ein / N

def sgdRL(data, labels, vini, eta, epochs):
    # Variables auxiliares
    w = vini.copy()
    w_old = w.copy()    
    minibatch_size = 1
                  
    for i in range(epochs):       
        # Ordenamos aleatoriamente las muestras
        fullbatch_x, fullbatch_y = shuffle(data, labels, random_state=0)
        
        # Separamos en minibatches
        batches_x = np.array_split(fullbatch_x, np.ceil(len(data) / minibatch_size))
        batches_y = np.array_split(fullbatch_y, np.ceil(len(data) / minibatch_size))      
        
        for (minibatch_x, minibatch_y) in zip(batches_x, batches_y):                          
            error = dEin(minibatch_x, minibatch_y, w)
            gradient = eta * error      
                      
            w = w - gradient                           
                        
    
        resta = w - w_old          
        surpassedMinError = True if np.all(np.abs(resta)) < 0.01 else False
    
        # Devolvemos si hemos alcanzado el error             
        if surpassedMinError:                                
            return w    
        
        w_old = w.copy()
          
    return w

print("Ejercicio 3\n")

# Generamos los puntos
data = simula_unif(100, 2, [0,2])

# Seleccionamos dos aleatoriamente
p = np.random.randint(0, len(data), 2)

x1 = data[p[0]][0]
x2 = data[p[1]][0]
y1 = data[p[0]][1]
y2 = data[p[1]][1]

# Calculamos la recta
a = (y2-y1)/(x2-x1) # Calculo de la pendiente.
b = y1 - a*x1       # Calculo del termino independiente.

# Etiquetamos
labels = np.array([[0,0]])
labels = np.delete(labels, (0), axis=0)

for x in data:  
  labels = np.append(labels, f(x[0], x[1], a, b))

truelabels = labels.copy()

# Añadir columna de unos
c0 = np.full(len(data),1)
data = np.column_stack((c0, data))

# Lanzamos el algoritmo
vini = np.ones(np.size(data,1))
eta = 0.01
epochs = 1000

w = sgdRL(data, labels, vini, eta, epochs)

# Usar la muestra de datos etiquetada para encontrar 
#nuestra solución g y estimar Eout usando para ello 
# un número suficientemente grande de nuevas muestras.

# Generamos conjunto de test
test = simula_unif(100, 2, [0,2])

# Añadir columna de unos a test
c0 = np.full(len(test),1)
test = np.column_stack((c0, test))

# Calculamos el error fuera de la muestra
misclassified = 0 

for (l,d) in zip(truelabels, data):
  v = signo(np.dot(d, w.transpose()))
  if l != v:
     misclassified += 1  

misclassified /= len(data)
print("Pesos de g: " + str(w))
print("Porcentaje Eout: " + str(misclassified))


# Pintar ---------------------------
x = data.copy()
y = labels.copy()

# Train
fig, ax = plt.subplots()
ax.plot(np.squeeze(x[np.where(y == -1),1]), np.squeeze(x[np.where(y == -1),2]), 'o', color='red', label='-1')
ax.plot(np.squeeze(x[np.where(y == 1),1]), np.squeeze(x[np.where(y == 1),2]), 'o', color='blue', label='1')
ax.set(xlabel='x', ylabel='y', title='Regresión Logística')


# Pintamos la línea
z = np.linspace(0, 2, 2)
v = a*z + b

ax.plot(z, v, color="green", linewidth=3, label="Recta real")


lx = np.linspace(0, 2, 2)
ly = -(w[0] + w[1]*lx) / w[2]

ax.plot(lx, ly, color="darkorange", linewidth=3, label="Recta clasificadora")

ax.set_xlim([0,2])
ax.set_ylim([0,2])

plt.legend()
plt.show()

input("\n--- Pulsar tecla para continuar ---\n")

###############################################################################
###############################################################################
###############################################################################
#BONUS: Clasificación de Dígitos

# Media de símbolos mal clasificados
def Err(data, label, w):
  N = len(data)
  error = 0
  
  for (x,y) in zip(data, label):    
    sign = signo(np.dot(w, x)) 
    if sign != signo(y):
      error += (1/N)
  
  return error


# Funcion para leer los datos
def readData(file_x, file_y, digits, labels):
	# Leemos los ficheros	
	datax = np.load(file_x)
	datay = np.load(file_y)
	y = []
	x = []	
	# Solo guardamos los datos cuya clase sea la digits[0] o la digits[1]
	for i in range(0,datay.size):
		if datay[i] == digits[0] or datay[i] == digits[1]:
			if datay[i] == digits[0]:
				y.append(labels[0])
			else:
				y.append(labels[1])
			x.append(np.array([1, datax[i][0], datax[i][1]]))
			
	x = np.array(x, np.float64)
	y = np.array(y, np.float64)
	
	return x, y

print("BONUS\n")

# Lectura de los datos de entrenamiento
x, y = readData('datos/X_train.npy', 'datos/y_train.npy', [4,8], [-1,1])
# Lectura de los datos para el test
x_test, y_test = readData('datos/X_test.npy', 'datos/y_test.npy', [4,8], [-1,1])

# Mostramos los datos
fig, ax = plt.subplots()
ax.plot(np.squeeze(x[np.where(y == -1),1]), np.squeeze(x[np.where(y == -1),2]), 'o', color='red', label='4')
ax.plot(np.squeeze(x[np.where(y == 1),1]), np.squeeze(x[np.where(y == 1),2]), 'o', color='blue', label='8')
ax.set(xlabel='Intensidad promedio', ylabel='Simetria', title='Digitos Manuscritos (TRAINING)')
ax.set_xlim((0, 1))
plt.legend()
plt.show()

fig, ax = plt.subplots()
ax.plot(np.squeeze(x_test[np.where(y_test == -1),1]), np.squeeze(x_test[np.where(y_test == -1),2]), 'o', color='red', label='4')
ax.plot(np.squeeze(x_test[np.where(y_test == 1),1]), np.squeeze(x_test[np.where(y_test == 1),2]), 'o', color='blue', label='8')
ax.set(xlabel='Intensidad promedio', ylabel='Simetria', title='Digitos Manuscritos (TEST)')
ax.set_xlim((0, 1))
plt.legend()
plt.show()

# Con Regresión (SGD) --------------------
vini = np.zeros(np.size(x,1))
eta = 0.01
epochs = 500

w = sgdRL(x, y, vini, eta, epochs)
w_reg = w.copy()


#CALCULO DE LOS ERRORES ---
ein = Err(x, y, w)
print("Regresión - Porcentaje Ein:\t" + str(ein))
etest = Err(x_test, y_test, w)
print("Regresión - Porcentaje Etest:\t" + str(etest))

ein = Ein(x, y, w)
print("Regresión - Valor Ein:\t" + str(ein))

etest = Ein(x_test, y_test, w)
print("Regresión - Valor Etest:\t" + str(etest))
  
#COTA SOBRE EL ERROR - VC Generalization Bound 
tolerance = 0.05

# Sobre Ein
N = len(x)

# Break Point = 4, por tanto:
dvc = 2**(4-1)

a = (8/N) * np.log( (4*( ((2*N)**dvc) + 1)) / tolerance )
sqr = np.sqrt(a)
eout = ein + sqr

print("Regresión - Cota Eout sobre Ein:\t" + str(eout))

# Sobre Etest
eout = etest + sqr
print("Regresión - Cota Eout sobre Etest:\t" + str(eout))

# Pintar ----------------------------
# Train
fig, ax = plt.subplots()
ax.plot(np.squeeze(x[np.where(y == -1),1]), np.squeeze(x[np.where(y == -1),2]), 'o', color='red', label='4')
ax.plot(np.squeeze(x[np.where(y == 1),1]), np.squeeze(x[np.where(y == 1),2]), 'o', color='blue', label='8')
ax.set(xlabel='Intensidad promedio', ylabel='Simetria', title='Digitos Manuscritos (TRAINING) - Reg')

# Pintamos la línea
lx = np.linspace(-1, 1, 50)
ly = -(w[0] + w[1]*lx) / w[2]

ax.plot(lx, ly, color="green", linewidth=3)

ax.set_xlim([0,0.7])
ax.set_ylim([-7,0])

plt.legend()
plt.show()

# Test
fig, ax = plt.subplots()
ax.plot(np.squeeze(x_test[np.where(y_test == -1),1]), np.squeeze(x_test[np.where(y_test == -1),2]), 'o', color='red', label='4')
ax.plot(np.squeeze(x_test[np.where(y_test == 1),1]), np.squeeze(x_test[np.where(y_test == 1),2]), 'o', color='blue', label='8')
ax.set(xlabel='Intensidad promedio', ylabel='Simetria', title='Digitos Manuscritos (TEST) - Reg')

# Pintamos la línea
lx = np.linspace(-1, 1, 50)
ly = -(w[0] + w[1]*lx) / w[2]

ax.plot(lx, ly, color="green", linewidth=3)

ax.set_xlim([0,0.7])
ax.set_ylim([-7,0])

plt.legend()
plt.show()

#POCKET ALGORITHM
def pocket(datos, label, max_iter, vini):
    # Variables auxiliares
    w = vini.copy()        
    pocket = w.copy() # La mejor de todas
    pocket_error = Err(datos, label, w)         
    
    for i in range(max_iter):
      w, it = ajusta_PLA(datos, label, 1, w)
      
      error = Err(datos, label, w)
      
      if error < pocket_error:
        pocket = w.copy()
        pocket_error = error
    
    return pocket, pocket_error

# Con Pocket a partir de Regresión --------------------
w = w_reg.copy()
max_iter = 1000
vini = np.ones(np.size(x,1))

w, ein = pocket(x, y, max_iter, vini)

#CALCULO DE LOS ERRORES
print("\nReg+Pocket - Porcentaje Ein:\t" + str(ein))
etest = Err(x_test, y_test, w)
print("Reg+Pocket- Porcentaje Etest:\t" + str(etest))

ein = Ein(x, y, w)
print("Reg+Pocket - Valor Ein:\t" + str(ein))

etest = Ein(x_test, y_test, w)
print("Reg+Pocket - Valor Etest:\t" + str(etest))


#COTA SOBRE EL ERROR - VC Generalization Bound 
tolerance = 0.05

# Sobre Ein
N = len(x)

# El Perceptron tiene Break Point = 4, por tanto:
dvc = 2**(4-1)

a = (8/N) * np.log( (4*( ((2*N)**dvc) + 1)) / tolerance )
sqr = np.sqrt(a)
eout = ein + sqr

print("Reg+Pocket - Cota Eout sobre Ein:\t" + str(eout))

# Sobre Etest
eout = etest + sqr
print("Reg+Pocket - Cota Eout sobre Etest:\t" + str(eout))

# Pintar-----------
# Train
fig, ax = plt.subplots()
ax.plot(np.squeeze(x[np.where(y == -1),1]), np.squeeze(x[np.where(y == -1),2]), 'o', color='red', label='4')
ax.plot(np.squeeze(x[np.where(y == 1),1]), np.squeeze(x[np.where(y == 1),2]), 'o', color='blue', label='8')
ax.set(xlabel='Intensidad promedio', ylabel='Simetria', title='Digitos Manuscritos (TRAINING) - Reg+Pocket')

# Pintamos la línea
lx = np.linspace(-1, 1, 50)
ly = -(w[0] + w[1]*lx) / w[2]

ax.plot(lx, ly, color="darkorange", linewidth=3)

ax.set_xlim([0,0.7])
ax.set_ylim([-7,0])

plt.legend()
plt.show()

# Test
fig, ax = plt.subplots()
ax.plot(np.squeeze(x_test[np.where(y_test == -1),1]), np.squeeze(x_test[np.where(y_test == -1),2]), 'o', color='red', label='4')
ax.plot(np.squeeze(x_test[np.where(y_test == 1),1]), np.squeeze(x_test[np.where(y_test == 1),2]), 'o', color='blue', label='8')
ax.set(xlabel='Intensidad promedio', ylabel='Simetria', title='Digitos Manuscritos (TEST)- Reg+Pocket')

# Pintamos la línea
lx = np.linspace(-1, 1, 50)
ly = -(w[0] + w[1]*lx) / w[2]

ax.plot(lx, ly, color="darkorange", linewidth=3)

ax.set_xlim([0,0.7])
ax.set_ylim([-7,0])

plt.legend()
plt.show()

# Con Pocket ------------------------------------------------
# Llamando a Pocket
max_iter = 1000
vini = np.ones(np.size(x,1))

w, ein = pocket(x, y, max_iter, vini)

#CALCULO DE LOS ERRORES
print("\nPocket - Porcentaje Ein:\t" + str(ein))
etest = Err(x_test, y_test, w)
print("Pocket- Porcentaje Etest:\t" + str(etest))
  
ein = Ein(x, y, w)
print("Pocket - Valor Ein:\t" + str(ein))

etest = Ein(x_test, y_test, w)
print("Pocket - Valor Etest:\t" + str(etest))

#COTA SOBRE EL ERROR - VC Generalization Bound 
tolerance = 0.05

# Sobre Ein
N = len(x)

# El Perceptron tiene Break Point = 4, por tanto:
dvc = 2**(4-1)

a = (8/N) * np.log( (4*( ((2*N)**dvc) + 1)) / tolerance )
sqr = np.sqrt(a)
eout = ein + sqr

print("Pocket - Cota Eout sobre Ein:\t" + str(eout))

# Sobre Etest
eout = etest + sqr
print("Pocket - Cota Eout sobre Etest:\t" + str(eout))

# Pintar ---------------------
# Train
fig, ax = plt.subplots()
ax.plot(np.squeeze(x[np.where(y == -1),1]), np.squeeze(x[np.where(y == -1),2]), 'o', color='red', label='4')
ax.plot(np.squeeze(x[np.where(y == 1),1]), np.squeeze(x[np.where(y == 1),2]), 'o', color='blue', label='8')
ax.set(xlabel='Intensidad promedio', ylabel='Simetria', title='Digitos Manuscritos (TRAINING) - Pocket')

# Pintamos la línea
lx = np.linspace(-1, 1, 50)
ly = -(w[0] + w[1]*lx) / w[2]

ax.plot(lx, ly, color="darkorange", linewidth=3)

ax.set_xlim([0,0.7])
ax.set_ylim([-7,0])

plt.legend()
plt.show()

# Test
fig, ax = plt.subplots()
ax.plot(np.squeeze(x_test[np.where(y_test == -1),1]), np.squeeze(x_test[np.where(y_test == -1),2]), 'o', color='red', label='4')
ax.plot(np.squeeze(x_test[np.where(y_test == 1),1]), np.squeeze(x_test[np.where(y_test == 1),2]), 'o', color='blue', label='8')
ax.set(xlabel='Intensidad promedio', ylabel='Simetria', title='Digitos Manuscritos (TEST)- Pocket')

# Pintamos la línea
lx = np.linspace(-1, 1, 50)
ly = -(w[0] + w[1]*lx) / w[2]

ax.plot(lx, ly, color="darkorange", linewidth=3)

ax.set_xlim([0,0.7])
ax.set_ylim([-7,0])

plt.legend()
plt.show()

input("\n--- Pulsar tecla para continuar ---\n")


