# -*- coding: utf-8 -*-
"""
TRABAJO 1. 
Nombre Estudiante: Ignacio Vellido Expósito
"""

import numpy as np
import matplotlib.pyplot as plt
from sklearn.utils import shuffle # Para ordenar los minibatch de sgd

np.random.seed(1)

################################################################################
################################################################################
print('EJERCICIO SOBRE LA BUSQUEDA ITERATIVA DE OPTIMOS\n')
print('Ejercicio 1 y 2\n')

# Función
def E(u,v):
    return ((u**2)*(np.exp(v)) - 2*(v**2)*(np.exp(-u)))**2      

#Derivada parcial de E con respecto a u
def dEu(u,v):    
    return 2 * ((u**2)*(np.exp(v)) - 2*(v**2)*(np.exp(-u))) * (2*u*np.exp(v) + 2*(v**2)*np.exp(-u))
    
#Derivada parcial de E con respecto a v
def dEv(u,v):
    return 2 * ((u**2)*(np.exp(v)) - 2*(v**2)*(np.exp(-u))) * ((u**2)*(np.exp(v)) - 4*v*np.exp(-u))

#Gradiente de E
def gradE(u,v):
    return np.array([dEu(u,v), dEv(u,v)])

"""
Gradiente descendente
Argumentos:
  Tasa de aprendizaje: eta
  Nº máximo de iteraciones: maxIter
  Tasa de error: error2get - En este caso valor a alcanzar
  Punto inicial: initial_point
"""
def gradient_descent(eta, maxIter, error2get, initial_point):
    # Variables auxiliares para el algoritmo
    iterations = 0
    surpassedMinError = False
    
    # Inicializamos w
    w = np.copy(initial_point)
    
    while iterations < maxIter and not surpassedMinError:            
      gradient = eta * gradE(w[0], w[1])      
      w = w - gradient      
      error = E(w[0], w[1])      
      
      surpassedMinError = True if error < error2get else False
      iterations += 1
    
    return w, iterations    


eta = 0.01 
maxIter = 10000000000
error2get = 1e-14
initial_point = np.array([1.0,1.0])

w, it = gradient_descent(eta, maxIter, error2get, initial_point)

# Pintar ############################
print ('Numero de iteraciones: ', it)
print ('Coordenadas obtenidas: (', w[0], ', ', w[1], ')')


# DISPLAY FIGURE - Superficie del error
from mpl_toolkits.mplot3d import Axes3D
x = np.linspace(-30, 30, 50)
y = np.linspace(-30, 30, 50)
X, Y = np.meshgrid(x, y)
Z = E(X, Y) #E_w([X, Y])
fig = plt.figure(1)
ax = Axes3D(fig)
surf = ax.plot_surface(X, Y, Z, edgecolor='none', rstride=1,
                        cstride=1, cmap='jet')
min_point = np.array([w[0],w[1]])
min_point_ = min_point[:, np.newaxis]
ax.plot(min_point_[0], min_point_[1], E(min_point_[0], min_point_[1]), 'r*', markersize=10)
ax.set(title='Ejercicio 1.2. Función sobre la que se calcula el descenso de gradiente')
ax.set_xlabel('u')
ax.set_ylabel('v')
ax.set_zlabel('E(u,v)')

input("\n--- Pulsar tecla para continuar ---\n")

###############################################################################
print("Ejercicio 3\n")
print("Apartado a)\n")

# Función
def F(x,y):
  return (x**2 + 2*(y**2) + 2*np.sin(2*np.pi*x)*np.sin(2*np.pi*y))

#Derivada parcial de F con respecto a x
def dFx(x,y):
  return (2*x + 2*np.sin(2*np.pi*y) * 2*np.pi * np.cos(2*np.pi*x))

#Derivada parcial de F con respecto a y
def dFy(x,y):
  return (4*y + 2*np.sin(2*np.pi*x) * 2*np.pi * np.cos(2*np.pi*y))

#Gradiente de F
def gradF(x,y):
    return np.array([dFx(x,y), dFy(x,y)])

