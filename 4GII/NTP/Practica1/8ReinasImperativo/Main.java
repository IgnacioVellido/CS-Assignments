import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {
        int dimension = 4;
        Buscador buscador = new Buscador(dimension);
        ArrayList<Tablero> soluciones = buscador.resolver();

        for(Tablero t : soluciones) {
            if (t.contenido.size() == dimension) {
                System.out.println(t.toString());
            }
        }
    }
}