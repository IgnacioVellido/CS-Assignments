package modeloqytetet;

import GUIQytetet.*;

import java.util.ArrayList;
import java.util.Collections;
import java.util.concurrent.ThreadLocalRandom;

public class Qytetet {
    public static final int MAX_JUGADORES = 4;
    static final int MAX_CARTAS = 12;
    static final int MAX_CASILLAS = 20;
    static final int PRECIO_LIBERTAD = 200;
    static final int SALDO_SALIDA = 1000;
    
    private Sorpresa cartaActual;
    private ArrayList<Sorpresa> mazo = new ArrayList(MAX_CARTAS);
    private ArrayList<Jugador> jugadores = new ArrayList(MAX_JUGADORES);
    private Jugador jugadorActual;
    private Tablero tablero;
    private Dado dado;
    
    // ----------------------- Constructor -------------------------------------
    public Qytetet() { }
    
    // ----------------------- Métodos singleton -------------------------------
    public static Qytetet getInstance() {
        return QytetetHolder.INSTANCE;
    }
    
    private static class QytetetHolder {
        private static final Qytetet INSTANCE = new Qytetet();
    }
    
    // ------------------------- Consultores -----------------------------------    
    public Sorpresa getCartaActual() {
        return cartaActual;
    }
    
    public Jugador getJugadorActual() {
        return jugadorActual;
    }
    
    public ArrayList<Jugador> getJugadores() {
        return jugadores;
    }

    public static int getPRECIO_LIBERTAD() {
        return PRECIO_LIBERTAD;
    }
            
    // -------------------------- Métodos --------------------------------------
    public Boolean aplicarSorpresa() { 
        Boolean tienePropietario = false;
        
        switch (cartaActual.getTipo()) {
            case PAGARCOBRAR:   
                jugadorActual.modificarSaldo(cartaActual.getValor());
                break;
            case IRACASILLA:
                // Devuelve el número de la casilla
                if (tablero.esCasillaCarcel(cartaActual.getValor()))
                    encarcelarJugador();
                else {
                    Casilla nuevaCasilla = tablero.obtenerCasillaNumero(cartaActual.getValor());
                    tienePropietario = jugadorActual.actualizarPosicion(nuevaCasilla);
                }
                break;
            case PORCASAHOTEL:
                jugadorActual.pagarCobrarPorCasaYHotel(cartaActual.getValor());
                break;
            case PORJUGADOR:
                for (Jugador jugador : jugadores) {
                    if (jugador != jugadorActual) {
                        jugador.modificarSaldo(cartaActual.getValor());         // Según la carta gana o pierde
                        jugadorActual.modificarSaldo(-cartaActual.getValor());
                    }
                }
                break;
            case SALIRCARCEL:
                jugadorActual.setCartaLibertad(cartaActual);
                break;  
            case CONVERTIRME:
                Especulador jugador = jugadorActual.convertirme(cartaActual.getValor());
                jugadores.remove(jugadorActual);
                // jugadorActual = jugador; ???
                jugadores.add(jugador);
                break;
        }
        mazo.add(mazo.size()-1, cartaActual);        
        // Se supone que elimina la primera ocurrencia, no debería haber problema
        // A lo mejor no hay que borrarla
        mazo.remove(cartaActual);
        
        return tienePropietario;
    }
    
    public Boolean comprarTituloPropiedad() {
        return jugadorActual.comprarTitulo();
    }
    
    public Boolean venderPropiedad(Casilla casilla) {
        Boolean puedoVender = false;
        
        if (jugadorActual.puedoVenderPropiedad(casilla)) {
            jugadorActual.venderPropiedad(casilla);
            puedoVender = true;
        }
        
        return puedoVender;
    }    
    
    public Boolean edificarCasa(Casilla casilla) {
        Boolean puedoEdificar = false;
        int factor = jugadorActual.getFactorEspeculador();   
        System.out.println("Factor: " + factor);
        
        if(casilla.soyEdificable() && casilla.sePuedeEdificarCasa(factor) 
                                   && jugadorActual.puedoEdificarCasa(casilla)) {           
            jugadorActual.modificarSaldo(-casilla.edificarCasa());
            puedoEdificar = true;
        }
        
        return puedoEdificar;
    }
    
