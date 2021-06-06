# -*- coding: utf-8 -*-
###############################################################################
# practica2.py
# 
# Ignacio Vellido Expósito
###############################################################################

############ CARGAR LAS LIBRERÍAS NECESARIAS ############################
# Librerías básicas
import numpy as np
import matplotlib.pyplot as plt
import keras.utils as np_utils

# Para poder realizar early stopping
from keras.callbacks import EarlyStopping, ModelCheckpoint

# Modelo
from keras import Sequential

# Capas
from keras.layers import Dense
from keras.layers import Dropout
from keras.layers import Flatten
from keras.layers import Conv2D
from keras.layers import MaxPooling2D
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

#########################################################################
######## FUNCIÓN PARA CARGAR Y MODIFICAR EL CONJUNTO DE DATOS ###########
#########################################################################

""" A esta función solo se le llama una vez. 
Devuelve 4 vectores conteniendo, por este orden:
 - Las imágenes de entrenamiento
 - Las clases de las imagenes de entrenamiento
 - Las imágenes del conjunto de test
 - Las clases del conjunto de test
"""
def cargarImagenes():
    # Cargamos Cifar100 . Cada imagen tiene tamaño (32, 32, 3). 
    # Nos vamos a quedar con las imágenes de 25 de las clases .
    (x_train, y_train), (x_test, y_test) = cifar100.load_data(label_mode ='fine')
    x_train = x_train.astype('float32')
    x_test = x_test.astype('float32')

    x_train /= 255
    x_test /= 255
    train_idx = np.isin(y_train, np.arange(25))
    train_idx = np.reshape( train_idx , -1)
    x_train = x_train[train_idx]
    y_train = y_train[train_idx]
    test_idx = np.isin (y_test, np.arange(25))
    test_idx = np.reshape(test_idx, -1)
    x_test = x_test[test_idx]
    y_test = y_test[test_idx]

    # Transformamos los vectores de clases en matrices. Cada componente se 
    # convierte en un vector de ceros con un uno en la componente 
    # correspondiente a la clase a la que pertenece la imagen. Este paso es
    # necesario para la clasificación multiclase en keras.
    y_train = np_utils.to_categorical(y_train, 25)
    y_test = np_utils.to_categorical(y_test, 25)
    return x_train, y_train, x_test, y_test

#########################################################################
######## FUNCIÓN PARA OBTENER EL ACCURACY DEL CONJUNTO DE TEST ##########
#########################################################################

""" Esta función devuelve el accuracy de un modelo, definido como el porcentaje 
de etiquetas bien predichas frente al total de etiquetas. Como parámetros es
necesario pasarle el vector de etiquetas verdaderas y el vector de etiquetas 
predichas, en el formato de keras (matrices donde cada etiqueta ocupa una fila,
con un 1 en la posición de la clase a la que pertenece, 0 en las demás).
"""
def calcularAccuracy(labels, preds):
    labels = np.argmax(labels, axis = 1)
    preds = np.argmax(preds, axis = 1)
    accuracy = sum(labels == preds) / len(labels)
    return accuracy

#########################################################################
## FUNCIÓN PARA PINTAR LA PÉRDIDA Y EL ACCURACY EN TRAIN Y VALIDACIÓN ###
#########################################################################

""" Esta función pinta dos gráficas, una con la evolución de la función de 
pérdida en el conjunto de train y en el de validación, y otra con la evolución 
del accuracy en el conjunto de train y el de validación.
Es necesario pasarle como parámetro el historial del entrenamiento del modelo 
(lo que devuelven las funciones fit() y fit_generator()).
"""
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
                        Modelo BaseNet base
