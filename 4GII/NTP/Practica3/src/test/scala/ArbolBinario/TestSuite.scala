package ArbolBinario

import org.scalatest.FunSuite

class TestSuite extends FunSuite {
  val nodos = List(Some(1),Some(2),Some(3),Some(4),Some(5),Some(6),Some(7),Some(8),Some(9),Some(10),Some(11))
  val nodos2 = List(Some(1),Some(2),Some(3))
  val nodos3 = List()

  val arbol = new ArbolBinario(nodos)
  val arbol2 = ArbolBinario2(nodos)

  val vacio = new ArbolBinario(nodos3)
  val vacio2 = ArbolBinario2(nodos3)

  // =========================================================================

  test("Sin elementos") {
    assert(vacio.size() == 0)
  }
  test("Con elementos") {
    assert(arbol.size() == nodos.size)
  }

  // =========================================================================

  test("Sin elementos v2") {
    assert(ArbolBinario2.size(vacio2) == 0)
  }
  test("Con elementos v2") {
    assert(ArbolBinario2.size(arbol2) == nodos.size)
  }
}
