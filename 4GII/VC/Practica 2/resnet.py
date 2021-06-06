# -*- coding: utf-8 -*-
###############################################################################
# practica2.py
# 
# Ignacio Vellido Expósito
###############################################################################

#########################################################################
################### OBTENER LA BASE DE DATOS ############################
#########################################################################

# Descargar también el fichero list.tar.gz, descomprimirlo y guardar los ficheros
# test.txt y train.txt dentro de la carpeta de imágenes anterior. Estos 
# dos ficheros contienen la partición en train y test del conjunto de datos.

#########################################################################
################ CARGAR LAS LIBRERÍAS NECESARIAS ########################
#########################################################################

# Librerías básicas
import numpy as np
import matplotlib.pyplot as plt
import keras.utils as np_utils

# Para obtener las imágenes
from keras.preprocessing.image import img_to_array, load_img

# Para poder realizar early stopping
from keras.callbacks import EarlyStopping, ModelCheckpoint

# Modelo
from keras import Sequential, Model

# Capas
from keras.layers import Dense
from keras.layers import Dropout
from keras.layers import Flatten
from keras.layers import Conv2D
from keras.layers import MaxPooling2D, AveragePooling2D
from keras.layers import GlobalAveragePooling2D, GlobalMaxPool2D
from keras.layers import BatchNormalization
from keras.layers import ReLU

# Para tratar el dataset
from keras.preprocessing.image import ImageDataGenerator
# Para separar validación
from sklearn.model_selection import train_test_split

# Importar optimizadores a usar
from keras.optimizers import SGD
from keras.optimizers import rmsprop
# Importar el conjunto de datos
from keras.datasets import cifar100

# Modelo ResNet50 y su respectiva función de preprocesamiento
from keras.applications.resnet50 import ResNet50, preprocess_input

#########################################################################
################## FUNCIÓN PARA LEER LAS IMÁGENES #######################
#########################################################################

# Dado un fichero train.txt o test.txt y el path donde se encuentran los
# ficheros y las imágenes, esta función lee las imágenes
# especificadas en ese fichero y devuelve las imágenes en un vector y 
# sus clases en otro.

def leerImagenes(vec_imagenes, path):
  clases = np.array([img.split('/')[0] for img in vec_imagenes])
  imagenes = np.array([img_to_array(load_img(path + "/" + img, 
                                             target_size = (224, 224))) 
                       for img in vec_imagenes])
  return imagenes, clases

#########################################################################
############# FUNCIÓN PARA CARGAR EL CONJUNTO DE DATOS ##################
#########################################################################

# Usando la función anterior, y dado el path donde se encuentran las
# imágenes y los archivos "train.txt" y "test.txt", devuelve las 
# imágenes y las clases de train y test para usarlas con keras
# directamente.

def cargarDatos(path):
  # Cargamos los ficheros
  train_images = np.loadtxt(path + "/train.txt", dtype = str)
  test_images = np.loadtxt(path + "/test.txt", dtype = str)
  
  # Leemos las imágenes con la función anterior
  train, train_clases = leerImagenes(train_images, path)
  test, test_clases = leerImagenes(test_images, path)
  
  # Pasamos los vectores de las clases a matrices 
  # Para ello, primero pasamos las clases a números enteros
  clases_posibles = np.unique(np.copy(train_clases))
  for i in range(len(clases_posibles)):
    train_clases[train_clases == clases_posibles[i]] = i
    test_clases[test_clases == clases_posibles[i]] = i

  # Después, usamos la función to_categorical()
  train_clases = np_utils.to_categorical(train_clases, 200)
  test_clases = np_utils.to_categorical(test_clases, 200)
  
  # Barajar los datos
  train_perm = np.random.permutation(len(train))
  train = train[train_perm]
  train_clases = train_clases[train_perm]

  test_perm = np.random.permutation(len(test))
  test = test[test_perm]
  test_clases = test_clases[test_perm]
  
  return train, train_clases, test, test_clases

#########################################################################
######## FUNCIÓN PARA OBTENER EL ACCURACY DEL CONJUNTO DE TEST ##########
#########################################################################