    public Boolean edificarHotel(Casilla casilla) {
        Boolean puedoEdificar = false;
        int factor = jugadorActual.getFactorEspeculador();
        
        if (casilla.soyEdificable() && casilla.sePuedeEdificarHotel(factor) 
                                    && jugadorActual.puedoEdificarHotel(casilla)) {           
            jugadorActual.modificarSaldo(-casilla.edificarHotel());
            puedoEdificar = true;
        }
        
        return puedoEdificar;        
    }
    
    public Boolean hipotecarPropiedad(Casilla casilla) {
        Boolean hipotecada = false;
        
        if (casilla.soyEdificable()) { 
            if (jugadorActual.puedoHipotecar(casilla)) {
                int precioHipotecar = casilla.hipotecar();
                jugadorActual.modificarSaldo(precioHipotecar);
                hipotecada = true;                        
            }
        }
        
        return hipotecada;
    }
        
    // @pre jugadorActual debe ser el propietario
    public Boolean cancelarHipoteca(Casilla casilla) {
        Boolean cancelada = false;
        
        if (casilla.soyEdificable() && casilla.estaHipotecada()) {            
            if (jugadorActual.puedoPagarHipoteca(casilla)) {
                int precioDeshipotecar = casilla.cancelarHipoteca();
                jugadorActual.modificarSaldo(-precioDeshipotecar);
                cancelada = true;
            }            
        }
        
        return cancelada;
    }
    
    // @pre Está encarcelado
    // @return true si está encarcelado
    public Boolean intentarSalirCarcel(MetodoSalirCarcel metodo) {
        Boolean libre;
        
        if (metodo == MetodoSalirCarcel.TIRANDODADO)
            libre = dado.nextNumber("Para salir necesitas un 6", "") > 5;
        else 
            libre = jugadorActual.pagarLibertad(Qytetet.PRECIO_LIBERTAD);
        
        if (libre)
            jugadorActual.setEncarcelado(false);
        
        return !libre;
    }                   
    
    public ArrayList<Casilla> propiedadesHipotecadasJugador(Boolean hipotecadas) {
        ArrayList<Casilla> resultado = new ArrayList();
        ArrayList<TituloPropiedad> propiedades = 
                       jugadorActual.obtenerPropiedadesHipotecadas(hipotecadas);              

        if (propiedades != null) {
            for (TituloPropiedad propiedad : propiedades) {
                resultado.add(propiedad.getCasilla());
            }
        }
         
        return resultado;
    }
    
    public void siguienteJugador() {
        int indice = (jugadores.indexOf(jugadorActual) + 1) % jugadores.size();
        jugadorActual = jugadores.get(indice);
    }    
    
    private void encarcelarJugador() {
        if (!jugadorActual.tengoCartaLibertad()) {
            jugadorActual.irACarcel(tablero.getCarcel());
        }
        else {
            Sorpresa carta = jugadorActual.devolverCartaLibertad();
            // Significa que se elimina del mazo cuando la consigue el jugador
            mazo.add(carta);
        }
    }
    
    public void inicializarJuego(ArrayList<String> nombres) {
        inicializarJugadores(nombres);
        inicializarTablero();
        inicializarCartasSorpresa();        
        salidaJugadores();     
        dado = Dado.getInstance();
    }    
    
