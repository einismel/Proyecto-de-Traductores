#= Titulo: 
# Programa Principal del Programa.
#= Autores: 
#* Einis Rodriguez
#* Elias Matheus (mailto:e3matheus@gmail.com) 
#= Usage
# 
#  Usage:  ruby yisiel.rb  [archivo]
 
require 'rdoc/usage'
require 'Lexer'
require 'Token'

# Descripción: Recibe la cantidad de parámetros en la instrucción. Si recibe uno solo, pide por consola el nombre del archivo. Si recibe dos, toma el segundo argumento como el nombre del archivo. En cualquier otro caso, no acepta la instrucción. 
#* @param arg - Arreglo que contiene los elementos introducidos en la llamada al archivo.
def recibeArchivo(arg)
  case arg.length
    when 0
      print "Introduzca el nombre del archivo a analizar: "
      return readline.chomp
    when 1
      return ARGV[0]
    else
      RDoc::usage('Usage')
  end
end

# Descripción: Programa principal. Chequea si el archivo existe, e imprime todos los tokens reconocidos por el analizador lexicográfico. Al encontrar un error del tipo Comentario Anidado, detiene la ejecución del programa.
def main
  archivo = recibeArchivo(ARGV)

  if File.exists?(archivo)  
    File.open(archivo, "r") do |file|
      # ... procesar el archivo
      lexer1 = Lexer.new(file)
      f= ""
      # ... se analizan todos los tokens.
      while !(f.nil?)
        # ... Bloque para la excepcion
        begin
          f= lexer1.yylex
          puts f.to_s
        rescue StandardError => err
          print err
          return if err.message[26.. -1].eql? "Comentarios Anidados!\n"
        end
      end
    end
  else 
    print "El archivo no existe. Hasta luego."
  end
end

main
