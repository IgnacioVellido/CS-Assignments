package Conjunto

object Main {
  var menor9Pred = (x: Int) => x<9
  var menor6Pred = (x: Int) => x<6
  var imparPred = (x: Int) => x%2 != 0
  var parPred = (x: Int) => x%2 == 0
  var el7Pred = (x: Int) => x == 7
  var vacioPred = (x: Int) => x == 7 && x != 7

  val LIMITE = 10

  def main(args: Array[String]) {
    println("................... Conjuntos ...................")
    val menor6 = new Conjunto(menor6Pred)
    val menor9 = new Conjunto(menor9Pred)
    val impar = new Conjunto(imparPred)
    val par = new Conjunto(parPred)
    val el7 = new Conjunto(el7Pred)
    val vacio = new Conjunto(vacioPred)

    println("Sin elementos: " + vacio.toString(LIMITE))
    println("El 7: " + el7.toString(LIMITE))
    println("El 7 en lista: " + el7.toList(LIMITE))
    println("Pares: " + par.toString(LIMITE))
    println("Impares: " + impar.toString(LIMITE))

    println("2 impar?: " + impar.apply(2))
    println("2 par?: " + par.apply(2))

    println("Solo el 3: " + par.conjuntoUnElemento(3).toString(LIMITE))

    println("Pares o el 7: " + par.union(el7).toString(LIMITE))
    println("Pares y el 7: " + par.interseccion(el7).toString(LIMITE))
    println("Impares y <6: " + impar.interseccion(menor6).toString(LIMITE))
    println("Diferencia <9 y <6: " + menor9.diferencia(menor6).toString(LIMITE))

    println("Filtrar impares <6:\t" + impar.filtrar(menor6Pred).toString(LIMITE))

    println("Existe par impar?:\t" + par.existe(imparPred, LIMITE))

    println("Convertir impares en pares:\t" + impar.map(x => x+1).toString(LIMITE))
  }
}

