#encoding: utf-8

require_relative "jugador"
require_relative "casilla"

module ModeloQytetet
  
  class TituloPropiedad
    attr_reader :nombre, :alquiler_base, :factor_revalorizacion, :hipoteca_base\
                , :precio_edificar
    attr_writer :propietario 
    attr_accessor :hipotecada, :casilla

    # -------------------------- Constructor -----------------------------------    
    def initialize (nombre, alquiler_base, factor_revalorizacion, hipoteca_base\
                          , precio_edificar)
      @nombre = nombre
      @alquiler_base = alquiler_base
      @factor_revalorizacion = factor_revalorizacion
      @hipoteca_base = hipoteca_base
      @precio_edificar = precio_edificar
      @hipotecada = false
      @propietario = nil
    end

    # ---------------------------- Consultores ---------------------------------
    def tengo_propietario
      (@propietario == nil) ? false : true
    end    

    def propietario_encarcelado
      @propietario.encarcelado
    end
        
    # ---------------------------- Métodos -------------------------------------
    def cobrar_alquiler(coste)
      @propietario.modificar_saldo(-coste)
    end
        
    def to_s()
      (@hipotecada == true)? hipotecada = "\n- Está hipotecada"\
                             : hipotecada = "\n- No está hipotecada"
        
      "- Nombre de la calle: " + @nombre + hipotecada + "\n- Hipoteca base: " + 
      @hipoteca_base.to_s + "\n- Alquiler base: "     + @alquiler_base.to_s + 
      "\n- Precio por edificar: "      + @precio_edificar.to_s +
      "\n- Factor de revalorización: " + @factor_revalorizacion.to_s
    end

  end
  
end