#------------------------------------------------------------------------------#
"""
# # -----------------------------------------------------------------------------#
# ################## DEFINICIÓN DEL MODELO  ################################
# # -----------------------------------------------------------------------------#

# x_train, y_train, x_test, y_test = cargarImagenes()
# input_shape = (32, 32, 3)
# num_classes = 25

# # BaseNet
# model = Sequential()
# model.add(Conv2D(6, kernel_size=(5,5), activation='relu', input_shape=input_shape))
# model.add(MaxPooling2D(pool_size=(2,2)))
# model.add(Conv2D(16, kernel_size=(5,5), activation='relu'))
# model.add(MaxPooling2D(pool_size=(2,2)))
# model.add(Flatten())
# model.add(Dense(50, activation='relu'))
# model.add(Dense(num_classes, activation='softmax')) # Por ser regresión, softmax

# # -----------------------------------------------------------------------------#
# ######### DEFINICIÓN DEL OPTIMIZADOR Y COMPILACIÓN DEL MODELO ###########
# # -----------------------------------------------------------------------------#

# # optimizer = SGD(lr=0.01, decay=1e-6, momentum=0.9, nesterov=True)
# optimizer = rmsprop()
# model.compile(optimizer, loss='categorical_crossentropy', metrics=['accuracy'])

# # -----------------------------------------------------------------------------#
# ###################### ENTRENAMIENTO DEL MODELO #########################
# # -----------------------------------------------------------------------------#
# batch_size = 32
# epochs = 20

# # Separar 10% para validación
# train_datagen = ImageDataGenerator(validation_split=0.1)                             
# train_datagen.fit(x_train)
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
# historial = model.fit(
#                         train_generator,                        
#                         validation_data=val_generator,
#                         epochs=epochs,                        
#                         verbose=1
#             )
# # -----------------------------------------------------------------------------#
# ################ PREDICCIÓN SOBRE EL CONJUNTO DE TEST ###################
# # -----------------------------------------------------------------------------#
# # Evaluar conjunto de test
# score = model.evaluate(x_test, y_test, verbose=0)

# # Mostrar resultados
# print('\nTest loss:', score[0])
# print('Test accuracy:', score[1])
# print("\n", model.summary())
# mostrarEvolucion(historial, str(score[1]))

"""
#------------------------------------------------------------------------------#
                    BaseNet con early stopping
#------------------------------------------------------------------------------#
"""
# -----------------------------------------------------------------------------#
################## DEFINICIÓN DEL MODELO  ################################
# -----------------------------------------------------------------------------#
# x_train, y_train, x_test, y_test = cargarImagenes()
# input_shape = (32, 32, 3)
# num_classes = 25

# # BaseNet
# model = Sequential()
# model.add(Conv2D(6, kernel_size=(5,5), activation='relu', input_shape=input_shape))
# model.add(MaxPooling2D(pool_size=(2,2)))
# model.add(Conv2D(16, kernel_size=(5,5), activation='relu'))
# model.add(MaxPooling2D(pool_size=(2,2)))
# model.add(Flatten())
# model.add(Dense(50, activation='relu'))
# model.add(Dense(num_classes, activation='softmax')) # Por ser regresión, softmax

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

# optimizer = rmsprop()
# model.compile(optimizer, loss='categorical_crossentropy', metrics=['accuracy'])

# # -----------------------------------------------------------------------------#
# ###################### ENTRENAMIENTO DEL MODELO #########################
# # -----------------------------------------------------------------------------#
# batch_size = 32
# epochs = 25

# # Separar 10% para validación
# train_datagen = ImageDataGenerator(validation_split=0.1)                             
# train_datagen.fit(x_train)
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
# historial = model.fit(
#                         train_generator,                        
#                         validation_data=val_generator,
#                         epochs=epochs,
#                         steps_per_epoch=len(x_train)*0.9/32,
#                         validation_steps=len(x_train)*0.1/32,
#                         callbacks=callbacks_list,                     
#                         verbose=1
#             )
# # -----------------------------------------------------------------------------#
# ################ PREDICCIÓN SOBRE EL CONJUNTO DE TEST ###################
# # -----------------------------------------------------------------------------#
# # Evaluar conjunto de test
# score = model.evaluate(x_test, y_test, verbose=0)

# # Mostrar resultados
# print('\nTest loss:', score[0])
# print('Test accuracy:', score[1])
# print("\n", model.summary())
# mostrarEvolucion(historial, str(score[1]))
"""
#------------------------------------------------------------------------------#
                    BaseNet con normalización
