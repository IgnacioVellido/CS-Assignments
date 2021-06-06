#encoding: utf-8

module InterfazTextualQytetet
  
  class VistaTextualQytetet
    # ---------------------------- Métodos -------------------------------------              
    def mostrar_y_esperar(texto)      
      mostrar(texto)
      pulsa_para_continuar
      clear
    end
    
    def clear
      #puts "\e[H\e[2J"   Averiguar por qué no va
      puts "\n\n\n\n"
    end
    
    def pulsa_para_continuar
      puts "Pulsa ENTER para continuar...\r" #Cambiar a \n si no funciona
      gets       
    end
    
    def verdadero_o_falso(texto)
      menuVF = [[0, 'NO'], [1, 'SI']]
      mostrar(texto)
      
      salida = seleccion_menu(menuVF)
      clear
      
      (salida == 1) ? true : false
    end
    
    def menu_salir_carcel(precio_libertad)
      mostrar('Elige el metodo para salir de la carcel')
      
      menuSC = [[0, 'Tirando el dado (necesita un 6)'], 
                [1, "Pagar (" + precio_libertad.to_s + ")"]]
      salida = seleccion_menu(menuSC)
      
      return salida
    end
    
    def elegir_quiero_comprar (nombre, precio)
      mostrar("Desea comprar " + nombre + " por " + precio.to_s + "$ ?")
      verdadero_o_falso("")
    end

    def menu_gestion_inmobiliaria
      mostrar('Elige la gestion inmobiliaria que deseas hacer')
            
      menuGI = [[0, 'Siguiente Jugador'],  [1, 'Edificar casa'],    \
               [2, 'Edificar Hotel'],      [3, 'Vender propiedad'],  \
               [4, 'Hipotecar Propiedad'], [5, 'Cancelar Hipoteca'], \
               [6, 'Mostrar informacion']]      
      
      salida = seleccion_menu(menuGI)
      
      return salida
    end    
    
    def menu_elegir_propiedad(listaPropiedades) # numero y nombre de propiedades            
        menuEP = Array.new
        numero_opcion=0;
        
        for prop in listaPropiedades
            menuEP << [numero_opcion, prop]; # Opción de menú, numero y nombre de propiedad
            numero_opcion = numero_opcion+1
        end
        
        salida = seleccion_menu(menuEP) # Método para controlar la elecci�n correcta en el men� 
        
        salida
    end      
    
    def seleccion_menu(menu)
      
      begin #Hasta que se hace una selección válida
        valido = true
        
        for m in menu     # Se muestran las opciones del menú
          mostrar( "#{m[0]}" + " : " + "#{m[1]}")
        end
        
        mostrar( "\n Elige un numero de opcion: ")
        captura = gets.chomp
        
        # Método para comprobar la elección correcta
        valido = comprobar_opcion(captura, 0, menu.length-1); 
        
        if (!valido) then
          mostrar( "\n\n ERROR !!! \n\n Seleccion erronea. Intentalo de nuevo.\n\n")
        end
        
      end while (!valido)
      
      Integer(captura)  
    end

    def obtener_nombre_jugadores
      nombres = Array.new
      valido = true 
      
      begin
        self.mostrar("Escribe el numero de jugadores: (de 2 a 4):");
        lectura = gets.chomp                                # Lectura de teclado
        valido = comprobar_opcion(lectura, 2, 4); 
      end while (!valido)

      # Pide los nombres de los jugadores y los mete en un array
      for i in 1..Integer(lectura)  
        mostrar('Jugador:  '+ i.to_s)
        nombre = gets.chomp
        nombres << nombre
      end
      
      nombres
    end    

    # Método para comprobar si la opcion introducida es correcta, usado por seleccion_menu    
    def comprobar_opcion(captura,min,max)
      valido = true
      
      begin
        opcion = Integer(captura)
        if (opcion<min || opcion>max) # Si no es un entero entre los válidos
          valido = false
          mostrar('El numero debe estar entre min y max')
        end
        
      rescue Exception => e  # No se ha introducido un entero
        valido = false
        mostrar('Debes introducir un numero')
      end 
      
      valido
    end
    
    # Método para mostrar el string que recibe como argumento
    def mostrar(texto)  
      puts texto
    end

    private :comprobar_opcion, :seleccion_menu
  end
  
end
