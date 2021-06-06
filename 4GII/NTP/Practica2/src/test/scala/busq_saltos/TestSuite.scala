package busq_saltos

import org.scalatest.FunSuite
import scala.util.Random

class TestSuite extends FunSuite {
  var menorDouble = (x: Double, y: Double) => x<y

  var listaDouble = for(_ <- 0 to 50) yield {
    Seq.fill(50)(Random.nextDouble())
  }

  test("Con lista de doubles") {
    for (x <- listaDouble) {
      val valor = x(Random.nextInt(x.size-1))
      val pos = Main.busquedaSaltos(x.distinct.sorted.toArray, valor, menorDouble)
      val pos2 = x.distinct.sorted.indexOf(valor)

      assert(pos == pos2)
    }
  }
}
