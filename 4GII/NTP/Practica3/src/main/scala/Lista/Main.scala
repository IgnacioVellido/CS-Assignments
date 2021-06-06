package Lista

object Main {
  var menor9 = (x: Int) => x<9
  var menor6 = (x: Int) => x<6
  var impar = (x: Int) => x%2 != 0

  def main(args: Array[String]) {
    println("................... Listas ...................")

    print("Sin elementos: ")
    val lista1 = Lista()
    Lista.mostrar(lista1)

    print("\nCon elementos: ")
    val lista3 = Lista(1,2,3,4,5,6,7)
    Lista.mostrar(lista3)

    print("\nEliminando 3 elementos: ")
    Lista.mostrar(Lista.eliminar(lista3, 3))

    print("\nEliminando mientras x < 6: ")
    Lista.mostrar(Lista.eliminarMientras(lista3, menor6))

    print("\nEliminando mientras x < 9: ")
    Lista.mostrar(Lista.eliminarMientras(lista3, menor9))

    print("\nReemplazando cabeza por 9: ")
    Lista.mostrar(Lista.asignarCabeza(lista3, 9))

    print("\nReemplazando cabeza por 9 en lista vacía: ")
    Lista.mostrar(Lista.asignarCabeza(lista1, 9))

    print("\nSuma enteros: ")
    print(Lista.sumaEnteros(lista3))

    print("\nSuma enteros de lista vacía: ")
    print(Lista.sumaEnteros(lista1))

    print("\nProducto enteros: ")
    print(Lista.productoEnteros(lista3))

    print("\nProducto enteros de lista vacía: ")
    print(Lista.productoEnteros(lista1))

    print("\nConcatenar listas: ")
    Lista.mostrar(Lista.concatenar(lista3, lista3))

    print("\nConcatenar listas vacías: ")
    Lista.mostrar(Lista.concatenar(lista1, lista1))

    print("\nEliminar último: ")
    Lista.mostrar(Lista.eliminarUltimo(lista3))

    print("\nEliminar último lista vacía: ")
    Lista.mostrar(Lista.eliminarUltimo(lista1))

    print("\ntoList: ")
    print(Lista.toList(lista3))

    print("\ntoList lista vacía: ")
    print(Lista.toList(lista1))

    print("\nFiltrar impares: ")
    Lista.mostrar(Lista.filtrar(lista3)(impar))

    print("\nFiltrar impares lista vacía: ")
    Lista.mostrar(Lista.filtrar(lista1)(impar))

    print("\nSuma foldRight: ")
    print(Lista.sumaFoldRight(lista3))

    print("\nSuma foldRight de lista vacía: ")
    print(Lista.sumaFoldRight(lista1))

    print("\nProducto foldRight: ")
    print(Lista.productoFoldRight(lista3))

    print("\nProducto foldRight de lista vacía: ")
    print(Lista.productoFoldRight(lista1))

    print("\nSuma foldLeft: ")
    print(Lista.sumaFoldLeft(lista3))

    print("\nSuma foldLeft de lista vacía: ")
    print(Lista.sumaFoldLeft(lista1))
  }
}
