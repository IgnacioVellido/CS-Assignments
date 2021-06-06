#encoding: utf-8

require_relative "tipo_casilla"
require_relative "titulo_propiedad"
require_relative "casilla"

module ModeloQytetet
  class Calle < Casilla
    attr_reader   :coste, :titulo
    attr_accessor :num_hoteles, :num_casas

# -------------------------- Constructor -----------------------------------
    def initialize(numero_casilla, coste, titulo)
      super(numero_casilla, tipo)
      @coste = coste
      @tipo = TipoCasilla::CALLE      
      @num_hoteles = 0
      @num_casas = 0
      
      set_titulo_propiedad(titulo)
    end

    # ----------------------- Consultores ------------------------------------- 
    def get_precio_edificar
      @titulo.precio_edificar
    end  
    
    def get_coste_hipoteca
      calcular_valor_hipoteca
    end
    
    def get_coste_cancelar_hipoteca
      get_coste_hipoteca * 1.1
    end
        
    def esta_hipotecada
      @titulo.hipotecada
    end
    
    def propietario_encarcelado
      @titulo.propietario_encarcelado
    end

    def calcular_valor_hipoteca
      @titulo.hipoteca_base + @num_casas * 0.5 + @titulo.hipoteca_base + \
               @num_hoteles + @titulo.hipoteca_base
    end
        
    def precio_total_comprar
      @coste
    end

    def se_puede_edificar_casa(factor_especulador)
      (@num_casas < factor_especulador*4 && @num_hoteles <= factor_especulador*4)
    end
    
    def se_puede_edificar_hotel(factor_especulador)
      (@num_casas == factor_especulador*4 && @num_hoteles < factor_especulador*4)
    end
    
    
    def tengo_propietario
      @titulo.tengo_propietario
    end
   
    # --------------------------- Modificadores --------------------------------
    def asignar_propietario(jugador)
      @titulo.propietario = jugador
      @titulo
    end
    
    # Debido a este método, titulo no tiene attr:accessor
    def set_titulo_propiedad(titulo)
      @titulo = titulo
      titulo.casilla = self
    end
    
    # ¿ Existe alguna diferencia con el anterior ?
    def asignar_titulo_propiedad
      #
    end
     
    # ---------------------------- Métodos -------------------------------------          
    def hipotecar
      @titulo.hipotecada = true
      
      get_coste_hipoteca
    end
    
    def cancelar_hipoteca
      @titulo.hipotecada = false
      
      get_coste_cancelar_hipoteca
    end
    
    def cobrar_alquiler
      coste_alquiler_base = @titulo.alquiler_base + \
                            (@num_casas * 0.5 + @num_hoteles * 2).to_i
                     
      @titulo.cobrar_alquiler(coste_alquiler_base)
      coste_alquiler_base
    end
    
    def edificar_casa
      @num_casas += 1
      @titulo.precio_edificar
    end
    
    def edificar_hotel
      @num_casas = 0
      @num_hoteles += 1
      @titulo.precio_edificar
    end
    
    def vender_titulo
      @titulo.propietario = nil
      ganancia = @coste + (@num_casas + @num_hoteles) * get_precio_edificar
      ganancia *= @titulo.factor_revalorizacion
      
      @num_casas = @num_hoteles = 0
      
      ganancia
    end      
      
    def to_s()
      "# Número de casilla: " + @numero_casilla.to_s    + \
          "\n# Tipo de casilla: " + @tipo.to_s          + \
          "\n# Coste: " + @coste.to_s 			+ \
          "\n# Número de hoteles: " + @num_hoteles.to_s + \
          "\n# Número de casas: " + @num_casas.to_s            
    end

    def ==obj
      if (obj == nil)
        return false
      end
      
      if obj.class.name.split('::').last != 'Calle'
        return false
      end
      
      if (@numero_casilla != obj.numero_casilla || \
          @coste          != obj.coste          || \
          @num_casas      != obj.num_casas      || \
          @num_hoteles    != obj.num_hoteles    || \
          @tipo           != obj.tipo           || \
          @titulo         != obj.titulo)                              
        return false          
      end
      
      return true
    end  

  end
end
