#= Titulo: 
# Main del programa
#= Autores: 
#* Einis Rodriguez
#* Elias Matheus (mailto:e3matheus@gmail.com)
#= Contenido: 
#  Compilador del lenguaje yisiel.
#= Usage 
#  Usage ruby yisiel.rb [archivo.rb]

require 'rdoc/usage'
require 'Lexer2'
require 'Token'

def main
  # ... Dependiendo de si es por consola o si tiene el argumento extra, se elige el archivo
  if (ARGV.length==0)
    archivo = readline.chomp
  elsif  (ARGV.length==1)
    archivo = ARGV[0]
  else
    puts "you suck"
  end

  if File.exists?(archivo)  
    File.open(archivo, "r") do |file|
      # ... procesar el archivo
      lexer1 = Lexer2.new(file)
      f= ""
      # ... se analizan todos los tokens.
      while !(f.nil?)
        # ... Bloque para la excepcion
        begin
          f= lexer1.yylex2
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
