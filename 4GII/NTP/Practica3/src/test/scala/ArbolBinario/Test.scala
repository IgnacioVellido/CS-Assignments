package ArbolBinario

import org.scalacheck.{Gen, Properties}
import org.scalacheck.Prop.forAll

object Test extends Properties("Árbol Binario"){

  // Se eliminan los nodos vacíos al principio y al final
  var listas = for {
    l <- Gen.listOf(Gen.option(Gen.choose(0, 20)))
  } yield l.reverse.dropWhile(_.isEmpty).reverse.dropWhile(_.isEmpty)

  // =========================================================================

  property("Tamaño") = {
    forAll(listas) { x => {
      val arbol = new ArbolBinario(x)
      x.count(y => y.nonEmpty) == arbol.size()
    }}
  }

  // En esta versión el tamaño difiere cuando las x contiene nodos vacíos ??
  property("Tamaño v2") = {
    forAll(listas) { x => {
      val arbol = ArbolBinario2(x)

      x.size == ArbolBinario2.size(arbol)
    }}
  }

  // =========================================================================

  property("Sumar hojas") = {
    forAll(listas) { x => {
      val arbol = new ArbolBinario(x)
      val hojas = arbol.getHojas

      hojas.sum == arbol.sumarHojas()
    }}
  }

  property("Sumar hojas v2") = {
    forAll(listas) { x => {
      val arbol = ArbolBinario2(x)
      val hojas = ArbolBinario2.getHojas(arbol)

      hojas.sum == ArbolBinario2.sumarHojas(arbol)
    }}
  }

  // =========================================================================

  property("Unión hojas") = {
    forAll(listas) { x => {
      val arbol = new ArbolBinario(x)
      val union = arbol.union2(arbol)

      union.sumarHojas() == (2 * arbol.sumarHojas())
    }}
  }

  property("Unión hojas v2") = {
    val addOptions = (o1: Option[Int], o2: Option[Int]) => (o1, o2) match {
      case (Some(v1), Some(v2)) => Some(v1 + v2)
      case (None, v@Some(_)) => v
      case (v@Some(_), None) => v
      case (None, None) => None
    }

    forAll(listas) { x => {
      val arbol = ArbolBinario2(x)
      val union = ArbolBinario2.union(arbol, arbol)(addOptions)

      ArbolBinario2.sumarHojas(union) == (2 * ArbolBinario2.sumarHojas(arbol))
    }}
  }

  // =========================================================================

  property("x2 a las hojas") = {
    forAll(listas) { x => {
//      var arbol = new ArbolBinario(x)
//      arbol = arbol.mapHojas(x => x*2)
//      val hojas = arbol.getHojas
//      hojas.sum == arbol.sumarHojas()

      // Forma alternativa
      var arbol = new ArbolBinario(x)
      val hojas = arbol.getHojas
      arbol = arbol.mapHojas(y => y*2)

      (hojas.sum * 2) == arbol.sumarHojas()
    }}
  }

  property("x2 a las hojas v2") = {
    forAll(listas) { x => {
      var arbol = ArbolBinario2(x)
      arbol = ArbolBinario2.mapHojas(arbol)(x => x.map(_*2))
      val hojas = ArbolBinario2.getHojas(arbol)
      hojas.sum == ArbolBinario2.sumarHojas(arbol)
    }}
  }

  // =========================================================================

  property("x10 a las hojas") = {
    forAll(listas) { x => {
      var arbol = new ArbolBinario(x)
      arbol = arbol.mapHojas(x => x*10)
      val hojas = arbol.getHojas
      hojas.sum == arbol.sumarHojas()
    }}
  }

  property("x10 a las hojas v2") = {
    forAll(listas) { x => {
//      var arbol = ArbolBinario2(x)
//      arbol = ArbolBinario2.mapHojas(arbol)(x => x.map(_*10))
//      val hojas = ArbolBinario2.getHojas(arbol)
//      hojas.sum == ArbolBinario2.sumarHojas(arbol)

      // Forma alternativa
      var arbol = ArbolBinario2(x)
      val hojas = ArbolBinario2.getHojas(arbol)
      arbol = ArbolBinario2.mapHojas(arbol)(x => x.map(_*10))

      (10 * hojas.sum) == ArbolBinario2.sumarHojas(arbol)
    }}
  }

  // =========================================================================

  property("^2 a las hojas") = {
    forAll(listas) { x => {
      var arbol = new ArbolBinario(x)
      arbol = arbol.mapHojas(y => y*y)
      val hojas = arbol.getHojas
      hojas.sum == arbol.sumarHojas()
    }}
  }

  property("^2 a las hojas v2") = {
    forAll(listas) { x => {
      var arbol = ArbolBinario2(x)
      arbol = ArbolBinario2.mapHojas(arbol)(z => z.map(y => y*y))
      val hojas = ArbolBinario2.getHojas(arbol)
      hojas.sum == ArbolBinario2.sumarHojas(arbol)
    }}
  }
}