#------------------------------------------------------------------------------#
"""
# # -----------------------------------------------------------------------------#
# ################## DEFINICIÓN DEL MODELO  ################################
# # -----------------------------------------------------------------------------#
# x_train, y_train, x_test, y_test = cargarImagenes()
# input_shape = (32, 32, 3)
# num_classes = 25

# # BaseNet
# model = Sequential()
# model.add(Conv2D(6, kernel_size=(5,5), activation='relu', input_shape=input_shape))
# model.add(MaxPooling2D(pool_size=(2,2)))
# model.add(Conv2D(16, kernel_size=(5,5), activation='relu'))
# model.add(MaxPooling2D(pool_size=(2,2)))
# model.add(Flatten())
# model.add(Dense(50, activation='relu'))
# model.add(Dense(num_classes, activation='softmax'))

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

# optimizer = rmsprop()
# model.compile(optimizer, loss='categorical_crossentropy', metrics=['accuracy'])

# # -----------------------------------------------------------------------------#
# ###################### ENTRENAMIENTO DEL MODELO #########################
# # -----------------------------------------------------------------------------#
# batch_size = 32
# epochs = 30

# # Separar 10% para validación
# x_train, x_val, y_train, y_val = train_test_split(x_train, y_train, test_size=0.1)

# # Datagens
# train_datagen   = ImageDataGenerator(featurewise_center=True,
#                                         featurewise_std_normalization=True)
# val_datagen     = ImageDataGenerator(featurewise_center=True,
#                                         featurewise_std_normalization=True)
# test_datagen    = ImageDataGenerator(featurewise_center=True,
#                                         featurewise_std_normalization=True)

# train_datagen.fit(x_train)
# val_datagen.fit(x_train)                                                   
# test_datagen.fit(x_train)

# # Generators
# train_generator = train_datagen.flow(x_train, 
#                                 y_train, shuffle=False,
#                                 batch_size=batch_size)
# val_generator = val_datagen.flow(x_val, 
#                                 y_val, shuffle=False,
#                                 batch_size=batch_size)
# test_generator = test_datagen.flow(x_test, 
#                                     y_test,
#                                     shuffle=False)


# # Ajustando el modelo
# historial = model.fit(
#                         train_generator,                        
#                         validation_data=val_generator,
#                         epochs=epochs,
#                         steps_per_epoch=len(x_train)*0.9/32,
#                         validation_steps=len(x_train)*0.1/32,
#                         callbacks=callbacks_list,                     
#                         verbose=1
#             )
# # -----------------------------------------------------------------------------#
# ################ PREDICCIÓN SOBRE EL CONJUNTO DE TEST ###################
# # -----------------------------------------------------------------------------#
# # Evaluar conjunto de test
# score = model.evaluate_generator(test_generator)

# # Mostrar resultados
# print('\nTest loss:', score[0])
# print('Test accuracy:', score[1])
# print("\n", model.summary())
# mostrarEvolucion(historial, str(score[1]))
"""
#------------------------------------------------------------------------------#
                    BaseNet con data augmentation
#------------------------------------------------------------------------------#
"""
# # -----------------------------------------------------------------------------#
# ################## DEFINICIÓN DEL MODELO  ################################
# # -----------------------------------------------------------------------------#
# x_train, y_train, x_test, y_test = cargarImagenes()
# input_shape = (32, 32, 3)
# num_classes = 25

# # BaseNet
# model = Sequential()
# model.add(Conv2D(6, kernel_size=(5,5), activation='relu', input_shape=input_shape))
# model.add(MaxPooling2D(pool_size=(2,2)))
# model.add(Conv2D(16, kernel_size=(5,5), activation='relu'))
# model.add(MaxPooling2D(pool_size=(2,2)))
# model.add(Flatten())
# model.add(Dense(50, activation='relu'))
# model.add(Dense(num_classes, activation='softmax'))

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

# optimizer = rmsprop()
# model.compile(optimizer, loss='categorical_crossentropy', metrics=['accuracy'])

# # -----------------------------------------------------------------------------#
# ###################### ENTRENAMIENTO DEL MODELO #########################
# # -----------------------------------------------------------------------------#
# batch_size = 32
# epochs = 50

# # Separar 10% para validación
# x_train, x_val, y_train, y_val = train_test_split(x_train, y_train, test_size=0.1)

# # Datagens
# train_datagen   = ImageDataGenerator(featurewise_center=True,
#                                         featurewise_std_normalization=True,
#                                         horizontal_flip=True,
#                                         zoom_range=0.15)
# val_datagen     = ImageDataGenerator(featurewise_center=True,
#                                         featurewise_std_normalization=True)
# test_datagen    = ImageDataGenerator(featurewise_center=True,
#                                         featurewise_std_normalization=True)

# train_datagen.fit(x_train)
# val_datagen.fit(x_train)                                                   
# test_datagen.fit(x_train)

# # Generators
# train_generator = train_datagen.flow(x_train, 
#                                 y_train, shuffle=False,
#                                 batch_size=batch_size)
# val_generator = val_datagen.flow(x_val, 
#                                 y_val, shuffle=False,
#                                 batch_size=batch_size)
# test_generator = test_datagen.flow(x_test, 
#                                     y_test,
#                                     shuffle=False)


# # Ajustando el modelo
# historial = model.fit(
#                         train_generator,                        
#                         validation_data=val_generator,
#                         epochs=epochs,
#                         steps_per_epoch=len(x_train)*0.9/32,
#                         validation_steps=len(x_train)*0.1/32,
#                         callbacks=callbacks_list,                     
#                         verbose=1
#             )
# # -----------------------------------------------------------------------------#
# ################ PREDICCIÓN SOBRE EL CONJUNTO DE TEST ###################
# # -----------------------------------------------------------------------------#
# # Evaluar conjunto de test
# score = model.evaluate_generator(test_generator)

# # Mostrar resultados
# print('\nTest loss:', score[0])
# print('Test accuracy:', score[1])
# print("\n", model.summary())
# mostrarEvolucion(historial, str(score[1]))
"""
#------------------------------------------------------------------------------#
                    BaseNet con red más profunda