"""
Gradiente descendente que además devuelve los valores de la función durante
el proceso. Para cuando se llega al máximo de iteraciones o se alcanza un mínimo
Argumentos:
  Tasa de aprendizaje: eta
  Nº máximo de iteraciones: maxIter
  Tasa de error: error2get - No se utiliza
  Punto inicial: initial_point  
"""
def printing_gradient_descent(eta, maxIter, error2get, initial_point):
    # Variables auxiliares para el algoritmo
    iterations = 0
    isMin = False    
    
    # Inicializamos w
    w = np.copy(initial_point)
    
    # Guardamos el valor de la función en el punto inicial
    values = F(w[0], w[1])
    
    while iterations < maxIter and not isMin:            
      gradient = eta * gradF(w[0], w[1])      
      old_w = np.copy(w)
      w = w - gradient            
      descent = abs(F(w[0], w[1]) - F(old_w[0], old_w[1]))      
      
      # Guardamos el valor de la función
      values = np.vstack((values, F(w[0], w[1])))      
            
      isMin = True if descent == 0 else False
      iterations += 1
    
    return w, iterations, values    

# 1.3a  - n=0,01
eta = 0.01 
maxIter = 50
error2get = 0
initial_point = np.array([0.1,0.1])

w, it, v = printing_gradient_descent(eta, maxIter, error2get, initial_point)

# Pintar ############################
print ('Numero de iteraciones: ', it)
print ('Coordenadas obtenidas: (', w[0], ', ', w[1], ')')


plt.figure(2)
plt.plot(v, color="r")

plt.xlabel('Iteración')
plt.ylabel('Valor')
plt.title('Ejercicio 1.3a - n = 0,01')

plt.show()

#-------------------------------------------------------

# 1.3a  - n=0,1
eta = 0.1
maxIter = 50
error2get = 0
initial_point = np.array([0.1,0.1])

w, it, v = printing_gradient_descent(eta, maxIter, error2get, initial_point)

# Pintar ############################
print ('Numero de iteraciones: ', it)
print ('Coordenadas obtenidas: (', w[0], ', ', w[1], ')')

plt.figure(3)
plt.plot(v, color="b")

plt.xlabel('Iteración')
plt.ylabel('Valor')
plt.title('Ejercicio 1.3a - n = 0,1')

plt.show()

input("\n--- Pulsar tecla para continuar ---\n")

###################################
print("\nApartado b)\n")

eta = 0.01
maxIter = 50
error2get = 0

initial_point = np.array([0.1,0.1])
w1, it1, v1 = printing_gradient_descent(eta, maxIter, error2get, initial_point)

#-------

initial_point = np.array([1.0,1.0])
w2, it2, v2 = printing_gradient_descent(eta, maxIter, error2get, initial_point)

#-------
    
initial_point = np.array([-0.5,-0.5])
w3, it3, v3 = printing_gradient_descent(eta, maxIter, error2get, initial_point)

#-------

initial_point = np.array([-1.0,-1.0])
w4, it4, v4 = printing_gradient_descent(eta, maxIter, error2get, initial_point)

# Pintar ############################
print ('Para [0.1,0.1]')
print ('Numero de iteraciones: ', it1)
print ('Coordenadas obtenidas: (', w1[0], ', ', w1[1], ')')
print ('Valor obtenido: ', v1[-1])

print ('\nPara [1.,1.]')
print ('Numero de iteraciones: ', it2)
print ('Coordenadas obtenidas: (', w2[0], ', ', w2[1], ')')
print ('Valor obtenido: ', v2[-1])

print ('\nPara [-0.5,-0.5]')
print ('Numero de iteraciones: ', it3)
print ('Coordenadas obtenidas: (', w3[0], ', ', w3[1], ')')
print ('Valor obtenido: ', v3[-1])

print ('\nPara [-1.0,-1.0]')
print ('Numero de iteraciones: ', it4)
print ('Coordenadas obtenidas: (', w4[0], ', ', w4[1], ')')
print ('Valor obtenido: ', v4[-1])


plt.figure(4)
plt.plot(v1, color="k", label="0.1")
plt.plot(v2, color="r", label="1.0", alpha=0.7)
plt.plot(v3, color="g", label="-0.5")
plt.plot(v4, color="b", label="-1.0", alpha=0.7)

plt.xlabel('Iteración')
plt.ylabel('Valor')
plt.title('Ejercicio 1.3b - Variando el punto inicial')
plt.legend()

plt.show()

input("\n--- Pulsar tecla para continuar ---\n")

###############################################################################
###############################################################################
###############################################################################
###############################################################################
print("---------------------------------------------------------------------")
print('EJERCICIO SOBRE REGRESION LINEAL\n')
print('Ejercicio 1\n')

label5 = 1
label1 = -1

