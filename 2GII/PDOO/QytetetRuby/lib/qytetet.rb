#encoding: utf-8

require "singleton"
require_relative "sorpresa"
require_relative "jugador"
require_relative "metodo_salir_carcel"
require_relative "dado"
require_relative "tipo_sorpresa"
require_relative "especulador"
require_relative "jugador"

module ModeloQytetet
  
  class Qytetet
    include Singleton

    @@MAX_JUGADORES = 4
    @@MAX_CARTAS = 10
    @@MAX_CASILLAS = 20
    @@PRECIO_LIBERTAD = 200
    @@SALDO_SALIDA = 1_000
    
    attr_reader :carta_actual, :jugador_actual
    
    # -------------------------- Constructor -----------------------------------
    def initialize()     
      @dado = Dado.instance
    end
    
    # ---------------------------- Métodos -------------------------------------
    def aplicar_sorpresa
      tiene_propietario = false
      
      case @carta_actual.tipo 
        when TipoSorpresa::PAGARCOBRAR
          @jugador_actual.modificar_saldo(@carta_actual.valor)
          
        when TipoSorpresa::IRACASILLA
          if (@tablero.es_casilla_carcel(@carta_actual.valor))
            encarcelar_jugador
          else
            nueva_casilla = @tablero.obtener_casilla_numero(@carta_actual.valor)
            tiene_propietario = @jugador_actual.actualizar_posicion(nueva_casilla)
          end
          
        when TipoSorpresa::PORCASAHOTEL
          @jugador_actual.pagar_cobrar_por_casa_y_hotel(@carta_actual.valor)
          
        when TipoSorpresa::PORJUGADOR
          @jugadores.each { |jugador| 
            if (jugador != @jugador_actual)
              jugador.modificar_saldo(@carta_actual.valor)
              @jugador_actual.modificar_saldo(-@carta_actual.valor)
            end          
          }
          
        when TipoSorpresa::SALIRCARCEL
          @jugador_actual.carta_libertad = @carta_actual
          
        when TipoSorpresa::CONVERTIRME
          jugador = @jugador_actual.convertirme(@carta_actual.valor)                   
          @jugadores.delete_at(@jugadores.index(@jugador_actual))
          @jugador_actual = jugador
          @jugadores << jugador
      end

      @@mazo << @carta_actual
      # REVISAR
      @@mazo.delete_at(@@mazo.index(@carta_actual))
      
      tiene_propietario
    end

    def comprar_titulo_propiedad
      @jugador_actual.comprar_titulo
    end
        
    def vender_propiedad(casilla)
      puedo_vender = false
      
      if (@jugador_actual.puedo_pagar_hipoteca(casilla))
        @jugador_actual.vender_propiedad(casilla)
        puedo_vender = true
      end
      
      puedo_vender
    end
      
    def edificar_casa(casilla)
      puedo_edificar = false
      
      if (@jugador_actual.instance_of? Especulador)
        factor = Especulador.class_variable_get(:@@factor_especulador)
      else
        factor = Jugador.class_variable_get(:@@factor_especulador)
      end
      
      if (casilla.soy_edificable && casilla.se_puede_edificar_casa(factor)\
                                 && @jugador_actual.puedo_edificar_casa(casilla))
        @jugador_actual.modificar_saldo(-casilla.edificar_casa)
        puedo_edificar = true                
      end
      
      puedo_edificar
    end
    
    def edificar_hotel(casilla)
      puedo_edificar = false
      
      if (@jugador_actual.instance_of? Especulador)
        factor = Especulador.class_variable_get(:@@factor_especulador)
      else
        factor = Jugador.class_variable_get(:@@factor_especulador)
      end
      
      if (casilla.soy_edificable && casilla.se_puede_edificar_hotel(factor)\
                                 && @jugador_actual.puedo_edificar_hotel(casilla))
        @jugador_actual.modificar_saldo(-casilla.edificar_hotel)        
        puedo_edificar = true                
      end
      
      puedo_edificar
    end    

    def hipotecar_propiedad(casilla)
      hipotecada = false
      
      if (casilla.soy_edificable && @jugador_actual.puedo_edificar_casa(casilla))
        @jugador_actual.modificar_saldo(casilla.hipotecar)
        hipotecada = true
      end
      
      hipotecada
    end
    
    def cancelar_hipoteca(casilla)
      cancelada = false
      
      if (casilla.soy_edificable && casilla.esta_hipotecada)
        if @jugador_actual.puedo_pagar_hipoteca(casilla)
          @jugador_actual.modificar_saldo(-casilla.cancelar_hipoteca)
          cancelada = true
        end
      end
      
      cancelada
    end
    
    def intentar_salir_carcel(metodo)
      libre = false
      
      if (metodo == MetodoSalirCarcel::TIRANDODADO)
        libre = @dado.tirar > 5
      else
        libre = @jugador_actual.pagar_libertad(Qytetet.class_variable_get(:@@PRECIO_LIBERTAD))
      end
      
      if libre
        @jugador_actual.encarcelado = false
      end
      
      !libre
    end    
    
    def propiedades_hipotecadas_jugador(hipotecadas)
      resultado = Array.new
      propiedades =  @jugador_actual.obtener_propiedades_hipotecadas(hipotecadas)
      
      propiedades.each do |propiedad|
        resultado << propiedad.casilla
      end
      
      resultado
    end
       
    def siguiente_jugador
      indice = (@jugadores.index(@jugador_actual) + 1) % @jugadores.size
      @jugador_actual = @jugadores[indice]
    end

    def encarcelar_jugador
      if !(@jugador_actual.tengo_carta_libertad)
        @jugador_actual.ir_a_carcel(@tablero.carcel)
      else
        carta = @jugador_actual.devolver_carta_libertad
        @@mazo << carta
      end
    end
    
    def inicializar_juego(nombres)
      inicializar_jugadores(nombres)       
      inicializar_tablero          
      inicializar_cartas_sorpresa
      salida_jugadores
    end      
    
    def inicializar_cartas_sorpresa
      @@mazo = Array.new
      num_carcel = @tablero.carcel.numero_casilla
            @@mazo << Sorpresa.new("El cursillo de multipropiedad al fin ha dado sus frutos"\
                            , 5000, TipoSorpresa::CONVERTIRME)
      ####################################################################
      @@mazo << Sorpresa.new("Ya he conseguido que nos devuelvan todo los que nos debían, jefe"\
                            , 500, TipoSorpresa::PAGARCOBRAR) 
      @@mazo << Sorpresa.new("A pagar moroso cab$%@", 500, TipoSorpresa::PAGARCOBRAR)
      ####################################################################
      @@mazo << Sorpresa.new("Te hemos pillado con chanclas y calcetines, lo sentimos, ¡debes ir a la carcel!"\
                            , num_carcel, TipoSorpresa::IRACASILLA)
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
      # El número de esta carta no es relevante
      @@mazo << Sorpresa.new("Un fan anónimo ha pagado tu fianza. Sales de la cárcel"\
                            , num_carcel, TipoSorpresa::SALIRCARCEL)
      ####################################################################
      @@mazo << Sorpresa.new("¿Quién ha dicho que no se pueda sobornar?"\
                            , 3000, TipoSorpresa::CONVERTIRME)

                        
      #@carta_actual = @@mazo[rand(@@MAX_CARTAS)] - Solo coje la primera al azar
      #@@mazo = @@mazo.shuffle 
      @carta_actual = @@mazo[0]
    end
    
    def inicializar_jugadores(nombres)
      @jugadores = Array.new
      nombres.each { |nomb_Jugador| 
        @jugadores << Jugador.new(nomb_Jugador)         
      }      
    end

    def inicializar_tablero
      @tablero = Tablero.new()
    end
    
    def salida_jugadores
      @jugador_actual = @jugadores[rand(@jugadores.size - 1)]
    end

    def jugar        
      valor_dado = @dado.tirar
      casilla_posicion = @jugador_actual.casilla_actual      
      nueva_casilla = @tablero.obtener_nueva_casilla(casilla_posicion, valor_dado)
      
      tiene_propietario = @jugador_actual.actualizar_posicion(nueva_casilla)
      
      if !(nueva_casilla.soy_edificable)        
        if (nueva_casilla.tipo == TipoCasilla::JUEZ)
          encarcelar_jugador
        elsif (nueva_casilla.tipo == TipoCasilla::SORPRESA)
          @carta_actual = @@mazo[0]
          
#          if @carta_actual.tipo == TipoSorpresa::SALIRCARCEL
#            @jugador_actual.carta_libertad = @carta_actual
#          else
#            @@mazo << @carta_actual
#          end
#          
#          @@mazo.delete(@carta_actual)
        end
      end
      
      return tiene_propietario
    end
        
    # Lo he hecho con un array de jugadores, que estarán ordenados de menor a
    # mayor capital
    def obtener_ranking
      ranking = Array.new
      puts @jugadores[0].to_s 
      ranking << @jugadores[0]
      
      for i in 1..(@jugadores.length-1) do
        if (@jugadores[i].obtener_capital > ranking[0].obtener_capital)
          ranking.insert(0, @jugadores[i])
        else
          ranking << @jugadores[i]
        end
      end
      
      ranking
    end
       
    def situacion_inicial
      resultado = Array.new
      
      resultado << "\nTablero:"
      resultado << @tablero.to_s
      resultado << "Cartas sorpresa:"  
      
      @@mazo.each { |carta| 
        resultado << carta.to_s
      }
      
      puts resultado
    end
  end
  
end