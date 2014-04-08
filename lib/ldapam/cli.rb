# encoding: utf-8
require "thor"
require "ldapam/config"
require "ldapam/connection"


module LDAPAM

  class CLI < Thor

    def self.die(exception, code=0)
    
      STDERR.puts "ERROR: #{exception.class}: '#{exception.message}'"
      ::Kernel.exit(code)
    end


    def self.pp_entry(entry, attributes)

      attributes.each do |attribute|

        if entry[attribute].length > 1

          puts "#{attribute}: #{entry[attribute].join(",")}"
        else

          puts "#{attribute}: #{entry[attribute][0]}"
        end
      end
    end


    desc "get uid attribute", "Show the attribute for the uid"
    method_option :config, :type =>:string, :required =>true
    def get(uid, attribute)

      config    = Config.new(options[:config])
      ldap      = Connection.new(config)
      resultset = ldap.find_by(:uid, uid, [attribute])

      resultset.each { |entry| CLI.pp_entry(entry, attribute) }
    rescue Exception =>exc
      CLI.die(exc, 1) 
    end


    desc "set uid attribute value", "Replace the attribute for the uid"
    method_option :config, :type =>:string, :required =>true
    def set(uid, attribute, value)

      config    = Config.new(options[:config])
      ldap      = Connection.new(config)
      resultset = ldap.find_by(:uid, uid, [:dn])

      resultset.each { |entry| ldap.update(entry.dn, attribute, value) }
    rescue Exception =>exc 
      CLI.die(exc, 2) 
    end


    desc "showuids attribute value", "Replace the attribute for the uid"
    method_option :config, :type =>:string, :required =>true
    def match(attribute, value, *attributes)

      config    = Config.new(options[:config])
      ldap      = Connection.new(config)
      resultset = ldap.find_by(attribute, value, attributes)

      resultset.each { |entry| puts entry.inspect; CLI.pp_entry(entry, attributes) }
    rescue Exception =>exc
      CLI.die(exc, 3) 
    end
  end
end