# Funcion para leer los datos
def readData(file_x, file_y):
	# Leemos los ficheros	
	datax = np.load(file_x)
	datay = np.load(file_y)
	y = []
	x = []	
	# Solo guardamos los datos cuya clase sea la 1 o la 5
	for i in range(0,datay.size):
		if datay[i] == 5 or datay[i] == 1:
			if datay[i] == 5:
				y.append(label5)
			else:
				y.append(label1)
			x.append(np.array([1, datax[i][0], datax[i][1]]))
			
	x = np.array(x, np.float64)
	y = np.array(y, np.float64)
	
	return x, y

# Cálculo del gradiente, derivada de Ein
def dEin(x,y,w):    
    M = len(x)    
    xt = x.transpose()           # Transpuesta de x, para multiplicar
    h = np.dot(w, xt)            # h(x)
    diff = h - y                 # Diferencia
    sumatoria = np.dot(xt, diff)
    
    return np.dot((2/M), sumatoria)     

# Funcion para calcular el error
def Err(x,y,w):
    M = len(x)    
    xt = x.transpose()           # Transpuesta de x, para multiplicar
    h = np.dot(w, xt)            # h(x)
    diff = h - y                 # Diferencia
    sqr = np.dot(diff, diff.transpose())
    sumatoria = np.sum(sqr)    
    
    return np.dot((1/M), sumatoria) 


"""
Gradiente Descendente Estocastico
Argumentos:
  Datos de aprendizaje: X
  Vector de salidas: Y
  Tasa de aprendizaje: eta
  Nº máximo de iteraciones: maxIter
  Tasa de error: error2get
  Punto inicial: initial_point
"""
def sgd(X, Y, eta, maxIter, error2get, initial_point):
    # Variables auxiliares
    surpassedMinError = False    
    minibatch_size = 32
    
    # Iniciamos w
    w = np.copy(initial_point)
      
    # Ordenamos aleatoriamente las muestras
    fullbatch_x, fullbatch_y = shuffle(X, Y, random_state=0)
    
    # Separamos en minibatches
    batches_x = np.array_split(fullbatch_x, np.ceil(len(X) / minibatch_size))
    batches_y = np.array_split(fullbatch_y, np.ceil(len(X) / minibatch_size))
              
    for (minibatch_x, minibatch_y) in zip(batches_x, batches_y):      
      iterations = 0
      
      # Aplicamos el algoritmo a cada minibatch
      while iterations < maxIter and not surpassedMinError:
        error = dEin(minibatch_x, minibatch_y, w)
        gradient = eta * error      
        w = w - gradient           
        
        error = Err(minibatch_x, minibatch_y, w)
        
        # Comprobando salida del bucle
        iterations += 1
        surpassedMinError = True if error < error2get else False
  
      # Devolvemos si hemos alcanzado el error             
      if surpassedMinError:
        return w
      
    return w


# Pseudoinversa	
def pseudoinverse(x,y):
    p_inverse = np.linalg.pinv(x)
    return p_inverse.dot(y)  
  
  
# Lectura de los datos de entrenamiento
x, y = readData('datos/X_train.npy', 'datos/y_train.npy')
# Lectura de los datos para el test
x_test, y_test = readData('datos/X_test.npy', 'datos/y_test.npy')

eta = 0.01 
maxIter = 10000
error2get = 1e-14
initial_point = np.array([1.0,1.0,1.0])

w = sgd(x, y, eta, maxIter, error2get, initial_point)

w_p = pseudoinverse(x, y)

# Pintar ############################
print ('Bondad del resultado para grad. descendente estocastico:\n')
print ("Learning rate: ", eta)
print ("Nº máximo de iteraciones: ", maxIter)
print ("Error mínimo a alcanzar: ", error2get)
print ("Punto inicial: ", initial_point)
print ("------------------------------")
print ("w: ", w)
print ("Ein: ", Err(x,y,w))
print ("Eout: ", Err(x_test, y_test, w))


print ('\n\nBondad del resultado para la pseudoinversa:\n')
print ("w: ", w_p)
print ("Ein: ", Err(x,y,w_p))
print ("Eout: ", Err(x_test, y_test, w_p))

# Gráfica 
plt.figure(5)
a = np.where(y_test==1)
b = np.where(y_test==-1)

plt.scatter(x_test[a][:, 1], x_test[a][:, 2], label="Nº 5", color='goldenrod', edgecolor='k')
plt.scatter(x_test[b][:, 1], x_test[b][:, 2], label="Nº 1", color='g', edgecolor='k')

