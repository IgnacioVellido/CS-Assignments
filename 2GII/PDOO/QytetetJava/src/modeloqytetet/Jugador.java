package modeloqytetet;

import java.util.ArrayList;

public class Jugador {
    private Boolean encarcelado = false;
    private String  nombre;
    private int     saldo = 7500;
    
    private Sorpresa                   cartaLibertad = null;
    private ArrayList<TituloPropiedad> propiedades   = null;
    private Casilla                    casillaActual;
    static int                         factorEspeculador = 1;
    
    // ----------------------- Constructor -------------------------------------   
    public Jugador(String nombre) {
        this.nombre = nombre;
                
        // BUSCAR LA MANERA DE HACERLO SIN CREAR LA CASILLA 
        casillaActual = new OtraCasilla(0, TipoCasilla.SALIDA);
    }
    
    // NO FUNCIONA EN RUBY, AUNQUE SEAN DE LA MISMA CLASE NECESITA READER
    protected Jugador(Jugador jugador) {
        this.encarcelado   = jugador.getEncarcelado();
        this.nombre        = jugador.getNombre();
        this.saldo         = jugador.getSaldo();
        this.cartaLibertad = jugador.cartaLibertad;        
        
        // Intento de copia defensiva
        if (propiedades != null)
            propiedades = (ArrayList<TituloPropiedad>) jugador.getPropiedades().clone();        
        this.casillaActual = jugador.getCasillaActual();                
    }
    
    // ----------------------- Consultores -------------------------------------   
    public Casilla getCasillaActual() {
        return casillaActual;  
    }

    public String getNombre() {
        return nombre;
    }

    public int getSaldo() {
        return saldo;
    }        
    
    public Boolean getEncarcelado() {
        return encarcelado;
    }

    public ArrayList<TituloPropiedad> getPropiedades() {
        return propiedades;
    }        

    public int getFactorEspeculador() {
        return factorEspeculador;
    }        
    
    public int obtenerCapital() {
        int capital  = saldo;
        int nCasas,
            nHoteles;
        
        if (propiedades != null) {
            for (TituloPropiedad propiedad : propiedades) {
                nCasas = propiedad.getCasilla().getNumCasas();
                nHoteles = propiedad.getCasilla().getNumHoteles();
                capital += propiedad.getFactorRevalorizacion() * (nCasas + nHoteles)
                            + propiedad.getCasilla().getCoste();
            }
        }
        return capital;
    }
    
    public Boolean tengoPropiedades() {
        return propiedades != null;
    }    

    boolean tengoCartaLibertad() {
        return cartaLibertad != null;
    }    
    
    protected Boolean tengoSaldo(int cantidad) {
        return saldo >= cantidad;
    }    
    
    Boolean puedoEdificarCasa(Casilla casilla) {
        return esDeMiPropiedad(casilla) && tengoSaldo(casilla.getPrecioEdificar());
    }
    
    Boolean puedoEdificarHotel(Casilla casilla) {
        return esDeMiPropiedad(casilla) && tengoSaldo(casilla.getPrecioEdificar());
    }
    
    Boolean puedoHipotecar(Casilla casilla) {
        return !casilla.estaHipotecada();
    }
    
    Boolean puedoPagarHipoteca(Casilla casilla) {
        int precioDeshipotecar = casilla.getCosteCancelarHipoteca();
        
        return tengoSaldo(precioDeshipotecar);
    }
    
    Boolean puedoVenderPropiedad(Casilla casilla) {
        return esDeMiPropiedad(casilla) && !casilla.getTitulo().getHipotecada();
    }   
    
    private int cuantasCasasHotelesTengo()  {
        int total = 0;
        Casilla cas ;
        
        if (propiedades != null) {
            for (TituloPropiedad propiedad : propiedades) {
                cas = propiedad.getCasilla();
                total += cas.getNumCasas() + cas.getNumHoteles();
            }
        }
        
        return total;
    }    
    
    private Boolean esDeMiPropiedad(Casilla casilla) {
        return propiedades.contains(casilla.getTitulo());        
    }
    
    // ----------------------- Modificadores -----------------------------------   
    void modificarSaldo(int cantidad) {
        saldo += cantidad;
    }
    
    void setCartaLibertad(Sorpresa carta) {
        this.cartaLibertad = carta;
    }
    
    void setCasillaActual(Casilla casilla) {
        this.casillaActual = casilla;
    }
    
    void setEncarcelado(Boolean encarcelado) {
        this.encarcelado = encarcelado;
    }
    
    private void eliminarDeMisPropiedades(Casilla casilla) {
        propiedades.remove(casilla.getTitulo());
    }    
        
