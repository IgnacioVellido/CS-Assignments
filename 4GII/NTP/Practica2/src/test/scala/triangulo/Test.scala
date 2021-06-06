package triangulo

import org.scalacheck.{Gen, Properties}
import org.scalacheck.Prop.{forAll, forAllNoShrink}

object Test extends Properties("Triangulo Pascal"){
  private val MAXIMO=15

  // generador
  val coordenadasExtremos = for {
    fila <- Gen.choose(0, MAXIMO)
    columna <- Gen.oneOf(0, fila)
  } yield (fila, columna)

  // propiedad
  property("Elementos en los extremos") = {
    forAll(coordenadasExtremos) { i => {
      val valor = Main.calcularValorTrianguloPascal(i._1, i._2)

      valor == 1
    }}
  }

  // =========================================================================

  // generador coordenadas internas
  val coordenadasInteriores = for {
    fila <- Gen.choose(2, MAXIMO)
    columna <- Gen.choose(1, fila-1)
  } yield(fila, columna)

  property("Elementos interiores") = {
    forAll(coordenadasInteriores) { i => {
      val valor = Main.calcularValorTrianguloPascal(i._1, i._2)
      val padreIzq = Main.calcularValorTrianguloPascal(i._1-1, i._2-1)
      val padreDch = Main.calcularValorTrianguloPascal(i._1-1, i._2)

      valor == (padreIzq + padreDch)
    }}
  }

  // =========================================================================

  val coordenadasCualquiera = for {
    fila <- Gen.choose(0, MAXIMO)
    columna <- Gen.choose(0, if (fila>0) fila-1 else 0)
  } yield(fila, columna)

  property("Ningún valor vale cero") = {
    forAll(coordenadasCualquiera) { i => {
      val valor = Main.calcularValorTrianguloPascal(i._1, i._2)

      valor != 0
    }}
  }

  // =========================================================================

  def factorial(x: Int) = {
    @annotation.tailrec
    def iterar(x: Int, acum: Long): Long = {
      if (x == 0 || x == 1)
        return acum

      iterar(x-1, acum*x)
    }
    iterar(x, 1)
  }

  property("Comprobando con fórmula") = {
    forAllNoShrink(coordenadasCualquiera) { i => {
      val valor = Main.calcularValorTrianguloPascal(i._1, i._2)

      valor == factorial(i._1) / (factorial(i._2) * factorial(i._1 - i._2))
    }}
  }
}