# Separador dado por el gradiente
lx = np.linspace(-1, 1, 50)
ly = -(w[0] + w[1]*lx) / w[2]

plt.plot(lx, ly, color="b", label="SGD")


# Separador dado por la pseudoinversa
lx = np.linspace(-1, 1, 50)
ly = -(w_p[0] + w_p[1]*lx) / w_p[2]

plt.plot(lx, ly, color="r", label="Pseudoinversa")


axes = plt.gca()
axes.set_xlim([0,0.7])
axes.set_ylim([-8,0])
axes.set_facecolor('darkseagreen')

plt.xlabel('Intensidad')
plt.ylabel('Simetría')
plt.title('Ejercicio 2.1')

plt.legend(loc='upper right', edgecolor='k')

plt.show()

input("\n--- Pulsar tecla para continuar ---\n")

##########################################
##########################################

print('Ejercicio 2\n')
print("Apartado a)\n")
  
  
# Simula datos en un cuadrado [-size,size]x[-size,size]
def simula_unif(N, d, size):
	return np.random.uniform(-size,size,(N,d))


train = simula_unif(1000, 2, 1)

# Pintar ############################
plt.figure(6)
plt.scatter(train[:, 0], train[:, 1], edgecolor='k')

plt.xlabel('Eje X')
plt.ylabel('Eje Y')
plt.title('Ejercicio 2.2a - Mapa de puntos')
plt.show()

input("\n--- Pulsar tecla para continuar ---\n")


#------------ Apartado b
print("Apartado b)\n")

# Función que asigna las etiquetas
# sign(x) = | -1 si x<0
#           |  1 si x>0
def setLabel(x1, x2):
  v = ((x1 - 0.2)**2) + x2**2 - 0.6
  
  return -1 if v < 0 else 1


# Calculamos las etiquetas
labels = np.array([[0,0]])
labels = np.delete(labels, (0), axis=0)

for (a,b) in zip(train[:,0], train[:,1]): 
  labels = np.append(labels, setLabel(a,b))  

# Cambiamos el singo con un 10% de probabilidad
for i, l in enumerate(labels):
  n = np.random.choice(2, 1, p=[0.9, 0.1])
  if n == 1:
    labels[i] = -l     

# Pintar ###############
plt.figure(7)

a = np.where(labels==1)
b = np.where(labels==-1)

plt.scatter(train[a][:, 0], train[a][:, 1], label="-1", color='r', edgecolor='k')
plt.scatter(train[b][:, 0], train[b][:, 1], label="-1", color='g', edgecolor='k')

plt.xlabel('Eje X')
plt.ylabel('Eje Y')
plt.title('Ejercicio 2.2b - Mapa de etiquetas')

plt.legend(loc='upper right', edgecolor='k')

plt.show()

input("\n--- Pulsar tecla para continuar ---\n")

#------------ Apartado c
print("Apartado c)\n")
  
# Añadimos a train la característica con valor 1
c0 = np.full(len(train),1)
puntos = np.copy(train)
train = np.column_stack((c0, train))

eta = 0.01 
maxIter = 10000
error2get = 1e-14
initial_point = np.array([1.0,1.0,1.0])

w = sgd(train, labels, eta, maxIter, error2get, initial_point)


# Pintar ###############
print ('Bondad del resultado para grad. descendente estocastico:\n')
print ("w: ", w)
print ("Ein: ", Err(train, labels, w))


# Gráfica ###############
plt.figure(8)

a = np.where(labels==1)
b = np.where(labels==-1)

plt.scatter(puntos[a][:, 0], puntos[a][:, 1], label="-1", color='crimson', edgecolor='k')
plt.scatter(puntos[b][:, 0], puntos[b][:, 1], label="-1", color='limegreen', edgecolor='k')

# Pintamos la línea
lx = np.linspace(-1, 1, 50)
ly = -(w[0] + w[1]*lx) / w[2]

plt.plot(lx, ly, color="darkorange", linewidth=3)

axes = plt.gca()
axes.set_xlim([-1,1])
axes.set_ylim([-1,1])

plt.xlabel('Eje X')
plt.ylabel('Eje Y')
plt.title('Ejercicio 2.2c - Mapa de etiquetas junto a la recta')

plt.legend(loc='upper right', edgecolor='k')

plt.show()

input("\n--- Pulsar tecla para continuar ---\n")

#------------ Apartado d
print("\nApartado d)\n")
  
# Inicializamos los valores
eout = ein = 0

