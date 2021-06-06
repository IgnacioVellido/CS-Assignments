package busq_binaria

import org.scalameter.api._
import busq_saltos.Main.busquedaSaltos

import scala.util.Random

/**
 * Tiempos para la búsqueda binaria y con saltos
 */
object Tiempos extends Bench.LocalTime {
  var menor = (x: Int, y: Int) => x<y
  val sizes = Gen.range("size")(150, 450, 50)

  val ranges = for {
    size <- sizes
  } yield 0 until size

  performance of "Busqueda" in {
    measure method "binaria" in {
      using(ranges) in {
        r => {
          for (s <- r) {
            val x = Seq.fill(s)(Random.nextInt())
            val valor = Random.nextInt(50)
            Main.busquedaBinaria(x.distinct.sorted.toArray, valor, menor)
          }
        }
      }
    }
    measure method "saltos" in {
      using(ranges) in {
        r => {
          for (s <- r) {
            val x = Seq.fill(s)(Random.nextInt())
            val valor = Random.nextInt(50)
            busquedaSaltos(x.distinct.sorted.toArray, valor, menor)
          }
        }
      }
    }
  }
}
