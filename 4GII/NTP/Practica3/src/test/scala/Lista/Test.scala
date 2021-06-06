package Lista

import org.scalacheck.{Gen, Properties}
import org.scalacheck.Prop.forAll

object Test extends Properties("Lista"){
  val menor9 = (x: Int) => x<9
  val menor6 = (x: Int) => x<6
  val impar = (x: Int) => x%2 != 0

  var listas = for {
    l <- Gen.listOf(Gen.choose(0, 50))
  } yield l

  // =========================================================================

  property("Suma Enteros") = {
    forAll(listas) { x => {
      val lista = Lista(x: _*)
      val sum = x.sum
      sum == Lista.sumaEnteros(lista)
    }}
  }

  property("Suma Enteros foldRight") = {
    forAll(listas) { x => {
      val lista = Lista(x: _*)
      val sum = x.sum
      sum == Lista.sumaFoldRight(lista)
    }}
  }

  property("Suma Enteros foldLeft") = {
    forAll(listas) { x => {
      val lista = Lista(x: _*)
      val sum = x.sum
      sum == Lista.sumaFoldLeft(lista)
    }}
  }

  // =========================================================================

  property("Producto Enteros") = {
    forAll(listas) { x => {
      val lista = Lista(x: _*)
      val prod = x.product
      prod == Lista.productoEnteros(lista)
    }}
  }

  property("Producto Enteros foldRight") = {
    forAll(listas) { x => {
      val lista = Lista(x: _*)
      val prod = x.product
      prod == Lista.productoFoldRight(lista)
    }}
  }

  // =========================================================================

  property("Filtrar impares") = {
    forAll(listas) { x => {
      var lista = Lista(x: _*)
      lista = Lista.filtrar(lista)(impar)
      val sum = x.filter(impar).sum
      sum == Lista.sumaFoldRight(lista)
    }}
  }

  property("Filtrar menores que 9") = {
    forAll(listas) { x => {
      var lista = Lista(x: _*)
      lista = Lista.filtrar(lista)(menor9)
      val sum = x.filter(menor9).sum
      sum == Lista.sumaFoldRight(lista)
    }}
  }

  // =========================================================================

  property("Concatenar") = {
    forAll(listas) { x => {
      var lista = Lista(x: _*)
      lista = Lista.concatenar(lista, lista)
      val sum = (x:::x).sum
      sum == Lista.sumaFoldRight(lista)
    }}
  }

  property("Eliminar último") = {
    forAll(listas) { x => {
      if (x.nonEmpty) { // Para no eliminar desde una lista vacía
        var lista = Lista(x: _*)
        lista = Lista.eliminarUltimo(lista)
        val sum = x.dropRight(1).sum
        sum == Lista.sumaFoldRight(lista)
      }
      else
        true
    }}
  }

  property("Eliminar mientras <6") = {
    forAll(listas) { x => {
      if (x.nonEmpty) { // Para no eliminar desde una lista vacía
        var lista = Lista(x: _*)
        val aux = x.dropWhile(menor6)
        aux.equals(Lista.toList(Lista.eliminarMientras(lista, menor6)))
      }
      else
        true
    }}
  }

  // =========================================================================
}