    // ----------------------- Métodos -----------------------------------------         
    protected Boolean actualizarPosicion(Casilla casilla) {
        Boolean tienePropietario = false;

        // Si la casilla objetivo es menor, es que ha pasado por la salida
        if (casilla.getNumeroCasilla() < casillaActual.getNumeroCasilla())
            modificarSaldo(Qytetet.SALDO_SALIDA);
                
        setCasillaActual(casilla);
        
        if (casilla.soyEdificable()) {
            tienePropietario = casilla.tengoPropietario();
            if (tienePropietario && !casilla.propietarioEncarcelado())  {
                int costeAlquiler = casilla.cobrarAlquiler();
                // En la otra clase se le ha añadido el dinero al propietario
                // Ahora se lo restamos al cliente
                modificarSaldo(-costeAlquiler);
            }                               
        }        
        else if (casilla.getTipo() == TipoCasilla.IMPUESTO)
            pagarImpuestos(casilla.getCoste());
        
        return tienePropietario;
    }
    
    Boolean comprarTitulo() {
        Boolean puedoComprar = false;
        
        if (casillaActual.soyEdificable() && !casillaActual.tengoPropietario()
                                          && casillaActual.precioTotalComprar() <= saldo) {            
            if (propiedades == null)
                propiedades = new ArrayList<TituloPropiedad>();                        
            
            propiedades.add(casillaActual.asignarPropietario(this));
            modificarSaldo(-casillaActual.getCoste());
            puedoComprar = true;
        }
                    
        return puedoComprar;
    }
    
    Sorpresa devolverCartaLibertad() {
        Sorpresa aDevolver = cartaLibertad;
        cartaLibertad = null;
        
        return aDevolver;
    }
    
    void irACarcel () {
        Casilla carcel = new OtraCasilla (15, TipoCasilla.CARCEL);
        irACarcel(carcel);
    }
    
    void irACarcel(Casilla casilla) {
        setCasillaActual(casilla);
        setEncarcelado(true);
    }
       
    ArrayList<TituloPropiedad> obtenerPropiedadesHipotecadas(Boolean hipotecada) {
        ArrayList<TituloPropiedad> propHipotecadas = null;
        
        for (TituloPropiedad propiedad : propiedades) {
            if (propiedad.getHipotecada() == hipotecada)
                propHipotecadas.add(propiedad) ;
        }
        
        return propHipotecadas;
    }
    
    void pagarCobrarPorCasaYHotel(int cantidad) {
        modificarSaldo(cantidad * cuantasCasasHotelesTengo());
    }
    
    Boolean pagarLibertad() {
        return pagarLibertad(Qytetet.PRECIO_LIBERTAD);
    }
    
    Boolean pagarLibertad(int cantidad) {
        Boolean pagado = false; 
        
        if (tengoSaldo(cantidad)) {
            modificarSaldo(-cantidad);
            pagado = true;
        }
        return pagado;
    }    
    
    void venderPropiedad(Casilla casilla) {
        int ganancia = casilla.venderTitulo();
        modificarSaldo(ganancia);
        
        eliminarDeMisPropiedades(casilla);
        if (propiedades.isEmpty())
            propiedades = null;
    }
    
    protected void pagarImpuestos(int cantidad) {
        modificarSaldo(-cantidad); 
    }    
    
    protected Especulador convertirme(int fianza) {
        return new Especulador(this, fianza);                
    }
        
    @Override
    public String toString() {
      String encar;
      String props = new String();
        if (encarcelado)
            encar = "Si";
        else 
            encar = "No";     
        
        int numCasas, numHoteles;
        if (propiedades != null) {
            for (TituloPropiedad propiedad : propiedades) {
                numCasas = propiedad.getCasilla().getNumCasas();
                numHoteles = propiedad.getCasilla().getNumHoteles();
                
                props += "\t -" + propiedad.getNombre() + ":\t" + 
                        (propiedad.getHipotecada() ? "Esta hipotecada" : 
                                                     "No esta hipotecada") + 
                        "\n\t  Numero de Casas: " + Integer.toString(numCasas) +
                        "\tNumero de Hoteles: " + Integer.toString(numHoteles) + "\n";
            }
        }
        
        /* Pre-Práctica 5
        return nombre + "\n- Saldo:\t" + saldo + "$\n- Casilla: \n" + 
                casillaActual + "\n- Encarcelado:\t" + encar + 
                "\n- Propiedades:\n" + props + "\n";
        */
        return nombre + "\n- Saldo:\t" + saldo + "\n- Encarcelado:\t" + encar + 
                "\n- Propiedades:\n" + props + "\n";
    }
}
