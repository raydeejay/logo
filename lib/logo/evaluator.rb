module Logo
  class Evaluator
    attr_accessor :reader, :interp, :env
    
    def initialize
      @reader = Reader.new
      @interp = Interpreter.new
      @env = Environment.new
    end

    def eval(string)
      @interp.interpret(@reader.read string)
    end
  end
end
