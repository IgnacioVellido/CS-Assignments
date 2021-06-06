package modeloqytetet;

public class TituloPropiedad {
    private String  nombre;
    private Boolean hipotecada;
    private float   factorRevalorizacion;
    private int     alquilerBase,
                    hipotecaBase,
                    precioEdificar;
    
    private Jugador propietario = null;
    private Casilla casilla;
    
    // ------------------------- Constructor -----------------------------------
    public TituloPropiedad (String nombre, int alquilerBase, float factorRevalorizacion
                            , int hipotecaBase, int precioEdificar) {
        this.nombre = nombre;
        this.alquilerBase = alquilerBase;
        this.factorRevalorizacion = factorRevalorizacion;
        this.hipotecaBase = hipotecaBase;
        this.precioEdificar = precioEdificar;
        this.hipotecada = false;
    }
    
    // ------------------------- Consultores -----------------------------------
    public int getAlquilerBase() {
        return alquilerBase;
    }
    
    public float getFactorRevalorizacion() {
        return factorRevalorizacion;
    }
    
    public int getHipotecaBase() {
        return hipotecaBase;
    }
    
    public Boolean getHipotecada() {
        return hipotecada;
    }
    
    public String getNombre() {
        return nombre;
    }

    public int getPrecioEdificar() {
        return precioEdificar;
    }
    
    public Casilla getCasilla() {
        return casilla;
    }
    
    Boolean tengoPropietario() {
        return propietario != null;
    }

    Boolean propietarioEncarcelado() {
        return propietario.getEncarcelado();
    }       
    
    // ------------------------- Modificadores ---------------------------------
    void setCasilla(Casilla casilla) {
        this.casilla = casilla;
    }
    
    void setHipotecada(Boolean hipotecada) {
        this.hipotecada = hipotecada;
    }
    
    void setPropietario(Jugador propietario) {
        this.propietario = propietario;   
    }
    
    // ---------------------------- Métodos ------------------------------------    
    void cobrarAlquiler(int coste) {
        propietario.modificarSaldo(-coste);
    }    
    
    @Override
    public String toString(){
        String hipotec = new String();
        if (hipotecada)
            hipotec = "\n· Está hipotecada";
        else
            hipotec = "\n· No está hipotecada";
        
        return "· Nombre de la calle: " + nombre + hipotec +
                "\n· Hipoteca base: "   + hipotecaBase + "\n· Alquiler base: " +
                alquilerBase + "\n· Precio por edificar: " + precioEdificar +
                "\n· Factor de revalorización: " + factorRevalorizacion;
    }
}
