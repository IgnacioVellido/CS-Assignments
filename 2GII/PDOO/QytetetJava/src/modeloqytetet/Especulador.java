package modeloqytetet;

public class Especulador extends Jugador {
    private int fianza;
    
    // ----------------------- Constructor -------------------------------------   
    protected Especulador(Jugador jugador, int fianza) {
        super(jugador);
        this.fianza = fianza;
        factorEspeculador = 2;
    } 
    
    // ------------------------- Consultor -------------------------------------   
    
    // ------------------------- Métodos  --------------------------------------   
    @Override
    protected void pagarImpuestos(int cantidad) {
        modificarSaldo(-(cantidad/2)); 
    }
    
    private Boolean pagarFianza(int cantidad) {
        Boolean puedoPagar = false;
        
        if (super.tengoSaldo(cantidad)) {
            super.modificarSaldo(-cantidad);
            puedoPagar = true;
        }
        
        return puedoPagar;
    }
    
    @Override
    protected void irACarcel(Casilla casilla) {
        if (!pagarFianza(fianza))
            super.irACarcel(casilla);
    }
    
    @Override
    protected Especulador convertirme(int fianza) {
        return this;
    }
    
    @Override
    public String toString() {
        String result = super.toString();
        
        return result + "$$ Especulador $$";
    }
}
