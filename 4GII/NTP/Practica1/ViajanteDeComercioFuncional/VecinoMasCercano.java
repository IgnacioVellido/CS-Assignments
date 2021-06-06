import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class VecinoMasCercano implements HeuristicaTSP {
    // -------------------------------------------------------------------------

    public VecinoMasCercano() {
    }

    public Ruta calcularRutaOptima(Problema problema) {
        Stream<Ciudad> ciudadStream = problema.ciudades.stream();

        // Función que genera la ruta VMC empezando en una ciudad
        Function<Ciudad, Ruta> generarRutaVMC = ciudad -> {
            Ruta solucion = new Ruta();
            int index = problema.getIdCiudad(ciudad);
            solucion.agregarCiudad(ciudad, problema.distancias);

            ArrayList<Ciudad> noIncluidas = (ArrayList<Ciudad>) problema.ciudades.clone();
            noIncluidas.remove(ciudad);

            while (solucion.ruta.size() < problema.dimension) {
                Ciudad masCercana = getCiudadMenorDistancia(index, noIncluidas,problema);
                solucion.agregarCiudad(masCercana, problema.distancias);

                // Eliminamos la nueva ciudad de las no incluidas
                index = problema.getIdCiudad(masCercana);
                noIncluidas.remove(masCercana);
            }

            return solucion;
        };

        // Para comparar las rutas por su coste
        Function<Ruta, Double> coste = Ruta::getCoste;
        Comparator<Ruta> comparator = Comparator.comparing(coste);

        // Ordenamos las rutas en orden decreciente de coste
        List<Ruta> rutas = ciudadStream.map(generarRutaVMC).sorted(comparator).collect(Collectors.toList());

        return rutas.get(0);    // Devolvemos la primera
    }

    /**
     * Devuelve la ciudad a menor distancia de otra sin pertenecer a la ruta
     * Recorremos el flujo de ciudades no incluídas quedándonos con la de mejor distancia
     */
    private Ciudad getCiudadMenorDistancia(int id, ArrayList<Ciudad> noIncluidas,
                                         Problema problema) {
        Ciudad masCercana = noIncluidas.get(0);
        Stream<Ciudad> ciudadStream = noIncluidas.stream();

        return ciudadStream.reduce(masCercana, (x,y) -> {
                                                            int id1  = problema.getIdCiudad(x)-1,
                                                                id2  = problema.getIdCiudad(y)-1;

                                                            double distancia1 = problema.distancias[id-1][id1],
                                                                   distancia2 = problema.distancias[id-1][id2];

                                                            return (distancia1 < distancia2) ? x : y;
                                                        });
    }
}