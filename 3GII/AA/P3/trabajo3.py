# -*- coding: utf-8 -*-
"""
TRABAJO 3
Nombre Estudiante: Ignacio Vellido Expósito
"""
import numpy as np
import matplotlib.pyplot as plt

# Para lectura de ficheros
import csv

# Para dividir en training y en test
from sklearn.model_selection import train_test_split

# Para reducir dimensionalidad
from sklearn.decomposition import PCA

# Para normalizar
from sklearn import preprocessing

# SGD
from sklearn.linear_model import SGDClassifier

# Cross-Validation
from sklearn.model_selection import cross_val_score

# Matriz de confusión
from sklearn.metrics import confusion_matrix

# Regresión lineal con regularización
from sklearn.linear_model import Ridge

# Cálculo de errores
from sklearn.metrics import mean_squared_error, mean_absolute_error

################################################################################
################################################################################
################################################################################
# Funciones genéricas

# Devuelve numpy array con el contenido del archivo
def readCSV(name, delimiter):
  with open(name) as csv_file:
    data_reader = csv.reader(csv_file, delimiter=delimiter)
    
    data = []
    
    for row in data_reader:      
      data.append(row)
    
    data = np.array(data, np.float64)
    
    return data  
  
################################################################################
################################################################################
################################################################################
# PROBLEMA DE CLASIFICACIÓN
print("--------------------------------------------")
print("--------- Problema de clasificación --------")
print("--------------------------------------------")

################################################################################
# Funciones

# Devuelve datos y clases del array pasado
def readDigitos(array):
  x = []
  y = []  
  
  for i in range(0, len(array)):
    x.append(array[i][0:-1])
    y.append(array[i][-1])
  
  return x, y


################################################################################
# Obtención de datos

dataTrain = readCSV("./data-clasificacion/optdigits.tra", ',')
dataTest = readCSV("./data-clasificacion/optdigits.tes", ',')

original_train_x, original_train_y = readDigitos(dataTrain)
original_test_x, original_test_y = readDigitos(dataTest)

train_x = original_train_x.copy()
train_y = original_train_y.copy()
test_x = original_test_x.copy()
test_y = original_test_y.copy()

################################################################################
# Mostrando los datos

pca = PCA(n_components=2)
proj = pca.fit_transform(train_x)
plt.figure(5)
plt.scatter(proj[:, 0], proj[:, 1], c=train_y, cmap="Paired")
plt.colorbar()
plt.title("Datos reducidos con PCA - 2 componentes")
plt.show()

################################################################################
# Preprocesado de datos

"""
Eliminamos aquellas columnas constantes, pues no nos aportan mucha información 
en el problema.
"""

# Buscamos las columnas
distintas = np.zeros((1, len(train_x[0])))

for row in train_x:
  distintas += row
  
distintas /= len(train_x)

insignificantes = np.zeros(np.shape(distintas))

for i in range(len(distintas[0])):
  if (distintas[0][i] < 0.5):
    insignificantes[0][i] = 1
  else:
    insignificantes[0][i] = 0


# Mostramos
np.set_printoptions(suppress=True)

print("Variación de las columnas:")
print(distintas, "\n")
print("Columnas con poca variabilidad:")
print(insignificantes, "\n\n")

np.set_printoptions(suppress=False)


# Quitamos las de menos variabilidad
train_x = np.delete(train_x, np.where(insignificantes == 1), 1)
test_x = np.delete(test_x, np.where(insignificantes == 1), 1)


# Puesto que vamos a usar un modelo cuadrático, normalizamos los datos
scaler = preprocessing.StandardScaler().fit(train_x)
train_x = scaler.transform(train_x)
test_x = scaler.transform(test_x)


# Cogemos los coeficientes con más variación usando PCA
pca = PCA(n_components=0.8, svd_solver="full") # La varianza para poder explicar debe ser mayor que 0.8
pca.fit(train_x)
train_x = pca.transform(train_x)
test_x = pca.transform(test_x)