# Esta función devuelve el accuracy de un modelo, definido como el 
# porcentaje de etiquetas bien predichas frente al total de etiquetas.
# Como parámetros es necesario pasarle el vector de etiquetas verdaderas
# y el vector de etiquetas predichas, en el formato de keras (matrices
# donde cada etiqueta ocupa una fila, con un 1 en la posición de la clase
# a la que pertenece y 0 en las demás).
def calcularAccuracy(labels, preds):
  labels = np.argmax(labels, axis = 1)
  preds = np.argmax(preds, axis = 1)
  
  accuracy = sum(labels == preds)/len(labels)
  
  return accuracy

#########################################################################
## FUNCIÓN PARA PINTAR LA PÉRDIDA Y EL ACCURACY EN TRAIN Y VALIDACIÓN ###
#########################################################################

# Esta función pinta dos gráficas, una con la evolución de la función
# de pérdida en el conjunto de train y en el de validación, y otra
# con la evolución del accuracy en el conjunto de train y en el de
# validación. Es necesario pasarle como parámetro el historial
# del entrenamiento del modelo (lo que devuelven las funciones
# fit() y fit_generator()).
def mostrarEvolucion(hist, test_acc):
    plt.figure()
    loss = hist.history['loss']
    val_loss = hist.history['val_loss']
    plt.plot(loss)
    plt.plot(val_loss)    
    plt.legend(['Training loss', 'Validation loss'])
    plt.show()

    plt.figure()    
    acc = hist.history['acc']  
    val_acc = hist.history['val_acc']
    plt.plot(acc)
    plt.plot(val_acc)
    plt.legend(['Training accuracy', 'Validation accuracy'])
    plt.title("Val acc: " + str(max(val_acc)) + "\nTest accuracy: " + test_acc)
    plt.show()
"""
#------------------------------------------------------------------------------#
                    ResNet con extracción de características
#------------------------------------------------------------------------------#
"""
# -----------------------------------------------------------------------------#
###################### PREPROCESADO DE LAS IMÁGENES #########################
# -----------------------------------------------------------------------------#
# # Cargando las imágenes
# train_x, train_y, test_x, test_y = cargarDatos("./imagenes")

# # Preprocesando en base al modelo Resnet
# train_x = preprocess_input(train_x)
# test_x = preprocess_input(test_x)    

# # Definición del modelo ResNet50 (preentrenado en ImageNet y sin la última capa).
# model = ResNet50(include_top=False, 
#                 weights='imagenet', 
#                 input_tensor=None,
#                 pooling='avg')

# # Obteniendo los vectores de características
# train_x = model.predict(train_x, verbose=1)
# test_x = model.predict(test_x, verbose=1)  

# x_train = train_x
# y_train = train_y
# x_test = test_x
# y_test = test_y

# print("Fin preprocesado de datos")

# # -----------------------------------------------------------------------------#
# ################## DEFINICIÓN DEL MODELO  ################################
# # -----------------------------------------------------------------------------#
# num_classes = 200

# classifier = Sequential()
# classifier.add(Dense(500, activation='relu', input_shape=x_train[0].shape))
# classifier.add(Dropout(0.8))
# classifier.add(Dense(num_classes, activation='softmax'))

# # -----------------------------------------------------------------------------#
# ######### DEFINICIÓN DEL OPTIMIZADOR Y COMPILACIÓN DEL MODELO ###########
# # -----------------------------------------------------------------------------#

# # Para poder realizar EarlyStopping
# callbacks_list = [
#     EarlyStopping(
#         monitor="val_acc",
#         patience = 3,
#         restore_best_weights=True
#     )
# ]

# optimizer = rmsprop(lr=0.0005)
# # optimizer = rmsprop()
# # optimizer = SGD(lr=0.01, decay=1e-6, momentum=0.9, nesterov=True)

# classifier.compile(optimizer, loss='categorical_crossentropy', metrics=['accuracy'])

# # -----------------------------------------------------------------------------#
# ###################### ENTRENAMIENTO DEL MODELO #########################
# # -----------------------------------------------------------------------------#
# # Seleccionando hiperparámetros de entrenamineto
# batch_size = 32
# epochs = 50

# historial = classifier.fit(
#                         x_train,
#                         y_train,
#                         epochs=epochs,
#                         steps_per_epoch=int(len(x_train)*0.9/batch_size),
#                         validation_steps=int(len(x_train)*0.1/batch_size),
#                         callbacks=callbacks_list, 
#                         validation_split=0.1,         
#                         verbose=1
#             )

