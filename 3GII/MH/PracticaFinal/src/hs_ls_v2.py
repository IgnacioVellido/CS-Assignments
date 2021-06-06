# -*- coding: utf-8 -*-
################################################################################
## Ignacio Vellido Expósito
## 
## Metaheurísticas
## Harmony Search - LS v2
################################################################################

################################################################################
# Requisitos

import time
import numpy as np
from scipy.spatial import distance
from sklearn.neighbors import NearestCentroid

################################################################################
# Funciones auxiliares

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
    # Separa datos según clúster
    data_clust = []
    for c in range(len(centroids)):
        indexes = np.where(solution == c)
        data_clust.append(data[indexes])

    # Calcular distancias
    distances = []
    for i, cent in enumerate(centroids):
        distances.append(euclidean_distances(data_clust[i], cent, i, solution))

    return distances

# ------------------------------------------------------------------------------

def desv_c(data, solution, centroids):
    # Distancia en cada clúster
    distances = distance_intra_cluster(data, centroids, solution)
    avg = 0

    for dist in distances:
        avg += np.average(dist)

    return avg / len(distances)

# ------------------------------------------------------------------------------

def objective_function(data, solution, rest_list, centroids, lmbd):
    return desv_c(data, solution, centroids) + (lmbd * infeasibility(solution, rest_list))

# ------------------------------------------------------------------------------

def check_no_cluster_empty(solution, num_clust):
    """ Devuelve false si algún clúster queda vacío """
    # Lista de clústers para comprobar si están todos en un vecino
    list_clust = set(range(num_clust))

    # Comprobar si no deja ningún clúster vacio
    return list_clust.issubset(set(solution))

# ------------------------------------------------------------------------------

def repair(child, num_clust):
    """ Comprueba si deja clúster vacío y repara en ese caso """
    # Lista de clústers para comprobar si están todos en un vecino
    list_clust = set(range(num_clust))

    # Comprobar si no deja ningún clúster vacio
    if not list_clust.issubset(set(child)):
        # Añadir cada cluster que falta a una posición aleatoria
        clust = list_clust - set(child)
        for c in clust:
            index = np.random.randint(len(child))
            child[index] = c

    return child            

# ------------------------------------------------------------------------------
# Ajuste de tono
# ------------------------------------------------------------------------------

def pitch_adjustment(note, num_clust):
    """ Devuelve una nota distinta de la pasada como argumento """
    clusters = [x for x in range(num_clust)]
    clusters.remove(note)

    return np.random.choice(clusters, size=1)

################################################################################

