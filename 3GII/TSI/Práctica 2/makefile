#!/bin/bash

FOLDER = Ejercicios/

FGENERADOR = Ejercicios/Generador/
GENERADOR = problema.pddl

METRIC = 0

NUMDOMAIN = 7
NUMPROBLEM = 1

DOMAIN = Ej$(NUMDOMAIN)dominio.pddl
PROBLEM = Ej$(NUMDOMAIN)problema$(NUMPROBLEM).pddl

FILE = $(FOLDER)/Ej$(NUMDOMAIN)soluciones/Plan_problema$(NUMPROBLEM).txt

run:
	if [ $(METRIC) -eq 0 ];	then \
		Metric-FF/ff -p $(FOLDER) -o $(DOMAIN) -f $(PROBLEM);	\
	else	\
		Metric-FF/ff -p $(FOLDER) -o $(DOMAIN) -f $(PROBLEM) -O -g 1 -h 1;	\
	fi;

guardar-salida:
	make run > $(FILE)

generador:
	if [ $(METRIC) -eq 0 ];	then \
		Metric-FF/ff -p $(FGENERADOR) -o $(DOMAIN) -f $(GENERADOR);	\
	else	\
		Metric-FF/ff -p $(FGENERADOR) -o $(DOMAIN) -f $(GENERADOR) -O -g 1 -h 1;	\
	fi;
