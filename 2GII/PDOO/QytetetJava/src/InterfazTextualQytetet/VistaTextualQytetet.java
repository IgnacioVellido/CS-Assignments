package InterfazTextualQytetet;

import java.util.ArrayList;
import java.util.Map;
import java.util.Scanner;
import java.util.TreeMap;


public class VistaTextualQytetet {    
    private static final Scanner in = new Scanner (System.in);

 // --------------------------- Métodos -------------------------------------
    public void mostrarYEsperar(String texto){          
        mostrar(texto);
        pulsaParaContinuar();
        clear();
     }

    public void clear() {
        //System.out.print("\033[H\033[2J");
        System.out.flush();
        System.out.print("\n\n\n\n");
     }

    public void pulsaParaContinuar() {
        System.out.println("Pulsa ENTER para continuar...\n");   
        try {
            System.in.read(); 
        } catch (Exception e) {}        
     }

    // Se le pasa un texto y se le pide elegir entre 0-FALSO o 1-VERDADERO         
    public boolean verdaderoOFalso (String texto) {
        Map<Integer, String> menuVF = new TreeMap();
        menuVF.put(0, "NO"); 
        menuVF.put(1, "SI");
        this.mostrar(texto);
        int salida=this.seleccionMenu(menuVF);    
        
        mostrar(""); // Porque el clear no funciona en NetBeans
        clear();

        if (salida == 1) 
            return true;
        else
            return false;
    }

    // Elección del método para salir de la carcel
    public int menuSalirCarcel(int precioLibertad){
        String pagar = "Pagar (" + precioLibertad + ")";
        this.mostrar("Elige como desea intentar salir de la carcel");

        Map<Integer, String> menuSC = new TreeMap();
        menuSC.put(0, "Tirar dado (necesita un 6)"); 
        menuSC.put(1, pagar);

        int salida = this.seleccionMenu(menuSC); 
        return salida;   
    }

    public boolean elegirQuieroComprar(String nombre, int precio){
        mostrar("Desea comprar " + nombre + " por " + Integer.toString(precio) + "$ ?");

        return verdaderoOFalso("");  
    }

    public int menuGestionInmobiliaria() {    
        this.mostrar("Elige la gestion inmobiliaria que deseas hacer");

        Map<Integer, String> menuGI = new TreeMap();
        menuGI.put(0, "Siguiente Jugador"); 
        menuGI.put(1, "Edificar casa");
        menuGI.put(2, "Edificar Hotel"); 
        menuGI.put(3, "Vender propiedad ");  	
        menuGI.put(4, "Hipotecar Propiedad"); 
        menuGI.put(5, "Cancelar Hipoteca");
        menuGI.put(6, "Mostrar informacion");

        // Método para controlar la elección correcta en el menú 
        int salida=this.seleccionMenu(menuGI); 

        return salida;
    }

    // Número y nombre de propiedades
    public int menuElegirPropiedad(ArrayList<String> listaPropiedades){              
        Map<Integer, String> menuEP = new TreeMap();
        int numeroOpcion=0;

        for(String prop: listaPropiedades) {
            menuEP.put(numeroOpcion, prop); //opcion de menu, numero y nombre de propiedad
            numeroOpcion=numeroOpcion+1;
        }

        int salida=this.seleccionMenu(menuEP);

        return salida;

    }   

    //Método para controlar la elección correcta de una opción en el menú que recibe como argumento   
    private int seleccionMenu(Map<Integer,String> menu) {   
        boolean valido = true; 
        int numero;
        String lectura;

        do { // Hasta que se hace una selección válida
          for (Map.Entry<Integer, String> fila : menu.entrySet()) {
                numero = fila.getKey();
                String texto = fila.getValue();
                this.mostrar(numero + " : " + texto);  // numero de opcion y texto
          }

          //this.mostrar("\n Elige una opcion: ");
          lectura = in.nextLine();  //lectura de teclado
          // Método para comprobar la elección correcta
          valido=this.comprobarOpcion(lectura, 0, menu.size()-1);

        } while (!valido);

        return Integer.parseInt(lectura);
    }

    // Método para pedir el nombre de los jugadores
    public ArrayList<String> obtenerNombreJugadores() { 
        boolean valido = true; 
        String lectura;
        ArrayList<String> nombres = new ArrayList();

        // Repetir mientras que el usuario no escriba un número correcto 
        do{ 
            this.mostrar("Escribe el numero de jugadores: (de 2 a 4):");
            lectura = in.nextLine();  
            valido=this.comprobarOpcion(lectura, 2, 4);
        } while (!valido);

        // Solicitud del nombre de cada jugador
        for (int i = 1; i <= Integer.parseInt(lectura); i++) { 
          this.mostrar("Nombre del jugador " + i + ": ");
          nombres.add (in.nextLine());
        }

        return nombres;
    }

    // Método para comprobar que se introduce un entero correcto, usado por seleccion_menu
    private boolean comprobarOpcion(String lectura, int min, int max){ 
         boolean valido=true;   
         int opcion;
         try {  
              opcion =Integer.parseInt(lectura);
              if (opcion<min || opcion>max) { // No es un entero entre los válidos
                   this.mostrar("el numero debe estar entre min y max");
                    valido = false;}

          } catch (NumberFormatException e) { // No se ha introducido un entero
                  this.mostrar("debes introducir un numero");
                  valido = false;  
          }
          if (!valido) {
            this.mostrar("\n\n Seleccion erronea. Intentalo de nuevo.\n\n");
          }
          return valido;
     }

    // Método que muestra en pantalla el string que recibe como argumento
    public void mostrar(String texto){          
        System.out.println(texto);
    }

}
 
