import java.util.ArrayList;
import java.util.Random;

/**
 * Clase para una búsqueda Greedy Monte Carlo
 */
public class MonteCarlo implements HeuristicaTSP {
    /**
     * Número de rutas aleatorias a generar
     */
    int numRutas;

    /**
     * Mejor solución actual
     */
    Ruta mejorSolucion;

    // -------------------------------------------------------------------------

    /**
     * Constructor
     * 
     * @param problema
     * @param dimension
     */
    public MonteCarlo(final int numRutas) {
        this.numRutas = numRutas;
    }

    /**
     * Algoritmo Monte Carlo
     * 
     * @return Mejor ruta encontrada
     */
    public Ruta calcularRutaOptima(final Problema problema) {
        Ruta newRuta;

        // Asignamos una solución inicial
        newRuta = generarSolucion(problema);
        mejorSolucion = newRuta;

        for (int i=0; i < numRutas; i++) {
            newRuta = generarSolucion(problema);

            if (newRuta.coste < mejorSolucion.coste) {
                mejorSolucion = newRuta;
            }
        }

        return mejorSolucion;
    }

    /**
     * Genera una solución aleatoria
     * @param problema
     * @return
     */
    private Ruta generarSolucion(final Problema problema) {
        final Ruta solucion = new Ruta();
        final ArrayList<Ciudad> ciudadesCopia = (ArrayList<Ciudad>) problema.ciudades.clone();
        int indice;

        for (int i = 0; i < problema.dimension; i++) {
            indice = new Random().nextInt(ciudadesCopia.size());
            solucion.agregarCiudad(ciudadesCopia.get(indice), problema.distancias);
            ciudadesCopia.remove(indice);
        }

        return solucion;
    }
}