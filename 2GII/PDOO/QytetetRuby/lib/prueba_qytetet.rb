#encoding: utf-8

require_relative "sorpresa"
require_relative "tablero"
require_relative "titulo_propiedad"
require_relative "casilla"

require_relative "controlador_qytetet"

module ModeloQytetet
  
  class PruebaQytetet
    @@mazo = Array.new
    
    def initialize 
      PruebaQytetet.inicializar_sorpresas
    end

    def self.main
      # inicializar_sorpresas
      
      # -------------- Pruebas sesión 1 -----------------------------------
      #@@mazo.each { |sorpresa| puts sorpresa.to_s }
      
      #positivas = sorpresas_positivas
      #puts positivas
      
      #iracasilla = ir_a_casilla
      #puts iracasilla
      
      #tiposorpresa = tipo_sorpresa(TipoSorpresa::PAGARCOBRAR)
      #puts tiposorpresa
      # --------------------------------------------------------------------
            
      # titu = TituloPropiedad.new("Nombre", 1, 2, 3, 4)
      # casi = Casilla.new(1, TipoCasilla::CALLE, 2, titu)
      # juga = Jugador.new("Paco")
      # sorp = Sorpresa.new("Hola", 500, TipoSorpresa::PAGARCOBRAR)      
      # tabl = Tablero.new()
      
      #puts casi.to_s
      #puts juga.to_s
      #puts sorp.to_s
      #puts tabl.to_s
      #puts titu.to_s
      
      InterfazTextualQytetet::ControladorQytetet.new
    end

    def self.inicializar_sorpresas
      @@mazo << Sorpresa.new("Ya he conseguido que nos devuelvan todo los que nos debían, jefe"\
                            , 500, TipoSorpresa::PAGARCOBRAR) 
      @@mazo << Sorpresa.new("A pagar moroso cab$%@", 500, TipoSorpresa::PAGARCOBRAR)
      ####################################################################
      @@mazo << Sorpresa.new("Te hemos pillado con chanclas y calcetines, lo sentimos, ¡debes ir a la carcel!"\
                            , 2, TipoSorpresa::IRACASILLA)
      @@mazo << Sorpresa.new("¿Te crees que ibas a andar por mi barrio sin que yo me enterase?"\
                            , 2, TipoSorpresa::IRACASILLA)
      @@mazo << Sorpresa.new("Cariño, estoy sola en casa", 4, TipoSorpresa::IRACASILLA)
      ####################################################################
      @@mazo << Sorpresa.new("Le han reevaluado sus viviendas, señor"\
                            , 1000, TipoSorpresa::PORCASAHOTEL)
      @@mazo << Sorpresa.new("Los políticos se han inventado una nueva sablada"\
                            , 1000, TipoSorpresa::PORCASAHOTEL)
      ####################################################################     
      @@mazo << Sorpresa.new("¿Chavales, os acordáis que me debíais dinero? Pues lo necesito ahora"\
                            , 750, TipoSorpresa::PORJUGADOR)
      @@mazo << Sorpresa.new("Un grupo de matones te han robado hasta el último centavo"\
                            , 750, TipoSorpresa::PORJUGADOR)
      ####################################################################
      @@mazo << Sorpresa.new("Un fan anónimo ha pagado tu fianza. Sales de la cárcel"\
                            , 0, TipoSorpresa::SALIRCARCEL)
    end

    def self.sorpresas_positivas()
      resultado = Array.new
      
      @@mazo.each do |sorpresa|
        if (sorpresa.valor > 0)
          resultado << Sorpresa.new(sorpresa.texto, sorpresa.valor, sorpresa.tipo)
        end
      end
      
      resultado
    end

    def self.ir_a_casilla()
      resultado = Array.new
      
      @@mazo.each do |sorpresa|
        if (sorpresa.tipo == TipoSorpresa::IRACASILLA)
          resultado << Sorpresa.new(sorpresa.texto, sorpresa.valor, sorpresa.tipo)
        end
      end
      
      resultado
    end

    def self.tipo_sorpresa(tipo)
      resultado = Array.new
      
      @@mazo.each do |sorpresa|
        if (sorpresa.tipo.equal?(tipo))
          resultado << Sorpresa.new(sorpresa.texto, sorpresa.valor, sorpresa.tipo)
        end
      end
      
      resultado
    end
  end
  
  PruebaQytetet.main
  
end