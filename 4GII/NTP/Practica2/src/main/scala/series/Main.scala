package series

object Main {

  // x = f-1, y = f-2
  val fibonacci  = (x: Int, y: Int) => x+y
  val lucas      = (x: Int, y: Int) => x+y
  val pell       = (x: Int, y: Int) => 2*x+y
  val pellLucas  = (x: Int, y: Int) => 2*x+y
  val jacobsthal = (x: Int, y: Int) => x+2*y

  def main(args: Array[String]) {
    println("................... Series ...................")
    println("Fibonacci: "  + calculaSerie(0,1, fibonacci, 6))
    println("Lucas: "      + calculaSerie(2,1, lucas, 6))
    println("Pell: "       + calculaSerie(2,6, pell, 5))
    println("Pell-Lucas: " + calculaSerie(2,2, pellLucas, 6))
    println("Jacobsthal: " + calculaSerie(0,1, jacobsthal, 6))
  }

  /**
   * Aplica el operador a los dos primeros elementos (consiguiendo f2), y llama recursivamente
   * simulando que f1=f0 y f2=f1
   * @param f0
   * @param f1
   * @param op
   * @param pos
   * @return
   */
  @annotation.tailrec
  def calculaSerie(f0: Int, f1: Int, op: (Int,Int) => Int, pos: Int): Int = {
    if (pos == 0) { // Salvo que se introduzca como parámetro nunca llegará aquí
      return f0
    }
    if (pos == 1) {
      return f1
    }
    calculaSerie(f1, op(f0,f1), op, pos-1)
  }
}

