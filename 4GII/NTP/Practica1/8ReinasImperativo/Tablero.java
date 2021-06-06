import java.util.ArrayList;

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
     * @return
     */
    public boolean posicionSegura(Celda celda) {
        for(Celda c : contenido) {
            // Mirar si están en la misma fila/columna
            if (c.getFila() == celda.getFila() || c.getColumna() == celda.getColumna()) {
                return false;
            }
            // Mirar si están en la diagonal
            Integer x = c.getFila() - celda.getFila();
            Integer y = c.getColumna() - celda.getColumna();
            float pendiente = Math.abs( x.floatValue() / y.floatValue() );
            if (pendiente == 1) {
                return false;
            }
        }

        return true;
    }

    public String toString(){
        String[][] tabl = new String[dimension][dimension];

        // Rellenamos con O
        for (int i = 0; i < dimension; i++) {
            for (int j = 0; j < dimension; j++) {
                tabl[i][j] = "O\t";
            }
        }

        // Pintamos las reinas X
        for(Celda celda : contenido) {
            tabl[celda.getFila()][celda.getColumna()] = "X\t";
        }

        // Recogemos en un único string
        String output = "";
        for (int i = 0; i < dimension; i++) {
            for (int j = 0; j < dimension; j++) {
                output += tabl[i][j];
            }
            output += "\n";
        }

        return output;
    }
}