# encoding: utf-8
require "thor"
require "ldapam/config"
require "ldapam/connection"


module LDAPAM

  class CLI < Thor


    desc "find attribute value", "Replace the attribute for the uid"
    method_option :config, :type =>:string, :required =>true
    def find(attribute, value, *attributes)

      connection = Connection.new(Config.new(options[:config]))
      rs         = connection.read(attribute, value, attributes)
        
      abort("No entry results for the match: #{attribute}=#{value}") if rs.length == 0
      rs.each do |entry| 

        entry.attribute_names.each { |attr| puts "#{attr}: #{(entry[attr].length > 1) ? entry[attr].join(',') : entry[attr][0]}" }
      end
    rescue Exception =>exc
      abort("ERROR: #{exc.message}")
    end


    desc "update UID attribute value", "Replace the attribute for the uid"
    method_option :config, :type =>:string, :required =>true
    def update(uid, attribute, value)

      connection = Connection.new(Config.new(options[:config]))
      dn         = connection.uid2dn(uid)

      connection.update(dn, { attribute =>value }) 
    rescue Exception =>exc 
      abort("ERROR: #{exc.message}")
    end
  end
end