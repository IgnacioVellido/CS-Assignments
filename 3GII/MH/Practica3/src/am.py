# -*- coding: utf-8 -*-
################################################################################
## Ignacio Vellido Expósito
## 
## Metaheurísticas
## Algoritmos meméticos
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
# Operador de selección
# ------------------------------------------------------------------------------

def binary_tournament(population, num_tourn):
    results = []

    for _ in range(num_tourn):
        contenders = np.random.choice(len(population), size=2, replace=False)
        contenders = population[contenders]
        results.append(contenders[0] if contenders[0][1] < contenders[1][1] else contenders[1])

    return np.array(results)

# ------------------------------------------------------------------------------
# Operadores de cruce
# ------------------------------------------------------------------------------

def cross_singlePoint(parent1, parent2, size):
    size = len(parent1)
    start = np.random.randint(size/2)
    length = np.random.randint(size/2)    
    end   = (start+length) % size - 1

    child = parent1.copy()
    if end < start:
        child[start:size] = parent2[start:size]
        child[0:end] = parent2[0:end]
    else:
        child[start:end] = parent2[start:end]

    return child

# ------------------------------------------------------------------------------

# Los índices nunca pillan ningun cambio
def cross_uniform(parent1, parent2, size):
    indexes = np.random.choice(size, size=int(size/2), replace=False)

    child = parent1.copy()
    child[indexes] = parent2[indexes]

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

# ------------------------------------------------------------------------------
# Operador de mutación
# ------------------------------------------------------------------------------

def mutation_uniform(chromosome, size, num_clust):
    leave = False

    # Comprobando que no deja ningún clúster vacío
    while not leave:
        new_chromosome = chromosome
        index = np.random.randint(size)
        clust = np.random.randint(num_clust)

        if chromosome[index] != clust:
            new_chromosome[index] = clust        
            leave = check_no_cluster_empty(new_chromosome, num_clust)

    return new_chromosome

################################################################################

