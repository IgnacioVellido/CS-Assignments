SRC = src
INC = include
OBJ = obj
BIN = bin
CXX = g++
CPPFLAGS = -Wall -g  -I$(INC) -c -std=c++11


all: $(BIN)/ejercicio1 $(BIN)/ejercicio2 $(BIN)/ejercicio3

# ************ Generación de documentación ******************
documentacion:
	doxygen doc/doxys/Doxyfile

# ************ Compilación de módulos ************
$(BIN)/ejercicio1: $(OBJ)/ejercicio1.o
	$(CXX) -o $(BIN)/ejercicio1  $(OBJ)/ejercicio1.o

$(OBJ)/ejercicio1.o: $(SRC)/ejercicio1.cpp
	$(CXX) $(CPPFLAGS) $(SRC)/ejercicio1.cpp -o $(OBJ)/ejercicio1.o

$(BIN)/ejercicio2: $(OBJ)/ejercicio2.o
	$(CXX) -o $(BIN)/ejercicio2  $(OBJ)/ejercicio2.o

$(OBJ)/ejercicio2.o: $(SRC)/ejercicio2.cpp
	$(CXX) $(CPPFLAGS) $(SRC)/ejercicio2.cpp -o $(OBJ)/ejercicio2.o

$(BIN)/ejercicio3: $(OBJ)/ejercicio3.o
	$(CXX) -o $(BIN)/ejercicio3  $(OBJ)/ejercicio3.o

$(OBJ)/ejercicio3.o: $(SRC)/ejercicio3.cpp
	$(CXX) $(CPPFLAGS) $(SRC)/ejercicio3.cpp -o $(OBJ)/ejercicio3.o


# ************ Limpieza ************
clean :
	-rm $(OBJ)/* $(SRC)/*~ $(INC)/*~ ./*~

mrproper : clean
	-rm $(BIN)/* doc/html/*
