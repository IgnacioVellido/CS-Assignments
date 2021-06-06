package ArbolBinario

/**
 * Interfaz base para un árbol binario (representado mediante enlaces de nodos)
 * e incluyendo valores opcionales.
 * Si el nodo está vacío, carece de valor, pero permite tener hijos
 * @tparam A
 */
sealed trait ArbolBinario2[+A]

/**
 * Árbol vacío
 */
case object Nil extends ArbolBinario2[Nothing]

/**
 * Árbol con elementos
 * @param padre
 * @param hijoIzq
 * @param hijoDch
 * @tparam A
 */
case class Cons[A](padre: Nodo[A], hijoIzq: ArbolBinario2[A], hijoDch: ArbolBinario2[A]) extends ArbolBinario2[A]

/**
 * Clase nodo con identificador y valor
 * @param id
 * @param valor
 * @tparam A
 */
case class Nodo[A](id: Int, valor: A)

// --------------------------------------------------------------
// --------------------------------------------------------------

object ArbolBinario2 {
  /**
   * Creación de un árbol binario a partir de la notación en forma
   * de lista
   * @param nodos
   * @tparam A
   * @return
   */
  def apply[A](nodos: List[Option[A]]): ArbolBinario2[A] = {
    // Árbol vacío
    if (nodos.isEmpty || nodos.head.isEmpty)
      return Nil


    def iterar[A](nodos: List[Option[A]], pos: Int): ArbolBinario2[A] = {
      if (pos >= nodos.size)
        Nil
      else {
        val izq = iterar(nodos,2*pos + 1)
        val dch = iterar(nodos,2*pos + 2)

        val actual = Nodo(pos, nodos(pos).getOrElse(None))
        Cons(actual, izq, dch).asInstanceOf[ArbolBinario2[A]]
      }
    }

    iterar(nodos, 0)
  }


  /**
   * Indica si existe nodo en la posición dada
   * @param pos
   * @return
   */
  def existeNodo[A](pos: Int, nodos: List[Option[A]]): Boolean =
    pos < nodos.size


  /**
   * Si el nodo existe y no es nulo
   * @param pos
   * @param nodos
   * @tparam A
   * @return
   */
  def nodoNoNulo[A](pos: Int, nodos: List[Option[A]]): Boolean =
    pos < nodos.size && nodos(pos).nonEmpty


  /**
   * Indica si el nodo es hoja
   * @param pos
   * @param nodos
   * @tparam A
   * @return
   */
  def esHoja[A](pos: Int, nodos: List[Option[A]]): Boolean = {
    val hijo1 = (2*pos) + 1
    val hijo2 = (2*pos) + 2

    !nodoNoNulo(hijo1, nodos) && !nodoNoNulo(hijo2, nodos)
  }


  /**
   * Obtener las hojas del árbol
   * @param arbol
   * @tparam A
   * @return
   */
  def getHojas[A](arbol: ArbolBinario2[A]): List[A] = {
    arbol match {
      case Nil => List()
      case Cons(padre, hijoIzq, hijoDch) => {
        val izq = getHojas(hijoIzq)
        val dch = getHojas(hijoDch)

        if (izq.isEmpty && dch.isEmpty && padre.valor != None) { // Es hoja
          val valor = padre.valor
          List(valor)
        }
        else // Devolvemos la hojas de cada subárbol
          izq ++ dch
      }
    }
  }


  /**
   * Recorrido en anchura contando los nodos vacíos pero con hijos
   * @param arbol
   * @tparam A
   * @return
   */
  def getNodos[A](arbol: ArbolBinario2[A]): List[Option[A]] = {
    arbol match {
      case Nil => List(None)
      case Cons(padre, hijoIzq, hijoDch) => {
        var izq = getNodos(hijoIzq)
        var dch = getNodos(hijoDch)

        var valor : Option[A] = None
        if (padre.valor.getClass.getName != "scala.None$")
          valor = Some(padre.valor)

        var lista = List[Option[A]](valor)

        if (izq.nonEmpty) {
          lista = lista ++ List(izq.head)
          izq = izq.tail
        }
        if (dch.nonEmpty) {
          lista = lista ++ List(dch.head)
          dch = dch.tail
        }

        // Juntar los subárboles (por capas)
        var tam = izq.size
        if (dch.size > tam)
          tam = dch.size

        // Cada nivel se encuentra en el rango [2^n - 2, 2^(n+1) -2)
        for (i <- 0 until tam) {
          val init = (scala.math.pow(2, i) - 2).toInt
          val fin = (scala.math.pow(2, i+1) - 2).toInt
          val listaIzq = izq.slice(init, fin)
          val listaDch = dch.slice(init, fin)
          lista = lista ++ listaIzq ++ listaDch
        }

        lista
      }
    }
  }


  /**
   * Contando nodos vacíos no hoja
   * @param arbol
   * @tparam A
   * @return
   */
  def size[A](arbol: ArbolBinario2[A]): Int =
    getNodos(arbol).reverse.dropWhile(_.isEmpty).size


