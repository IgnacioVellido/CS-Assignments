import java.util.function.Predicate;
import java.util.stream.Stream;

public class Main {
    public static void main(String[] args) {
        int dimension = 4;
        Buscador buscador = new Buscador(dimension);
        Stream<Tablero> streamSoluciones = buscador.resolver().stream();

        // Comprobar si la solución está completa
        Predicate<Tablero> solucionValida = tablero -> tablero.contenido.size() == dimension;

        // Filtrar soluciones no terminadas e imprimir
        streamSoluciones.filter(solucionValida).forEach(tablero -> {System.out.println(tablero.toString());});
    }
}