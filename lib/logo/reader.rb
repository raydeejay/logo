module Logo
  class Reader
    def skip_spaces(stream)
      loop {
        break if stream.eof?
        c = stream.getc
        if c != ' '
          stream.ungetc(c)
          break
        end
      }
    end
    
    def skip_to_newline(stream)
      loop {
        break if stream.eof?
        c = stream.getc
        break if c == '\n'
      }
    end
    
    def read_delimited(stream, delimiter)
      list = []
      
      loop {
        skip_spaces(stream)
        token = read_one(stream)
        break if stream.eof?
        break if token == [:delimiter, delimiter]
        list << token
      }

      return list
    end
    
    def read_number(stream)
      token = StringIO.new
      c = stream.getc
      negative = c == '-'
      
      loop {
        token << c
        break if stream.eof?
        c = stream.getc
        if not ('0'..'9') === c
          stream.ungetc(c)
          break
        end
      }
      
      return token.string.to_i
    end
    
    def read_word(stream)
      token = StringIO.new
      c = stream.getc
      
      loop {
        token << c
        break if stream.eof?
        c = stream.getc
        if ' ,;()[]{}'.include?(c)
          stream.ungetc(c)
          break
        end
      }
      
      return token.string
    end

    def proc_sum(a, b)
      a + b
    end

    def proc_print(a)
      puts a
    end
    
    def is_procedure(string)
      Builtins.procedures.include? string.downcase.to_sym
    end
    
    def read_procedure(stream)
      # this is when things get hairy because the reader must know a procedure's arity
      # so we hardcode it for now
      skip_spaces(stream)
      procedure = read_word(stream)
      args = []
      argc = 2

      case procedure
      when '+'
        argc = 2
      when 'print'
        argc = 1
      else
        argc = 2
      end

      n = 1
      loop {
        break if n > argc
        break if stream.eof?
        token = read_one(stream)
        if token
          args << token
          n += 1
        end
      }

      return [procedure] + args
    end

    def read_delimited_procedure(stream)
      skip_spaces(stream)
      procedure = read_word(stream)
      args = read_delimited(stream, ')')
      return [procedure] + args
    end

    def read_list(stream)
      read_delimited(stream, ']')
    end

    def read_expression(stream)
      read_delimited(stream, ')')
    end

    def read_procedure_or_expression(stream)
      skip_spaces(stream)
      pos = stream.pos
      token = read_word(stream)
      stream.seek(pos)

      if is_procedure(token)
        read_procedure(stream)
      else
        read_expression(stream)
      end
    end

    def read_one(stream)
      c = stream.getc
      
      case c
      when ' '
        skip_spaces(stream)
      when ';'
        skip_to_newline(stream)
      when ?'
        return [:word, read_word(stream)]
      when ?"
        return [:word, read_word(stream)]
      when ('0'..'9')
        stream.ungetc(c)
        return [:number, read_number(stream)]
      when '-'
        stream.ungetc(c)
        return [:number, read_number(stream)]
      when ?:
        return [:variable, read_word(stream)]
      when '['
        return [:list, read_list(stream)]
      when ']'
        return [:delimiter, ']']
      when '('
        skip_spaces(stream)
        pos = stream.pos
        token = read_word(stream)
        stream.seek(pos)

        if is_procedure(token)
          return [:procedure, read_delimited_procedure(stream)]
        else
          return [:expression, read_expression(stream)]
        end
      when ')'
        return [:delimiter, ')']
      else
        stream.ungetc(c)
        return [:procedure, read_procedure(stream)]
      end
    end

    def read(string)
      stream = StringIO.new(string)
      tokens = []

      loop {
        skip_spaces(stream)
        break if stream.eof?
        
        token = read_one(stream)
        tokens << token if token
      }

      return tokens
    end
  end
end
