#encoding: utf-8

# SE SUPONE QUE HAY QUE BORRAR TODOS LOS MÉTODOS MENOS
# soy_edificiable y to_s

require_relative "tipo_casilla"
require_relative "titulo_propiedad"

module ModeloQytetet
  class Casilla
    attr_reader :numero_casilla, :tipo

    # -------------------------- Constructor -----------------------------------
    def initialize(numero_casilla, tipo)
      @numero_casilla = numero_casilla
      @tipo = tipo      
    end
    
    # ----------------------- Consultores -------------------------------------  
    def soy_edificable
      @tipo == TipoCasilla::CALLE ? true : false 
    end

    # --------------------------- Modificadores --------------------------------
     
    # ---------------------------- Métodos -------------------------------------                    
    def to_s()
      "# Número de casilla: " + @numero_casilla.to_s + \
          "\n# Tipo de casilla: " + @tipo.to_s
    end

    def ==obj
      if (obj == nil)
        return false
      end
      
      if obj.class.name.split('::').last != 'Casilla'
        return false
      end
      
      if (@numero_casilla != obj.numero_casilla ||
            @tipo         != obj.tipo)
        return false          
      end
      
      return true
    end
  end

end
