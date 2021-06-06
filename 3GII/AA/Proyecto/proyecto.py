# -*- coding: utf-8 -*-
"""
PROYECTO FINAL
Nombre Estudiante: Ignacio Vellido Expósito
"""

################################################################################
################################################################################
################################################################################

import numpy as np
import matplotlib.pyplot as plt

# Para lectura de ficheros
import csv

# Para dividir en training y en test
from sklearn.model_selection import train_test_split

# Para estandarizar
from sklearn import preprocessing

# Cross-Validation
from sklearn.model_selection import GridSearchCV

# Random Forest
from sklearn.ensemble import RandomForestClassifier

# Regresión Logística
from sklearn.linear_model import LogisticRegression

# Support Vector Machine
from sklearn.svm import SVC

# Ada Boost
from sklearn.ensemble import AdaBoostClassifier
from sklearn.tree import DecisionTreeClassifier

# Medida de resultados
from sklearn.metrics import confusion_matrix, accuracy_score, log_loss
from sklearn.metrics import roc_auc_score, classification_report, roc_curve

################################################################################
############################    Funciones   ####################################
################################################################################

# Devuelve numpy array con el contenido del archivo
def readCSV(name, delimiter):
  with open(name) as csv_file:
    data_reader = csv.reader(csv_file, delimiter=delimiter)
    
    data = []
    
    for row in data_reader:      
      data.append(row)
    
    return data  
  
# Separa los datos de entrada de la clase
# Elimina la primera fila pues corresponde a los nombres de cada columna
def readData(array):
  x = []
  y = []
    
  for i in range(1, len(array)):
    x.append(array[i][1:-1])
    y.append(array[i][-1])
  
  return x, y
  
# Separa una fecha en sus distintas partes, eliminando año y mes
def convertirFechas(array):
  dias = []    
  horas = []    
  minutos = []    
  segundos = []    
  
  for fecha in array:    
    fecha = fecha.split(" ")
    
    a = fecha[0].split("-")
    b = fecha[1].split(":")
    
    dias.append(a[2])
    horas.append(b[0])
    minutos.append(b[1])
    segundos.append(b[2])
    
  dias = np.array(dias, np.float64)  
  horas = np.array(horas, np.float64)  
  minutos = np.array(minutos, np.float64)  
  segundos = np.array(segundos, np.float64)  
    
  return dias, horas, minutos, segundos

# Devuelve una columna de una matriz
def column(matrix, i):
    return [row[i] for row in matrix]
  
################################################################################
###################   Obtención de los datos   #################################
################################################################################

data = readCSV("./datos/datatraining.txt", ',')
data += readCSV("./datos/datatest.txt", ',')[1::]
data += readCSV("./datos/datatest2.txt", ',')[1::]

data_x, data_y = readData(data)

data_x = np.array(data_x)

################################################################################
######################   Procesado de datos   ##################################
################################################################################

# Separamos la fecha en sus componentes
dias, horas, minutos, segundos = convertirFechas(column(data_x, 0))    

# Aplicamos función seno y coseno
dias_seno = np.sin(dias*(2.*np.pi/30))
dias_coseno = np.cos(dias*(2.*np.pi/30))

horas_seno = np.sin(horas*(2.*np.pi/24))
horas_coseno = np.cos(horas*(2.*np.pi/24))

minutos_seno = np.sin(minutos*(2.*np.pi/60))
minutos_coseno = np.cos(minutos*(2.*np.pi/60))

segundos_seno = np.sin(segundos*(2.*np.pi/60))
segundos_coseno = np.cos(segundos*(2.*np.pi/60))

# Quitamos le fecha y añadimos lo calculado previamente
data_x = data_x[:,1:]
data_x = np.column_stack((data_x, dias_seno))
data_x = np.column_stack((data_x, dias_coseno))

data_x = np.column_stack((data_x, horas_seno))
data_x = np.column_stack((data_x, horas_coseno))

data_x = np.column_stack((data_x, minutos_seno))
data_x = np.column_stack((data_x, minutos_coseno))

data_x = np.column_stack((data_x, segundos_seno))
data_x = np.column_stack((data_x, segundos_coseno))

# Convertimos en array a flotantes
data_x = np.array(data_x, np.float64)
data_y = np.array(data_y, np.float64)

# Guardamos una copia para las gráficas
original_data_x = data_x.copy()
original_data_y = data_y.copy()

################################################################################
##################   Preprocesado de datos   ###################################
################################################################################

# Aplicamos normalización
scaler = preprocessing.StandardScaler().fit(data_x)
data_x = scaler.transform(data_x)


# Separamos en training y test
train_x, test_x, train_y, test_y = train_test_split(data_x, data_y, test_size=0.2)

