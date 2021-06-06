#encoding: utf-8

require "singleton"

module ModeloQytetet
  
  class Dado
    include Singleton

    # -------------------------- Constructor -----------------------------------
    def initialize
      # No necesita nada
    end
    
    # ---------------------------- Métodos -------------------------------------
    def tirar
      1 + rand(6)
    end
  end
 
end