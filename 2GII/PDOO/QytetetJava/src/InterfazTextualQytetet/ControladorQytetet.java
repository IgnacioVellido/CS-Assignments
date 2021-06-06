package InterfazTextualQytetet;

import java.util.ArrayList;
import modeloqytetet.*;

public class ControladorQytetet {
    private Qytetet qytetet;
    private Jugador jugador;
    private Casilla casilla;
    
    private VistaTextualQytetet vista;    
    
    // ------------------------- Constructor -----------------------------------    
    public ControladorQytetet() {
        // Elegir modo texto
        vista = new VistaTextualQytetet();
        
        inicializacionJuego();
    }
    
    // ----------------- Métodos  --------------------------
    public void inicializacionJuego() {
        qytetet = new Qytetet();
        
        // Pidiendo el nombre de los jugadores
        ArrayList<String> jugadores;
        jugadores = vista.obtenerNombreJugadores();
    
        qytetet.inicializarJuego(jugadores);
        jugador = qytetet.getJugadorActual();   
        casilla = jugador.getCasillaActual();
        
        vista.clear();
        
        for (String cadena : qytetet.situacionInicial())
            System.out.println(cadena);

        vista.pulsaParaContinuar();
        vista.clear();
        
        desarrolloJuego();
    }  
    
    public void desarrolloJuego() {
        Boolean fin = false,
                encarcelado,
                noTienePropietario;   
        
        while (!fin) {
            vista.mostrarYEsperar("\nTurno del jugador: " + jugador.toString());                                        
            
            encarcelado = jugador.getEncarcelado();
            if (encarcelado) {                                
                vista.mostrarYEsperar("Jugador encarcelado");                
                        
                int metodo = vista.menuSalirCarcel(Qytetet.getPRECIO_LIBERTAD());
                encarcelado = qytetet.intentarSalirCarcel(MetodoSalirCarcel.values()[metodo]);
                // Mostrar si ha conseguido salir + pausa para continuar
                if (encarcelado) {
                    vista.mostrarYEsperar("Sigues encarcelado");
                    qytetet.siguienteJugador();
                    jugador = qytetet.getJugadorActual();                    
                    continue;
                }
                else 
                    vista.mostrarYEsperar("Sales de la carcel");                                                            
            }

            noTienePropietario = !qytetet.jugar();
            casilla = jugador.getCasillaActual();
            // Mostrar lo que pasa en jugar()
            
            vista.mostrarYEsperar("Ha caido en\n" + jugador.getCasillaActual());                                 

            // ¿Bancarrota?
            if (jugador.getSaldo() > 0) {
                // Puede que haya caído en irACarcel
                encarcelado = jugador.getEncarcelado();
                if (!encarcelado) {

                    switch (casilla.getTipo()) { 
                        case SORPRESA: 
                            vista.mostrarYEsperar("Sorpresa !" + 
                                    qytetet.getCartaActual().toString() + "\n");                            
                            
                            noTienePropietario = qytetet.aplicarSorpresa();

                            // Puede que le haya tocado la carta de ir a la carcel
                            encarcelado = jugador.getEncarcelado();
                            // Mirar si esto hace falta
                            casilla = jugador.getCasillaActual();
                            
                            if (!encarcelado && (jugador.getSaldo() > 0)) {
                                if (casilla.getTipo() == TipoCasilla.CALLE 
                                        && noTienePropietario 
                                        && vista.elegirQuieroComprar(casilla.getTitulo().getNombre(), casilla.getCoste()))
                                    if(qytetet.comprarTituloPropiedad())
                                        vista.mostrarYEsperar("Se ha comprado la casilla " 
                                             + casilla.getTitulo().getNombre());
                                    else
                                        vista.mostrarYEsperar("No se puede comprar " 
                                             + casilla.getTitulo().getNombre()); 
                            }
                            
                            vista.mostrar("Su saldo ahora es de " + jugador.getSaldo() + "$\n");
                            break;
                        case CALLE: 
                            if (noTienePropietario)
                                if (vista.elegirQuieroComprar(casilla.getTitulo().getNombre(), casilla.getCoste()))
                                    qytetet.comprarTituloPropiedad(); 
                            break;
                    }

                    encarcelado = jugador.getEncarcelado();
                    if (!encarcelado && (jugador.getSaldo() > 0) && jugador.tengoPropiedades()) { 
                        String nombreCasilla;
                        // Si se equivoca de opcion o quiere seguir se pone a true
                        Boolean eligiendo;                         
                        
                        do {
                            // Cogemos los nombres de las propiedades del jugador y las mostramos
                            ArrayList<String> listaPropiedades = new ArrayList();
                            for (TituloPropiedad propiedad : jugador.getPropiedades())
                                listaPropiedades.add(propiedad.getNombre());  
                            
                            int opcion = vista.menuGestionInmobiliaria();

                            // Si se elige Siguiente Jugador sale del bucle
                            if (opcion == 0) 
                                break;
                            
                            int numPropiedad = vista.menuElegirPropiedad(listaPropiedades);
                            Casilla propiedad = jugador.getPropiedades().get(numPropiedad).getCasilla();
                                                                                            
                            nombreCasilla = 
                                    jugador.getPropiedades().get(numPropiedad).getNombre();                            
                            
                            eligiendo = false;
                            switch (opcion) {
                                case 0: // Por el break de la iteración anterior, aquí no llega                             
                                    break;
                                case 1:     
                                    if(qytetet.edificarCasa(propiedad))
                                        vista.mostrar("Edificando casa en " 
                                             + nombreCasilla);
                                    else
                                        vista.mostrar("No se puede edificar casa en " 
                                             + nombreCasilla);                                     
                                    break;
                                case 2: 
                                    if (qytetet.edificarHotel(propiedad))
                                        vista.mostrar("Edificando hotel en " 
                                             + nombreCasilla);                                    
                                    else
                                        vista.mostrar("No se puede edificar hotel en " 
                                             + nombreCasilla); 
                                    break;
                                case 3:
                                    if (qytetet.venderPropiedad(propiedad)) 
                                        vista.mostrar("Ha vendido "
                                             + nombreCasilla
                                             + "\nSu saldo actual es de "
                                             + Integer.toString(jugador.getSaldo()));
                                    else
                                        vista.mostrar("No se puede vender " 
                                             + nombreCasilla);                                         
                                    break;
                                case 4:
                                    if (qytetet.hipotecarPropiedad(propiedad))
                                        vista.mostrar("Ha hipotecado "
                                             + nombreCasilla
                                             + "\nSu saldo actual es de "
                                             + Integer.toString(jugador.getSaldo()));
                                    else
                                        vista.mostrar("No se puede hipotecar " 
                                             + nombreCasilla);                                            
                                    break;
                                case 5:
                                    if (qytetet.cancelarHipoteca(propiedad))
                                        vista.mostrar("Ha cancelado la hipoteca de "
                                             + nombreCasilla
                                             + "\nSu saldo actual es de "
                                             + Integer.toString(jugador.getSaldo()));  
                                    else
                                        vista.mostrar("No se puede deshipotecar " 
                                             + nombreCasilla);                                                                                         
                                    break;
                                case 6:
                                    vista.mostrar(propiedad.toString());
                                    break;
                                default:
                                    vista.menuGestionInmobiliaria();
                                    eligiendo = true;
                                    break;
                            }
                            // Si ha realizado una operacion y sigue teniendo propiedades
                            if (!eligiendo && jugador.tengoPropiedades()) {
                                if (vista.verdaderoOFalso("\nElegir otra opcion ?"))
                                    eligiendo = true;
                            }
                        } while (eligiendo);
                    }
                }

                if (jugador.getSaldo() > 0) {
                    qytetet.siguienteJugador();
                    jugador = qytetet.getJugadorActual();
                }
                // No se me ocurre como ponerlo sin repetir código, se debería
                // salir de aquí y entrar en el else
                else 
                    fin = true;
            }
            else
                fin = true;
           
        }
        
        // FIN del juego
        vista.mostrar("Fin del juego");      
        vista.mostrar("Clasificacion:");      
        
        ArrayList<Jugador> ranking = qytetet.obtenerRanking();
        
        for (int i = 0; i < ranking.size(); i++) {
            vista.mostrar(Integer.toString(i+1)             + "º - "
                            + ranking.get(i).getNombre()    + " - "
                            + ranking.get(i).obtenerCapital());      
        }
        
        vista.mostrarYEsperar("Gracias por jugar");                  
    }
    
    // Este metodo toma una lista de propiedades y genera una lista de strings, 
    // con el numero y nombre de las propiedades.
    // Luego llama a la vista para que el usuario pueda elegir.     
    public Casilla elegirPropiedad(ArrayList<Casilla> propiedades){ 
        vista.mostrar("\tCasilla\tTitulo");
        int seleccion;
        
        ArrayList<String> listaPropiedades= new ArrayList();
        for (Casilla casilla: propiedades) {
                listaPropiedades.add( "\t"+casilla.getNumeroCasilla()+"\t"+casilla.getTitulo().getNombre()); 
        }
        seleccion=vista.menuElegirPropiedad(listaPropiedades);  
        return propiedades.get(seleccion);
    }
        
}