    private void inicializarCartasSorpresa() {
        final int num_carcel = tablero.getCarcel().getNumeroCasilla();
        ////////////////////////////////////////////////////////////////////
        mazo.add(new Sorpresa ("Ya he conseguido que nos devuelvan todo los que nos debían, jefe"
                , 500, TipoSorpresa.PAGARCOBRAR));        
        mazo.add(new Sorpresa ("A pagar moroso cab$%@"
                , 500, TipoSorpresa.PAGARCOBRAR));
        ////////////////////////////////////////////////////////////////////
        mazo.add(new Sorpresa ("Te hemos pillado con chanclas y calcetines, lo sentimos, ¡debes ir a la carcel!"
                , num_carcel, TipoSorpresa.IRACASILLA));
        mazo.add(new Sorpresa ("¿Te crees que ibas a andar por mi barrio sin que yo me enterase?"
                , 2, TipoSorpresa.IRACASILLA));        
        mazo.add(new Sorpresa ("Cariño, estoy sola en casa"
                , 11, TipoSorpresa.IRACASILLA));
        ////////////////////////////////////////////////////////////////////
        mazo.add(new Sorpresa ("Le han reevaluado sus viviendas, señor"
                , 1000, TipoSorpresa.PORCASAHOTEL));        
        mazo.add(new Sorpresa ("Los políticos se han inventado una nueva sablada"
                , 1000, TipoSorpresa.PORCASAHOTEL));
        ////////////////////////////////////////////////////////////////////
        mazo.add(new Sorpresa ("¿Chavales, os acordáis que me debíais dinero? Pues lo necesito ahora"
                , 750, TipoSorpresa.PORJUGADOR));        
        mazo.add(new Sorpresa ("Un grupo de matones te han robado hasta el último centavo"
                , 750, TipoSorpresa.PORJUGADOR));
        ////////////////////////////////////////////////////////////////////
        // El número de esta carta no es relevante
        mazo.add(new Sorpresa ("Un fan anónimo ha pagado tu fianza. Sales de la cárcel"
                , num_carcel, TipoSorpresa.SALIRCARCEL)); 
        ////////////////////////////////////////////////////////////////////
        mazo.add(new Sorpresa ("¿Quién ha dicho que no se pueda sobornar?"
                , 3000, TipoSorpresa.CONVERTIRME));        
        mazo.add(new Sorpresa ("El cursillo de multipropiedad al fin ha dado sus frutos"
                , 5000, TipoSorpresa.CONVERTIRME));        
        
        Collections.shuffle(mazo); 
        cartaActual = mazo.get(0);
        // Con esto solo conseguimos que la primera sea aleatoria, el resto no
        //cartaActual = mazo.get(ThreadLocalRandom.current().nextInt(0,mazo.size()));
    }
    
    private void inicializarJugadores(ArrayList<String> nombres) {              
        for (String nombJugador : nombres) {
            jugadores.add(new Jugador (nombJugador)); 
        }        
    }
    
    private void inicializarTablero() {
        tablero = new Tablero();
    }
    
    private void salidaJugadores() {
        // Generando número aletorio en [0,numJugadores)
        int aleatorio = ThreadLocalRandom.current().nextInt(0, jugadores.size()-1);

        jugadorActual = jugadores.get(aleatorio);
    }
    
    public Boolean jugar() {
        Boolean tienePropietario;
        
        int valorDado = dado.nextNumber("","");
        Casilla casillaPosicion = jugadorActual.getCasillaActual();  
        Casilla nuevaCasilla = tablero.obtenerNuevaCasilla(casillaPosicion, valorDado);
        
        tienePropietario = jugadorActual.actualizarPosicion(nuevaCasilla);
        
        if (!nuevaCasilla.soyEdificable()) {
            if (nuevaCasilla.getTipo() == TipoCasilla.JUEZ)
                encarcelarJugador();
            else if (nuevaCasilla.getTipo() == TipoCasilla.SORPRESA)      
                cartaActual = mazo.get(0);                
        }
        
        return tienePropietario;
    }     
    
    // Lo he hecho con un array de jugadores, que estarán ordenados de menor a
    // mayor capital
    public ArrayList<Jugador> obtenerRanking() {
        ArrayList<Jugador> ranking = new ArrayList();
        Jugador jugador;
        ranking.add(0, jugadores.get(0));
        
        for (int i = 1; i < jugadores.size(); i++) {        
            jugador = jugadores.get(i);
            if (jugador.obtenerCapital() > ranking.get(0).obtenerCapital())
                ranking.add(0, jugador);
            else
                ranking.add(jugador);
        }
        
        return ranking;
    }    
    
    // Array de strings para ver la situación inicial del juego
    public ArrayList<String> situacionInicial() {
        ArrayList<String> resultado = new ArrayList();
        
        resultado.add("\nTablero:");
        resultado.add(tablero.toString());
        resultado.add("Cartas sorpresa:");
        resultado.add(mazo.toString());        
        
        return resultado;
    }
}
