package busq_saltos

import org.scalacheck.{Gen, Properties}
import org.scalacheck.Prop.forAll
import util.Random

object Test extends Properties("Saltos"){
  var menor = (x: Int, y: Int) => x<y

  var lista = for {
    l <- Gen.listOf(Gen.choose(0, 50))
  } yield l

  // =========================================================================

  property("Función de la clase e implementación coinciden") = {
    forAll(lista) { x => {
      val valor = Random.nextInt(50)
      val pos = Main.busquedaSaltos(x.sorted.toArray, valor, menor)
      val pos2 = x.sorted.indexOf(valor)

      pos == pos2
    }}
  }

  // =========================================================================

  var menorString = (x: Char, y: Char) => x<y

  var listaStrings = for {
    l <- Gen.listOfN(50, Gen.alphaChar.sample.get)
  } yield l


  property("Con lista de cadenas") = {
    forAll(listaStrings) { x => {
      val valor = x(Random.nextInt(x.size-1))
      val pos = Main.busquedaSaltos(x.distinct.sorted.toArray, valor, menorString)
      val pos2 = x.distinct.sorted.indexOf(valor)

      pos == pos2
    }}
  }
}
