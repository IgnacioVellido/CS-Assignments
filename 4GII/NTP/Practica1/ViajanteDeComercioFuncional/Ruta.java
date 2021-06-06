import java.util.ArrayList;
import java.util.stream.Collectors;

public class Ruta {
    ArrayList<Ciudad> ruta;
    double coste;

    // -------------------------------------------------------------------------

    /**
     * Constructor
     */
    public Ruta() {
        ruta = new ArrayList<>();
        coste = 0.0;
    }

    public double getCoste() {
        return coste;
    }

    /**
     * Agrega una nueva ciudad al final de la ruta y recalcula el coste
     * @param ciudad
     * @param distancias
     */
    public void agregarCiudad(Ciudad ciudad, Double[][] distancias) {
        double distancia;
        // Restar coste último enlace (el de vuelta al origen)
        if (ruta.size() > 1) {
            distancia = distancias[ruta.get(0).getLabelAsInt()-1]
                                  [ruta.get(ruta.size()-1).getLabelAsInt()-1];

            coste -= distancia;
        }
        
        ruta.add(ciudad);

        // Si hay una ciudad o menos el coste es 0
        if (ruta.size() > 1) {        
            // Añadir nuevos costes
            coste += distancias[ruta.get(ruta.size()-2).getLabelAsInt()-1]
                               [ruta.get(ruta.size()-1).getLabelAsInt()-1];
            
            coste += distancias[ruta.get(0).getLabelAsInt()-1] // Regreso
                               [ruta.get(ruta.size()-1).getLabelAsInt()-1];
        }
    }

    @Override
    public String toString() {
        String output = "Coste: " + coste + "\nRuta: ";

        return output + ruta.stream().map(ciudad -> ciudad.getLabel() + " ").collect(Collectors.joining());
    }
}