def algorithm(data, rest_matrix, rest_list, num_clust, rng, agg=True, uniform=True, amType="10"):
    # --------------------------------------------------------------------------
    # Inicialización -----------------------------------------------------------
    size_solution = len(data)
    # Parámetros
    max_iterations = 10_000
    hmcr = 0.5
    hms = 12
    par = 0.01

    # HM - Cada armonía debe ser válida
    harmony = None
    hm = []

    for i in range(hms):
        found_initial_solution = False
        while not found_initial_solution:
            harmony = np.random.randint(0, num_clust, size=len(data))
            found_initial_solution = check_no_cluster_empty(harmony, num_clust)

        hm.append([harmony, 0])  # Guardaremos también el coste

    # Variables auxiliares -------------------

    # Calculando distancias entre puntos    
    points_distances = distance.cdist(data, data, 'euclidean')

    # Cociente entre valor mayor a la distancia máxima en el conjunto de datos 
    # y el nº de restricciones
    lmbd = np.max(points_distances) / len(rest_list)

    # Generar y evaluar centroides
    clf = NearestCentroid() # Para actualizar los centroides

    actual_cost = 0
    for c, harmony in enumerate(hm):
        centroids = clf.fit(data, harmony[0]).centroids_
        cost = objective_function(data, harmony[0], rest_list, centroids, lmbd) # Valor de la función objetivo actual        
        hm[c][1] = cost
        actual_cost += cost
 
    actual_cost /= hms

    # Ordenamos la HM por coste
    hm = np.array(sorted(hm, key=lambda x: x[1]))

    # --------------------------------------------------------------------------
    # Bucle principal ----------------------------------------------------------

    stats = []  # Cálculo de tiempos entre iteración
    iteration = 0 
    s = time.process_time()    
    while iteration < max_iterations:
        # Guardar info de la iteración
        stats.append([iteration, time.process_time() - s, actual_cost])
        if not (iteration % 500):
            print(stats[iteration], hm[-1][1])

            # Si no hay mejoras en las últimas 3000 iteraciones, salir        
            if iteration > 3000 and stats[-3000][2] - stats[-1][2] < 1e-10:
                print(np.std([row[2] for row in stats[-10:]]))
                print(stats[-1000][2] - stats[-1][2])
                break

        s = time.process_time()
        iteration += 1

        # ----------------------------------------------------------------------
        # Improvisar armonía ---------------------------------------------------

        new_harmony = np.zeros(size_solution)

        for i in range(size_solution):
            if np.random.uniform() < hmcr:
                # Elegir una nota ya existente
                pos = np.random.choice(hms, size=1)[0]
                new_harmony[i] = hm[pos][0][i]

                # --------------------------------------------------------------
                # Ajuste de tono -----------------------------------------------
                if np.random.uniform() < par:
                    new_harmony[i] = pitch_adjustment(new_harmony[i], num_clust)

            else:
                # Seleccionar una aleatoria
                new_harmony[i] = np.random.randint(num_clust)
            
        
        # Reparar armonía si no es válida
        if check_no_cluster_empty(new_harmony, num_clust):
            new_harmony = repair(new_harmony, num_clust)
        

        new_harmony = [new_harmony, 0]

        # ----------------------------------------------------------------------
        # Evaluar  -------------------------------------------------------------
        
        centroids = clf.fit(data, new_harmony[0]).centroids_
        f_value = objective_function(data, new_harmony[0], rest_list, centroids, lmbd) # Valor de la función objetivo actual        
        new_harmony[1] = f_value
                
        # ----------------------------------------------------------------------
        # Reemplazar -----------------------------------------------------------
        
        if hm[-1][1] > new_harmony[1]:
            hm[-1] = new_harmony

        actual_cost = hm[:,1].mean()

        # Ordenamos la población
        hm = np.array(sorted(hm, key=lambda x: x[1]))

        # ----------------------------------------------------------------------
        # Ajustar hiperparámetros
        # Disminuir par
        parMin = 0.01
        parMax = 0.99
        parDiff = parMax - parMin
        par = parMin + ((parDiff / max_iterations) * (max_iterations - iteration))

        # Incremetar hmcr
        hmcrMin = 0.5
        hmcrMax = 0.95
        hmcrDiff = hmcrMax - hmcrMin
        hmcr = hmcrMin + ((hmcrDiff / max_iterations) * (iteration))


    # --------------------------------------------------------------------------
    # Devolver la mejor armonía
    solution = hm[0][0]
    centroids = clf.fit(data, solution).centroids_
    actual_cost = hm[0][1]

    # --------------------------------------------------------------------------    
    # Búsqueda local

    # Creando todas los posibles vecinos virtuales (index -> clust) de una solución
    aux = list(range(len(solution)))    
    aux2 = list(range(num_clust))
    neigh = np.array(np.meshgrid(aux, aux2)).T.reshape(-1,2)

    iteration -= 1
    iterations = 30_000
    upgrade_found = True
    ev = 0   # i corresponde al número de evaluaciones de la función objetivo
    s = time.process_time()    
    while ev < iterations and upgrade_found:
        # Guardar info de la iteración
        stats.append([iteration, time.process_time() - s, actual_cost])
        s = time.process_time()
        if not ev % 20:
            print(stats[iteration], "Evaluciones: ", ev)

        iteration += 1
        ev += 1
        upgrade_found = False

        # Generar y barajar vecindario virtual
        neighborhood = generate_neighbors(neigh, solution, num_clust)
        rng.shuffle(neighborhood)

        for neighbor in neighborhood:
            # Calculamos solución que se genera con este vecino
            new_solution = get_solution(solution, neighbor)            
            clf.fit(data, new_solution)
            centroids = clf.centroids_

            cost = objective_function(data, new_solution, rest_list, centroids, lmbd)
            ev += 1

            # Si mejora el coste
            if (actual_cost - cost) > 1e-3:
                actual_cost = cost
                solution = new_solution.copy()
                upgrade_found = True
                break

    return solution, centroids, stats

# ------------------------------------------------------------------------------

def get_solution(solution, neighbor):
    """ Devuelve la solución asociada a un vecino virtual """
    new_solution = np.copy(solution)    
    new_solution[neighbor[0]] = neighbor[1]    
    return new_solution


def generate_neighbors(neighborhood, solution, num_clust):
    keep = np.zeros(len(neighborhood), dtype=bool)
    
    for pos, n in enumerate(neighborhood):        
        # No incluír los presentes en la solución actual
        if not solution[n[0]] == n[1]:
            new_solution = get_solution(solution, n)

            # Si no deja ningún clúster vacío, incluirlo        
            if check_no_cluster_empty(new_solution, num_clust):
                keep[pos] = True

    index = np.where(keep)
    neighborhood = neighborhood[index]

    return neighborhood