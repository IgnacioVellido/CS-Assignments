package ArbolBinario

/**
 * Un árbol binario se puede representar como una lista de elementos
 * donde el hijo de un nodo n se sitúa en la posición 2n+1 y 2n+2
 * El padre se encuentra en floor((n-1)/2)
 *
 * Se incluyen Opction en la lista para indicar que un nodo puede no
 * existir aunque su casilla en la lista esté definida
 * @param nodos
 */
class ArbolBinario(val nodos: List[Option[Int]]) {
  /**
   * Devuelve un árbol a partir de una representación en lista
   * @param nodos
   * @return
   */
  def apply(nodos: List[Option[Int]]): ArbolBinario = new ArbolBinario(nodos)


  /**
   * Tamaño del árbol (incluye hojas y nodos internos)
   * @return
   */
  def size(): Int = nodos.count(x => x.nonEmpty)


  /**
   * Indica si existe nodo en la posición dada (puede ser vacío)
   * @param pos
   * @return
   */
  def existeNodo(pos: Int): Boolean = pos < size


  /**
   * Modifica, si es posible, el nodo en la posición indicada
   * @param pos
   * @param valor
   * @return
   */
  def modificarNodo(pos: Int, valor: Int): ArbolBinario = {
    if (pos < size() && nodos(pos).nonEmpty) // Si existe y no está vacío
      apply(nodos.updated(pos, Some(valor)))
    else
      apply(nodos)
  }


  /**
   * Devuelve una lista con las hojas
   * @return
   */
  def getHojas: List[Int] = {
    val tam = size()
    var hojas = List[Int]()
    for (i <- 0 until tam) {
      val hijo1 = (2*i) + 1
      val hijo2 = (2*i) + 2

      if (!existeNodo(hijo1) && !existeNodo(hijo2))
        hojas = hojas ++ nodos(i)
    }
    hojas
  }


  /**
   * Devuelve lista con el recorrido en anchura del árbol
   * @return
   */
  def recorrerAnchura(): List[Int] = nodos.flatten


  /**
   * Devuelve lista con el recorrido en profundidad del árbol
   * @return
   */
  def recorrerProfundidad(): List[Int] = {
      def iterar(pos: Int): List[Int] = {
        val hijo1 = (2*pos) + 1
        val hijo2 = (2*pos) + 2
        var lista = List[Int](nodos(pos).getOrElse(-1))

        if (existeNodo(hijo1)) { // Si tiene hijo a izq
          if (existeNodo(hijo2)) { // Si tiene hijo a dch
            lista = lista ++ iterar(hijo1)
            lista = lista ++ iterar(hijo2)
          }
          else
            lista = lista ++ iterar(hijo1)
        }
        else if (existeNodo(hijo2))  // Si solo tiene hijo a dch
          lista = lista ++ iterar(hijo2)

        lista
      }

      if (size() > 0)
        iterar(0)
      else
        List[Int]()
  }

  /**
   * Sumar los valores almacenados en las hojas
   * NOTA: También se podría hacer un getHojas().sum
   * @return
   */
  def sumarHojas(): Int = {
    def iterar(pos: Int, acumulado: Int): Int = {
      val hijo1 = (2*pos) + 1
      val hijo2 = (2*pos) + 2

      if (existeNodo(hijo1)) { // Si tiene hijo a izq
        if (existeNodo(hijo2)) // Si tiene hijo a dch
          iterar(hijo2, acumulado + iterar(hijo1, 0))
        else
          iterar(hijo1, acumulado)
      }
      else if (existeNodo(hijo2))  // Si solo tiene hijo a dch
        iterar(hijo2, acumulado)
      else
        nodos(pos).getOrElse(0) + acumulado
    }

    if (size()> 0)
      iterar(0, 0)
    else
      0
  }


  /**
   * Aplica una función a todas las hojas
   * @param funcion
   * @return
   */
  def mapHojas(funcion: Int => Int): ArbolBinario = {
    val tam = size()
    var nuevoArbol = apply(nodos)
    for (i <- 0 until tam) {
      val hijo1 = (2*i) + 1
      val hijo2 = (2*i) + 2

      if (!existeNodo(hijo1) && !existeNodo(hijo2))
        nuevoArbol = nuevoArbol.modificarNodo(i,funcion(nodos(i).getOrElse(0)))   // Como i < size, siempre va a existir
    }
    nuevoArbol
  }


  // Me he ayudado de internet para la suma de dos opcionales
  private val addOptions = (o1: Option[Int], o2: Option[Int]) => (o1, o2) match {
    case (Some(v1), Some(v2)) => Some(v1 + v2)
    case (None, v@Some(_)) => v
    case (v@Some(_), None) => v
    case (None, None) => None
  }

  private def addMapOpcionalALista(lista: List[Option[Int]], x: Option[Int], y: Option[Int]): List[Option[Int]] = {
    if (x.isEmpty)
      lista ++ List(y)
    else if (y.isEmpty)
      lista ++ List(x)
    else
      lista ++ List[Option[Int]](addOptions(x, y))
  }


  /**
   * Generar un nuevo árbol a partir de otros dos,
   * rellenando en anchura
   * @param arbol2
   * @return
   */
  def union(arbol2: ArbolBinario): ArbolBinario = apply(nodos ++ arbol2.nodos)


  /**
   * Si dos nodos se solapan, se suman
   * @param arbol2
   * @return
   */
  def union2(arbol2: ArbolBinario): ArbolBinario = {
    var lista = List[Option[Int]]()

    // Itera hasta el más largo, rellenando con ceros
    for ((x,y) <- nodos.zipAll(arbol2.nodos, Some(0), Some(0))) {
      lista = addMapOpcionalALista(lista, x, y)
    }
    apply(lista)
  }


  def interseccion(arbol2: ArbolBinario): ArbolBinario = {
    var lista = List[Option[Int]]()

    for ((x,y) <- nodos zip arbol2.nodos) // Itera hasta que acaba el más corto
      lista = addMapOpcionalALista(lista, x, y)

    apply(lista)
  }


  /**
   * Representación gráfica del árbol en formato String
   * @return
   */
  override def toString: String = {
    var string = ""

    def iterar(pos: Int, tabulaciones: Int): String = {
      val hijo1 = (2*pos) + 1
      val hijo2 = (2*pos) + 2
      var string = "\t" * (tabulaciones-1) + "∟ " + nodos(pos).getOrElse(None).toString

      if (existeNodo(hijo1)) { // Si tiene hijo a izq
        if (existeNodo(hijo2)) { // Si tiene hijo a dch
          string += "\n" + iterar(hijo2, tabulaciones+1)
          string += "\n" + iterar(hijo1, tabulaciones+1)
        }
        else
          string += "\n" + iterar(hijo1, tabulaciones+1)
      }
      else if (existeNodo(hijo2))  // Si solo tiene hijo a dch
        string += "\n" + iterar(hijo2, tabulaciones+1)

      string
    }

    if (size() > 0)
      string = iterar(0, 1)

    string
  }
}
