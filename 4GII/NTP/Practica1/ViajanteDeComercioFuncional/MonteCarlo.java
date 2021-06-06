import java.util.*;
import java.util.stream.Collector;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

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

    private Problema problema;  // Para acceder en el collector definido a mano

    // -------------------------------------------------------------------------

    /**
     * Constructor
     * 
     * @param numRutas
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
        this.problema = problema;

        // Asignamos una solución inicial
        mejorSolucion = generarSolucion();

        IntStream.range(0, numRutas).forEach(i -> {
            Ruta newRuta = generarSolucion();

            if (newRuta.coste < mejorSolucion.coste) {
                mejorSolucion = newRuta;
            }
        });

        return mejorSolucion;
    }

    /**
     * Genera una solución aleatoria. Crea una ordenación de índices aleatoria y crea una ruta en base a ella
     * @return solución aleatoria
     */
    private Ruta generarSolucion() {
        // Generar ids de ciudades
        List<Integer> ids = IntStream.range(0, problema.dimension).boxed().collect(Collectors.toList());

        // Reordenar
        Collections.shuffle(ids);

        // Generar Ruta con esos ids
        Stream<Integer> idStream = ids.stream();

        Collector<Ciudad, ?, Ruta> solucion = Collector.of(                     // Un collector para crear la ruta
                Ruta::new,
                (ruta, ciudad) -> ruta.agregarCiudad(ciudad, this.problema.distancias),
                (result1, result2) -> result1
        );

        // Recoger las ciudades en base a su id y recogerlas en una ruta
        return idStream.map(problema::getCiudadById).collect(solucion);
    }
}