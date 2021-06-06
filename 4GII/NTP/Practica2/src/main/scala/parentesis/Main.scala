package parentesis

object Main {
  def main(args: Array[String]) {
    println("................... Series ...................")
    println(chequearBalance("())()())".toList))
    println(chequearBalance("Te lo dije (eso esta (todavia) hecho))".toList))
  }

  /**
   * No es necesario mantener dos contadores, con uno es suficiente
   * si comprobamos que nunca pase a un valor negativo
   * @param cadena
   * @return
   */
  def chequearBalance(cadena: List[Char]): Boolean = {
    var contador = 0
    // Filtramos los carácteres que no nos interesan
    for (c <- cadena.filter(x => x == '(' || x == ')')) {
      if (c == '(') {
        contador += 1
      }
      else {
        contador -= 1
      }

      if (contador < 0) {
        return false
      }
    }
    // Cuando llegamos al final, el contador debe valer cero
    contador == 0
  }
}
