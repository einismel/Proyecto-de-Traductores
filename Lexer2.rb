# Author:: Einis Rodriguez/Elias Matheus  (mailto:e3matheus@gmail.com)
require "Token"

class Lexer2
  attr_reader :line, :col
  def initialize(input)
    @input     = input
    @buffer    = @input.gets
    @line      = 1
    @col       = 1
		@ignorar = {'\A\n' => :nl, '\A\{#' => :Comentario, '\A(( |\t)+|(#.+))' => :Ignorar}
    @ERs = {'\A\+' => TkPlus, '\A\-'=> TkMinus, '\A\*' => TkTimes, '\A\/'=> TkDiv,'\A=' => TkSet,'\A(\d+)'=> TkNum}	
    @ERc = {'\A(\w+)' => :Word, '\A(".+")'=> :Str,  "\A('.+')"=> :Str}
  end
  def skip( n=1 )
    @buffer = @buffer[ n .. -1 ]
    @col = @col + n 
  end
  def nl(*option)
    @buffer = @input.gets
    @line = @line + 1
    @col = 1
		return "ignora"
  end
  def Str( cl ,cc,t )
    return TkStr.new( cl, cc, t) 
	end
  def Ignorar( cl ,cc, t)
    return "ignora"
  end
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
        else
	  return TkId.new( cl, cc, t )
      end
    end 
  end

	#  Aqui coloque un comentario #Token
  def Comentario( cl ,cc, t)
		while @buffer !~ /\A([^#]*)#/ 
			nl()
			return nil if @input.eof?  # si se termina el archivo, toma todo como comentario.	
		end
		skip($1.length)
		# ... Ciclo para verificar el caracter siguiente del segundo #.	
		if @buffer =~ /\A#\}/
			skip(2)
			return "ignora"
		else
			skip()
			raise "Error Linea #{@line}, Columna #{@col}. Comentarios Anidados!\n"
		end
  end

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
	
	# Descripcion de yylex2
  def yylex2()
    cl = @line
    cc = @col
    t = ""
    while !(t.nil?)
			t = searchHash(@ignorar, cl, cc, 2)	
			cl = @line
			cc = @col
			f = searchHash(@ERs, cl, cc, 1)
			return f if !(f.nil?)
			f = searchHash(@ERc, cl, cc, 2)
			return f if !(f.nil?)
    end
		return nil if (@input.eof? && @buffer.nil?)
		skip()
		raise  "Linea #{cl}, Columna #{cc}. Simbolo invalido.\n" 
  end
end