################################################################################
# Ajuste
"""
alpha    - Para regularización
max_iter - Número máximo de iteraciones
tol      - Criterio de parada
"""
tol = 1e-4
max_iter = 10_000

best_classifier = 0
best_scores = 0
best_media = float('-inf')

for i in range(3):
  alpha = 0.0001 * (10 ** i)
  classifier = SGDClassifier(max_iter=max_iter, tol=tol, alpha=alpha, 
                             loss="log", penalty="none")
  
  scores = cross_val_score(classifier, train_x, train_y, cv=10)  
  
  media = scores.mean()
  
  # Nos quedamos con la mejor
  if media > best_media:    
    best_classifier = classifier
    best_scores = scores
    best_media = media
  

best_classifier.fit(train_x, train_y)

################################################################################
# Evaluamos el ajuste
print("Mejores puntuaciones con CV:\n", best_scores)
print("Y su mejor media: ", best_media, "\n")
print("Porcentaje de aciertos en train:", best_classifier.score(train_x, train_y))
print("Porcentaje de aciertos en test: ", best_classifier.score(test_x, test_y))

predict = best_classifier.predict(test_x)
cm = confusion_matrix(test_y, predict)

errores = np.zeros(10)
for i, row in enumerate(cm):
  errores[i] = sum([value for j,value in enumerate(row) if j != i])
  
print("\nMatriz de confusión:\n", cm)
print("\nLista de fallos por dígito:\n", list(range(10)), "\n", errores)


input("\n--- Pulsar tecla para continuar ---\n")

################################################################################
################################################################################
################################################################################
# PROBLEMA DE REGRESIÓN
print("--------------------------------------------")
print("--------- Problema de regresión ------------")
print("--------------------------------------------")

################################################################################
# Funciones

# Devuelve datos y clases del array pasado
def readAleron(array):
  x = []
  y = []
  
  for i in range(0, len(array)):
    x.append(array[i][0:-1])
    y.append(array[i][-1])
  
  return x, y

################################################################################
# Obtención de datos

data = readCSV("./data-regresion/airfoil_self_noise.dat", '\t')

data_x, data_y = readAleron(data)

original_data_x = data_x.copy()
original_data_y = data_y.copy()

data_x = np.array(data_x)
data_y = np.array(data_y)

################################################################################
# Mostrando los datos

# Mostramos la variación de la presión en función de las características
plt.figure(1, figsize=(10,7))
plt.subplot(321)
plt.scatter(data_x[:, 0], data_y[:], c=data_y, s=4)
plt.colorbar()
plt.xlabel("Frecuencia")
plt.ylabel("Presión")

plt.subplot(322)
plt.scatter(data_x[:, 1], data_y[:], c=data_y, s=4)
plt.colorbar()
plt.xlabel("Ángulo de ataque")
plt.ylabel("Presión")

plt.subplot(323)
plt.scatter(data_x[:, 2], data_y[:], c=data_y, s=4)
plt.colorbar()
plt.xlabel("Dimensión del ala")
plt.ylabel("Presión")


plt.subplot(324)
plt.scatter(data_x[:, 3], data_y[:], c=data_y, s=4)
plt.colorbar()
plt.xlabel("Velocidad del aire")
plt.ylabel("Presión")


plt.subplot(325)
plt.scatter(data_x[:, 4], data_y[:], c=data_y, s=4)
plt.colorbar()
plt.xlabel("Desplazamiento")
plt.ylabel("Presión")

plt.suptitle("Variación de la presión con las distintas características")
plt.tight_layout(rect=[0, 0.03, 1, 0.95])
plt.show()

################################################################################
# Preprocesado de datos

# Añadimos cuadrados
data_x = np.column_stack((data_x, np.square(data_x)))

# Normalizado
scaler = preprocessing.StandardScaler()
scaler.fit(data_x)
data_x = scaler.transform(data_x)

