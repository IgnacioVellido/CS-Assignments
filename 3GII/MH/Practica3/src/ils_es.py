# -*- coding: utf-8 -*-
################################################################################
## Ignacio Vellido Expósito
## 
## Metaheurísticas
## Algoritmo de Enfriamiento Simulado Iterativo
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

def anneal(temperature, beta):
    """ Esquema de enfriamiento """
    return temperature / (1 + beta * temperature)

# ------------------------------------------------------------------------------

def generate_neighbor(old_solution, num_clust):
    solution = old_solution.copy()
    cluster_empty = True
    size = len(solution)

    while cluster_empty:
        clust = np.random.randint(0, num_clust, size=1)[0]
        pos   = np.random.randint(0, size, size=1)[0]

        if solution[pos] != clust:
            solution[pos] = clust

            cluster_empty = not check_no_cluster_empty(solution, num_clust)

    return solution

# ------------------------------------------------------------------------------

def metrop(actual_cost, cost, temperature):
    """ Criterio de Metropolis para la aceptación de un vecino """
    diff = actual_cost - cost
    return diff > 1e-4 or np.random.uniform(0,1,1)[0] < np.exp(diff/temperature)

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
    iterations = 10_000
    max_neigh = 10 * len(data)
    max_annealing = round(iterations / max_neigh)  # == M
    max_success = len(data) # == (0.1 * max_neigh)
    mu = phi = 0.3
    min_temperature = 1e-3      # == Tf
    num_success = 0
    executions = 10         # Número de veces a aplicar ES

    # Calculando distancias entre puntos    
    points_distances = distance.cdist(data, data, 'euclidean')

    # Cociente entre valor mayor a la distancia máxima en el conjunto de datos 
    # y el nº de restricciones
    lmbd = np.max(points_distances) / len(rest_list)

    # --------------------------------------------------------------------------
    # Bucle principal ----------------------------------------------------------

    stats = []  # Cálculo de tiempos entre iteración
    iteration = 0 
    i = 0   # i corresponde al número de evaluaciones de la función objetivo
    s = time.process_time()

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

    true_best_solution = solution.copy()
    
    for _ in range(executions):
        # Mutar mejor solución (10% de elementos)
        true_best_solution = mutation_singlePoint(true_best_solution, num_clust)

        # Reparar
        true_best_solution = repair(true_best_solution, num_clust)

        # Preparar siguiente iteración
        solution = true_best_solution.copy()
        best_solution = true_best_solution.copy()

        clf.fit(data, true_best_solution)
        centroids = clf.centroids_
        actual_cost = best_cost = true_best_cost = objective_function(data, solution, rest_list, centroids, lmbd) # Valor de la función objetivo actual

        # Calculando temperatura inicial
        temperature = initial_temperature = (mu * actual_cost) / - np.log(phi)    # == T0
        beta = (initial_temperature - min_temperature) / (max_annealing * initial_temperature * min_temperature)

        for _ in range(max_annealing):
            # Guardar info de la iteración
            stats.append([iteration, time.process_time() - s, actual_cost])
            print(stats[iteration], "\tEvaluaciones: ", i, "\tÉxitos: ", num_success, "\tTemperatura: ", temperature)
            s = time.process_time()

            iteration += 1
            num_success = 0

            # Generación de vecinos para la temperatura actual
            for _ in range(max_neigh):
                # Generamos un nuevo vecino
                new_solution = generate_neighbor(solution, num_clust)
                
                clf.fit(data, new_solution)
                centroids = clf.centroids_

                cost = objective_function(data, new_solution, rest_list, centroids, lmbd)
                i += 1

                # Comprobar si aceptar vecino
                if metrop(actual_cost, cost, temperature):
                    num_success += 1
                        
                    # Actualizar solución actual
                    actual_cost = cost
                    solution = new_solution.copy()

                    # Actualizando mejor solución
                    if (best_cost - actual_cost) > 1e-4:
                        best_cost = actual_cost
                        best_solution = solution.copy()

                # Hemos alcanzado el número máximo de vecinos
                if (num_success >= max_success):
                    break

            # ----------------------------------------------------------------------
            # Si no se consigue ningún éxito o no se consiga ningún éxito
            if num_success == 0:
                break

            # Enfriamiento ---------------------------------------------------------
            temperature = anneal(temperature, beta)
            # temperature *= 0.99


        # Quedarse con la solución si mejora
        if (true_best_cost - best_cost) > 1e-2:
            true_best_cost = best_cost
            true_best_solution = best_solution.copy()
                    
    clf.fit(data, true_best_solution)
    centroids = clf.centroids_

    return true_best_solution, centroids, stats