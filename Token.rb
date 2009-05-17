# Author:: Einis Rodriguez/Elias Matheus  (mailto:e3matheus@gmail.com)
class Token
  attr_reader :line, :col, :kind, :value
  def initialize(line, col)
    @line   = line
    @col    = col
    @kind   = "Token"
    @value  = ""
  end
  def to_s
    "Linea #{@line}, Columna #{@col}: #{@kind} #{@value}"
  end
end

class TkPlus < Token
  def initialize(line, col)
    super(line,col)
    @kind   = "TkPlus"
    @value = "+"
  end
end

class TkMinus < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkMinus"
    @value = "-"
  end
end

class TkTimes < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkTimes"
    @value = "*"
  end
end

class TkDiv < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkDiv"
    @value = "/"
  end
end

class TkSet < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkSet"
    @value = "="
  end
end

class TkLength < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkLength"
    @value = "$"
  end
end

class TkRes < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkRes"
    @value = "%"
  end
end

class TkAP < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkAP"
    @value = "("
  end
end

class TkCP < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkCP"
    @value = ")"
  end
end

class TkAC < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkAC"
    @value = "["
  end
end

class TkCC < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkCC"
    @value = "]"
  end
end

class TkCD < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkCD"
    @value = "\""
  end
end

class TkLess < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkLess"
    @value = "<"
  end
end

class TkGreat < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkGreat"
    @value = ">"
  end
end

class TkLE < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkLE"
    @value = "<="
  end
end

class TkGE < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkGE"
    @value = ">="
  end
end

class TkDif < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkDif"
    @value = "!="
  end
end

class TkConj < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkConj"
    @value = "&&"
  end
end

class TkDisy < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkDisy"
    @value = "||"
  end
end

class TkNeg < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkNeg"
    @value = "~"
  end
end

class TkComa < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkComa"
    @value = ","
  end
end

class TkPP < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkPP"
    @value = ":"
  end
end

class TkAsigD < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkAsigD"
    @value = "->"
  end
end

class TkAsigI < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkAsigI"
    @value = "<-"
  end
end

class TkPC < Token
  def initialize(line, col)
    super(line,col)
    @kind  = "TkPC"
    @value = ";"
  end
end

class TkNum < Token
  def initialize(line, col, val)
    super(line,col)
    @kind  = "TkNum"
    @value = val
  end
end

class TkId < Token
  def initialize(line, col, val)
    super(line,col)
    @kind  = "TkId"
    @value = val
  end
end

class TkStr < Token
  def initialize(line, col, val)
    super(line,col)
    @kind  = "TkStr"
    @value = val
  end
end

# ... Comienzo de palabras reservadas ......................

class TkLet < Token
  def initialize(line, col)
    super(line,col)
    @kind   = "TkLet"
    @value = "let"
  end
end

class TkIn < Token
  def initialize(line, col)
    super(line,col)
    @kind   = "TkIn"
    @value = "in"
  end
end

class TkBegin < Token
  def initialize(line, col)
    super(line,col)
    @kind   = "TkBegin"
    @value = "begin"
  end
end

class TkEnd < Token
  def initialize(line, col)
    super(line,col)
    @kind   = "TkEnd"
    @value = "end"
  end
end

class TkProc < Token
  def initialize(line, col)
    super(line,col)
    @kind   = "TkProc"
    @value = "proc"
  end
end

class TkAs < Token
  def initialize(line, col)
    super(line,col)
    @kind   = "TkAs"
    @value = "as"
  end
end

class TkReturn < Token
  def initialize(line, col)
    super(line,col)
    @kind   = "TkReturn"
    @value = "return"
  end
end

class TkShow < Token
  def initialize(line, col)
    super(line,col)
    @kind   = "TkShow"
    @value = "show"
  end
end

class TkTrue < Token
  def initialize(line, col)
    super(line,col)
    @kind   = "TkTrue"
    @value = "true"
  end
end

class TkFalse < Token
  def initialize(line, col)
    super(line,col)
    @kind   = "TkFalse"
    @value = "false"
  end
end
class TkValue < Token
  def initialize(line, col)
    super(line,col)
    @kind   = "TkValue"
    @value = "value"
  end
end
class TkVar < Token
  def initialize(line, col)
    super(line,col)
    @kind   = "TkVar"
    @value = "var"
  end
end
class TkArrayOf < Token
  def initialize(line, col)
    super(line,col)
    @kind   = "TkArrayOf"
    @value = "array of"
  end
end
class TkSkip < Token
  def initialize(line, col)
    super(line,col)
    @kind   = "TkSkip"
    @value = "skip"
  end
end
