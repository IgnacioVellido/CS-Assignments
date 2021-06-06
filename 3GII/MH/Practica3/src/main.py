# -*- coding: utf-8 -*-
################################################################################
## Ignacio Vellido Expósito
## 
## Metaheurísticas
################################################################################

################################################################################
# Requisitos

import sys
import time
import random
import os.path
import argparse
import numpy as np
import matplotlib.pyplot as plt
from scipy.spatial import distance

################################################################################
# Funciones

# rest_list: Lista de restricciones
def infeasibility(solution, rest_list):
    "Calcula infeasibility a partir de una solución"
    inf = 0

    for rest in rest_list:
        if rest[2] == 1 and (solution[rest[0]] != solution[rest[1]]):
          inf += 1
        elif rest[2] == -1 and (solution[rest[0]] == solution[rest[1]]):
            inf += 1
    
    return inf

# ------------------------------------------------------------------------------

def euclidean_distances(data_clust, centroid_matrix, centroid_id, solution):
    """ Distancia euclídea de los elementos de un clúster a su centroide """
    distances = [np.linalg.norm(x-centroid_matrix) for x in data_clust]    
    return np.mean(distances)

# ------------------------------------------------------------------------------

def distance_intra_cluster(data, centroids, solution):
    distances = []

    # Separa datos según clúster
    data_clust = []
    for c in range(len(centroids)):
        indexes = np.where(solution == c)
        data_clust.append(data[indexes])

    for i, cent in enumerate(centroids):
        distances.append(euclidean_distances(data_clust[i], cent, i, solution))

    return distances


# ------------------------------------------------------------------------------

def desv_c(data, solution, centroids):
    distances = distance_intra_cluster(data, centroids, solution)
    avg = 0

    for dist in distances:
        avg += np.average(dist)

    return avg / len(distances)

# ------------------------------------------------------------------------------

def objective_function2(desvC, inf, lmbd):
    return desvC + (lmbd * inf)

################################################################################
# Recibiendo argumentos

argparser = argparse.ArgumentParser(
    formatter_class=argparse.RawDescriptionHelpFormatter
)
argparser.add_argument( # Algoritmo
  "-a", required=True, help="Algoritmo a utilizar (copkm, bl)"
)
argparser.add_argument( # Problema
  "-p", required=True, help="Problema a ejecutar (iris10, ecoli20...)"
)
argparser.add_argument( # Semilla
  "-s", default=None, help="Archivo que contiene la semilla"
)
argparser.add_argument( # Semilla
  "-ss", default=None, help="Valor de la semilla"
)

args = argparser.parse_args()

################################################################################
# Eligiendo qué algoritmo utilizar

ag = None
uniform = None
amType = None

if args.a == "copkm":
  print("Ejecutando algoritmo COPKM\n")
  from copkm import *
elif args.a == "copkm2":
  print("Ejecutando algoritmo COPKM\n")
  from copkm2 import *
elif args.a == "bl":
  print("Ejecutando algoritmo de Búsqueda Local\n")
  from bl import *
# ===================================================
elif args.a == "aggun":
  print("Ejecutando algoritmo AGG-UN\n")
  from ag import *
  ag = True
  uniform = True
# ---------------------------------------------
elif args.a == "aggsf":
  print("Ejecutando algoritmo AGG-SF\n")
  from ag import *
  ag = True
  uniform = False
# ---------------------------------------------
elif args.a == "ageun":
  print("Ejecutando algoritmo AGE-UN\n")
  from ag import *
  ag = False
  uniform = True
# ---------------------------------------------
elif args.a == "agesf":
  print("Ejecutando algoritmo AGE-SF\n")
  from ag import *
  ag = False
  uniform = False
# ---------------------------------------------
# ---------------------------------------------
elif args.a == "am10":
  print("Ejecutando algoritmo AM10\n")
  from am import *
  ag = True
  uniform = True
  amType = "10"
# ---------------------------------------------
elif args.a == "am01":
  print("Ejecutando algoritmo AM01\n")
  from am import *
  ag = True
  uniform = True
  amType = "01"
# ---------------------------------------------
elif args.a == "am01mej":
  print("Ejecutando algoritmo AM01mej\n")
  from am import *
  ag = True
  uniform = True
  amType = "01mej"
# ===================================================
elif args.a == "es":
  print("Ejecutando algoritmo de Enfriamiento Simulado\n")
  from es import *
# ---------------------------------------------
elif args.a == "bmb":
  print("Ejecutando algoritmo de Búsqueda Multiarranque Básica\n")
  from bmb import *
# ---------------------------------------------
elif args.a == "ils":
  print("Ejecutando algoritmo de Búsqueda Local Reiterada\n")
  from ils import *
  annealing = False
# ---------------------------------------------
elif args.a == "ils-es":
  print("Ejecutando algoritmo de Búsqueda Local Reiterada con ES\n")
  from ils_es import *
