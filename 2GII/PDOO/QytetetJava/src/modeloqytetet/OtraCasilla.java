package modeloqytetet;

public class OtraCasilla extends Casilla {

    // ------------------------- Constructor -----------------------------------
    public OtraCasilla(int numeroCasilla, TipoCasilla tipo) {
        super(numeroCasilla, tipo);
    }
    // ----------------------- Consultores -------------------------------------

    // ----------------------- Modificadores -----------------------------------

    // ------------------------ Métodos ----------------------------------------       
    @Override
    public String toString() {
        return "# Número de casilla: " + getNumeroCasilla() + "\n# Tipo de casilla: "
                + getTipo();                
    }
}
