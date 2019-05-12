module Logo
  class Environment
    attr_reader :contents, :parent
    
    def initialize(parent=nil)
      @contents = {}
      @parent = parent
    end

    def []=(key, value)
      if @contents.include? key
        @contents[key] = value
      elsif @parent
        @parent[key] = value
      else
        @contents[key] = value
      end
    end

    def [](key)
      return @contents[key] if @contents.include? key
      return @parent[key] if @parent
      raise Error.new "Error: Undefined binding #{key}"
    end

    def delete(key)
      if @contents.include? key
        @contents.delete key
      elsif @parent
        @parent.delete key
      else
        raise Error.new "Error: Undefined binding #{key}"
      end
    end

    def create(key)
      @contents[key] = nil
    end
  end
end
