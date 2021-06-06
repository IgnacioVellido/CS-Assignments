// Francisco José Cotán López
// Ignacio Vellido Expósito

#include "../include/pregunta.h"

Pregunta::Pregunta() {
	atributo       = "";
	num_personajes = 0;
}

Pregunta::Pregunta(const Pregunta & pregunta) {
	this->atributo       = pregunta.atributo;
	this->num_personajes = pregunta.num_personajes;
}

Pregunta::Pregunta(const string atributo,const int num_personajes) {
	this->atributo       = atributo;
	this->num_personajes = num_personajes;
}

Pregunta::~Pregunta() {
	atributo       = "";
	num_personajes = 0;
}

Pregunta & Pregunta::operator = (const Pregunta & pregunta) {
	this->atributo       = pregunta.atributo;
	this->num_personajes = pregunta.num_personajes;
	return *this;
}

ostream& operator<< (ostream& os, const Pregunta &pregunta) {
	if(pregunta.num_personajes==1) {
		os << "Personaje: " << pregunta.atributo << " ";
	}else{
		os << "Pregunta: ¿Es "<< pregunta.atributo << "? ";
	}
	os<< "(num_personajes="<< pregunta.num_personajes << ")";
	return os;
}

int Pregunta::obtener_num_personajes() const {
	return num_personajes;
}

void Pregunta::aumentar_num_personajes() {
	num_personajes++;
}

string Pregunta::obtener_pregunta() const {
	assert(num_personajes >1);

	return atributo;
}

string Pregunta::obtener_personaje() const {
	assert(num_personajes == 1);
	return atributo;
}

bool Pregunta::es_personaje()const {
	return num_personajes == 1;
}

bool Pregunta::es_pregunta()const {
	return num_personajes > 1;
}