#------------------------------------------------------------------------------#
"""
# # -----------------------------------------------------------------------------#
# ################## DEFINICIÓN DEL MODELO  ################################
# # -----------------------------------------------------------------------------#
# x_train, y_train, x_test, y_test = cargarImagenes()
# input_shape = (32, 32, 3)
# num_classes = 25

# # BaseNet
# model = Sequential()
# model.add(Conv2D(6, kernel_size=(5,5), activation='relu', input_shape=input_shape))
# model.add(Conv2D(14, kernel_size=(3,3), activation='relu', padding="same"))
# model.add(BatchNormalization())
# model.add(MaxPooling2D(pool_size=(2,2)))
# model.add(Conv2D(20, kernel_size=(5,5), activation='relu', padding="same"))
# model.add(Conv2D(28, kernel_size=(3,3), activation='relu'))
# model.add(BatchNormalization())
# model.add(MaxPooling2D(pool_size=(2,2)))
# model.add(Conv2D(20, kernel_size=(5,5), activation='relu', padding="same"))
# model.add(Conv2D(28, kernel_size=(3,3), activation='relu'))
# model.add(BatchNormalization())
# model.add(MaxPooling2D(pool_size=(2,2)))
# model.add(Conv2D(32, kernel_size=(3,3), activation='relu', padding="same"))
# model.add(Conv2D(40, kernel_size=(1,1), activation='relu'))
# model.add(BatchNormalization())
# model.add(MaxPooling2D(pool_size=(2,2)))
# model.add(Flatten())
# model.add(Dense(50, activation='relu'))
# model.add(Dense(num_classes, activation='softmax'))

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

# optimizer = rmsprop()
# model.compile(optimizer, loss='categorical_crossentropy', metrics=['accuracy'])

# # -----------------------------------------------------------------------------#
# ###################### ENTRENAMIENTO DEL MODELO #########################
# # -----------------------------------------------------------------------------#
# batch_size = 32
# epochs = 50

# # Separar 10% para validación
# x_train, x_val, y_train, y_val = train_test_split(x_train, y_train, test_size=0.1)
#                                                     # shuffle=True, stratify=y_train)

# # Datagens
# train_datagen   = ImageDataGenerator(featurewise_center=True,
#                                         featurewise_std_normalization=True,
#                                         horizontal_flip=True,
#                                         zoom_range=0.15)
# val_datagen     = ImageDataGenerator(featurewise_center=True,
#                                         featurewise_std_normalization=True)
# test_datagen    = ImageDataGenerator(featurewise_center=True,
#                                         featurewise_std_normalization=True)

# train_datagen.fit(x_train)
# val_datagen.fit(x_train)                                                   
# test_datagen.fit(x_train)

# # Generators
# train_generator = train_datagen.flow(x_train, 
#                                 y_train, shuffle=False,
#                                 batch_size=batch_size)
# val_generator = val_datagen.flow(x_val, 
#                                 y_val, shuffle=False,
#                                 batch_size=batch_size)
# test_generator = test_datagen.flow(x_test, 
#                                     y_test,
#                                     shuffle=False)


# # Ajustando el modelo
# historial = model.fit(
#                         train_generator,                        
#                         validation_data=val_generator,
#                         epochs=epochs,
#                         steps_per_epoch=len(x_train)*0.9/32,
#                         validation_steps=len(x_train)*0.1/32,
#                         callbacks=callbacks_list,                     
#                         verbose=1
#             )
# # -----------------------------------------------------------------------------#
# ################ PREDICCIÓN SOBRE EL CONJUNTO DE TEST ###################
# # -----------------------------------------------------------------------------#
# # Evaluar conjunto de test
# score = model.evaluate_generator(test_generator)

# # Mostrar resultados
# print('\nTest loss:', score[0])
# print('Test accuracy:', score[1])
# print("\n", model.summary())
# mostrarEvolucion(historial, str(score[1]))
"""
#------------------------------------------------------------------------------#
                    BaseNet con batch normalization
