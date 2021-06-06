package busq_binaria

object Main {
  var menor = (x: Int, y: Int) => x<y

  def main(args: Array[String]) {
    println("................... Busqueda binaria ...................")
    println(busquedaBinaria(Array(1,2,3,4), 3, menor))
    println(busquedaBinaria(Array(1,2,3,4), 1, menor))
    println(busquedaBinaria(Array(1,2,3,4), 4, menor))
    println(busquedaBinaria(Array(1,2,3,4), 2, menor))
    println(busquedaBinaria(Array(1,2,3,4), 7, menor))
  }

  /**
   * @param coleccion Array ordenado en basa al criterio
   * @param aBuscar
   * @param criterio El elemento primero está a la dch si true, en otro caso a la izq
   * @tparam A
   * @return Posición sobre la que se ubica el elemento, o -1
   */
  def busquedaBinaria[A](coleccion: Array[A], aBuscar: A, criterio: (A, A) => Boolean): Int = {
    /**
     * @param fin Intervalo superior abierto
     */
    @annotation.tailrec
    def iterar(coleccion: Array[A], aBuscar: A, criterio: (A,A) => Boolean, inicio: Int, fin: Int): Int = {
      val mitad = inicio + ((fin - inicio) / 2)

      if (coleccion(mitad) == aBuscar)
        mitad
      else if (inicio == mitad) // No está en la colección
        -1
      else if (criterio(aBuscar, coleccion(mitad))) // A la izq
        iterar(coleccion, aBuscar, criterio, inicio, mitad)
      else // A la dch
        iterar(coleccion, aBuscar, criterio, mitad, fin)
    }

    if (coleccion.isEmpty)
      -1
    else
      iterar(coleccion, aBuscar, criterio, 0, coleccion.length)
  }
}
