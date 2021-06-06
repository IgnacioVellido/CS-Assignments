#encoding: utf-8


module InterfazTextualQytetet
class VistaTextualQytetet

  
  def seleccion_menu(menu)
     
    begin #Hasta que se hace una seleccionn valida
      valido= true
      for m in menu #se muestran las opciones del menuº
        mostrar( "#{m[0]}" + " : " + "#{m[1]}")
      end
      mostrar( "\n Elige un numero de opcion: ")
      captura = gets.chomp
      valido=comprobar_opcion(captura, 0, menu.length-1); #metodo para comprobar la eleccion correcta
      if (! valido) then
        mostrar( "\n\n ERROR !!! \n\n Seleccion erronea. Intentalo de nuevo.\n\n")
      end
    end while (! valido)
    Integer(captura)  

  end
  
  
  def comprobar_opcion(captura,min,max)
    # metodo para comprobar si la opcion introducida es correcta, usado por seleccion_menu
     valido=true
     begin
        opcion = Integer(captura)
        if (opcion<min || opcion>max) #No es un entero entre los validos
          valido = false
          mostrar('el numero debe estar entre min y max')
        end
      rescue Exception => e  #No se ha introducido un entero
        valido = false
        mostrar('debes introducir un numero')
     end 
     valido
  end
  
  
  
  
  def menu_gestion_inmobiliaria
    mostrar( 'Elige la gestion inmobiliaria que deseas hacer')
    menuGI=[[0, 'Siguiente Jugador'], [1, 'Edificar casa'], [2, 'Edificar Hotel'], [3, 'Vender propiedad'],[4, 'Hipotecar Propiedad'], [5, 'Cancelar Hipoteca']]
    salida=seleccion_menu(menuGI)
    mostrar( 'has elegido')
    mostrar(salida)
    return salida
  end
  
  def menu_salir_carcel
    mostrar( 'Elige el metodo para salir de la carcel')
    menuSC=[[0, 'Tirando el dado'], [1, 'Pagando mi libertad']]
    salida=seleccion_menu(menuSC)
    mostrar( 'has elegido')
    mostrar(salida)
    salida
  end
  
  def elegir_quiero_comprar
    #se pide si o no se quiere comprar una propiedad
  end
  
 
        
def menu_elegir_propiedad(listaPropiedades) # numero y nombre de propiedades            
    menuEP = Array.new
    numero_opcion=0;
    for prop in listaPropiedades
        menuEP<<[numero_opcion, prop]; # opcion de menu, numero y nombre de propiedad
        numero_opcion=numero_opcion+1
    end
    puts menuEP.inspect
    salida=seleccion_menu(menuEP); # Método para controlar la elección correcta en el menú 
    salida;
end  
  
   def obtener_nombre_jugadores
       nombres=Array.new
       valido = true; 
       begin
        self.mostrar("Escribe el numero de jugadores: (de 2 a 4):");
        lectura = gets.chomp #lectura de teclado
        valido=comprobar_opcion(lectura, 2, 4); #método para comprobar la elección correcta
      end while(!valido)
    
      for i in 1..Integer(lectura)  #pide nombre de jugadores y los mete en un array
         mostrar('Jugador:  '+ i.to_s)
         nombre=gets.chomp
         nombres<<nombre
      end
    nombres
  end
  
  def mostrar(texto)  #metodo para mostrar el string que recibe como argumento
    puts texto
  end
  
  private :comprobar_opcion, :seleccion_menu
  
 
end
end

 #   # --------------------el siguiente método va en ControladorQytetet
# def elegir_propiedad(propiedades) # lista de propiedades a elegir
#        @vista.mostrar("\tCasilla\tTitulo");
#        
#        listaPropiedades= Array.new
#        for prop in propiedades  # crea una lista de strings con numeros y nombres de propiedades
#                propString= prop.numeroCasilla.to_s+' '+prop.titulo.nombre; 
#                listaPropiedades<<propString
#        end
#        seleccion=@vista.menu_elegir_propiedad(listaPropiedades)  # elige de esa lista del menu
#        propiedades.at(seleccion)
# end
