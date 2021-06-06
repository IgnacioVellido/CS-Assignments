package ArbolBinario

object Main {
  def main(args: Array[String]) {
    println("................... Árboles Binarios ...................")

//    val nodos = List(Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(1), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0), Some(0))
//    val nodos = List(Some(1),Some(2),Some(3),Some(4),Some(5), None, Some(6),Some(7),Some(8),Some(9),Some(10),Some(11))
    val nodos = List(Some(1), Some(2), None, Some(3), Some(4))
    val nodos2 = List(Some(1),Some(2), Some(3))
    val arbol = new ArbolBinario(nodos)
    val arbol2 = new ArbolBinario(nodos2)

    println("En anchura:\t" + arbol.recorrerAnchura())
    println("En profundidad:\t" + arbol.recorrerProfundidad())

    println("toString:\n" + arbol.toString)

    println("x2 en hojas:\n" + arbol.mapHojas(x => x*2).recorrerAnchura().toString)

    println("Sumar hojas: " + arbol.sumarHojas().toString)

    println("Unión:\n" + arbol.union(arbol2).toString)
    println("Unión v2:\n" + arbol.union2(arbol2).toString)

    println("Hojas:\n" + arbol.getHojas)

    // =========================================================================
    println("................... Árboles Binarios v2 ...................")
    // =========================================================================

    val arbol3 = ArbolBinario2(nodos)
    val arbol4 = ArbolBinario2(nodos2)

    println("Get nodos:\t" + ArbolBinario2.getNodos(arbol3))
    println("En anchura:\t" + ArbolBinario2.recorrerAnchura(arbol3))
    println("En profundidad:\t" + ArbolBinario2.recorrerProfundidad(arbol3))

    println("x2 en hojas:\n" + ArbolBinario2.toString(ArbolBinario2.mapHojas(arbol3)(x => x.map(_ * 2))))

    println("Sumar hojas: " + ArbolBinario2.sumarHojas(arbol3).toString)

    val addOptions = (o1: Option[Int], o2: Option[Int]) => (o1, o2) match {
      case (Some(v1), Some(v2)) => Some(v1 + v2)
      case (None, v@Some(_)) => v
      case (v@Some(_), None) => v
      case (None, None) => None
    }

    println("Unión v2:\n" + ArbolBinario2.toString(ArbolBinario2.union(arbol3, arbol4)(addOptions)))
    println("Unión v2:\n" + ArbolBinario2.toString(ArbolBinario2.union(arbol3, arbol3)(addOptions)))

    println("Size v2: " + ArbolBinario2.size(arbol3).toString)

    println("toString v2: " + ArbolBinario2.toString(arbol3))

    println("pintar:\n" + ArbolBinario2.pintar(arbol3))
    println("pintar:\n" + ArbolBinario2.pintar(arbol4))
  }
}


