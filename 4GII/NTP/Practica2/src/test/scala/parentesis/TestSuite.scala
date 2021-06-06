package parentesis

import org.scalatest.FunSuite

class TestSuite extends FunSuite {
  // Prueba 1
  test("chequear balance: '(if (zero? x) max (/ 1 x))' esta balanceada") {
    assert(Main.chequearBalance("(if (zero? x) max (/ 1 x))".toList))
  }
  // Prueba 2
  test("chequear balance: 'Te lo dije ...' esta balanceada") {
    assert(!Main.chequearBalance("Te lo dije (eso esta (todavia) hecho))".toList))
  }
  // Prueba 3
  test("chequear balance: ':-)' no esta balanceada") {
    assert(!Main.chequearBalance(":-)".toList))
  }
  // Prueba 4
  test("chequear balance: no basta con contar sin mas") {
    assert(!Main.chequearBalance("())(".toList))
  }
  // Prueba 5
  test("(if (a > b) (b/a) else (a/(b*b)))") {
    assert(Main.chequearBalance("(if (a > b) (b/a) else (a/(b*b)))".toList))
  }
  // Prueba 6
  test("(ccc(ccc)cc((ccc(c))))") {
    assert(Main.chequearBalance("(ccc(ccc)cc((ccc(c))))".toList))
  }
  // Prueba 7
  test("(if (a > b) b/a) else (a/(b*b)))") {
    assert(!Main.chequearBalance("(if (a > b) b/a) else (a/(b*b)))".toList))
  }
  // Prueba 7
  test("(ccc(ccccc((ccc(c))))") {
    assert(!Main.chequearBalance("(ccc(ccccc((ccc(c))))".toList))
  }
  // Prueba 8
  test("())()())") {
    assert(!Main.chequearBalance("())()())".toList))
  }
}