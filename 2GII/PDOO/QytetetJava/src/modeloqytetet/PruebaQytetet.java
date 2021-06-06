package modeloqytetet;

import java.util.ArrayList;
import InterfazTextualQytetet.*;

public class PruebaQytetet {
    static private ArrayList<Sorpresa> mazo = new ArrayList();
    static private Tablero tablero = new Tablero();
    
    private static void inicializarSorpresas() {
        mazo.add(new Sorpresa ("Ya he conseguido que nos devuelvan todo los que nos debían, jefe", 500
                , TipoSorpresa.PAGARCOBRAR));
        
        mazo.add(new Sorpresa ("A pagar moroso cab$%@", 500
                , TipoSorpresa.PAGARCOBRAR));
        ////////////////////////////////////////////////////////////////////
        mazo.add(new Sorpresa ("Te hemos pillado con chanclas y calcetines,"
                + "lo sentimos, ¡debes ir a la carcel!"
                , tablero.getCarcel().getNumeroCasilla()
                , TipoSorpresa.IRACASILLA));
        mazo.add(new Sorpresa ("¿Te crees que ibas a andar por mi barrio sin que yo me enterase?", 2
                , TipoSorpresa.IRACASILLA));
        
        mazo.add(new Sorpresa ("Cariño, estoy sola en casa", 11
                , TipoSorpresa.IRACASILLA));
        ////////////////////////////////////////////////////////////////////
        mazo.add(new Sorpresa ("Le han reevaluado sus viviendas, señor", 1000
                , TipoSorpresa.PORCASAHOTEL));
        
        mazo.add(new Sorpresa ("Los políticos se han inventado una nueva sablada", 1000
                , TipoSorpresa.PORCASAHOTEL));
        ////////////////////////////////////////////////////////////////////
        mazo.add(new Sorpresa ("¿Chavales, os acordáis que me debíais dinero? Pues lo necesito ahora", 750
                , TipoSorpresa.PORJUGADOR));
        
        mazo.add(new Sorpresa ("Un grupo de matones te han robado hasta el último centavo", 750
                , TipoSorpresa.PORJUGADOR));
        ////////////////////////////////////////////////////////////////////
        mazo.add(new Sorpresa ("Un fan anónimo ha pagado tu fianza. Sales"
                + " de la cárcel", 0
                , TipoSorpresa.SALIRCARCEL));
    }
    
    private static ArrayList sorpresasPositivas() {
        ArrayList<Sorpresa> resultado = new ArrayList();
        
        for (Sorpresa sorpresa : mazo) {
            if (sorpresa.getValor() > 0) {
                resultado.add(new Sorpresa (sorpresa.getTexto(), 
                                sorpresa.getValor(), sorpresa.getTipo()));
            }
        }
        
        return resultado;
    }
    
    private static ArrayList irACasilla() {
        ArrayList<Sorpresa> resultado = new ArrayList();

        for (Sorpresa sorpresa : mazo) {
            if (sorpresa.getTipo() == TipoSorpresa.IRACASILLA) {
                resultado.add(new Sorpresa (sorpresa.getTexto(), 
                                sorpresa.getValor(), TipoSorpresa.IRACASILLA));
            }
        }
        
        return resultado;        
    }
    
    private static ArrayList tipoSorpresa(TipoSorpresa tipo_pedido) {
        ArrayList<Sorpresa> resultado = new ArrayList();
        
        for (Sorpresa sorpresa : mazo) {
            if (sorpresa.getTipo() == TipoSorpresa.IRACASILLA) {
                resultado.add(new Sorpresa (sorpresa.getTexto(), 
                                sorpresa.getValor(), tipo_pedido));
            }
        }
        
        return resultado;        
    }
    
    public static void main(String[] args) {
        /* ------------- Pruebas sesión 1 -----------------------------------        
        inicializarSorpresas();
        
        System.out.print("Mazo completo:\n");
        System.out.print(mazo.toString());
        
        ArrayList<Sorpresa> positivas = sorpresasPositivas();
        System.out.print("\nSorpresas positivas:\n");
        System.out.print(positivas.toString());
        
        ArrayList<Sorpresa> casillas = irACasilla();
        System.out.print("\nSorpresas \"Ir a casilla\":\n");
        System.out.print(casillas.toString());
        
        ArrayList<Sorpresa> carcel = tipoSorpresa(TipoSorpresa.SALIRCARCEL);
        System.out.print("\nSorpresas \"Salir cárcel\":\n");
        System.out.print(carcel.toString());
        
        System.out.print("Mostrando tablero:\n" + tablero);
        
        
        TituloPropiedad titu = new TituloPropiedad("Nombre",1,2,3,4);
        Casilla casi = new Casilla(1, TipoCasilla.CALLE, 2, titu);
        Jugador juga = new Jugador("Paco");
        Sorpresa sorp = new Sorpresa("Hola", 500, TipoSorpresa.PAGARCOBRAR);
        Tablero tabl = new Tablero();
        
        Qytetet qyte = Qytetet.getInstance();
        
        //System.out.println(casi);
        //System.out.println(juga);
        //System.out.println(sorp);
        //System.out.println(tabl);
        //System.out.println(titu);
        
        System.out.print('\n');
        */// ------------------------------------------------------------------
        
        ControladorQytetet juego = new ControladorQytetet();
   } 
}
