package Conjunto

/**
 * Clase conjunto que define si un elemento o no pertenece a partir del
 * parámetro funcion
 *
 * @param funcion
 */
class Conjunto(val funcion: Int => Boolean) {
  /**
   * Indica si el @elemento pertenece o no al conjunto
   * @param elemento
   * @return
   */
  def apply(elemento: Int): Boolean = funcion(elemento)


  /**
   * Creación de un conjunto dado por un único elemento
   * @param elemento
   * @return
   */
  def conjuntoUnElemento(elemento: Int): Conjunto =
    new Conjunto((x: Int) => x == elemento)


  /**
   * Unión de dos conjuntos
   * @param conjunto2
   * @return
   */
  def union(conjunto2: Conjunto): Conjunto =
    new Conjunto((x: Int) => funcion(x) || conjunto2.funcion(x))


  /**
   * Intersección de dos conjuntos
   * @param conjunto2
   * @return
   */
  def interseccion(conjunto2: Conjunto): Conjunto =
    new Conjunto((x: Int) => funcion(x) && conjunto2.funcion(x))


  /**
   * Elementos que pertenecen a conjunto1 y no a conjunto2
   * @param conjunto2
   * @return
   */
  def diferencia(conjunto2: Conjunto): Conjunto =
    new Conjunto((x: Int) => funcion(x) && !conjunto2.funcion(x))


  /**
   * Devuelve el conjunto que cumple la condición dada
   * @param function
   * @return
   */
  def filtrar(function: Int => Boolean): Conjunto =
    // Equivale a la intersección
    interseccion(new Conjunto(function))


  /**
   * Comprueba si un predicado se cumple para todos los elementos del conjunto
   * @param predicado
   * @param limite: >= 0
   * @return
   */
  // Vamos restando el límite y comprobando
  def paraTodo(predicado: Int => Boolean, limite: Int): Boolean = {
    @annotation.tailrec
    def iterar(predicado: Int => Boolean, limite: Int, cumpleCondicion: Boolean): Boolean = {
      if (limite <= 0)
        true
      else
        iterar(predicado, limite-1, predicado(limite) && predicado(-limite) && cumpleCondicion)
    }

    iterar(predicado, limite-1, predicado(limite) && predicado(-limite))
  }


  /**
   * Determina si existe elemento que cumple predicado
   * @param predicado
   * @return
   */
  // Sustituye ors por ands
  def existe(predicado: Int => Boolean, limite: Int): Boolean = {
    @annotation.tailrec
    def iterar(predicado: Int => Boolean, limite: Int, cumpleCondicion: Boolean): Boolean = {
      if (limite <= 0)
        false
      else
        iterar(predicado, limite-1, predicado(limite) || predicado(-limite) || cumpleCondicion)
    }

    iterar(predicado, limite-1, predicado(limite) || predicado(-limite))
  }


  /**
   * Aplica un predicado a todos los elementos del conjunto
   * @param predicado
   * @return
   */
  def map(predicado: Int => Int): Conjunto = new Conjunto((x: Int) => funcion(predicado(x)))


  /**
   * Devuelve una lista con los elementos en el rango (-limite, +limite)
   * @param limite
   * @return
   */
  def toList(limite: Int): List[Int] = {
    var lista = List[Int]()
    for (x <- -limite to limite) {
      if (funcion(x))
        lista = lista :+ x
    }
    lista
  }


  /**
   * Imprime los valores en el rango (-limite, +limite)
   * @param limite
   * @return
   */
  def toString(limite: Int): String = {
    var string = ""
    for (x <- -limite to limite) {
      if (funcion(x))
        string = string + x.toString  + "\t "
    }
    string
  }
}
