#encoding: utf-8

require_relative "tipo_sorpresa"

module ModeloQytetet

  class Sorpresa
    attr_reader :texto, :tipo, :valor

    # -------------------------- Constructor -----------------------------------    
    # @pre Texto - string, valor - int, tipo - TipoSorpresa
    def initialize(texto, valor, tipo)
      @texto = texto
      @valor = valor
      @tipo = tipo
    end

    # ---------------------------- Métodos -------------------------------------
    def to_s
      "\n~ Texto: #{@texto} \n~ Valor: #{@valor} \n~ Tipo: #{@tipo}"
    end

  end
  
end