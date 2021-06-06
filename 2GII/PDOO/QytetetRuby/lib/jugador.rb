#encoding: utf-8

require_relative "casilla"
require_relative "titulo_propiedad"
require_relative "sorpresa"
require_relative "qytetet"
require_relative "especulador"

module ModeloQytetet
  
  class Jugador
    attr_reader :nombre, :saldo, :propiedades
    attr_writer :carta_libertad
    attr_accessor :encarcelado, :casilla_actual
    

    # -------------------------- Constructor -----------------------------------    
    def initialize(nombre)
      @nombre = nombre
      @encarcelado = false
      @saldo = 7_500
      @propiedades = nil
      @casilla_actual = Casilla.new(0, TipoCasilla::SALIDA)    
      
      @@factor_especulador = 1
    end

	def nuevoJugador(jugador)
    @nombre = jugador.nombre
    @encarcelado = jugador.encarcelado
    @saldo = jugador.saldo
    @propiedades = jugador.propiedades
    @carta_libertad = jugador.get_carta_libertad
    @casilla_actual = jugador.casilla_actual	  
	end
    
    # ----------------------- Consultores -------------------------------------   
    def get_carta_libertad()
      @carta_libertad
    end
    
    def obtener_capital
      capital = @saldo
      n_casas = n_hoteles = 0
      
      if @propiedades != nil
        @propiedades.each do |propiedad|  
          n_casas = propiedad.casilla.num_casas
          n_hoteles = propiedad.casilla.num_hoteles
          capital += propiedad.factor_revalorizacion * (n_casas + n_hoteles) + \
                     propiedad.casilla.coste
        end        
      end      
      
      capital
    end

    def tengo_propiedades
      (@propiedades == nil) ? false : true 
    end
    
    def tengo_carta_libertad
      (@carta_libertad == nil) ? false : true
    end   
        
    def tengo_saldo(cantidad)
      @saldo >= cantidad
    end    
    
    def puedo_edificar_casa(casilla)
      es_de_mi_propiedad(casilla) && tengo_saldo(casilla.titulo.precio_edificar)
    end
    
    def puedo_edificar_hotel(casilla)
      es_de_mi_propiedad(casilla) && tengo_saldo(casilla.titulo.precio_edificar)
    end
    
    def puedo_hipotecar(casilla)
      !casilla.esta_hipotecada
    end
    
    def puedo_pagar_hipoteca(casilla)
      precio_deshipotecar = casilla.get_coste_cancelar_hipoteca
      
      tengo_saldo(precio_deshipotecar) ? true : false
    end
    
    def puedo_vender_propiedad(casilla)
      es_de_mi_propiedad(casilla) && !casilla.titulo.hipotecada
    end      
    
    def cuantas_casas_hoteles_tengo
      total = 0
      
      if @propiedades != nil 
        @propiedades.each do |propiedad|
          cas = propiedad.casilla
          total += cas.num_casas + cas.num_hoteles
        end
      end 
      
      total
    end

    # Comprueba si está el objeto
    def es_de_mi_propiedad(casilla)
      @propiedades.include?(casilla.titulo)
    end
    
    # ----------------------- Modificadores -----------------------------------   
    def modificar_saldo(cantidad)
      @saldo += cantidad
    end    
    
    # Borra todas las ocurrencias, en este caso como máximo solo una
    def eliminar_de_mis_propiedades(casilla)
      @propiedades.delete(casilla.titulo)
    end
    
    # ---------------------------- Métodos -------------------------------------    
    def actualizar_posicion(casilla)
      tiene_propietario = false
      
      if(casilla.numero_casilla < @casilla_actual.numero_casilla)
        modificar_saldo(Qytetet.class_variable_get(:@@SALDO_SALIDA))
      end
      
      @casilla_actual = casilla
      
      if (casilla.soy_edificable)
        tiene_propietario = casilla.tengo_propietario
        if (tiene_propietario && !casilla.propietario_encarcelado)
          coste_alquiler = casilla.cobrar_alquiler()
          modificar_saldo(-coste_alquiler)
        end      
      elsif (casilla.tipo == TipoCasilla::IMPUESTO)
        pagar_impuestos(-casilla.valor)
      end
      
      tiene_propietario
    end
    
    def comprar_titulo
      puedo_comprar = false
      
      if (@casilla_actual.soy_edificable && !@casilla_actual.tengo_propietario\
                                         && @casilla_actual.coste <= @saldo)
        if @propiedades == nil
          @propiedades = Array.new
        end
        
        @propiedades << @casilla_actual.asignar_propietario(self)                             
        modificar_saldo(-@casilla_actual.coste)
        puedo_comprar = true
      end
      
      puedo_comprar
    end
    
    def devolver_carta_libertad
      a_devolver = @carta_libertad
      @carta_libertad = nil
      
      a_devolver
    end
    
    # Crash or not to crash ? That is the question
    def ir_a_carcel(casilla = Casilla.new(15, TipoCasilla::CARCEL))
      @casilla_actual = casilla
      @encarcelado = true
    end        

    def obtener_propiedades_hipotecadas(hipotecada)      
      prop_hipotecadas = Array.new
      
      @propiedades.each do |propiedad|  
        if (propiedad.hipotecada == hipotecada)
          prop_hipotecadas << propiedad
        end
      end
    end
    
    def pagar_cobrar_por_casa_y_hotel(cantidad)
      modificar_saldo(cantidad * cuantas_casas_hoteles_tengo)
    end
    
    def pagar_libertad(cantidad = Qytetet.class_variable_get(:@@PRECIO_LIBERTAD))
      pagado = false
      
      if (tengo_saldo(cantidad))
        modificar_saldo(-cantidad)
        pagado = true
      end
      
      pagado
    end
         
    def vender_propiedad(casilla)
      modificar_saldo(casilla.vender_titulo)
      
      eliminar_de_mis_propiedades(casilla)
      if @propiedades.empty?
        @propiedades = nil
      end
    end        
    
    def pagar_impuestos(cantidad)
      modificar_saldo(-cantidad)
    end
    
    def convertirme(fianza)
      Especulador.new(self, fianza)
    end
    
    def to_s()
      (@encarcelado == true)? encarcelado = "Si" : encarcelado = "No"
      
      props = String.new    
      if @propiedades != nil        
        @propiedades.each { |propiedad| 
          num_casas = propiedad.casilla.num_casas
          num_hoteles = propiedad.casilla.num_hoteles
          props += "\t -" + propiedad.nombre + ":\t" + 
            (propiedad.hipotecada ? "Esta hipotecada" : "No esta hipotecada") + 
            "\n\t  Numero de Casas: " + num_casas.to_s + 
            "\tNumero de Hoteles: " + num_hoteles.to_s + "\n"
        }
      end
      
      @nombre.to_s + ": \n- Saldo:\t" + @saldo.to_s + "\n- Casilla: \n" + \
                @casilla_actual.to_s + "\n- Encarcelado:\t" + encarcelado.to_s + \
                "\n- Propiedades:\n" + props + "\n"
                    
    end

    #protected :pagar_impuestos    
    private :eliminar_de_mis_propiedades, :es_de_mi_propiedad, :tengo_saldo\
            , :cuantas_casas_hoteles_tengo
  end
  
end
