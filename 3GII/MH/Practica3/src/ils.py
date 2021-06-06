# -*- coding: utf-8 -*-
################################################################################
## Ignacio Vellido Expósito
## 
## Metaheurísticas
## Algoritmo de Búsqueda Local Iterativa
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

# ------------------------------------------------------------------------------

def check_no_cluster_empty(solution, num_clust):
    """ Devuelve false si algún clúster queda vacío """
    # Lista de clústers para comprobar si están todos en un vecino
    list_clust = set(range(num_clust))

    # Comprobar si no deja ningún clúster vacio
    return list_clust.issubset(set(solution))

# ------------------------------------------------------------------------------

def get_solution(solution, neighbor):
    """ Devuelve la solución asociada a un vecino virtual """
    new_solution = np.copy(solution)    
    new_solution[neighbor[0]] = neighbor[1]    
    return new_solution


# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

def mutation_singlePoint(solution, num_clust):
    size = len(solution)
    start = np.random.randint(size/2)
    length = int(0.1 * size)    # 10% de los elementos
    end   = (start+length) % size

    child = solution.copy()
    if end < start:
        child[start:size] = np.random.randint(0, num_clust, size=size-start)    # Últimos elementos
        child[0:end] = np.random.randint(0, num_clust, size=end)                # Primeros elementos
    else:
        child[start:end] = np.random.randint(0, num_clust, size=length)

    return child

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

################################################################################
# Algoritmo

def algorithm(data, rest_matrix, rest_list, num_clust, rng, agg=True, uniform=True, amType="10"):
    """
        - rng: Variable Random
        - num_clust: Número de clústers del problema
    """
    # --------------------------------------------------------------------------
    # Parámetros del algoritmo -------------------------------------------------
    executions = 10         # Número de veces a aplicar BL
    evaluations = 10_000

    # Calculando distancias entre puntos    
    points_distances = distance.cdist(data, data, 'euclidean')

    # Cociente entre valor mayor a la distancia máxima en el conjunto de datos 
    # y el nº de restricciones
    lmbd = np.max(points_distances) / len(rest_list)
    
    # Creando todas los posibles vecinos virtuales (index -> clust) de una solución
    aux = list(range(len(data)))    
    aux2 = list(range(num_clust))
    neigh = np.array(np.meshgrid(aux, aux2)).T.reshape(-1,2)
    
    # --------------------------------------------------------------------------
    # Bucle principal ----------------------------------------------------------

    stats = []  # Calculo de tiempos entre iteración
    iteration = 0 
    i = 0   # i corresponde al número de evaluaciones de la función objetivo
    s = time.process_time() 

    # Inicializar BL -----------------------------------
    # Solución inicial - Debe ser válida
    found_initial_solution = False
    solution = None
    while not found_initial_solution:
        solution = np.random.randint(0, num_clust, size=len(data))
        found_initial_solution = check_no_cluster_empty(solution, num_clust)

    # Generar centroides
    clf = NearestCentroid() # Para actualizar los centroides
    clf.fit(data, solution)
    centroids = clf.centroids_

    # Variables auxiliares    
    actual_cost = objective_function(data, solution, rest_list, centroids, lmbd) # Valor de la función objetivo actual

    best_solution = solution.copy()
    best_cost = actual_cost

    for _ in range(executions):
        i = 0
        upgrade_found = True    # Si ha encontrado mejora

        # Mutar mejor solución (10% de elementos)
        best_solution = mutation_singlePoint(best_solution, num_clust)

        # Reparar
        best_solution = repair(best_solution, num_clust)

        # Preparar siguiente iteración
        solution = best_solution.copy()

        clf.fit(data, best_solution)
        centroids = clf.centroids_
        actual_cost = best_cost = objective_function(data, solution, rest_list, centroids, lmbd) # Valor de la función objetivo actual

        # Algoritmo de BL -----------------------------------
        while i < evaluations and upgrade_found:
            # Guardar info de la iteración
            stats.append([iteration, time.process_time() - s, actual_cost])
            print(stats[iteration], "Evaluciones: ", i)
            s = time.process_time()

            iteration += 1
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
                i += 1

                # Si mejora el coste
                if (actual_cost - cost) > 1e-2:
                    actual_cost = cost
                    solution = new_solution.copy()
                    upgrade_found = True
                    break

        # Quedarse con la solución si mejora
        if (best_cost - actual_cost) > 1e-2:
            best_cost = actual_cost
            best_solution = solution.copy()
            

    clf.fit(data, best_solution)
    centroids = clf.centroids_

    return best_solution, centroids, stats