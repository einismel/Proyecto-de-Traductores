# Author:: Einis Rodriguez/Elias Matheus  (mailto:e3matheus@gmail.com)

require "Token"

class Lexer
  attr_reader :line, :col
  def initialize(input)
    @input     = input
    @buffer    = @input.gets
    @line      = 1
    @col       = 1
  end
  def skip( n=1 )
    @buffer = @buffer[ n .. -1 ]
    @col = @col + n 
  end
  def nl()
    @buffer = @input.gets
    @line = @line + 1
    @col = 1
  end
  def yylex()
    cl = @line
    cc = @col
    while true
      case @buffer 
          # ... Agregue comentarios de una sola linea.....
	when /\A(( |\t)+|(#.+))/ 
          skip($&.length)
          cc = @col
        when /\A\n/
          nl()
          cl = @line
	  # ... Le faltaba la instruccion cc = @col........
	  cc = @col
        when /\A\+/
          begin
            skip(1)
            return TkPlus.new( cl, cc )
          end
        when /\A\-/
          begin
            skip(1)
            return TkMinus.new( cl, cc )
          end
        when /\A\*/
          begin
            skip(1)
            return TkTimes.new( cl, cc )
          end
        when /\A\//
          begin
            skip(1)
            return TkDiv.new( cl, cc )
          end
        when /\A=/
          begin
            skip(1)
            return TkSet.new( cl, cc )
          end
        when /\A(\d+)/
          begin
            skip( $&.length )
            return TkNum.new( cl, cc, $&.to_i )
          end
# ... Expresiones Regulares nuevas ..................
        when /\A(".+"|'.+')/
          begin
            skip( $&.length )
            return TkStr.new( cl, cc, $&)
          end	
        when /\A(\{#)/
          begin
            skip($&.length)
					while @buffer !~ /\A([^#]*#)/ 
					nl()
					return nil if @input.eof? # ... si se termina el archivo, toma todo como comentario.	
					end
				skip($1.length)	
				# ... Ciclo para verificar el caracter siguiente del segundo #.	
				if @buffer =~ /\A\}/
								skip()
				else
					raise "Linea #{@line}, Columna #{@col}. Comentarios Anidados!"
				end
				cl = @line
				cc = @col
          end	
# ... Fin de Expresiones Regulares nuevas ..................
        when /\A(\w+)/
          begin
            skip( $&.length )
            case $&
              when "let"
                return TkLet.new( cl, cc )
              when "in"
                return TkIn.new( cl, cc )
# ... Expresiones Regulares de palabras reservadas que agregue.......
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
# ... Fin de expresiones regulares de palabras reservadas que agregue....
              else
                return TkId.new( cl, cc, $& )
            end
          end
        else 
          if @input.eof? then
            return nil
          else
            skip()
	    raise  "Linea #{cl}, Columna #{cc}. Simbolo invalido.\n"
          end 
      end
    end
  end
    
end
