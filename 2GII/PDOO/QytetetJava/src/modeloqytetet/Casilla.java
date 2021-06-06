package modeloqytetet;

public abstract class Casilla {
    private int numeroCasilla;
    private TipoCasilla tipo;
    
    // ----------------------- Constructor -------------------------------------
    protected Casilla(int numeroCasilla, TipoCasilla tipo){
        this.numeroCasilla = numeroCasilla;
        this.tipo = tipo;
    }
    
    // ----------------------- Consultores -------------------------------------
    public TipoCasilla getTipo() {
        return tipo;
    }
    
    public int getNumeroCasilla() {
        return numeroCasilla;
    }    
    
    Boolean soyEdificable() {
        return (tipo == TipoCasilla.CALLE);
    }        

    public TituloPropiedad getTitulo() {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }  
    
    public int getCoste() {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");        
    }               
    
    public int getNumCasas() {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }

    public int getNumHoteles() {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }

    public int getPrecioEdificar() {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }
    
    public int getCosteHipoteca() {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }
    
    public int getCosteCancelarHipoteca() {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }        
    
    Boolean estaHipotecada() {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }
    
    Boolean propietarioEncarcelado() {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }        
        
    int calcularValorHipoteca() {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }   

    int precioTotalComprar() {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }
    
    Boolean sePuedeEdificarCasa(int factorEspeculador) {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }
    
    Boolean sePuedeEdificarHotel(int factorEspeculador) {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }
    
    Boolean tengoPropietario() {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }
    
    // ----------------------- Modificadores -----------------------------------
    void setNumCasas(int nuevoNumero) {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }
    
    void setNumHoteles(int nuevoNumero) {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }

    TituloPropiedad asignarPropietario(Jugador jugador) {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }
        
    protected void setTituloPropiedad(TituloPropiedad titulo) {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }    
    
    // ------------------------ Métodos ----------------------------------------       
    int hipotecar() {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }
    
    int cancelarHipoteca() {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }

    int cobrarAlquiler() {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }
    
    int edificarCasa() {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }
    
    int edificarHotel() {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }
            
    int venderTitulo() {
        throw new UnsupportedOperationException("No se debería haber llamado a este método");
    }

    @Override
    abstract public String toString();
}
