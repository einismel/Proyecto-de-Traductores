require "Token"
require "Lexer"
def main
# ... Dependiendo de si es por consola o si tiene el argumento extra, se elige el archivo
if (ARGV.length==0)
	archivo = readline.chomp
else
	archivo = ARGV[0]
end

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
				return if err.message[20.. -1].eql? "Comentarios Anidados!"
			end
		end
	end
else 
	print "El archivo no existe. Hasta luego."
end
end
main
