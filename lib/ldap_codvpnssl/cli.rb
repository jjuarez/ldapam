# encoding: utf-8
require "thor"
require "ldap_codvpnssl/config"
require "ldap_codvpnssl/ldap"


module LdapCodVPNSSL

  class CLI < Thor

    desc "get CONFIG_FILE", "Muestra el CodVPNSSL de un uid"
    method_option :attribute, :aliases => "-a", :default =>:codvpnssl, :type =>:string, :desc =>"Atributo a consultar"
    method_option :id,        :aliases => "-i", :default =>:uid,       :type =>:string, :desc =>"Atributo de búsqueda" 
    def get(config, uid)

      query = case options[:id]

        when :uid then "uid=#{uid}"
        else "#{options[:id]}=#{uid}"
      end

      resultset = LDAP.new(Config.new(config)).search(query, [:dn, :uid, options[:attribute]])

      case resultset.size
        when 0 then
          STDERR.puts("No hay resultados para el UID=#{uid}")

      else
        resultset.each do |e|

          puts "dn: #{e.dn}"
          puts "#{options[:attribute]}: #{e[options[:attribute]]}"
        end
      end
    end


    desc "set CONFIG_FILE UID VALUE", "Muestra el atributo de un UID"
    method_option :attribute, :aliases => "-a", :default =>:codvpnssl, :type =>:string, :desc =>"Atributo a cambiar" 
    method_option :id,        :aliases => "-i", :default =>:uid,       :type =>:string, :desc =>"Atributo de búsqueda" 
    def set(config, uid, value)

      query = case options[:id]

        when :uid then "uid=#{uid}"
        else "#{options[:id]}=#{uid}"
      end

      ldap      = LDAP.new(Config.new(config))
      resultset = ldap.search(query, [:dn])

      case resultset.size
        when 0 then
          STDERR.puts("No hay resultados para el UID=#{uid}")

        else
          resultset.each { |e| ldap.replace(e.dn, options[:attribute], value) }
      end
    end
  end
end