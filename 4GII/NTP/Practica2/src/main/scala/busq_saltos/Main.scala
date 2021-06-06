package busq_saltos

object Main {
  var menor = (x: Int, y: Int) => x<y

  def main(args: Array[String]) {
    println("................... Busqueda con saltos ...................")
    println(busquedaSaltos(Array(1,2,3,4), 3, menor), 2)
    println(busquedaSaltos(Array(1,2,3,4), 1, menor), 0)
    println(busquedaSaltos(Array(1,2,3,4), 4, menor), 3)
    println(busquedaSaltos(Array(1,2,3,4), 2, menor), 1)
    println(busquedaSaltos(Array(1,2,3,4), 7, menor), -1)
    println(busquedaSaltos(Array(3,8,14), 14, menor), 2)
    println(busquedaSaltos(Array(2,3,45,46), 18, menor), -1)
    println(busquedaSaltos(Array(0,2,3), 0, menor), 0)
    println(busquedaSaltos(Array(-8,0,1,9), 0, menor), 1)
  }

  /**
   * @param coleccion Array ordenado en basa al criterio
   * @param aBuscar
   * @param criterio El elemento primero está a la dch si true, en otro caso a la izq
   * @tparam A
   * @return Posición sobre la que se ubica el elemento, o negativo
   */
  def busquedaSaltos[A](coleccion: Array[A], aBuscar: A, criterio: (A, A) => Boolean): Int = {
    def busquedaLineal[B](coleccion: Array[B], aBuscar: B): Int = {
      var pos = 0
      for (elem <- coleccion) {
        if (elem == aBuscar)
          return pos
        pos += 1
      }
      -1
    }

    // Si la lista está vacía no está el elemento
    if (coleccion.isEmpty)
      return -1

    // Proceso
    val tamBloque = math.sqrt(coleccion.length).toInt
    val max = coleccion.size -1
    var ini = 0
    var fin = Math.min(ini + tamBloque, max)

    // Vamos saltando
    while (criterio(coleccion(fin), aBuscar)) {
      if (coleccion(fin) == aBuscar)
        return fin
      if (fin == max)
        return -1

      ini += tamBloque
      fin = Math.min(ini + tamBloque, max)
    }

    // Si hemos llegado aquí -> Búsqueda lineal sobre el bloque
    val lineal = busquedaLineal(coleccion.slice(ini, fin+1), aBuscar)

    // Si ha encontrado la posición, la devolvemos
    if (lineal >= 0)
      ini + lineal
    else
      -1
  }
}
