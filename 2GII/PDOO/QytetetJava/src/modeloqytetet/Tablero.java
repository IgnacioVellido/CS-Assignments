package modeloqytetet;
import java.util.ArrayList;

public class Tablero {
    private ArrayList<Casilla> casillas;
    private Casilla carcel;
    
    // ------------------------- Constructor -----------------------------------
    public Tablero () {
        inicializar();
    }    
    
    // ------------------------- Consultores -----------------------------------
    Casilla getCarcel() {
        return carcel;
    }
    
    // @pre numeroCasilla > 0 y < MAX_CASILLAS
    Casilla obtenerCasillaNumero(int numeroCasilla) {
        return casillas.get(numeroCasilla);
    }
    
    // Antes se sumaba 1, ahora no
    Casilla obtenerNuevaCasilla(Casilla casilla, int desplazamiento) {
        int indice = casillas.indexOf(casilla);

        indice = (indice + desplazamiento) % Qytetet.MAX_CASILLAS;
        
        return casillas.get(indice);
    }
    
    Boolean esCasillaCarcel(int numeroCasilla) {
        return carcel.getNumeroCasilla() == numeroCasilla;
    }
    
    // --------------------------- Métodos -------------------------------------
    private void inicializar() {
        int numCarcel = 15;
        casillas = new ArrayList();
        
        // Construir cada casilla del tablero, a las de calle añadir el título
        casillas.add (new OtraCasilla (0, TipoCasilla.SALIDA));
        casillas.add (new Calle (1, TipoCasilla.CALLE, 100
                , new TituloPropiedad("Bronx        ", 10, (float) 0.25, 50, 50)));
        casillas.add (new Calle (2, TipoCasilla.CALLE, 200
                , new TituloPropiedad("Baltic Avenue", 30, (float) 0.5, 150, 120)));
        casillas.add (new OtraCasilla (3, TipoCasilla.SORPRESA));
        casillas.add (new Calle (4, TipoCasilla.CALLE, 250
                , new TituloPropiedad("Whitehall    ", 50, (float) 0.75, 200, 200)));
        ////////////////////////////////////////////////////////////////////////
        casillas.add (new OtraCasilla (5, TipoCasilla.CARCEL));
        casillas.add (new Calle (6, TipoCasilla.CALLE, 300
                , new TituloPropiedad("Covent Garden", 70, 1, 250, 250)));
        casillas.add (new OtraCasilla (7, TipoCasilla.SORPRESA));
        casillas.add (new Calle (8, TipoCasilla.CALLE, 450
                , new TituloPropiedad("Chinatown    ", 80, (float) 1.1, 400, 390)));
        casillas.add (new Calle (9, TipoCasilla.CALLE, 600
                , new TituloPropiedad("Canary Wharf ", 100, (float) 1.2, 500, 500)));
        ////////////////////////////////////////////////////////////////////////
        casillas.add (new OtraCasilla (10, TipoCasilla.PARKING));
        casillas.add (new Calle (11, TipoCasilla.CALLE, 800
                , new TituloPropiedad("Almanjáyar   ", 120, (float) 1.4, 700, 750)));
        casillas.add (new Calle (12, TipoCasilla.CALLE, 1000
                , new TituloPropiedad("Baker Street ", 170, (float) 1.5, 900, 800)));
        casillas.add (new OtraCasilla (13, TipoCasilla.SORPRESA));
        casillas.add (new Calle (14, TipoCasilla.CALLE, 1500
                , new TituloPropiedad("Wall Street  ", 250, (float) 1.6, 1200, 900)));
        ////////////////////////////////////////////////////////////////////////
        casillas.add (new OtraCasilla (numCarcel, TipoCasilla.CARCEL));
        casillas.add (new Calle (16, TipoCasilla.CALLE, 2000
                , new TituloPropiedad("Gothan       ", 350, (float) 1.7, 1500, 1000)));
        casillas.add (new OtraCasilla (17, TipoCasilla.SORPRESA));  // Debería ser de tipo impuesto
        casillas.add (new Calle (18, TipoCasilla.CALLE, 4000
                , new TituloPropiedad("Av. Saharaui ", 500, 2, 3000, 2000)));
        casillas.add (new Calle (19, TipoCasilla.CALLE, 7000
                , new TituloPropiedad("Union Square ", 800, (float) 2.5, 5000, 4000)));
        ////////////////////////////////////////////////////////////////////////

        carcel = casillas.get(numCarcel);
    }    
    
    @Override
    public String toString() {
        String resultado = new String();
        
        for (Casilla cas : casillas) {
            resultado += cas.toString() + "\n-------------------------------\n";
        }
        
        return resultado;
    }
}
