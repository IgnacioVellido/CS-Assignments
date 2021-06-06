import java.util.ArrayList;
import java.util.Arrays;
import java.util.function.Predicate;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

class Tablero {
    int dimension;
    ArrayList<Celda> contenido;

    Tablero(int d) {
        dimension = d;
        contenido = new ArrayList<>();
    }

    Tablero(Tablero c) {
        dimension = c.dimension;
        contenido = (ArrayList<Celda>) c.contenido.clone();
    }

    /**
     * No realiza comprobación sobre la validez de la celda
     * @param f Fila
     * @param c Columna
     */
    public void ponerReina(int f, int c) {
        Celda celda = new Celda(f, c);
        contenido.add(celda);
    }

    /**
     * Comprueba si la celda está en conflicto con alguna de las ocupadas en el tablero
     * @param celda
     * @return Si la celda se puede colocar o no
     */
    public boolean posicionSegura(Celda celda) {
        Stream<Celda> streamCeldas = contenido.stream();

        // Comprobación de posición segura
        Predicate<Celda> posicionValida = c ->
                c.getFila() != celda.getFila() &&
                c.getColumna() != celda.getColumna() &&
                Math.abs(c.getFila() - celda.getFila()) != Math.abs(c.getColumna() - celda.getColumna());

        // Devolver true si satisface el predicado en todas las casillas
        return streamCeldas.allMatch(posicionValida);
    }

    public String toString(){
        String[][] tabl = new String[dimension][dimension];

        // Rellenamos la matriz a O
        IntStream.range(0, dimension).forEach(i -> {
            IntStream.range(0, dimension).forEach(j -> tabl[i][j] = "O\t");
        });

        // Colocamos las reinas (X)
        Stream<Celda> streamCeldas = contenido.stream();
        streamCeldas.forEach(c -> tabl[c.getFila()][c.getColumna()] = "X\t");

        // Convertimos cada fila en un stream añadiéndole al final '\n' para mostrarlo correctamente por pantalla
        Stream<String> stringStream = Arrays.stream(tabl)
                                        .flatMap(strings -> Stream.concat(Arrays.stream(strings),Stream.of("\n")));
        return stringStream.collect(Collectors.joining());  // Juntamos el stream y devolvemos
    }
}