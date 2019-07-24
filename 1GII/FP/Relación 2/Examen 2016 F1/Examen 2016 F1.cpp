// Ignacio Vellido Expósito - F3(martes)

#include <iostream>
#include <stdlib.h>
#include <string>
using namespace std; 

int filtro_positivo (string msj) {
	int valor ;
	cout << msj << endl ;
	do {
		cin >> valor ;
	} while (valor < 0) ;
	return (valor) ;
}

int filtro_entero (string msj) {
	int valor ;
	cout << msj << endl ;
	do {
		cin >> valor ;
	} while ((valor < 100 || valor > 999) && valor != 0) ;
	return (valor) ;
}

int main () 
{
	const int CONVERSOR = 60 , TERMINADOR = 0 ;
	int destino , origen , minutos , segundos ,
		  max = 0 ;
	int corta , media , larga , muy_larga = 0 , total ;										// Contadores
	int pc = 0 , pm = 0 , pl = 0 , pml = 0 ;																// Porcentajes (corta, mdia, larga, muy larga)
	string condicion_destino = "Introduzca el codigo del destino: " ,
			 condicion_origen = "Introduzca el codigo del origen: " ,
			 condicion_minutos = "Introduzca el numero de minutos: " ,
			 condicion_segundos = "Introduzca el numero de segundos: " ,
			 resultado1 , resultado2 ;
				 
	origen = filtro_entero(condicion_origen) ;
	
	while (origen != TERMINADOR) {
		
		destino = filtro_entero(condicion_destino) ;
		minutos = filtro_positivo(condicion_minutos) ;
		segundos = filtro_positivo(condicion_segundos) ;
	
		segundos = segundos + (minutos * CONVERSOR) ;
		
		if (segundos > max) {
			max = segundos ;
			resultado1 = "La llamada mas larga tiene como origen " + to_string(origen) + " y destino " + to_string(destino) ;
		}
		
		if (segundos <= 30)
			corta++ ;
		else if (segundos <= 90) 
			media++ ;
		else if (segundos <= 120)
			larga++ ;
		else 
			muy_larga++ ;
			
		total++ ;
		origen = filtro_entero(condicion_origen) ;
	}
	
	pc = (corta * 100.0) / total ;
	pm = (media * 100.0) / total ;
	pl = (larga * 100.0) / total ;
	pml = (muy_larga * 100.0) / total ;
	
	resultado2 = "Los porcentajes de llamadas han sido:\nCorta: " + to_string(pc) + "\nMedia: " + to_string(pm) + "\nLarga: " + to_string(pl) + "\nMuy larga: " + to_string(pml) ;
	
	if (total == 0) {
		resultado1 = "No se han introducido datos" ;
		resultado2 = " " ;
	}
	
	cout << resultado1 << endl ;
	cout << resultado2 << endl ;
	
	return 0 ;
}
