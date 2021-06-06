package moneda

import org.scalacheck.{Gen, Properties}
import org.scalacheck.Prop.forAll
import util.Random

object Test extends Properties("Monedas"){
  private val MAXIMO=30

  val monedas: Int => Gen[List[Int]] =
    (n: Int) => {
      Gen.listOfN(n, Gen.choose(1, MAXIMO))
    }

  // =========================================================================

  property("Suman lo mismo") = {
    forAll(monedas.apply(10)) { x => {
      val cantidad = 1 + Random.nextInt((1 + MAXIMO) + 1)
      val cambios = Main.listarCambiosPosibles(cantidad, x.sorted.distinct)

      // Si hay algún cambio que no suma correctamente, el filtro no
      // quedará vacío
      if (cambios != null)
        !cambios.exists(y => y.sum != cantidad) || !cambios.exists(y => y.nonEmpty)
      else
        true
    }}
  }

  // =========================================================================

  property("No devuelve ningún cambio") = {
    forAll(monedas.apply(10)) { x => {
      val cantidad = 0
      val cambios = Main.listarCambiosPosibles(cantidad, x.sorted.distinct)

      !cambios.exists(y => y.nonEmpty)
    }}
  }

  // =========================================================================

  property("Sin monedas") = {
    forAll(monedas.apply(10)) { x => {
      val cantidad = 1 + Random.nextInt((1 + MAXIMO) + 1)
      val cambios = Main.listarCambiosPosibles(cantidad, List())

      (cambios == null) || !cambios.exists(y => y.nonEmpty)
    }}
  }
}
