# -*- coding: utf-8 -*-
# Practica 0 - Ignacio Vellido Expósito

import numpy as np
from sklearn import datasets     # Para leer iris
import matplotlib.pyplot as plt  # Para imprimir

# Importando iris y cogiendo las dos últimas caracterísiticas
iris = datasets.load_iris()
X = iris.data[:, -2::]  # Datos de entrada
Y = iris.target         # Clases

# Parte 1 ---------------------------------------------------------------

pt_x = X[:, 0]  # Coordenadas en el eje x
pt_y = X[:, 1]  # Coordenadas en el eje y

clases = list(set(Y))
colores = ['red', 'green', 'blue']  # Lista de colores
etiquetas = iris.target_names

# Imprimir los datos 

# Crear figura 1 para esta parte de la práctica
plt.figure(1)

# Para cada clase hacemos un scatter, cogiendo solo los puntos pertenecientes
# a esa clase, y añadiéndole uno de los colores pedidos junto a la etiqueta
for i, valor in enumerate(clases):
    xi = [pt_x[j] for j  in range(len(pt_x)) if Y[j] == valor]
    yi = [pt_y[j] for j  in range(len(pt_x)) if Y[j] == valor]
    plt.scatter(xi, yi, c=colores[i], label=etiquetas[i], edgecolor='k')
    

plt.xlabel('Eje X')
plt.ylabel('Eje Y')
plt.title('Parte 1')

plt.legend()

plt.show()

# Parte 2 ---------------------------------------------------------------
# He creado solamento un array de puntos para test y otro para training

# Separamos los datos por su clase en arrays diferentes
num_clases = np.amax(Y)   # Suponemos que las clases están numeradas de 0 al
                          # máximo identificador de clase
clases = [X[Y==i] for i in range(num_clases+1)]

# Creamos arrays donde separar los datos con una fila de ceros
train = np.array([[0,0,0]])
test = np.array([[0,0,0]])

# Eliminamos la primera fila
train = np.delete(train, (0), axis=0)
test = np.delete(test, (0), axis=0)

# Separamos cada conjunto de datos en dos partes y los concatenamos
for i, c in enumerate(clases):   
    # Ordenamos de forma aleatoria el vector
    np.random.shuffle(c)
    
    # Separamos la clase
    entrenamiento, comprobacion = np.split(c, [int(.8*len(c))])        
    
    # Añadimos una columna con el identificador de la clase
    id_clase = np.full((len(entrenamiento),1), i)            
    entrenamiento = np.column_stack((entrenamiento,id_clase))
    
    id_clase = np.full((len(comprobacion),1), i)
    comprobacion = np.column_stack((comprobacion,id_clase))
    
    # Las concatenamos con el resto de train/test
    train = np.concatenate((train, entrenamiento))
    test = np.concatenate((test, comprobacion))
    
# =============================================================================
#     # Descomentar para ver la separación por clase
#     print("\nTrain clase ", i, ": ---------------")
#     print(entrenamiento, "\n")
#     print("Test clase ", i, ": ----------------")
#     print(comprobacion, "\n")
#     print("Num_elementos train: ", len(entrenamiento))
#     print("Num_elementos test: ", len(comprobacion))
#     print("-----------------------------------")    
# =============================================================================

print("-----------------------------------")
print("LEYENDA: <nº de la tupla> - [punto_x, punto_y, clase]")

print("\nTrain: ---------------")
for i, t in enumerate(train):
  print(i, "-\t", t)

print("-----------------------------------")    

print("Test: ----------------")
for i, t in enumerate(test):
  print(i, "-\t", t)
  
print("-----------------------------------")      
print("Num_elementos train: ", len(train))
print("Num_elementos test: ", len(test))
print("-----------------------------------")    


    
# Parte 3 --------------------------------------------------------------

# Crear figura 2
plt.figure(2)

# Obtenemos los valores
datos = np.linspace(start=0, stop=(2*np.pi), num=100)

# Calculamos las funciones
sin = np.sin(datos)
cos = np.cos(datos)
sincos = sin + cos

# Pintamos cada una
plt.plot(sin, 'b--', label='sin(x)')
plt.plot(cos, 'r--', label='cos(x)')
plt.plot(sincos, 'g--', label='sin(x) + cos(x)')

plt.xlabel('Eje X')
plt.ylabel('Eje Y')
plt.title('Parte 3')

plt.legend()

plt.show()
