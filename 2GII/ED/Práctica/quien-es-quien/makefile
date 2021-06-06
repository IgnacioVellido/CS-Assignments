# Francisco José Cotán López
# Ignacio Vellido Expósito

# Definición de macros para definir las carpetas de trabajo
BIN = ./bin
OBJ = ./obj
SRC = ./src
INC = ./include
CXX = g++
ZIP = ./zip
# Opciones de compilación
CPPFLAGS = -g  -I$(INC) -std=c++11


# Las macros se usan en las reglas del makefile como si fuesen variables
# que se sustituyen por su valor definido anteriormente
all: $(BIN)/quienesquien

jugar: $(BIN)/quienesquien
	$(BIN)/quienesquien datos/personajes-1.csv

jugarRedundante: $(BIN)/quienesquien
	$(BIN)/quienesquien datos/personajes-redundantes.csv

limpiar: $(BIN)/quienesquien
	$(BIN)/quienesquien datos/personajes-1.csv limpiar

limpiarRedundante: $(BIN)/quienesquien
	$(BIN)/quienesquien datos/personajes-redundantes.csv limpiar

aleatorio: $(BIN)/quienesquien
	$(BIN)/quienesquien aleatorio

# ************ Generación de documentación ******************
documentacion: $(SRC)/main.cpp $(SRC)/pregunta.cpp $(SRC)/quienesquien.cpp $(INC)/pregunta.h $(INC)/quienesquien.h
	doxygen doc/doxys/Doxyfile

# ************ Compilación de módulos ************
$(BIN)/quienesquien: $(OBJ)/main.o $(OBJ)/quienesquien.o
	$(CXX) $(OBJ)/main.o $(OBJ)/quienesquien.o $(OBJ)/pregunta.o -o $(BIN)/quienesquien $(CPPFLAGS)

# Creamos los objetos
$(OBJ)/main.o: $(SRC)/main.cpp $(OBJ)/pregunta.o $(OBJ)/quienesquien.o
	$(CXX) -c $(SRC)/main.cpp -o $(OBJ)/main.o $(CPPFLAGS)	

$(OBJ)/quienesquien.o: $(SRC)/quienesquien.cpp $(OBJ)/pregunta.o
	$(CXX) -c $(SRC)/quienesquien.cpp -o $(OBJ)/quienesquien.o $(CPPFLAGS)

$(OBJ)/pregunta.o: $(SRC)/pregunta.cpp
	$(CXX) -c $(SRC)/pregunta.cpp -o $(OBJ)/pregunta.o $(CPPFLAGS)


# ************ Limpieza y encapsulado ************
clean :
	-rm -r $(OBJ)/* $(BIN)/* $(ZIP)/*

zip : clean
	zip -r $(ZIP)/$(PRJ).zip *
