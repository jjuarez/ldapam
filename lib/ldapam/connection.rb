require 'uri'
require 'net/ldap'


module LDAPAM

  class ConnectionError < StandardError
  end

  class NoResults < StandardError
  end

  class Connection

    CONFIG_KEYS = [:uri, :base, :username, :password]

    def self.test_config(options)

      CONFIG_KEYS.all? { |k| options.keys.include?(k)}
    end


    def initialize(options)

      raise ConnectionError.new("Bad configuration file") unless Connection.test_config(options)

      uri = URI.parse(options[:uri])

    	@connection = Net::LDAP.new(
    	  :host       =>uri.host,
        :port       =>uri.port,
        :base       =>options[:base],
        :encryption =>uri.scheme == 'ldaps' ? :simple_tls : nil,
        :auth       =>{
          :method   =>:simple,
          :username =>options[:username],
          :password =>options[:password]
        })
 
      self
    end

    def create(dn, attributes)

      @connection.add(:dn =>dn, :attributes =>attributes)
    end

    def read(attribute, value, attributes=nil)
      
      result = @connection.search(
        :filter        =>Net::LDAP::Filter.eq(attribute, value), 
        :attributes    =>attributes,
        :return_result =>true)

      raise NoResults.new("No results for search: '#{attribute}=#{value}") unless result.length > 0

      return result
    end

    def update(dn, attributes)

      # @TODO: Esta operacion no es transaccional
      attributes.each { |a, v| @connection.replace_attribute(dn, a, v) }
    end

    def delete(dn)

      @connection.delete(:dn =>dn)
    end

    def uid2dn(uid)

      result = @connection.search(
        :filter        =>Net::LDAP::Filter.eq("uid", uid),
        :attributes    =>[:dn],
        :return_result =>true)

      raise NoResults.new("No results for UID: #{uid}") if result.length == 0

      return result[0].dn
    end
  end
end