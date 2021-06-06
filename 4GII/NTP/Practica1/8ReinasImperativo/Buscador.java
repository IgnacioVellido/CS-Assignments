import java.util.ArrayList;

public class Buscador {
    int dimension;

    Buscador(int d) {
        dimension = d;
    }

    // Recoger las soluciones de primera pieza en cada fila
    public ArrayList<Tablero> resolver() {
        ArrayList<Tablero> soluciones = new ArrayList<>();
        for (int i = 0; i < dimension; i++) {
            soluciones.addAll(ubicarReina(i));
        }
        return soluciones;
    }

    public ArrayList<Tablero> ubicarReina(int fila) {
        ArrayList<Tablero> tableros = new ArrayList();
        ArrayList<Tablero> solucion = new ArrayList();

        // Caso base
        if (fila == -1) {
            Tablero t = new Tablero(dimension);
            tableros.add(t);
            return tableros;
        }

        // Caso inductivo
        tableros = ubicarReina(fila - 1);

        for (Tablero t : tableros) {
            for (int col = 0; col < dimension; col++) {   // Por cada columna
                Celda celda = new Celda(fila, col);
                if (t.posicionSegura(celda)) {
                    Tablero newT = new Tablero(t);
                    newT.ponerReina(fila, col);
                    solucion.add(newT);
                }
            }
        }

        return solucion;
    }
}
