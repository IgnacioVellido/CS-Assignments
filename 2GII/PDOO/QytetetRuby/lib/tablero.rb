#encoding: utf-8

require_relative "casilla"
require_relative "calle"

module ModeloQytetet

  class Tablero
    attr_reader :carcel

    # -------------------------- Constructor -----------------------------------    
    def initialize()
      inicializar()
    end
    
    # ------------------------- Consultores -----------------------------------
    # @pre numeroCasilla > 0 y < MAX_CASILLAS
    def obtener_casilla_numero(numero_casilla)
      @casillas[numero_casilla]
    end
    
    def obtener_nueva_casilla(casilla, desplazamiento)
      # Devuelve la primera ocurrencia o nil
      # @pre la casilla existe y devuelve su valor correcto      
      indice = @casillas.index(casilla)      
      
      indice = (indice + desplazamiento + 1) % Qytetet.class_variable_get(:@@MAX_CASILLAS)
      
      return @casillas[indice]
    end
    
    def es_casilla_carcel(numero_casilla)
      @carcel.numero_casilla == numero_casilla
    end
    
    # ---------------------------- Métodos -------------------------------------
    def inicializar
      num_carcel = 15
      @casillas = Array.new
      
      ##########################################################################
      @casillas << Casilla.new(0, TipoCasilla::SALIDA)
      @casillas << Calle.new(1, 100\
                   , TituloPropiedad.new("Bronx        ", 10, 0.25, 50, 50) )
      @casillas << Calle.new(2, 200\
                   , TituloPropiedad.new("Baltic Avenue", 30, 0.5, 150, 120) )
      @casillas << Casilla.new(3, TipoCasilla::SORPRESA)               
      @casillas << Calle.new(4, 250\
                   , TituloPropiedad.new("Whitehall    ", 50, 0.75, 200, 200) ) 
      ##########################################################################
      @casillas << Casilla.new(5, TipoCasilla::CARCEL)
      @casillas << Calle.new(6, 300\
                   , TituloPropiedad.new("Covent Garden", 70, 1, 250, 250) ) 
      @casillas << Casilla.new(7, TipoCasilla::SORPRESA)               
      @casillas << Calle.new(8, 450\
                   , TituloPropiedad.new("Chinatown    ", 80, 1.1, 400, 390) )  
      @casillas << Calle.new(9, 600\
                   , TituloPropiedad.new("Canary Wharf ", 100, 1.2, 500, 500) )
      ##########################################################################               
      @casillas << Casilla.new(10, TipoCasilla::PARKING)
      @casillas << Calle.new(11, 800\
                   , TituloPropiedad.new("Almanjáyar   ", 120, 1.4, 700, 750) )      
      @casillas << Calle.new(12, 1000\
                   , TituloPropiedad.new("Baker Street ", 170, 1.5, 900, 800) )
      @casillas << Casilla.new(13, TipoCasilla::SORPRESA) 
      @casillas << Calle.new(14, 1500\
                   , TituloPropiedad.new("Wall Street  ", 250, 1.6, 1200, 900) )
      ##########################################################################               
      @casillas << Casilla.new(num_carcel, TipoCasilla::JUEZ)
      @casillas << Calle.new(16, 2000\
                   , TituloPropiedad.new("Gothan       ", 350, 1.7, 1500, 1000) ) 
      @casillas << Casilla.new(17, TipoCasilla::SORPRESA)     # Debería ser de tipo Impuesto            
      @casillas << Calle.new(18, 4000\
                   , TituloPropiedad.new("Av. Saharaui ", 500, 2, 3000, 2000) )        
      @casillas << Calle.new(19, 7000\
                   , TituloPropiedad.new("Union Square ", 800, 2.5, 5000, 4000) )               
      ##########################################################################
      
      @carcel = @casillas[num_carcel]
    end    
        
    def to_s()
      resultado = String.new
      
      @casillas.each do |cas|
        resultado += cas.to_s + "\n------------------------\n"
      end
      
      resultado
    end
      
  end

end