eta = 0.01 
maxIter = 50
error2get = 1e-14
initial_point = np.array([1.0,1.0,1.0])

for n in range(1000):
  train = simula_unif(1000, 2, 1)
  test = simula_unif(1000, 2, 1)
  
  # Calculamos las etiquetas
  labels = np.array([[0,0]])
  labels = np.delete(labels, (0), axis=0)
  
  for (a,b) in zip(train[:,0], train [:,1]): 
    labels = np.append(labels, setLabel(a,b))

  # Cambiamos el singo con un 10% de probabilidad
  for i, l in enumerate(labels):
    n = np.random.choice(2, 1, p=[0.9, 0.1])
    if n == 1:
      labels[i] = -l 
      
  # Añadimos a train y a test la característica con valor 1
  c0 = np.full(len(train),1)
  train = np.column_stack((c0, train))
  test = np.column_stack((c0, test))
  
  w = sgd(train, labels, eta, maxIter, error2get, initial_point)  

  ein += (Err(train, labels, w) / 1000)
  
  # Calculamos el error fuera de la muestra
  eout += (Err(test, labels, w) / 1000)


# Pintar ###############
print("Ein medio obtenido: ", ein)
print("Eout medio obtenido: ", ein)
  
input("\n--- Pulsar tecla para continuar ---\n")


###############################################################################
###############################################################################
###############################################################################
###############################################################################
print('\nBONUS\n')

def dSecondFxx(x,y):
  return 2 - (8 * (np.pi**2) * np.sin(2*np.pi*y) * np.sin(2*np.pi*x))
  
def dSecondFxy(x,y):
  return 8 * (np.pi**2) * np.cos(2*np.pi*x) * np.cos(2*np.pi*y)
  
def dSecondFyy(x,y):
  return 4 - (8 * (np.pi**2) * np.sin(2*np.pi*x) * np.sin(2*np.pi*y))

def dSecondFyx(x,y):
  return 8 * (np.pi**2) * np.cos(2*np.pi*y) * np.cos(2*np.pi*x)


def hessian_newton(eta, maxIter, initial_guess):        
  # Variables auxiliares
  iterations = 0
  isMin = False
  
  # Inicializamos w
  w = initial_guess.copy()
  values = F(w[0], w[1]) # Donde guardamos los valores
  
  while iterations < maxIter and not isMin:
    # Construimos la matriz Hessiana
    d2fxx = dSecondFxx(w[0], w[1])
    d2fxy = dSecondFxy(w[0], w[1])
    d2fyy = dSecondFyy(w[0], w[1])
    d2fyx = dSecondFyx(w[0], w[1])
    
    
    hessian = np.empty((2,2))
    hessian[0][0] = d2fxx
    hessian[0][1] = d2fxy
    hessian[1][0] = d2fyx
    hessian[1][1] = d2fyy
    
    # La invertimos
    hessian = np.linalg.inv(hessian)
    
    # Calculamos el gradiente
    grad = gradF(w[0], w[1])        
    
    # Actualizamos w
    old_w = w
    w = w - eta * np.dot(hessian, grad)

    # Comprobamos si hemos descendido en el valor de la función  
    descent = abs(F(w[0], w[1]) - F(old_w[0], old_w[1]))                               
    isMin = True if descent == 0 else False
        
    # Guardamos el valor de la función
    values = np.vstack((values, F(w[0], w[1])))      
        
    iterations += 1    
  
  return w, values
  

maxIter = 50
initial_guess = np.array([0.1,0.1])
eta = 1

w, values = hessian_newton(eta, maxIter, initial_guess)

# Pintar ###############
print ('Sin tasa de aprendizaje:')
print ('Coordenadas obtenidas: (', w[0], ', ', w[1], ')')
print ('Valor final: ', F(w[0], w[1]))

plt.figure(9)
plt.plot(values, color="r")

plt.xlabel('Iteración')
plt.ylabel('Valor de la función')
plt.title('Bonus - Sin tasa de aprendizaje')

plt.show()

#######################
eta = 0.1
w, values = hessian_newton(eta, maxIter, initial_guess)

# Pintar ###############
print ('\nCon tasa de aprendizaje:')
print ('Coordenadas obtenidas: (', w[0], ', ', w[1], ')')
print ('Valor final: ', F(w[0], w[1]))

plt.figure(10)
plt.plot(values, color="b")

plt.xlabel('Iteración')
plt.ylabel('Valor de la función')
plt.title('Bonus - Con tasa de aprendizaje')

plt.show()
