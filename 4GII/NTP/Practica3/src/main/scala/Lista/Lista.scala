package Lista

/**
 * Interfaz genérica para la lista
 * @tparam A
 */
sealed trait Lista[+A]

/**
 * Objeto para definir lista vacia
 */
case object Nil extends Lista[Nothing]

/**
 * Clase para definir la lista como compuesta por elemento inicial
 * (cabeza) y resto (cola)
 * @param cabeza
 * @param cola
 * @tparam A
 */
case class Cons[+A](cabeza : A, cola : Lista[A]) extends Lista[A]

// --------------------------------------------------------------
// --------------------------------------------------------------

object Lista {
  /**
   * Metodo para permitir crear listas sin usar new
   * @param elementos secuencia de elementos a incluir en la lista
   * @tparam A
   * @return
   */
  def apply[A](elementos : A*) : Lista[A] = {
    if (elementos.isEmpty)
      Nil
    else // _* -> Splat, separar los elementos y recogerlos
      Cons(elementos(0), apply(elementos.tail: _*))
  }

  /**
   * Obtiene la longitud de una lista
   * @param lista
   * @tparam A
   * @return
   */
  def longitud[A](lista : Lista[A]) : Int = {
    lista match {
      case Nil => 0
      case Cons(_, cola) => 1 + longitud(cola)
    }
  }

  /**
   * Metodo para sumar los valores de una lista de enteros
   * @param enteros
   * @return
   */
  def sumaEnteros(enteros : Lista[Int]) : Int = {
    enteros match {
      case Nil => 0
      case Cons(cabeza, cola) => cabeza + sumaEnteros(cola)
    }
  }

  /**
   * Metodo para multiplicar los valores de una lista de enteros
   * @param enteros
   * @return
   */
    def productoEnteros(enteros : Lista[Int]) : Int = {
      // Para Scala el producto de una lista vacía es uno
      enteros match {
        case Nil => 1
        case Cons(cabeza, cola) => cabeza * productoEnteros(cola)
      }
    }

  /**
   * Metodo para agregar el contenido de dos listas
   * @param lista1
   * @param lista2
   * @tparam A
   * @return
   */
   def concatenar[A](lista1: Lista[A], lista2: Lista[A]): Lista[A] = {
     lista1 match {
       case Nil => lista2       // Devolver segunda si vacía
       case Cons(_, _) => {
         lista2 match {
           case Nil => lista1   // Devolver primera si vacía
           case Cons(cabeza2, cola2) => {
              // Concatenar
              var aux1 = Cons(cabeza2, lista1).asInstanceOf[Lista[A]]

              // Queda cola2
              var aux2 = cola2
              while (longitud(aux2) != 0) {
                val elem = obtenerCabeza(aux2)
                aux2 = eliminar(aux2, 1)
                aux1 = Cons(elem, aux1).asInstanceOf[Lista[A]]
              }

              aux1  // Devolver
           }
         }
       }
     }
   }

  /**
   * Funcion de utilidad para aplicar una funcion de forma sucesiva a los
   * elementos de la lista con asociatividad por la derecha
   * @param lista
   * @param neutro
   * @param funcion
   * @tparam A
   * @tparam B
   * @return
   */
    def foldRight[A, B](lista : Lista[A], neutro : B)(funcion : (A, B) => B): B = {
      lista match {
        case Nil => neutro
        case Cons(cabeza, cola) =>
          funcion(cabeza, foldRight(cola, neutro)(funcion)) // Vamos de derecha a izquierda
      }
    }

  /**
   * Suma mediante foldRight
   * @param listaEnteros
   * @return
   */
    def sumaFoldRight(listaEnteros : Lista[Int]) : Double = {
      listaEnteros match {
        case Nil => 0
        case Cons(cabeza, cola) =>
          foldRight(cola, cabeza)(_ + _)
      }
    }

  /**
   * Producto mediante foldRight
   * @param listaEnteros
   * @return
   */
  def productoFoldRight(listaEnteros : Lista[Int]) : Int = {
    listaEnteros match {
      case Nil => 1
      case Cons(cabeza, cola) =>
        foldRight(cola, cabeza)(_ * _)
    }
  }

  /**
   * Reemplaza la cabeza por nuevo valor. Se asume que si la lista esta vacia
   * se devuelve una lista con el nuevo elemento
   *
   * @param lista
   * @param cabezaNueva
   * @tparam A
   * @return
   */
  def asignarCabeza[A](lista : Lista[A], cabezaNueva : A) : Lista[A] = {
    lista match {
      case Nil => Cons(cabezaNueva, Nil)
      case Cons(_, cola) => Cons(cabezaNueva, cola)
    }
  }

