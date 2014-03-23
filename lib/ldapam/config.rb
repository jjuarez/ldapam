require 'yaml'
require 'json'


module LDAPAM

  class Config

    def initialize(source=nil, options={ }, &block)

      @config = Hash.new

      case source
        when /\.(yml|yaml)/i then @config = YAML.load_file(source)        
        when Hash            then @config = source

      else
        
        yield self if block_given?
      end

      self
    end


    def [](key, default=nil)
      
      if @config[key]
        
        @config[key]
      else 
        
        default
      end
    end
  end
end