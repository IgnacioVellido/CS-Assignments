require_relative "./jugador"

module ModeloQytetet
  
  class Especulador < Jugador
    
    # -------------------------- Constructor -----------------------------------    
    def initialize (jugador, fianza)
      # Si por algún casual tambien tenías: super.nuevoJugador(...)
      # super llama siempre al método con el mismo nombre pero en la clase
      # padre. No es lo mismo que el puntero "this" de Java o C++
      nuevoJugador(jugador.clone)            
      
      @fianza = fianza
      @@factor_especulador = 2
    end
    
    # ---------------------------- Métodos -------------------------------------
    def pagar_impuestos(cantidad)
      super.modificar_saldo(-(cantidad/2))
    end
    
    def pagar_fianza(cantidad)
      puego_pagar = false
      
      if (super.tengo_saldo(cantidad))
        super.modificar_saldo(-cantidad)
        puedo_pagar = true
      end
      
      puedo_pagar
    end
    
    def ir_a_carcel(casilla)
      if(!pagar_fianza(fianza))
        super.ir_a_carcel(casilla)
      end
    end
    
    def convertirme(fianza)
      return self
    end
    
    def to_s
      super.to_s + "$$ Especulador $$"
    end
    
    protected :pagar_impuestos, :ir_a_carcel
    private :pagar_fianza
  end
  
end