################################################################################
####################   Ajuste con Random Forest    #############################
################################################################################
# =============================================================================
# print("_____________________________________________")
# print("Ajuste con Random Forest")
# 
# """ En la memoria se incluyen pruebas con un mayor número de parámetros. Puesto
# que el tiempo de cómputo con ellos es bastante más alto, se deja únicamente los
# valores con mejores resultados """
# 
# # Argumentos
# parameters = {
#                'n_estimators': [100, 200],
#                'max_depth': [100, 200]
#              }
# 
# rf = GridSearchCV( estimator  = RandomForestClassifier(),
#                    param_grid = parameters,
#                    cv         = 10,
#                    scoring    = "neg_log_loss"
#                  )         
# 
# # Ajustamos el mejor obtenido
# rf.fit(train_x, train_y) 
# 
# print("\nMejor parámetro: ", rf.best_params_)
# print("Random Forest train error: ", rf.score(train_x, train_y))
# print("Random Forest test error: ", rf.score(test_x, test_y))
# 
# # Cálculo del resto de métricas
# train_predict = rf.predict(train_x)
# test_predict = rf.predict(test_x)
# 
# print("\nRandom Forest train accuracy: ", accuracy_score(train_y, train_predict))
# print("Random Forest test accuracy: ", accuracy_score(test_y, test_predict))
# 
# print("\nRandom Forest train area bajo la curva: ", roc_auc_score(train_y, train_predict))
# print("Random Forest test area bajo curva: ", roc_auc_score(test_y, test_predict))
# 
# print("\n", classification_report(test_y, test_predict, target_names=["No ocupada", "Ocupada"]))
# 
# cm = confusion_matrix(test_y, test_predict)
# print("\nMatriz de confusión:\n", cm)
# 
# # Mostramos el área bajo la curva
# auc = roc_auc_score(test_y, test_predict)
# fpr, tpr, thresholds = roc_curve(test_y, test_predict)
# 
# plt.figure(1)
# plt.plot([0, 1], [0, 1], linestyle='--')
# plt.plot(fpr, tpr, marker='.')
# 
# plt.title("Área bajo la curva en test - Random Forest")
# plt.xlabel("AUC: " + str(auc))
# 
# plt.show()
# 
# input("\n--- Pulsar tecla para continuar ---\n")
# =============================================================================

################################################################################
####################   Ajuste con Regresión Logística   ########################
################################################################################
print("_____________________________________________")
print("Ajuste con Regresión Logística")

# Argumentos
parameters = {
                'C': [1000, 100, 10, 1, 0.1, 0.01, 0.001, 0.001],                       
             }

rl = GridSearchCV( estimator  = LogisticRegression(solver='lbfgs'),
                   param_grid = parameters,
                   cv         = 10,
                   scoring    = "neg_log_loss"                   
                 )         

# Ajustamos el mejor obtenido
rl.fit(train_x, train_y) 

print("\nMejor parámetro: ", rl.best_params_)
print("Regresión logística train: ", rl.score(train_x, train_y))
print("Regresión logística test: ", rl.score(test_x, test_y))

# Cálculo del resto de métricas
train_predict = rl.predict(train_x)
test_predict = rl.predict(test_x)

print("\nRegresión logística train accuracy: ", accuracy_score(train_y, train_predict))
print("Regresión logística test accuracy: ", accuracy_score(test_y, test_predict))
print("\nRegresión logística train area bajo la curva: ", roc_auc_score(train_y, train_predict))
print("Regresión logística test area bajo la curva: ", roc_auc_score(test_y, test_predict))

print("\n", classification_report(test_y, test_predict, target_names=["No ocupada", "Ocupada"]))

cm = confusion_matrix(test_y, test_predict)
print("\nMatriz de confusión:\n", cm)

# Calculo de la cota del error
tol = 0.05
eout = -rl.score(test_x, test_y) + np.sqrt(1 / (2*len(train_x)) * np.log(2/tol))
eout1 = log_loss(test_y, test_predict) + np.sqrt(1 / (2*len(train_x)) * np.log(2/tol))
print(eout)
print(eout1)

# Mostramos el área bajo la curva
auc = roc_auc_score(test_y, test_predict)
fpr, tpr, thresholds = roc_curve(test_y, test_predict)

plt.figure(2)
plt.plot([0, 1], [0, 1], linestyle='--')
plt.plot(fpr, tpr, marker='.')

plt.title("Área bajo la curva en test - Regresión logística")
plt.xlabel("AUC: " + str(auc))

plt.show()

input("\n--- Pulsar tecla para continuar ---\n")