  /**
   * Obtiene el elemento que ocupa la cabeza de la lista
   *
   * @param lista
   * @tparam A
   * @return
   */
  def obtenerCabeza[A](lista : Lista[A]): A = {
    lista match {
      case Nil => throw new ArrayIndexOutOfBoundsException("Lista vacía")
      case Cons(cabeza, _) => cabeza
    }
  }

  /**
   * Elimina el elemento cabeza de la lista y devuelve la lista con
   * el resto de elementos
   * @param lista
   * @tparam A
   * @return
   */
    def obtenerCola[A](lista : Lista[A]): Lista[A] = {
      lista match {
        case Nil => Nil
        case Cons(_, cola) => cola
      }
    }

  /**
   * Elimina los n primeros elementos de una lista
   * @param lista lista con la que trabajar
   * @param n numero de elementos a eliminar
   * @tparam A tipo de datos
   * @return
   */
  def eliminar[A](lista : Lista[A], n: Int) : Lista[A] = {
    var aux = lista
    for (_ <- 1 to n) {
      aux = obtenerCola(aux)
    }
    aux
  }

  /**
   * Elimina elementos mientra se cumple la condicion pasada como
   * argumento
   * @param lista lista con la que trabajar
   * @param criterio predicado a considerar para continuar con el borrado
   * @tparam A tipo de datos a usar
   * @return
   */
    def eliminarMientras[A](lista : Lista[A], criterio: A => Boolean) : Lista[A] = {
      var aux = lista
      try {
        while (criterio(obtenerCabeza(aux))) {
          aux = obtenerCola(aux)
        }
      }
      catch {
        case _: Exception => aux = Nil
      }

      aux
    }


  /**
   * Elimina el último elemento de la lista. Aquí no se pueden compartir
   * datos en los objetos y hay que generar una nueva lista copiando
   * datos
   * @param lista lista con la que trabajar
   * @tparam A tipo de datos de la lista
   * @return
   */
    def eliminarUltimo[A](lista : Lista[A]) : Lista[A] = {
      if (longitud(lista) == 0)
        lista
      else if (longitud(lista) == 1)
        Nil
      else
        Cons(obtenerCabeza(lista), eliminarUltimo(obtenerCola(lista)))
    }

    /**
      * foldLeft con recursividad tipo tail
      * @param lista lista con la que trabajar
      * @param neutro elemento neutro
      * @param funcion funcion a aplicar
      * @tparam A parametros de tipo de elementos de la lista
      * @tparam B parametro de tipo del elemento neutro
      * @return
      */
    @annotation.tailrec
    def foldLeft[A, B](lista : Lista[A], neutro: B)(funcion : (B, A) => B): B = {
      lista match {
        case Nil => neutro
        case Cons(cabeza, cola) =>
          foldLeft(cola, funcion(neutro, cabeza))(funcion) // Vamos de izquierda a derecha
      }
    }

    /** suma via foldLeft
      * @param lista
      * @return
      */
    def sumaFoldLeft(lista : Lista[Int]): Int = {
      lista match {
        case Nil => 0
        case Cons(cabeza, cola) =>
          foldLeft(cola, cabeza)(_ + _)
      }
    }

  /**
    * Metodo de filtrado para quedarnos con los elementos
    * que cumplen una determinada condicion
    * @param lista
    * @param criterio
    */
  def filtrar(lista: Lista[Int])(criterio : (Int) => Boolean): Lista[Int] = {
    lista match {
      case Nil => Nil
      case Cons(cabeza, cola) => {
        // Comprobar cabeza
        if (criterio(cabeza)) {
          val aux = Cons(cabeza, Nil)
          // Comprobar resto de elementos
          concatenar(filtrar(cola)(criterio), aux)
        }
        else {
          // Comprobar resto de elementos
          concatenar(Nil, filtrar(cola)(criterio))
        }
      }
    }
  }

  /**
   * Metodo para mostrar el contenido de la lista
 *
   * @param lista
   * @return
   */
  @annotation.tailrec
  def mostrar[A](lista : Lista[A]) : Unit = {
    lista match {
      case Nil =>
      case Cons(cabeza, cola) => print(cabeza.toString + " "); mostrar(cola)
    }
  }

  /**
   * Funcion de utilidad para facilitar la programación de los
   * casos de prueba: el resultado de las funciones propias debe
   * producir el mismo resultado que si se usara un objeto de la
   * clase List directamente
   * @param lista
   * @tparam A
   * @return
   */
    def toList[A](lista : Lista[A]) : List[A] = {
      lista match {
        case Nil => List()
        case Cons(cabeza, cola) => {
          var list = List[A]()
          list = list :+ cabeza
          list ::: toList(cola)
        }
      }
    }
}