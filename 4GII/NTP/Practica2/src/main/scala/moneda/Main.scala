package moneda

object Main {

  def main(args: Array[String]) {
    println("................... Monedas ...................")
    listarCambiosPosibles(0, List()).foreach(println)
  }

  /**
   *
   * @param cantidad Cantidad a calcular
   * @param monedas Lista de valores de monedas (ordenadas crecientemente y sin repetición)
   * @return Lista de posibles cambios
   */
  def listarCambiosPosibles(cantidad: Int, monedas: List[Int]): List[List[Int]] = {
    var res = List[List[Int]](List()) // Creamos estructura vacía

    if (cantidad == 0) {
      return res
    }

    monedas.filter(m => cantidad >= m).foreach(m => {
      val aux = listarCambiosPosibles(cantidad - m, monedas)

      if (aux != null) {
        // Incluímos la moneda actual al resto de cambios encontrados
        res = aux.map(x => m::x):::res

        // Eliminar listas vacías que han quedado en res
        res = res.filter(x => x.nonEmpty)
      }
    })

    // Si no ha encontrado ninguna opción, devolver null
    if (cantidad > 0 && !res.exists(x => x.nonEmpty)) {
      return null
    }

    // Ordenar elementos de cada lista y eliminar repetidos
    res.map(x => x.sorted).distinct
  }
}