# ===================================================
else:
  print("El algoritmo especificado no es correcto")
  sys.exit()

################################################################################
# Leyendo semilla desde archivo si solicitado

if args.s:
  f = open(args.s)
  seed = int(np.loadtxt(f))
elif args.ss:
  seed = int(args.ss)
else:
  seed = random.randrange(2**32 - 1)

rng = random.Random(seed)
np.random.seed(seed)

################################################################################
# Leyendo datos

data_file = rest_file = ""

if "iris" in args.p:
  data_file = "./data/iris_set.dat"
  num_clust = 3
  if "10" in args.p:
    rest_file = "./data/iris_set_const_10.const"
  else:
    rest_file = "./data/iris_set_const_20.const"

elif "ecoli" in args.p:
  data_file = "./data/ecoli_set.dat"
  num_clust = 8
  if "10" in args.p:
    rest_file = "./data/ecoli_set_const_10.const"
  else:
    rest_file = "./data/ecoli_set_const_20.const"

elif "rand" in args.p:
  data_file = "./data/rand_set.dat"
  num_clust = 3
  if "10" in args.p:
    rest_file = "./data/rand_set_const_10.const"
  else:
    rest_file = "./data/rand_set_const_20.const"

elif "new" in args.p:
  data_file = "./data/newthyroid_set.dat"
  num_clust = 3
  if "10" in args.p:
    rest_file = "./data/newthyroid_set_const_10.const"
  else:
    rest_file = "./data/newthyroid_set_const_20.const"

else:
  print("El problema especificado no es correcto")
  sys.exit()

# Leyendo archivo de datos
f = open(data_file)
data = np.loadtxt(f,delimiter=",")

# Leyendo archivo de restricciones
f = open(rest_file)
rest_matrix = np.loadtxt(f,delimiter=",", dtype="int8")

# Pasar matriz de restricciones a lista
rest_list = []
for i in range(0,len(rest_matrix[0])):
  for j in range(i+1, len(rest_matrix[0])):
    if rest_matrix[i,j] != 0:
      rest_list.append([i,j,rest_matrix[i,j]])

rest_list = np.array(rest_list)

################################################################################
# Ejecutando algoritmo

print("[Iteración, Tiempo, Agregado]")

start = time.process_time()
solution, centroids, stats = algorithm(data, rest_matrix, rest_list, num_clust, 
                                        rng, ag, uniform, amType)
t_elapsed = time.process_time() - start

################################################################################
# Calcular medidas

c_measure = desv_c(data, solution, centroids)
inf = infeasibility(solution, rest_list)

# Calculando distancias entre puntos    
points_distances = distance.cdist(data, data, 'euclidean')

# Cociente entre valor mayor a la distancia máxima en el conjunto de datos 
# y el nº de restricciones
lmbd = np.max(points_distances) / len(rest_list)

agregado = objective_function2(c_measure, inf, lmbd)

################################################################################
# Imprimiendo resultados

print("Semilla:\t{}" .format(seed))
print("Solución:\t{}".format(solution))
print("Tasa_C:\t\t{}".format(c_measure))
print("Tasa_inf:\t{}".format(inf))
print("Agregado:\t{}".format(agregado))
print("Tiempo:\t\t{}".format(t_elapsed))

################################################################################
# Mostrando gráficas

data_clust = []
for c in range(len(centroids)):
    indexes = np.where(solution == c)
    data_clust.append(data[indexes])

# Scatter de las dos primeras dimensiones
fig, ax = plt.subplots()
for dc in data_clust:
  ax.scatter([d[0] for d in dc], [d[1] for d in dc])

for c in centroids:
  ax.scatter(c[0], c[1])

plt.title(rest_file[7:-6])
plt.savefig("../doc/img/"+args.a+"/"+rest_file[7:-6]+"_"+str(seed)+"_clust")
plt.show()

# Gráfica de tiempo por iteración
fig, ax = plt.subplots()

ax.plot([i[0] for i in stats[1:]], [i[1] for i in stats[1:]], linestyle='--', marker='o')
ax.set_xlabel("Iteraciones")
ax.set_ylabel("Tiempo (s)")

plt.title(rest_file[7:-6])
plt.savefig("../doc/img/"+args.a+"/"+rest_file[7:-6]+"_"+str(seed)+"_time")
plt.show()

# Decremento de la función objetivo por iteración
fig, ax = plt.subplots()

ax.plot([i[0] for i in stats[1:]], [i[2] for i in stats[1:]], linestyle='--', marker='o', color="g")
ax.set_xlabel("Iteraciones")
ax.set_ylabel("Función objetivo")

plt.title(rest_file[7:-6])
plt.savefig("../doc/img/"+args.a+"/"+rest_file[7:-6]+"_"+str(seed)+"_cost")
plt.show()