package Conjunto

import org.scalatest.FunSuite

class Test extends FunSuite {
  var menor9Pred = (x: Int) => x<9
  var menor6Pred = (x: Int) => x<6
  var imparPred = (x: Int) => x%2 != 0
  var parPred = (x: Int) => x%2 == 0
  var el7Pred = (x: Int) => x == 7
  var vacioPred = (x: Int) => x == 7 && x != 7

  val LIMITE = 200

  val menor6 = new Conjunto(menor6Pred)
  val menor9 = new Conjunto(menor9Pred)
  val impar = new Conjunto(imparPred)
  val par = new Conjunto(parPred)
  val el7 = new Conjunto(el7Pred)
  val vacio = new Conjunto(vacioPred)

  test("Sin elementos") {
    assert(!vacio.existe(vacioPred, LIMITE))
  }
  // Comprueban el número de elementos
  test("El 7") {
    assert(el7.toList(LIMITE)(0) == 7)
  }
  test("Pares") {
    assert(par.toList(LIMITE).size == (LIMITE + ((LIMITE+1)%2)))
  }
  test("Impares") {
    assert(impar.toList(LIMITE).size == (LIMITE + (LIMITE%2)))
  }

  test("¿2 impar?") {
    assert(!impar(2))
  }
  test("¿2 par?") {
    assert(par(2))
  }

  test("Solo el 3") {
    assert(par.conjuntoUnElemento(3).toList(LIMITE).size == 1)
  }

  test("Pares o el 7") {
    assert(par.union(el7).toList(LIMITE).size == (1 + LIMITE + ((LIMITE+1)%2)))
  }
  test("Pares y el 7") {
    assert(par.interseccion(el7).toList(LIMITE).isEmpty)
  }
  test("Impares y <6") {
    val aux = List.range(-LIMITE, 6).filter(imparPred)
    assert(impar.interseccion(menor6).toList(LIMITE).size == aux.size)
  }
  test("Diferencia <9 y <6") {
    assert(menor9.diferencia(menor6).toList(LIMITE).size == 3)
  }

  test("Existe par impar?") {
    assert(!par.existe(imparPred, LIMITE))
  }

  test("Convertir impares en pares") {
    assert(impar.map(x => x+1).toList(LIMITE) == par.toList(LIMITE))
  }
}