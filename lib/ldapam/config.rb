require 'yaml'
require 'json'


module LDAPAM

  class Config

    def initialize(source=nil, options={ }, &block)

      @config = Hash.new

      case source
        when /\.(yml|yaml)/i then @config = YAML.load_file(source)        
        when /\.json/i       then @config = JSON.parse(File.read(source))
        when Hash            then @config = source

      else
        
        yield self if block_given?
      end

      self
    end


    def [](key)
      @config[key]
    end


    def []=(key, value)
      @config[key] = value
    end


    def method_missing(method, *arguments, &block)

      attribute = method.to_s

      case attribute

        when /(.+)=$/ then
          key          = attribute.delete('=').to_sym 
          @config[key] = (arguments.size == 1 ? arguments[0] : arguments)

        when /(.+)\?$/ then
          key = attribute.delete('?').to_sym
          @config.keys.include?(key) 

        else
          if @config.keys.include?(method)
            
            @config[method]
          else
            
            super
          end
      end
    end
  end
end