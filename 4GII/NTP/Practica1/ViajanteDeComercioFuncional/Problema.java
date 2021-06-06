import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Optional;
import java.util.function.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class Problema {
    /**
     * Lista de ciudades
     */
    ArrayList<Ciudad> ciudades;

    /**
     * Dimensión del problema
     */
    int dimension;

    /**
     * Matriz de distancias
     */
    Double[][] distancias;

    // -------------------------------------------------------------------------

    /**
     * Constructor
     * @param file
     * @throws IOException
     */
    public Problema(String file) {   
        try {
            // Se leen las lineas del archivo
            Stream<String> lineas = Files.lines(Paths.get(file));

            Function<String, Optional<Ciudad> > mapeo = linea -> {
                // Coger dimensión
                if (linea.contains("DIMENSION: ")) {
                    String delimitador = "DIMENSION: ";
                    dimension = Integer.parseInt(linea.split(delimitador)[1]);
                }
                else {
                    String delimitador = "\\s+";
                    String[] linea_split = linea.split(delimitador);

                    if (linea_split.length == 3) {
                        String etiqueta = linea_split[0];
                        double coorx = Double.parseDouble(linea_split[1]);
                        double coory = Double.parseDouble(linea_split[2]);

                        return Optional.of(new Ciudad(etiqueta, coorx, coory));
                    }
                }

                return Optional.empty();
            };

            // Se procesan las lineas del archivo
            ciudades = (ArrayList<Ciudad>) lineas.map(mapeo)    // Aplicar función "mapeo"
                        .flatMap(o -> o.map(Stream::of).orElseGet(Stream::empty))  // Si se ha devuelto un objeto
                        .collect(Collectors.toList());  // Agruparlos

            // Calculando distancias
            distancias = new Double[dimension][dimension];
            calcularDistancias();
        } catch(IOException e){
            System.out.println("Error leyendo el archivo: " + file);
            System.exit(0);
        }
    }

    /**
     * Rellena la matriz de distancias
     */
    private void calcularDistancias() {
        distancias =
                IntStream.range(0, dimension)
                        .mapToObj(x -> IntStream.range(0, dimension)
                                .mapToObj(y -> {
                                    if (x == y) {
                                        return 0.0;
                                    }
                                    else {
                                        return Utilidades.distanciaEuclidea(ciudades.get(x), ciudades.get(y));
                                    }
                                })
                                .toArray(Double[]::new))
                        .toArray(Double[][]::new);
    }

    /**
     * Devuelve el la posición de la ciudad en la matriz de distancias
     */
    protected int getIdCiudad(Ciudad ciudad) {
        Predicate<Ciudad> condicion = c -> c.equals(ciudad);    // Condición para encontrar la ciudad pedida
        Stream<Ciudad> streamCiudades = ciudades.stream();      // Flujo de ciudades

        // Devolvemos el ID de la ciudad solicitada
        return streamCiudades.filter(condicion).findFirst().get().getLabelAsInt();
    }

    protected Ciudad getCiudadById(int id) {
        return ciudades.get(id);
    }
}