package modeloqytetet;

public class Calle extends Casilla {
    private int             coste,
                            numCasas,
                            numHoteles;
    private TituloPropiedad titulo;
    
    // ------------------------- Constructor -----------------------------------
    public Calle(int numeroCasilla, TipoCasilla tipo, int coste, TituloPropiedad titulo) {
        super(numeroCasilla, tipo);
        this.numCasas   = 0;
        this.numHoteles = 0;
        this.coste      = coste;
        setTituloPropiedad(titulo);
    }
    
    // ----------------------- Consultores -------------------------------------
    @Override
    public TipoCasilla getTipo() {
        return super.getTipo();
    }

    @Override
    public TituloPropiedad getTitulo() {
        return titulo;
    }  
    
    @Override
    public int getCoste() {
        return coste;        
    }           
    
    @Override
    public int getNumeroCasilla() {
        return super.getNumeroCasilla();
    }
    
    @Override
    public int getNumCasas() {
        return numCasas;
    }

    @Override
    public int getNumHoteles() {
        return numHoteles;
    }

    @Override
    public int getPrecioEdificar() {
        return titulo.getPrecioEdificar();
    }
    
    @Override
    public int getCosteHipoteca() {
        return calcularValorHipoteca();
    }
    
    @Override
    public int getCosteCancelarHipoteca() {
        return (int) (getCosteHipoteca() * 1.1);
    }        
    
    @Override
    Boolean estaHipotecada() {
        return titulo.getHipotecada();
    }
    
    @Override
    Boolean propietarioEncarcelado() {
        return titulo.propietarioEncarcelado();
    }        
        
    // No se supone que hace lo mismo que getCosteHipoteca() ?
    @Override
    int calcularValorHipoteca() {
        return (int) (titulo.getHipotecaBase() + 
                numCasas * 0.5 * titulo.getHipotecaBase() +
                numHoteles * titulo.getHipotecaBase());    
    }   

    // Alguna diferencia actual con getCoste() ???
    @Override
    int precioTotalComprar() {
        return getCoste();
    }
    
    @Override
    Boolean sePuedeEdificarCasa(int factorEspeculador) {
        return (numCasas < factorEspeculador*4 && numHoteles <= factorEspeculador*4);
    }
    
    // Se cambian 4 (u 8 si Especulador) casas por un hotel
    @Override
    Boolean sePuedeEdificarHotel(int factorEspeculador) {
        return (numCasas == factorEspeculador*4 && numHoteles < factorEspeculador*4);
    }        
    
    @Override
    Boolean tengoPropietario() {
        return titulo.tengoPropietario();
    }
    
    // ----------------------- Modificadores -----------------------------------
    @Override
    void setNumCasas(int nuevoNumero) {
        this.numCasas = nuevoNumero;
    }
    
    @Override
    void setNumHoteles(int nuevoNumero) {
        this.numHoteles = nuevoNumero;
    }

    @Override
    TituloPropiedad asignarPropietario(Jugador jugador) {
        titulo.setPropietario(jugador);
        return titulo;
    }
        
    @Override
    protected void setTituloPropiedad(TituloPropiedad titulo) {
        this.titulo = titulo;
        titulo.setCasilla(this);
    }    

    // ¿ Alguna diferencia con el set ?
//    void asignarTituloPropiedad() {
//        throw new UnsupportedOperationException("Sin implementar");                
//    }    
    
    // ------------------------ Métodos ----------------------------------------       
    @Override
    int hipotecar() {
        titulo.setHipotecada(true);
        
        return getCosteHipoteca();
    }
    
    @Override
    int cancelarHipoteca() {
        titulo.setHipotecada(false);
        
        return getCosteCancelarHipoteca();
    }

    @Override
    int cobrarAlquiler() {
        int costeAlquilerBase = titulo.getAlquilerBase() +
                                (int) (numCasas * 0.5 + numHoteles * 2);        
        
        titulo.cobrarAlquiler(costeAlquilerBase);
        return costeAlquilerBase;
    }
    
    @Override
    int edificarCasa() {
        setNumCasas(numCasas + 1);
        
        return titulo.getPrecioEdificar();
    }
    
    // Se cambian las 4 casas por un hotel
    @Override
    int edificarHotel() {
        setNumCasas(0);        
        setNumHoteles(numHoteles + 1);
        
        return titulo.getPrecioEdificar();    
    }
            
    @Override
    int venderTitulo() {
        titulo.setPropietario(null);
        int ganancia = getCoste() + (numCasas + numHoteles) * getPrecioEdificar();
        ganancia *= titulo.getFactorRevalorizacion();
        
        numCasas = numHoteles = 0;

        return ganancia;
    }

    @Override
    public String toString() {
        return "# Número de casilla: " + getNumeroCasilla() + "\n# Tipo de casilla: "
                + getTipo()  + "\n# Coste: " + coste   + "\n# Número de hoteles: " 
                + numHoteles + "\n# Número de casas: " + numCasas + "\n\n" 
                + titulo.toString();
    }
}
