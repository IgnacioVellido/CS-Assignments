package series

import org.scalacheck.{Gen, Properties}
import org.scalacheck.Prop.forAll

object Test extends Properties("Series"){
  val fibonacci  = (x: Int, y: Int) => x+y
  val lucas      = (x: Int, y: Int) => x+y
  val pell       = (x: Int, y: Int) => 2*x+y
  val pellLucas  = (x: Int, y: Int) => 2*x+y
  val jacobsthal = (x: Int, y: Int) => x+2*y

  val posiciones = for {
    n <- Gen.choose(2,10)
  } yield n

  // =========================================================================

  property("Posiciones con Fibonacci") = {
    forAll(posiciones) { x => {
      val valor = Main.calculaSerie(0, 1, fibonacci, x)
      val anterior = Main.calculaSerie(0, 1, fibonacci, x - 1)
      val anterior2 = Main.calculaSerie(0, 1, fibonacci, x - 2)

      valor == fibonacci(anterior2, anterior)
    }
    }
  }

  // =========================================================================

  property("Posiciones con Lucas") = {
    forAll(posiciones) { x => {
      val valor = Main.calculaSerie(2, 1, lucas, x)
      val anterior = Main.calculaSerie(2, 1, lucas, x - 1)
      val anterior2 = Main.calculaSerie(2, 1, lucas, x - 2)

      valor == lucas(anterior2, anterior)
    }
    }
  }

  // =========================================================================

  property("Posiciones con Pell") = {
    forAll(posiciones) { x => {
      val valor = Main.calculaSerie(2,6, pell, x)
      val anterior = Main.calculaSerie(2,6, pell, x-1)
      val anterior2 = Main.calculaSerie(2,6, pell, x-2)

      valor == pell(anterior2,anterior)
    }}
  }

  // =========================================================================

  property("Posiciones con Pell-Lucas") = {
    forAll(posiciones) { x => {
      val valor = Main.calculaSerie(2,2, pellLucas, x)
      val anterior = Main.calculaSerie(2,2, pellLucas, x-1)
      val anterior2 = Main.calculaSerie(2,2, pellLucas, x-2)

      valor == pellLucas(anterior2, anterior)
    }}
  }

  // =========================================================================

  property("Posiciones con Jacobsthal") = {
    forAll(posiciones) { x => {
      val valor = Main.calculaSerie(0,1, jacobsthal, x)
      val anterior = Main.calculaSerie(0,1, jacobsthal, x-1)
      val anterior2 = Main.calculaSerie(0,1, jacobsthal, x-2)

      valor == jacobsthal(anterior2, anterior)
    }}
  }
}