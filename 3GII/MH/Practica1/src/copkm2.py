# -*- coding: utf-8 -*-
################################################################################
## Ignacio Vellido Expósito
## 
## Metaheurísticas
## Algoritmo COPKM Greedy versión 2
################################################################################

################################################################################
# Requisitos

import time
import numpy as np
from sklearn.neighbors import NearestCentroid
from sklearn.metrics import euclidean_distances

################################################################################
# Funciones auxiliares

# rest_list: Lista de restricciones
def infeasibility2(solution, rest_list):
    "Calcula infeasibility a partir de una solución"
    inf = 0

    for rest in rest_list:
        if rest[2] == 1 and (solution[rest[0]] != solution[rest[1]]):
            inf += 1
        elif rest[2] == -1 and (solution[rest[0]] == solution[rest[1]]):
            inf += 1
  
    return inf

def infeasibility(solution, rest_list):
    "No suma las Must-Link de elementos aún no asignados"
    inf = 0

    for rest in rest_list:
        if rest[2] == 1 and (solution[rest[0]] != solution[rest[1]]) and (solution[rest[0]] != -1) and (solution[rest[1]] != -1):
            inf += 1
        elif rest[2] == -1 and (solution[rest[0]] == solution[rest[1]]) and (solution[rest[0]] != -1) and (solution[rest[1]] != -1):
            inf += 1
  
    return inf

# ------------------------------------------------------------------------------

def euclidean_distances2(data_clust, centroid_matrix, centroid_id, solution):
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
        distances.append(euclidean_distances2(data_clust[i], cent, i, solution))

    return distances


def check_no_cluster_empty(solution, num_clust):
    """ Devuelve false si algún clúster queda vacío """
    # Lista de clústers para comprobar si están todos en un vecino
    list_clust = set(range(num_clust))

    # Comprobar si no deja ningún clúster vacio
    return list_clust.issubset(set(solution))

################################################################################
# Algoritmo

def algorithm(data, rest_matrix, rest_list, num_clust, rng):
    """
        - rng: Variable Random
        - num_clust: Número de clústers del problema
    """
    # --------------------------------------------------------------------------
    # Variables auxiliares -----------------------------------------------------

    solution_changed = True    # Indica si la solución ha cambiado en esa iteración
    solution = np.random.randint(0, num_clust, size=len(data))

    indexes = np.arange(len(data))  # Índices

    # --------------------------------------------------------------------------
    # Generar centroides -------------------------------------------------------

    clf = NearestCentroid() # Para actualizar los centroides
    clf.fit(data, solution)
    centroids = clf.centroids_

    # --------------------------------------------------------------------------
    # Barajando índices --------------------------------------------------------

    rng.shuffle(indexes)

    # --------------------------------------------------------------------------
    # Mientras cambie el conjunto de clústers ----------------------------------

    stats = []  # Calculo de tiempos entre iteración
    iteration = 0
    old_solution = []
    s = time.process_time()
    while solution_changed:
        # Guardar info de la iteración
        stats.append([iteration, time.process_time() - s, infeasibility(solution, rest_list)])
        print(stats[iteration])
        s = time.process_time()
        
        iteration += 1
        solution_changed = False     

        # ----------------------------------------------------------------------
        # Para cada elemento del conjunto de datos asignarle clúster más cercano
        # que menos aumente inf

        # Calcular nuevo clúster para cada entrada
        for z, index in enumerate(indexes):
            clust_list = []  # Posibles clústers que mejoran la inf
            inf = len(rest_list)
           
            # Recorremos cada clúster
            for i in range(num_clust):
                # Modificamos solución
                solution_modified = solution.copy()
                solution_modified[index] = i

                if not check_no_cluster_empty(solution, num_clust):
                    break

                # Calculamos nueva inf
                new_inf = infeasibility(solution_modified, rest_list)

                # Actualizamos lista de posibles clústers
                if new_inf < inf:
                    inf = new_inf
                    clust_list = [i]
                elif new_inf == inf:
                    clust_list.append(i)
                
            # ------------------------------------------------------------------
            # Si hay más de un clúster posible, cogemos el de menor distancia --
            np.sort(clust_list) # Para evitar ciclos, ordenamos los clústers

            distances = [euclidean_distances(centroids[c].reshape(1,-1), 
                        data[index].reshape(1,-1)) for c in clust_list]
            distances = np.array(distances).reshape((len(distances)))

            if len(distances):
                min_distance = np.where(distances == distances.min())
                solution[index] = clust_list[min_distance[0][0]]

        # ----------------------------------------------------------------------
        # Para cada clúster actualizar su centroide        
        clf.fit(data, solution)
        centroids = clf.centroids_

        if not np.array_equal(solution, old_solution) and check_no_cluster_empty(solution, num_clust):
            old_solution = solution.copy()
            solution_changed = True

    # --------------------------------------------------------------------------
    return old_solution, centroids, stats