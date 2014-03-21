require "thor"
require "ldap_codvpnssl/config"
require "ldap_codvpnssl/ldap"


module LdapCodVPNSSL

  class CLI < Thor

    desc "get CONFIG_FILE UID", "Muestra el CodVPNSSL de un uid"
    method_option :attribute, :aliases => "-a", :default =>:codvpnssl, :type => :string, :desc =>"Atributo a mostrar" 
    def get(config, uid)

      cfg  = Config.new(config)
      ldap = LDAP.new(cfg)
    
      ldap.connection.search(:base =>cfg[:base], :filter =>::Net::LDAP::Filter.eq("uid", uid), :attributes =>[:dn, :uid, options[:attribute]]) do |entry|

        puts "dn: #{entry.dn}"
        puts "uid: #{entry[:uid][0]}"
        puts "#{options[:attribute]}: #{entry[options[:attribute]]}"
      end
    end

    desc "set CONFIG_FILE UID VALUE", "Muestra el atributo de un UID"
    method_option :attribute, :aliases => "-a", :default =>:codvpnssl, :type =>:string, :desc =>"Atributo a cambiar" 
    def set(config, uid, value)

      cfg  = Config.new(config)
      ldap = LDAP.new(cfg)

      ldap.connection.search(:base =>cfg[:base], :filter =>::Net::LDAP::Filter.eq("uid", uid), :attributes =>[:dn]) do |entry|

        ldap.connection.replace_attribute(entry.dn, options[:attribute], value) 
      end
    end
  end
end