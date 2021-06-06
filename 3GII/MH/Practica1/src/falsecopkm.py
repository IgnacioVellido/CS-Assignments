# -*- coding: utf-8 -*-
################################################################################
## Ignacio Vellido Expósito
## 
## Metaheurísticas
## Algoritmo COPKM2 Greedy
################################################################################

################################################################################
# Requisitos

import numpy as np
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
  distances = []

  # Separa datos según clúster
  data_clust = np.ndarray((len(centroids),1))
  for x,y in zip(data, solution):
    np.append(data_clust[y], x)

  for i, cent in enumerate(centroids):
    distances.append(euclidean_distances(data_clust[i], cent, i, solution))

  return distances


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

    iteration = 0
    s = time.process_time()
    stats = []
    while solution_changed:
        # Guardar info de la iteración
        stats.append([iteration, time.process_time() - s, infeasibility(solution, rest_list)])
        print(stats[iteration])
        s = time.process_time()

        iteration += 1
        solution_changed = False

        # ----------------------------------------------------------------------
        # Para cada elemento del conjunto de datos asignarle clúster que 
        # decremente inf

        # Calculando distancias
        distances = distance_intra_cluster(data, centroids, solution)

        # Calcular nuevo clúster para cada entrada
        for index in indexes:
            actual_inf = infeasibility(solution, rest_list)
            changed_inf = actual_inf
            clust_list = []  # Posibles clústers que mejoran la inf
           
            # Recorremos cada clúster
            for i in range(num_clust):
                # Modificamos solución
                solution_modified = solution.copy()
                solution_modified[index] = i

                # Calculamos nueva inf
                new_inf = infeasibility(solution_modified, rest_list)

                # Actualizamos lista de posibles clústers
                if new_inf < actual_inf:
                    actual_inf = new_inf
                    solution_changed = True
                    clust_list = [i]
                elif new_inf == actual_inf:
                    clust_list.append(i)
                
            # Si hay más de un clúster posible, cogemos el de menor distancia
            if solution_changed:
                np.sort(clust_list) # Para evitar ciclos, ordenamos los clústers
                min_distance = np.average(distances[clust_list[0]])
                # print(distances)
                solution[index] = clust_list[0]

                for clust in clust_list:
                    if np.average(distances[clust]) < min_distance:
                        min_distance = np.average(distances[clust])
                        solution[index] = clust

        # ----------------------------------------------------------------------
        # Para cada clúster actualizar su centroide        
        clf.fit(data, solution)
        centroids = clf.centroids_

    # --------------------------------------------------------------------------
    return solution, centroids