#------------------------------------------------------------------------------#
"""
# # -----------------------------------------------------------------------------#
# ################## DEFINICIÓN DEL MODELO  ################################
# # -----------------------------------------------------------------------------#
# x_train, y_train, x_test, y_test = cargarImagenes()
# input_shape = (32, 32, 3)
# num_classes = 25

# # BaseNet
# model = Sequential()
# model.add(Conv2D(6, kernel_size=(5,5), input_shape=input_shape))
# model.add(ReLU())
# model.add(Conv2D(14, kernel_size=(3,3), padding="same"))
# model.add(BatchNormalization())
# model.add(ReLU())
# model.add(MaxPooling2D(pool_size=(2,2)))

# model.add(Conv2D(20, kernel_size=(5,5), padding="same"))
# model.add(ReLU())
# model.add(Conv2D(28, kernel_size=(3,3)))
# model.add(BatchNormalization())
# model.add(ReLU())
# model.add(MaxPooling2D(pool_size=(2,2)))

# model.add(Conv2D(20, kernel_size=(5,5), padding="same"))
# model.add(ReLU())
# model.add(Conv2D(28, kernel_size=(3,3)))
# model.add(BatchNormalization())
# model.add(ReLU())
# model.add(MaxPooling2D(pool_size=(2,2)))

# model.add(Conv2D(32, kernel_size=(3,3), padding="same"))
# model.add(ReLU())
# model.add(Conv2D(40, kernel_size=(1,1)))
# model.add(BatchNormalization())
# model.add(ReLU())
# model.add(MaxPooling2D(pool_size=(2,2)))

# model.add(Flatten())
# model.add(Dense(50, activation='relu'))
# model.add(Dense(num_classes, activation='softmax'))

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

# optimizer = rmsprop()
# model.compile(optimizer, loss='categorical_crossentropy', metrics=['accuracy'])

# # -----------------------------------------------------------------------------#
# ###################### ENTRENAMIENTO DEL MODELO #########################
# # -----------------------------------------------------------------------------#
# batch_size = 32
# epochs = 50

# # Separar 10% para validación
# x_train, x_val, y_train, y_val = train_test_split(x_train, y_train, test_size=0.1)

# # Datagens
# train_datagen   = ImageDataGenerator(featurewise_center=True,
#                                         featurewise_std_normalization=True,
#                                         horizontal_flip=True,
#                                         zoom_range=0.15)
# val_datagen     = ImageDataGenerator(featurewise_center=True,
#                                         featurewise_std_normalization=True)
# test_datagen    = ImageDataGenerator(featurewise_center=True,
#                                         featurewise_std_normalization=True)

# train_datagen.fit(x_train)
# val_datagen.fit(x_train)                                                   
# test_datagen.fit(x_train)

# # Generators
# train_generator = train_datagen.flow(x_train, 
#                                 y_train, shuffle=False,
#                                 batch_size=batch_size)
# val_generator = val_datagen.flow(x_val, 
#                                 y_val, shuffle=False,
#                                 batch_size=batch_size)
# test_generator = test_datagen.flow(x_test, 
#                                     y_test,
#                                     shuffle=False)


# # Ajustando el modelo
# historial = model.fit(
#                         train_generator,                        
#                         validation_data=val_generator,
#                         epochs=epochs,
#                         steps_per_epoch=len(x_train)*0.9/32,
#                         validation_steps=len(x_train)*0.1/32,
#                         callbacks=callbacks_list,                     
#                         verbose=1
#             )
# # -----------------------------------------------------------------------------#
# ################ PREDICCIÓN SOBRE EL CONJUNTO DE TEST ###################
# # -----------------------------------------------------------------------------#
# # Evaluar conjunto de test
# score = model.evaluate_generator(test_generator)

# # Mostrar resultados
# print('\nTest loss:', score[0])
# print('Test accuracy:', score[1])
# print("\n", model.summary())
# mostrarEvolucion(historial, str(score[1]))
"""
#------------------------------------------------------------------------------#
                            BaseNet final
