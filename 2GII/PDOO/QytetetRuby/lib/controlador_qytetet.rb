#encoding: utf-8

require_relative "vista_textual_qytetet"
require_relative "qytetet"
require_relative "tipo_casilla"

module InterfazTextualQytetet
  class ControladorQytetet

    # -------------------------- Constructor -----------------------------------    
    def initialize
      # Elegir modo texto
      @vista = VistaTextualQytetet.new

      inicializacion_juego
    end

    # ---------------------------- Métodos -------------------------------------              
    def inicializacion_juego
      @qytetet = ModeloQytetet::Qytetet.instance
      
      jugadores = @vista.obtener_nombre_jugadores
      
      @qytetet.inicializar_juego(jugadores)
      @jugador = @qytetet.jugador_actual
      @casilla = @jugador.casilla_actual
      
      @vista.clear
      @vista.mostrar(@qytetet.situacion_inicial)
      
      @vista.pulsa_para_continuar
      @vista.clear
      
      desarrollo_juego
    end
    
    def desarrollo_juego
      fin = false      
      
      while (!fin) do
        @vista.mostrar_y_esperar("\nTurno del jugador: " + @jugador.to_s)
        
        encarcelado = @jugador.encarcelado
        if (encarcelado)
          @vista.mostrar_y_esperar("Jugador encarcelado")
          
          metodo = @vista.menu_salir_carcel(ModeloQytetet::Qytetet.class_variable_get(:@@PRECIO_LIBERTAD))
          if metodo == 0
            metodo = ModeloQytetet::MetodoSalirCarcel::TIRANDODADO
          else
            metodo = ModeloQytetet::MetodoSalirCarcel::PAGANDOLIBERTAD
          end
          
          encarcelado = @qytetet.intentar_salir_carcel(metodo)          
          if (encarcelado)
            @vista.mostrar_y_esperar("Sigues encarcelado")
            @qytetet.siguiente_jugador
            @jugador = @qytetet.jugador_actual
            next  # Terminamos la iteración del bucle
          else
            @vista.mostrar_y_esperar("Sales de la carcel")
          end
        end
        
        no_tiene_propietario = !@qytetet.jugar
        @casilla = @jugador.casilla_actual
        
        @vista.mostrar_y_esperar("Ha caido en\n" + @jugador.casilla_actual.to_s)
        
        if (@jugador.saldo > 0)
          encarcelado = @jugador.encarcelado
          if (!encarcelado)
            
            case @casilla.tipo
            when ModeloQytetet::TipoCasilla::SORPRESA
              @vista.mostrar_y_esperar("Sorpresa !" + @qytetet.carta_actual.to_s + "\n")
              no_tiene_propietario = @qytetet.aplicar_sorpresa
              
              encarcelado = @jugador.encarcelado
              @casilla = @jugador.casilla_actual
              if (!encarcelado && (@jugador.saldo > 0))
                if (@casilla.tipo == ModeloQytetet::TipoCasilla::CALLE \
                      && no_tiene_propietario \
                      && @vista.elegir_quiero_comprar(@casilla.titulo.nombre, @casilla.coste))
                  
                  if @qytetet.comprar_titulo_propiedad
                    @vista.mostrar_y_esperar("Se ha comprado la casilla "\
                                              + @casilla.titulo.nombre)
                  else
                    @vista.mostrar_y_esperar("No se puede comprar "\
                                              + @casilla.titulo.nombre)                    
                  end
                end
              end
              
            when ModeloQytetet::TipoCasilla::CALLE
              if (no_tiene_propietario \
                    && @vista.elegir_quiero_comprar(@casilla.titulo.nombre, @casilla.coste))
                @qytetet.comprar_titulo_propiedad
              end  
              
            end
            
            encarcelado = @jugador.encarcelado
            if (!encarcelado && (@jugador.saldo > 0) && @jugador.tengo_propiedades)              
              
              eligiendo = true
              while eligiendo 
                lista_propiedades = Array.new
                @jugador.propiedades.each { |propiedad|
                  lista_propiedades << propiedad.nombre
                }

                opcion = @vista.menu_gestion_inmobiliaria
                if (opcion == 0)
                  break
                end
                
                num_propiedad = @vista.menu_elegir_propiedad(lista_propiedades)
                propiedad = @jugador.propiedades.at(num_propiedad).casilla
                nombre_casilla = @jugador.propiedades.at(num_propiedad).nombre
                
                eligiendo = false
                case opcion                
                when 1
                  if @qytetet.edificar_casa(propiedad)
                    @vista.mostrar("Edificando casa en " + nombre_casilla)
                  else
                    @vista.mostrar("No se puede edificar casa en " + nombre_casilla)
                  end
                  
                when 2 
                  if @qytetet.edificar_hotel(propiedad)
                    @vista.mostrar("Edificando hotel en " + nombre_casilla)
                  else
                    @vista.mostrar("No se puede edificar hotel en " + nombre_casilla)
                  end
                  
                when 3
                  if @qytetet.vender_propiedad(propiedad)
                    @vista.mostrar("Ha vendido " + nombre_casilla \
                                    + "\nSu saldo actual es de "     \
                                    + @jugador.saldo.to_s)
                  else
                    @vista.mostrar("No se puede vender " + nombre_casilla)
                  end                  
                  
                when 4
                  if @qytetet.hipotecar_propiedad(propiedad)
                    @vista.mostrar("Ha hipotecado " + nombre_casilla \
                                    + "\nSu saldo actual es de "     \
                                    + @jugador.saldo.to_s)
                  else
                    @vista.mostrar("No se puede hipotecar " + nombre_casilla)
                  end
                  
                when 5
                  if @qytetet.cancelar_hipoteca(propiedad)
                    @vista.mostrar("Ha cancelado la hipoteca de "    \
                                    + nombre_casilla                 \
                                    + "\nSu saldo actual es de "     \
                                    + @jugador.saldo.to_s)
                  else
                    @vista.mostrar("No se puede deshipotecar " + nombre_casilla)
                  end
                  
                when 6
                  @vista.mostrar(propiedad.to_s)                    
                  
                else
                  @vista.menu_gestion_inmobiliaria
                  eligiendo = true
                  
                end
                
                if (!eligiendo && @jugador.tengo_propiedades)
                  if @vista.verdadero_o_falso("\nElegir otra opcion ?")
                    eligiendo = true
                  end
                end
                
              end
            end
          end
          
          if @jugador.saldo > 0
            @qytetet.siguiente_jugador
            @jugador = @qytetet.jugador_actual            
          else
            fin = true
          end
        
        else
          fin = true
        end                
      end
      
      @vista.mostrar("Fin del juego\nClasificacion:")

      ranking = @qytetet.obtener_ranking        
      for i in 0..(ranking.length-1)
        @vista.mostrar( (i+1).to_s         + "º - " \
                      + ranking[i].nombre  + " - "  \
                      + ranking[i].obtener_capital.to_s)
      end

      @vista.mostrar_y_esperar("Gracias por jugar")
    end
    
    
    # @param propiedades Lista de propiedades a elegir
    def elegir_propiedad(propiedades) 
      @vista.mostrar("\tCasilla\tTitulo");

      listaPropiedades = Array.new
      for prop in propiedades  # Crea una lista de strings con numeros y nombres de propiedades
              propString= prop.numeroCasilla.to_s+' '+prop.titulo.nombre; 
              listaPropiedades<<propString
      end
      
      seleccion = @vista.menu_elegir_propiedad(listaPropiedades)  # Elige de esa lista del menu
      propiedades.at(seleccion)
    end
  end
end
