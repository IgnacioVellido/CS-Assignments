package modeloqytetet;

public class Sorpresa {
    private String texto;
    private TipoSorpresa tipo;
    private int valor;
    
    // ------------------------- Constructor -----------------------------------
    public Sorpresa(String texto, int valor, TipoSorpresa tipo) {
        this.texto = texto;
        this.valor = valor;
        this.tipo = tipo;
    }
    
    // ------------------------- Consultores -----------------------------------   
    String getTexto() {
        return texto;
    }
    
    TipoSorpresa getTipo() {
        return tipo;
    }
    
    int getValor() {
        return valor;
    }
    
    // --------------------------- Métodos -------------------------------------
    @Override
    public String toString() {
        return "~ Texto: " + texto + "\n~ Valor: " + valor + "\n~ Tipo: " + tipo;
    }
}