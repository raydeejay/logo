module Logo
  class Interpreter

    # declare all procedures to have arity two
    
    def interpret(tokens)
      result = nil
      ts = tokens.each

      loop {
        begin
          token = ts.next

          case token[0]
          when :expression
            result = interpret(token[1])
          when :number
            result = token
          when :list
            result = token
          when :word
            result = token
          when :procedure
            name = token[1][0]
            symname = name.downcase.to_sym
            args = token[1][1..]

            # look the default arity up or something ?
            # right now it's hardcoded in the reader, 1 for print and 2 for anything else
            if Builtins.procedures.include? symname
              result = Builtins.new.send(symname, *args.collect {|arg| interpret([arg])})
            # else
            else
              raise Error.new "Error: Undefined procedure #{name}"
            end
          end
        rescue StopIteration
          break
        end
      }

      return result
    end
  end
end
