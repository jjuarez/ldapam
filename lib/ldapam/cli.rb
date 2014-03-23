# encoding: utf-8
require "thor"
require "ldapam/config"
require "ldapam/client"


module LDAPAM

  class CLI < Thor

    class_option :config, :aliases =>"-c", :type =>:string

    desc "get uid attribute", "Show the attribute for the uid"
    def get(uid, attribute)

      Client.new(Config.new(options[:config])).find_by_uid(uid, [attribute]).each { |e| puts "#{attribute}: #{e[attribute]}" }
    end


    desc "set uid attribute value", "Replace the attribute for the uid"
    def set(uid, attribute, value)

      ldap      = Client.new(Config.new(options[:config]))
      resultset = ldap.find_by_uid(uid, [:dn])

      resultset.each { |e| ldap.update(e.dn, attribute, value) }
    end
  end
end