  /**
   * Recorrido en anchura
   * @param arbol
   * @tparam A
   * @return
   */
  def recorrerAnchura[A](arbol: ArbolBinario2[A]): List[A] = {
    arbol match {
      case Nil => List()
      case Cons(padre, hijoIzq, hijoDch) => {
        var izq = recorrerAnchura(hijoIzq)
        var dch = recorrerAnchura(hijoDch)
        var lista = List[A](padre.valor)

        if (izq.nonEmpty) {
          lista = lista ++ List(izq.head)
          izq = izq.tail
        }
        if (dch.nonEmpty) {
          lista = lista ++ List(dch.head)
          dch = dch.tail
        }

        // Juntar los subárboles
        var tam = izq.size
        if (dch.size > tam)
          tam = dch.size

        // Cada nivel se encuentra en el rango [2^n - 2, 2^(n+1) -2)
        for (i <- 0 until tam) {
          val init = (scala.math.pow(2, i) - 2).toInt
          val fin = (scala.math.pow(2, i+1) - 2).toInt
          val listaIzq = izq.slice(init, fin)
          val listaDch = dch.slice(init, fin)
          lista = lista ++ listaIzq ++ listaDch
        }

        lista
      }
    }
  }


  /**
   * Recorrido en profundidad
   * @param arbol
   * @tparam A
   * @return
   */
  def recorrerProfundidad[A](arbol: ArbolBinario2[A]): List[A] = {
    arbol match {
      case Nil => List()
      case Cons(padre, hijoIzq, hijoDch) => {
        val valor = padre.valor
        val izq = recorrerProfundidad(hijoIzq)
        val dch = recorrerProfundidad(hijoDch)
        val lista = List[A](valor)
        lista ++ izq ++ dch
      }
    }
  }


  /**
   * Reducir las hojas a un único valor usando function
   * @param arbol
   * @param function
   * @tparam A
   * @return
   */
  def reduceHojas[A](arbol: ArbolBinario2[A])(function: (A,A) => A): A =
    getHojas(arbol).reduce(function)


  /**
   * Sumar los valorees de cada hoja
   * @param arbol
   * @return
   */
  def sumarHojas(arbol: ArbolBinario2[Int]): Int = getHojas(arbol).sum


  /**
   * Aplica function a cada hoja
   * @param arbol
   * @param function
   * @tparam A
   * @return
   */
  def mapHojas[A](arbol: ArbolBinario2[A])
                 (function: Option[A] => Option[A]): ArbolBinario2[A] = {
    // Cogemos los nodos como lista
    var nodos = getNodos(arbol).reverse.dropWhile(_.isEmpty).reverse

    // Modificamos las hojas
    val tam = nodos.size
    for (i <- 0 until tam) {
      if (esHoja(i, nodos))
        nodos = nodos.updated(i, function(nodos(i)))  // Como i < size, siempre va a existir
    }
    apply(nodos)
  }


  /**
   * Unión de dos árboles, aplicando function cuando dos nodos coinciden en la misma posición
   * @param arbol
   * @param arbol2
   * @param function
   * @tparam A
   * @return
   */
  def union[A](arbol: ArbolBinario2[A], arbol2: ArbolBinario2[A])
              (function: (Option[A],Option[A]) => Option[A]): ArbolBinario2[A] = {
    // Cogemos los nodos como lista ---------------------
    val nodos = getNodos(arbol)
    val nodos2 = getNodos(arbol2)

    // Aplicamos la unión -------------------------------

    // Itera hasta el más largo, rellenando con None
    var lista = List[Option[A]]()
    for ((x,y) <- nodos.zipAll(nodos2, None, None))
      lista = lista ++ List(function(x.asInstanceOf[Option[A]], y.asInstanceOf[Option[A]]))

    // Devolvemos el nuevo árbol ----------------
    apply(lista)
  }


  /**
   * Representación en lista
   * @param arbol
   * @tparam A
   * @return
   */
  def toString[A](arbol: ArbolBinario2[A]): String =
    getNodos(arbol).reverse.dropWhile(x => x.isEmpty).reverse.toString()


  /**
   * Representación gráfica del árbol en formato String
   * @return
   */
  def pintar[A](arbol: ArbolBinario2[A]): String = {
    var string = ""

    def iterar[A](arbol: ArbolBinario2[A], pos: Int, tabulaciones: Int): String = {
      val nodos = getNodos(arbol).reverse.dropWhile(_.isEmpty).reverse
      val hijo1 = (2*pos) + 1
      val hijo2 = (2*pos) + 2
      var string = "\t" * (tabulaciones-1) + "∟ " + nodos(pos).getOrElse(None).toString

      if (existeNodo(hijo1, nodos)) { // Si tiene hijo a izq
        if (existeNodo(hijo2, nodos)) { // Si tiene hijo a dch
          string += "\n" + iterar(arbol, hijo2, tabulaciones+1)
          string += "\n" + iterar(arbol, hijo1, tabulaciones+1)
        }
        else
          string += "\n" + iterar(arbol, hijo1, tabulaciones+1)
      }
      else if (existeNodo(hijo2, nodos))  // Si solo tiene hijo a dch
      string += "\n" + iterar(arbol, hijo2, tabulaciones+1)

      string
    }

    if (size(arbol) > 0)
      string = iterar(arbol, 0, 1)

    string
  }
}
