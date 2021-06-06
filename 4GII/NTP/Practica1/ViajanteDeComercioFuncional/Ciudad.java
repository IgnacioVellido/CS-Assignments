/**
 * Clase basica para representar una ubicacion en el problema
 * del TSP
 */
public class Ciudad {
   /**
    * Etiqueta para identificar la ciudad
    */
   private String etiqueta;

   /**
    * Datos miembro para almacenar las coordenadas de la ciudad
    */
   private double x;
   private double y;

   // --------------------------------------------------------------------------

   /**
    * Constructor de la clase
    *
    * @param etiqueta
    * @param coorx
    * @param coory
    */
   public Ciudad(String etiqueta, double coorx, double coory) {
      this.etiqueta = etiqueta;
      x = coorx;
      y = coory;
   }

   /**
    * Obtiene la coordenada X
    *
    * @return
    */
   public double getX() {
      return x;
   }

   /**
    * Obtiene la coordenada Y
    *
    * @return
    */
   public double getY() {
      return y;
   }

   /**
    * Obtiene la etiqueta
    *
    * @return
    */
   public String getLabel() {
      return etiqueta;
   }

   /**
    * Obtiene la etiqueta
    *
    * @return
    */
    public int getLabelAsInt() {
      return Integer.parseInt(etiqueta);
   }
}
