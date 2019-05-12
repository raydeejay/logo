module Logo
  class Builtins
    def self.procedures
      self.instance_methods.select { |sym| self.instance_method(sym).owner == self}
    end
    
    def word(*args)
      return [:word, ''] if args.empty?
      return args[0] if args.size == 1
      return [:word, args[0][1] + word(*args[1..])[1]]
    end

    def list(*args)
      return [:list, []] if args.empty?
      return [:list, [args[0]]] if args.size == 1
      return [:list, [args[0]] + list(*args[1..])[1]]
    end

    def sentence(*args)
      return [:list, []] if args.empty?
      return args[0] if args.size == 1
      return [:list, args[0][1] + sentence(*args[1..])[1]]
    end

    def +(*args)
      return [:number, 0] if args.empty?
      return args[0] if args.size == 1
      return [:number, args[0][1] + self.+(*args[1..])[1]]
    end

    def first(*args)
      return nil if args.empty?
      return args[0][1][0]
    end

    def last(*args)
      return nil if args.empty?
      return args[0][1][-1]
    end

    def print(*args)
      return if args.empty?
      if args[0][0] == :list
        args[0][1].each_with_index { |arg, i|
          self.print arg
          Kernel.print ' ' if i < args[0][1].size-1
        }
      else
        Kernel.print args[0][1]
        self.print(*args[1..])
      end
    end

    def show(*args)
      return if args.empty?
      if args[0][0] == :list
        Kernel.print '['
        args[0][1].each_with_index { |arg, i|
          self.print arg
          Kernel.print ' ' if i < args[0][1].size-1
        }
        Kernel.print ']'
      else
        Kernel.print args[0][1]
        self.print(*args[1..])
      end
    end
  end
end