# PCA
pca = PCA(n_components=0.99, svd_solver="full") 
data_x = pca.fit_transform(data_x)

# Separamos en train y en test
train_x, test_x, train_y, test_y = train_test_split(data_x, data_y, test_size=0.2)

train_x = np.array(train_x)
test_x = np.array(test_x)
train_y = np.array(train_y)
test_y = np.array(test_y)

np.set_printoptions(suppress=True)

################################################################################
# Ajuste
"""
alpha    - Para regularización
max_iter - Número máximo de iteraciones
tol      - Criterio de parada
"""
tol = 1e-5
max_iter = 100_000

best_classifier = 0
best_scores = 0
best_media = float('-inf')

for i in range(3):
  alpha = 0.0001 * (10 ** i)
  classifier = Ridge(max_iter=max_iter, tol=tol, alpha=alpha)
  
  scores = cross_val_score(classifier, train_x, train_y, cv=10)    
  media = scores.mean()
  
  # Nos quedamos con la mejor
  if media > best_media:
    best_classifier = classifier
    best_scores = scores
    best_media = media
  

print("Mejores puntuaciones con CV: ", best_scores)
print("Mejor media: ", best_media, "\n")

best_classifier.fit(train_x, train_y)

################################################################################
# Evaluamos el ajuste

print("Error cuadrático en train:", best_classifier.score(train_x, train_y))
print("Error cuadrático en test: ", best_classifier.score(test_x, test_y))

print("Mean squared error:", mean_squared_error(best_classifier.predict(test_x), test_y))
print("Mean absolute error:", mean_absolute_error(best_classifier.predict(test_x), test_y))

################################################################################
# Mostrando resultados

"""Los puntos son el valor y su predicción, si son iguales deberían estar
en la diagonal"""
# Predecimos
pred_y = best_classifier.predict(test_x) 

plt.figure(2)
plt.plot(test_y, pred_y, '.')

# Pintamos recta
x = np.linspace(100, 145, 500)
y = x

plt.plot(x, y)
plt.title("Valor predicho frente a valor real")
plt.xlabel("Valor real")
plt.ylabel("Valor predicho")
plt.show()

################################################################################
# Modelos no lineales

print("\nOtros modelos no lineales:")

from sklearn.ensemble import RandomForestRegressor
from sklearn import svm

svm = svm.SVR(gamma="auto", C=1.0, epsilon=0.2, max_iter=100_000)
svm.fit(train_x, train_y) 

print("SVM test: ", svm.score(test_x, test_y))
print("SVM train: ", svm.score(train_x, train_y))
print("SVM MSE: ", mean_squared_error(svm.predict(test_x), test_y))

clf = RandomForestRegressor(n_estimators=10)
clf.fit(train_x, train_y) 

print("\nRF test: ", clf.score(test_x, test_y))
print("RF train: ", clf.score(train_x, train_y))
print("RF MSE: ", mean_squared_error(clf.predict(test_x), test_y))


################################################################################
# Mostrando resultados - Random Forest y SVM

# Predecimos
pred_y = clf.predict(test_x) 

plt.figure(3)
plt.plot(test_y, pred_y, '.')

# Pintamos recta
x = np.linspace(100, 145, 500)
y = x

plt.plot(x, y)
plt.title("Valor predicho frente a valor real - Random Forest")
plt.xlabel("Valor real")
plt.ylabel("Valor predicho")
plt.show()

# Predecimos
pred_y = svm.predict(test_x) 

plt.figure(4)
plt.plot(test_y, pred_y, '.')

# Pintamos recta
x = np.linspace(100, 145, 500)
y = x

plt.plot(x, y)
plt.title("Valor predicho frente a valor real - SVM")
plt.xlabel("Valor real")
plt.ylabel("Valor predicho")
plt.show()

input("\n--- Pulsar tecla para continuar ---\n")