################################################################################
#################   Ajuste con Support Vector Machine   ########################
################################################################################
# =============================================================================
# print("_____________________________________________")
# print("Ajuste con SVM")
# 
# """ Al igual que con RF, esta búsqueda del mejor valor lleva demasiado tiempo
# y se reduce el número de parámetros en el código """
# 
# # Argumentos
# parameters = {
#                 'C': [100, 10],   
#                 'gamma': [0.001, 'auto']  
#              }
# """auto = 1 / nº de características """                 
# 
# svm = GridSearchCV( estimator  = SVC(kernel='rbf'),
#                     param_grid = parameters,
#                     cv         = 10,
#                   )         
# 
# svm.fit(train_x, train_y) 
# 
# print("\nMejores parámetros: ", svm.best_params_)
# print("Support Vector Machine train: ", svm.score(train_x, train_y))
# print("Support Vector Machine test: ", svm.score(test_x, test_y))
# 
# # Cálculo del resto de métricas
# train_predict = svm.predict(train_x)
# test_predict = svm.predict(test_x)
# 
# print("\nSupport Vector Machine train accuracy: ", accuracy_score(train_y, train_predict))
# print("Support Vector Machine test accuracy: ", accuracy_score(test_y, test_predict))
# 
# print("\nSupport Vector Machine train area bajo la curva: ", roc_auc_score(train_y, train_predict))
# print("Support Vector Machine test area bajo la curva: ", roc_auc_score(test_y, test_predict))
# 
# print("\n", classification_report(test_y, test_predict, target_names=["No ocupada", "Ocupada"]))
# 
# print("\nMatriz de confusión:\n", cm)
# cm = confusion_matrix(test_y, test_predict)
# 
# # Mostramos el área bajo la curva
# auc = roc_auc_score(test_y, test_predict)
# fpr, tpr, thresholds = roc_curve(test_y, test_predict)
# 
# plt.figure(3)
# plt.plot([0, 1], [0, 1], linestyle='--')
# plt.plot(fpr, tpr, marker='.')
# 
# plt.title("Área bajo la curva en test - SVM")
# plt.xlabel("AUC: " + str(auc))
# 
# plt.show()
# 
# input("\n--- Pulsar tecla para continuar ---\n")
# 
# ################################################################################
# ####################   Ajuste con Boosting #####################################
# ################################################################################
# print("_____________________________________________")
# print("Ajuste con Boosting")
# 
# """ Al igual que con RF, esta búsqueda del mejor valor lleva demasiado tiempo
# y se reduce el número de parámetros """
# 
# # Argumentos
# parameters = {
#                'n_estimators': [50, 100]
#              }
#              
# 
# ada = GridSearchCV( estimator  = AdaBoostClassifier(DecisionTreeClassifier(max_depth=1)),
#                     param_grid = parameters,
#                     cv         = 10,                                     
#                   )         
# 
# ada.fit(train_x, train_y) 
# 
# print("\nMejores parámetros: ", ada.best_params_)
# print("AdaBoost train: ", ada.score(train_x, train_y))
# print("AdaBoost test: ", ada.score(test_x, test_y))
# 
# # Cálculo del resto de métricas
# train_predict = ada.predict(train_x)
# test_predict = ada.predict(test_x)
# 
# print("\nAdaBoost train accuracy: ", accuracy_score(train_y, train_predict))
# print("AdaBoost test accuracy: ", accuracy_score(test_y, test_predict))
# 
# print("\nAdaBoost train area bajo la curva: ", roc_auc_score(train_y, train_predict))
# print("AdaBoost test area bajo la curva: ", roc_auc_score(test_y, test_predict))
# 
# print("\n", classification_report(test_y, test_predict, target_names=["No ocupada", "Ocupada"]))
# 
# cm = confusion_matrix(test_y, test_predict)
# print("\nMatriz de confusión:\n", cm)
# 
# # Mostramos el área bajo la curva
# auc = roc_auc_score(test_y, test_predict)
# fpr, tpr, thresholds = roc_curve(test_y, test_predict)
# 
# plt.figure(4)
# plt.plot([0, 1], [0, 1], linestyle='--')
# plt.plot(fpr, tpr, marker='.')
# 
# plt.title("Área bajo la curva en test - Boosting")
# plt.xlabel("AUC: " + str(auc))
# 
# plt.show()
# 
# 
# input("\n--- Pulsar tecla para continuar ---\n")
# 
# 
# ################################################################################
# ####################   Cálculos adicionales  ###################################
# ################################################################################
# print("_____________________________________________")
# print("Entrenando regresión lineal con cada característica\n")
# 
# """Podemos ver el efecto de cada característica viendo qué precisión
# conseguimos entrenando solo con ella"""
# 
# copia_train_x = train_x.copy()
# copia_test_x = test_x.copy()
# 
# etiquetas = ["Temperatura", 'Humedad relativa', 'Cantidad de lux', 'CO2', \
#              'Ratio de humedad', 'Días-seno', 'Días-coseno', 'Horas-seno', \
#              'Horas-coseno', 'Minutos-seno', 'Minutos-coseno', \
#              'Segundos-seno', 'Segundos-coseno']
# 
# for i in range(len(copia_train_x[0])):
#   train_x = copia_train_x[:,i]
#   test_x = copia_test_x[:,i]
#   train_x = train_x.reshape(-1, 1)
#   test_x = test_x.reshape(-1, 1)
#   
#   rl = LogisticRegression(C=100, solver='lbfgs')
#   rl.fit(train_x, train_y) 
#   
#   train_predict = rl.predict(train_x)
#   test_predict = rl.predict(test_x)
# 
#   
#   print("\n" + etiquetas[i] + ", train accuracy: ", rl.score(train_x, train_y))
#   print(etiquetas[i] + ", test accuracy: ", rl.score(test_x, test_y))
# =============================================================================
