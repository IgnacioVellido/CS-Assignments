import java.util.ArrayList;
import java.util.function.Consumer;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class Buscador {
    int dimension;

    Buscador(int d) {
        dimension = d;
    }

    // Recoger las soluciones de primera pieza en cada fila
    // Para cada fila f: 0 <= f < dimension -> Llamar a ubicarReina(f)
    public ArrayList<Tablero> resolver() {
        ArrayList<Tablero> soluciones = new ArrayList<>();
        IntStream.range(0, dimension).forEach(i -> soluciones.addAll(ubicarReina(i)));
        return soluciones;
    }

    public ArrayList<Tablero> ubicarReina(int fila) {
        ArrayList<Tablero> tableros = new ArrayList<>();
        ArrayList<Tablero> solucion = new ArrayList<>();

        // Caso base
        if (fila == -1) {
            Tablero t = new Tablero(dimension);
            tableros.add(t);
            return tableros;
        }

        // Caso inductivo
        tableros = ubicarReina(fila - 1);

        // Recorrer cada columna y comprobar si es posición segura
        Stream<Tablero> streamTableros = tableros.stream();
        Consumer<Tablero> funcion = t -> {
            IntStream.range(0, dimension).forEach(col -> {
                Celda celda = new Celda(fila, col);
                if (t.posicionSegura(celda)) {
                    Tablero newT = new Tablero(t);
                    newT.ponerReina(fila, col);
                    solucion.add(newT);
                }
            });
        };

        streamTableros.forEach(funcion);

        return solucion;
    }
}