def algorithm(data, rest_matrix, rest_list, num_clust, rng, agg=True, uniform=True, amType="10"):
    # --------------------------------------------------------------------------
    # Inicialización -----------------------------------------------------------
    size_solution = len(data)
    # Parámetros
    max_iterations = 100_000
    prob_mutat = 0.001
    prob_cross = 0.7
    population_size = 10
    num_tourn = population_size if agg else 2

    crossovers = int(prob_cross * population_size / 2)
    mutations = int(prob_mutat * population_size * size_solution)

    # Población inicial - Cada cromosoma debe ser válido
    chromosome = None
    population = []

    for i in range(population_size):
        found_initial_solution = False
        while not found_initial_solution:
            chromosome = np.random.randint(0, num_clust, size=len(data))
            found_initial_solution = check_no_cluster_empty(chromosome, num_clust)

        population.append([chromosome, 0])  # Guardaremos también el coste

    # Variables auxiliares -------------------

    # Calculando distancias entre puntos    
    points_distances = distance.cdist(data, data, 'euclidean')

    # Cociente entre valor mayor a la distancia máxima en el conjunto de datos 
    # y el nº de restricciones
    lmbd = np.max(points_distances) / len(rest_list)

    # Generar y evaluar centroides
    clf = NearestCentroid() # Para actualizar los centroides

    actual_cost = 0
    for c, chrom in enumerate(population):
        centroids = clf.fit(data, chrom[0]).centroids_
        cost = objective_function(data, chrom[0], rest_list, centroids, lmbd) # Valor de la función objetivo actual        
        population[c][1] = cost
        actual_cost += cost
 
    actual_cost /= population_size

    # Ordenamos la población
    population = np.array(sorted(population, key=lambda x: x[1]))

    # --------------------------------------------------------------------------
    # Bucle principal ----------------------------------------------------------

    stats = []  # Cálculo de tiempos entre iteración
    iteration = 0 
    ev = 0   # ev corresponde al número de evaluaciones de la función objetivo
    s = time.process_time()    
    while ev < max_iterations:
        # Guardar info de la iteración
        stats.append([iteration, time.process_time() - s, actual_cost])
        # print(stats[iteration], "Evaluciones: ", ev)
        s = time.process_time()
        iteration += 1

        # Vector de flags
        flags = np.zeros(population_size)

        # ----------------------------------------------------------------------
        # Seleccionar ----------------------------------------------------------
        new_population = binary_tournament(population, num_tourn)

        # ----------------------------------------------------------------------
        # Recombinar -----------------------------------------------------------
        for _ in range(crossovers):
            parents = np.random.choice(num_tourn, size=2, replace=False)

            if agg:
                flags[parents[0]] = flags[parents[1]] = 1

            if uniform:
                child1 = cross_uniform(new_population[parents[0]][0], new_population[parents[1]][0], size_solution)
                child2 = cross_uniform(new_population[parents[1]][0], new_population[parents[0]][0], size_solution)
            else:
                child1 = cross_singlePoint(new_population[parents[0]][0], new_population[parents[1]][0], size_solution)
                child2 = cross_singlePoint(new_population[parents[1]][0], new_population[parents[0]][0], size_solution)
            
            child1 = repair(child1, num_clust)
            child2 = repair(child2, num_clust)

            new_population[parents[0]][0] = child1
            new_population[parents[1]][0] = child2

        # ----------------------------------------------------------------------
        # Mutar ----------------------------------------------------------------
        for _ in range(mutations):
            chromosome = np.random.randint(num_tourn)

            if agg and not amType == "10":
                flags[chromosome] = 1

            new_population[chromosome][0] = mutation_uniform(new_population[chromosome][0], size_solution, num_clust)

        # ----------------------------------------------------------------------
        # Optimizar ------------------------------------------------------------
        new_population = np.array(sorted(new_population, key=lambda x: x[1]))

        # Cada 10 iteraciones
        if iteration % 10 == 0:

            # Coger índices de los cromosomas a optimizar
            if amType == "10": # Todos
                flags[:] = 1
                optimization_population = np.arange(population_size)
            elif amType == "01": # 0.1 aleatoriamente
                optimization_population = np.random.choice(population_size, size=int(population_size * 0.1), replace=False)
                flags[optimization_population] = 1
            else: # Los 0.1 mejores
                optimization_population = np.arange(int(0.1*population_size))
                flags[optimization_population] = 1

            # Generar y barajar índices
            indexes = np.arange(len(data))  # Índices

            max_errors = int(size_solution * 0.1)
            
            # Optimizar cromosoma
            for chrom in optimization_population:
                # Barajar índices
                rng.shuffle(indexes)
                errors = 0
                improving = True
                solution = new_population[chrom]

                # BL suave
                for i in indexes:
                    if not improving and errors >= max_errors:
                        break
                    
                    improving = False
                    new_solution = solution[0].copy()

                    # Probamos con todos los clústers posibles
                    for c in range(num_clust):
                        ev += 1
                        new_solution[i] = c
                        centroids = clf.fit(data, new_solution).centroids_
                        new_sol_cost = objective_function(data, new_solution, rest_list, centroids, lmbd)

                        # Cambiamos la solución si mejora
                        if (solution[1] - new_sol_cost) > 1e-2:
                            solution[0][i] = c
                            solution[1] = new_sol_cost
                            improving = True

                    if not improving:
                        errors += 1

        # ----------------------------------------------------------------------
        # Reemplazar -----------------------------------------------------------

        # Se reemplaza enteramente
        if agg:
            # Si la mejor solución de la generación anterior no sobrevive, 
            # Sustituye directamente la peor solución de la nueva población
            if population[0][1] < new_population[0][1]:
                new_population[population_size-1] = population[0]

            population = new_population
        else:
            # Se cambian con los dos peores
            population[-1] = new_population[0]
            population[-2] = new_population[1]
            flags[-1] = flags[-2] = 1

        # ----------------------------------------------------------------------
        # Evaluar  -------------------------------------------------------------
        
        for c, chrom in enumerate(population):
            if flags[c]:
                centroids = clf.fit(data, chrom[0]).centroids_
                f_value = objective_function(data, chrom[0], rest_list, centroids, lmbd) # Valor de la función objetivo actual        
                population[c][1] = f_value

        actual_cost = population[:,1].mean()
        ev += population_size

        # Ordenamos la población
        population = np.array(sorted(population, key=lambda x: x[1]))

    # --------------------------------------------------------------------------
    # Devolver el mejor cromosoma
    solution = population[0][0]

    return solution, centroids, stats