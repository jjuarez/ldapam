require 'uri'
require 'net/ldap'


module LDAPAM

  class ConnectionError < StandardError
  end

  class Connection

    CONFIG_KEYS = [:uri, :base, :username, :password]


    def self.test_config(options)

      CONFIG_KEYS.each do |key|

        raise ConnectionError.new("Bad configuration, the key: #{key} do not exist") unless options.keys.include?(key)
      end
    end


    def initialize(options)

      Connection.test_config(options)

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


    def update(dn, attribute, value)

      @connection.replace_attribute(dn, attribute, value)
    end

      
    def find_by(attribute, value, attributes=[:dn])
      
      filter = Net::LDAP::Filter.eq(attribute, value)

      @connection.search(
        :filter        =>filter, 
        :attributes    =>attributes,
        :return_result =>true)
    end
  end
end