# # -----------------------------------------------------------------------------#
# ###################### VALORACIÓN Y PREDICCIÓN #########################
# # -----------------------------------------------------------------------------#
# # Evaluar conjunto de test
# score = classifier.evaluate(x_test, y_test)

# # Mostrar resultados
# print('\nTest loss:', score[0])
# print('Test accuracy:', score[1])
# print("\n", classifier.summary())
# mostrarEvolucion(historial, str(score[1]))
"""
#------------------------------------------------------------------------------#
                        ResNet con fine-tunning
#------------------------------------------------------------------------------#
"""
# # -----------------------------------------------------------------------------#
# ###################### PREPROCESADO DE LAS IMÁGENES #########################
# # -----------------------------------------------------------------------------#
# # Cargando las imágenes
# train_x, train_y, test_x, test_y = cargarDatos("/content/images")

# # Definición del modelo ResNet50 (preentrenado en ImageNet y sin la última capa).
# resnet = ResNet50(include_top=False, 
#                   weights='imagenet',
#                   pooling='avg',
#                   input_shape=(224,224,3))

# for layer in resnet.layers:
#   layer.trainable=False
# for i in range(1, 21):
#   resnet.layers[-i].trainable = True

# train_x = preprocess_input(train_x)
# test_x = preprocess_input(test_x)  

# x_train = train_x
# y_train = train_y
# x_test = test_x
# y_test = test_y

# # -----------------------------------------------------------------------------#
# ################## DEFINICIÓN DEL MODELO  ################################
# # -----------------------------------------------------------------------------#
# num_classes = 200

# x = resnet.output
# x = Dense(400, activation='relu')(x)
# x = Dropout(0.8)(x)
# last = Dense(num_classes, activation='softmax')(x)
# model = Model(inputs=resnet.input, outputs=last)

# # -----------------------------------------------------------------------------#
# ######### DEFINICIÓN DEL OPTIMIZADOR Y COMPILACIÓN DEL MODELO ###########
# # -----------------------------------------------------------------------------#

# # Para poder realizar EarlyStopping
# callbacks_list = [
#     EarlyStopping(
#         monitor="val_acc",
#         patience = 3,
#         restore_best_weights=True
#     )
# ]

# optimizer = rmsprop(lr=0.0005)
# optimizer = SGD()
# optimizer = SGD(lr=0.01, decay=1e-6, momentum=0.9, nesterov=True)

# model.compile(optimizer, loss='categorical_crossentropy', metrics=['accuracy'])

# # -----------------------------------------------------------------------------#
# ###################### ENTRENAMIENTO DEL MODELO #########################
# # -----------------------------------------------------------------------------#
# # Seleccionando hiperparámetros de entrenamineto
# batch_size = 8
# epochs = 30

# # Datagen
# train_datagen = ImageDataGenerator(horizontal_flip=True,
#                                     zoom_range=0.15,
#                                    validation_split=0.1)                             
# train_datagen.fit(x_train)

# # Generators
# train_generator = train_datagen.flow(x_train, 
#                                     y_train,                                    
#                                     batch_size=batch_size,                                
#                                     subset="training"
#                     )
# val_generator = train_datagen.flow(x_train, 
#                                 y_train,
#                                 batch_size=batch_size,
#                                 subset="validation"
#                 )

# # Ajustando el modelo
# historial = model.fit_generator(
#                       train_generator,
#                       validation_data=val_generator,
#                       epochs=epochs,
#                       steps_per_epoch=int(len(x_train)*0.9/batch_size),
#                       validation_steps=int(len(x_train)*0.1/batch_size),
#                       callbacks=callbacks_list,     
#                       verbose=1
#             )

# # -----------------------------------------------------------------------------#
# ###################### VALORACIÓN Y PREDICCIÓN #########################
# # -----------------------------------------------------------------------------#
# # Evaluar conjunto de test
# score = model.evaluate(x_test, y_test)

# # Mostrar resultados
# print('\nTest loss:', score[0])
# print('Test accuracy:', score[1])
# # print("\n", model.summary())
# mostrarEvolucion(historial, str(score[1]))