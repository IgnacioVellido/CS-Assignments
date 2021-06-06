import java.util.ArrayList;

public class VecinoMasCercano implements HeuristicaTSP {

    // -------------------------------------------------------------------------

    public VecinoMasCercano() {
    }

    public Ruta calcularRutaOptima(Problema problema) {
        Ruta solucion; 
        Ruta mejorSolucion = new Ruta();
        mejorSolucion.coste = Double.MAX_VALUE;
        ArrayList<Ciudad> ciudades = problema.ciudades;

        for (Ciudad ciudad : ciudades) {
            solucion = new Ruta();
            ArrayList<Ciudad> noIncluidas = (ArrayList<Ciudad>) problema.ciudades.clone();
            int index; // Índice de la última ciudad añadida

            // Añadimos ciudad inicial
            solucion.agregarCiudad(ciudad, problema.distancias);
            index = problema.getIdCiudad(ciudad);
            noIncluidas.remove(ciudad);

            while (solucion.ruta.size() < problema.dimension) {
                Ciudad masCercana = getCiudadMenorDistancia(index, noIncluidas,
                                                            problema);
                solucion.agregarCiudad(masCercana, problema.distancias);

                // Eliminamos la nueva ciudad de las no incluidas
                index = problema.getIdCiudad(masCercana);
                noIncluidas.remove(masCercana);
            }
            
            if (solucion.coste < mejorSolucion.coste) {
                mejorSolucion = solucion;
            }
        }

        return mejorSolucion;
    }

    /**
     * Devuelve la ciudad a menor distancia de otra sin pertenecer a la ruta
     * Debería comprobar que noIncluidas tenga algún elemento
     */
    private Ciudad getCiudadMenorDistancia(int id, ArrayList<Ciudad> noIncluidas,
                                         Problema problema) {
        double mejorDistancia = Double.MAX_VALUE, 
                distancia;
        int x;   // Auxiliar        
        Ciudad masCercana = noIncluidas.get(0);

        for (Ciudad ciudad : noIncluidas) {
            x = problema.getIdCiudad(ciudad);
            distancia = problema.distancias[id][x];

            if (distancia < mejorDistancia) {
                mejorDistancia = distancia;
                masCercana = ciudad;
            }
        }

        return masCercana;
    }
}