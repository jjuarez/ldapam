require 'yaml'


module LdapCodVPNSSL

  class Config

    def initialize(config_file)

      @config = YAML.load_file(config_file)

      self
    end

    def [](key)

      @config[key]
    end
  end
end