#------------------------------------------------------------------------------#
"""
# -----------------------------------------------------------------------------#
################## DEFINICIÓN DEL MODELO  ################################
# -----------------------------------------------------------------------------#
x_train, y_train, x_test, y_test = cargarImagenes()
input_shape = (32, 32, 3)
num_classes = 25

# BaseNet
model = Sequential()
model.add(Conv2D(6, kernel_size=(5,5), activation='relu', input_shape=input_shape))
model.add(Conv2D(14, kernel_size=(3,3), activation='relu', padding="same"))
model.add(BatchNormalization())
model.add(MaxPooling2D(pool_size=(2,2)))
model.add(Conv2D(20, kernel_size=(5,5), activation='relu', padding="same"))
model.add(Conv2D(28, kernel_size=(3,3), activation='relu'))
model.add(BatchNormalization())
model.add(MaxPooling2D(pool_size=(2,2)))
model.add(Conv2D(20, kernel_size=(5,5), activation='relu', padding="same"))
model.add(Conv2D(28, kernel_size=(3,3), activation='relu'))
model.add(BatchNormalization())
model.add(MaxPooling2D(pool_size=(2,2)))
model.add(Conv2D(32, kernel_size=(3,3), activation='relu', padding="same"))
model.add(Conv2D(40, kernel_size=(1,1), activation='relu'))
model.add(BatchNormalization())
model.add(MaxPooling2D(pool_size=(2,2)))
model.add(Flatten())
model.add(Dense(50, activation='relu'))
model.add(Dense(num_classes, activation='softmax'))

# -----------------------------------------------------------------------------#
######### DEFINICIÓN DEL OPTIMIZADOR Y COMPILACIÓN DEL MODELO ###########
# -----------------------------------------------------------------------------#

# Para poder realizar EarlyStopping
callbacks_list = [
    EarlyStopping(
        monitor="acc",
        patience = 3,
        restore_best_weights=True
    )
]

optimizer = rmsprop()
model.compile(optimizer, loss='categorical_crossentropy', metrics=['accuracy'])

# -----------------------------------------------------------------------------#
###################### ENTRENAMIENTO DEL MODELO #########################
# -----------------------------------------------------------------------------#
batch_size = 32
epochs = 18

# Datagens
train_datagen   = ImageDataGenerator(featurewise_center=True,
                                        featurewise_std_normalization=True,
                                        horizontal_flip=True,
                                        zoom_range=0.15)
test_datagen    = ImageDataGenerator(featurewise_center=True,
                                        featurewise_std_normalization=True)

train_datagen.fit(x_train)                     
test_datagen.fit(x_train)

# Generators
train_generator = train_datagen.flow(x_train, 
                                y_train, shuffle=False,
                                batch_size=batch_size)
test_generator = test_datagen.flow(x_test, 
                                    y_test,
                                    shuffle=False)


# Ajustando el modelo
historial = model.fit(
                        train_generator,                                            
                        epochs=epochs,
                        steps_per_epoch=len(x_train)*0.9/32,                        
                        callbacks=callbacks_list,                     
                        verbose=1
            )
# -----------------------------------------------------------------------------#
################ PREDICCIÓN SOBRE EL CONJUNTO DE TEST ###################
# -----------------------------------------------------------------------------#
# Evaluar conjunto de test
score = model.evaluate_generator(test_generator)

# Mostrar resultados
print('\nTest loss:', score[0])
print('Test accuracy:', score[1])