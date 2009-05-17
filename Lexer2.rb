#= Ttulo: 
# Lexer sin el case
#= Autores: 
#* Einis Rodriguez
#* Elias Matheus (mailto:e3matheus@gmail.com)
#= Contenido: 
#  Analizador Lexicografico del lenguaje yisiel.

require "Token"
class Lexer2
  attr_reader :line, :col
  
  # Descripcion: Constructor del Lexer
  # @param input - Archivo al cual debemos analizar
  # Contiene en 3 listas, las expresiones regulares, asociadas con su función
  def initialize(input)
    @input     = input
    @buffer    = @input.gets
    @line      = 1
    @col       = 1
		@ignorar = {'\A\n' => :nl, '\A\{#' => :Comentario, '\A(( |\t)+|(#))' => :Ignorar}
    @ERs = {'\A\+' => TkPlus, '\A\-'=> TkMinus, '\A\*' => TkTimes, '\A\/'=> TkDiv,'\A=' => TkSet,'\A(\d+)'=> TkNum, '\A\|\|' => TkDisy, '\A&&' => TkConj, '\A~' => TkNeg, '\A%' => TkRes, '\A<' => TkLess, '\A>' => TkGreat, '\A<=' => TkLE, '\A>=' => TkGE, '\A\$' => TkLength, '\A\(' => TkAP,'\A\)' => TkCP, '\A\[' => TkAC, '\A\]' => TkCC,'\A,' => TkComa, '\A:' => TkPP, '\A->' => TkAsigD, '\A<-'=> TkAsigI, '\A;' => TkPC, '\Aarray of '=> TkArrayOf}	
    @ERc = {'\A(\w+)' => :Word, '\A("[^"]*")'=> :Str, "\A('[^']*')"=> :Str}
  end

  # Descripción: Representa el movimiento en la página.
  # @param n - Número de pasos a saltar
  def skip( n=1 )
    @buffer = @buffer[ n .. -1 ]
    @col = @col + n 
  end

  # Descripción: Pasa a la siguiente Linea
  # @param extra - Parametro opcional, que permite condensar el codigo.  
  def nl(*extra)
    @buffer = @input.gets
    @line = @line + 1
    @col = 1
		return "ignora"
  end

  # Descripción: Crea un Token de String. 
  #* @param cl - Columna Actual en el archivo input.
  #* @param cc - Fila Actual en el archivo input.
  #* @param t - Archivo de Metadata resultado de comparación con la expresion regular.
  def Str( cl ,cc,t )
    return TkStr.new( cl, cc, t) 
	end

  # Descripción: Chequea si hay un comentario anidado, de lo contrario manda a ignorar la expresion. 
  #* @param cl - Columna Actual en el archivo input.
  #* @param cc - Fila Actual en el archivo input.
  #* @param t - Archivo de Metadata resultado de comparación con la expresion regular.
  def Ignorar( cl ,cc, t)
    raise "Error Linea #{@line}, Columna #{@col-1}. Comentarios Anidados!\n" if @buffer =~ /[^#]*#/
    return "ignora"
  end
  
  # Descripción: Dependiendo del archivo de metadata, crea o un token de palabra reservada o un token de una variable del programa. 
  #* @param cl - Columna Actual en el archivo input.
  #* @param cc - Fila Actual en el archivo input.
  #* @param t - Archivo de Metadata resultado de comparación con la expresion regular.
  def Word( cl ,cc, t)
    begin
      case t
        when "let"
          return TkLet.new( cl, cc )
        when "in"
          return TkIn.new( cl, cc )
        when "begin"
          return TkBegin.new( cl, cc )
        when "end"
          return TkEnd.new( cl, cc )
        when "proc"
          return TkProc.new( cl, cc )
        when "as"
          return TkAs.new( cl, cc )
        when "return"
          return TkReturn.new( cl, cc )
        when "show"
          return TkShow.new( cl, cc )
        when "true"
          return TkTrue.new( cl, cc )
        when "false"
          return TkFalse.new( cl, cc )
        when "value"
          return TkValue.new( cl, cc )
        when "var"
          return TkVar.new( cl, cc )
        when "skip"
          return TkSkip.new( cl, cc )
      else
        return TkId.new( cl, cc, t )
      end
    end 
  end

  # Descripción: Función de comentarios de múltiples líneas. Revisa que no existen Comentarios anidados, de haberlos crea un error. 
  #* @param cl - Columna Actual en el archivo input.
  #* @param cc - Fila Actual en el archivo input.
  #* @param t - Archivo de Metadata resultado de comparación con la expresion regular.
  def Comentario( cl ,cc, t)
		while @buffer !~ /\A([^#]*)#/ 
			nl()
		  if @input.eof?
        skip(@buffer.length+1)
        return "ignora"
      end  
		end
		skip($1.length-1)
		if @buffer =~ /\A(.)#\}/
			raise "Error Linea #{@line}, Columna #{@col}. Comentarios Anidados!\n" if $1.eql? "{"
      skip(3)
			return "ignora"
		else
      skip if @buffer !~ /\A\{/
			raise "Error Linea #{@line}, Columna #{@col}. Comentarios Anidados!\n"
		end
  end

  # Descripción: Función de comentarios de múltiples líneas. Revisa que no existen Comentarios anidados, de haberlos crea un error. 
  #* @param h - Hash que recorremos.
  #* @param cl - Columna Actual en el archivo input.
  #* @param cc - Fila Actual en el archivo input.
  #* @param opcion - Define el tipo de función a ejecutar.
  def searchHash(h, cl, cc, opcion)
		h.each { |key,value|
			if @buffer =~ Regexp.new(key)
				skip($&.length) 
				case opcion
					when 1	
						return value.send(:new, cl, cc)
					when 2
						return send(value, cl, cc, $&)
				end
			end
		}
		return nil
	end	
	
  # Descripción: Realiza una búsqueda en los hash y devuelve el token mas adecuado a la expresión regular.
  # De no encontrar ninguno que cuadre, o se acabo el archivo o existe un símbolo inválido. 
  def yylex2()
    t = ""
    while !(t.nil?)
			t = searchHash(@ignorar, @line, @col, 2)	
			f = searchHash(@ERs, @line, @col, 1)
			return f if !(f.nil?)
			f = searchHash(@ERc, @line, @col, 2)
			return f if !(f.nil?)
    end
		return nil if (@input.eof? && @buffer.nil?)
		skip()
		raise  "Linea #{@line}, Columna #{@col-1}. Simbolo invalido.\n" 
  end
end
