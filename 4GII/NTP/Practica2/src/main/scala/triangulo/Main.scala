package triangulo

object Main {

  def main(args: Array[String]) {
    println("................... Triangulo de Pascal ...................")
    muestraTriangulo(10)

    // Se muestra el valor que debe ocupar la columna 5 en la fila 10
    print("Valor: " + calcularValorTrianguloPascal(10, 5))
  }

  def muestraTriangulo(filas: Int): Unit = {
    // Se muestran 10 filas del trinagulo de Pascal
    for (row <- 0 to filas) {  // Se muestran 10 filas
      for (col <- 0 to row)
        print(calcularValorTrianguloPascal(row, col) + " ")

      // Salto de línea final para mejorar la presentacion
      println()
    }
  }

  /**
   * fila >= columna
   * @param fila
   * @param columna
   * @return
   */
  def calcularValorTrianguloPascal(fila: Int, columna: Int): Int = {
    if (columna.equals(0) || columna.equals(fila)) {
      return 1
    }

    calcularValorTrianguloPascal(fila-1, columna) +
      calcularValorTrianguloPascal(fila-1, columna-1)
  }
}
