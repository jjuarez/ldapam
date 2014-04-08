require 'yaml'
require 'json'


module LDAPAM

  class ConfigError < StandardError
  end

  class Config

    def initialize(source=nil, options={ }, &block)

      @config = Hash.new

      case source
        when /\.(yml|yaml)/i then
          raise ConfigError.new("File: #{source} do not exist") unless File.exist?(source)
          @config = YAML.load_file(source)    
        
        when Hash then 
          @config = source

      else
        
        yield self if block_given?
      end

      self
    end


    def keys()

      @config.keys
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