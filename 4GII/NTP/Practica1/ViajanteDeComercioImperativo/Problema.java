import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

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
    double[][] distancias;

    // -------------------------------------------------------------------------

    /**
     * Constructor
     * @param file
     * @throws IOException
     */
    public Problema(String file) {   
        try {
            // Leer archivo de problema
            Scanner scanner = new Scanner(new File(file));
            ArrayList<String> lineas = new ArrayList<String>();
            while (scanner.hasNextLine()) {
                lineas.add(scanner.nextLine());
            }
    
            // Parsear dimension
            String delimitador = "DIMENSION: ";
            dimension = Integer.parseInt(lineas.get(0).split(delimitador)[1]);
            lineas.remove(0);

            // Parsear ciudades
            ciudades = new ArrayList<>();
            delimitador = "\\s+";
            String[] linea_split;
            String etiqueta;
            double coorx, coory;

            for (String linea : lineas) {
                linea_split = linea.split(delimitador);
                if (linea_split.length == 3) {                    
                    etiqueta = linea_split[0];
                    coorx = Double.parseDouble(linea_split[1]);
                    coory = Double.parseDouble(linea_split[2]);
                                
                    ciudades.add(new Ciudad(etiqueta, coorx, coory));
                }
            }

            distancias = new double[dimension][dimension];
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
        for (int i = 0; i < ciudades.size(); i++) {
            // Diagonal a cero
            distancias[i][i] = 0.0;

            for (int j = i+1; j < ciudades.size(); j++) {
                double dist = Utilidades.distanciaEuclidea(ciudades.get(i), ciudades.get(j));
                distancias[i][j] = distancias[j][i] = dist;
            }
        }
    }

    /**
     * Devuelve el la posición de la ciudad en la matriz de distancias
     */
    protected int getIdCiudad(Ciudad ciudad) {
        for (int i = 0; i < ciudades.size(); i++) {
           if (ciudades.get(i).equals(ciudad)) {
               return i;
           }
        }

        // Debería lanzar una excepción
        return -1;
    }
}