require 'uri'
require 'net/ldap'


module LdapCodVPNSSL

  class LDAP

    def initialize(options)

      uri = URI.parse(options[:uri])

    	@connection = Net::LDAP.new(
    	  :host       =>uri.host,
        :port       =>uri.port,
        :base       =>options[:base],
        :encryption =>(uri.scheme == "ldaps" ? :simple_tls : nil),
        :auth       =>{
          :method   =>:simple,
          :username =>options[:username],
          :password =>options[:password]
        })

      self
    end

    def search(query, attributes = [])
      
      @connection.search(:filter =>Net::LDAP::Filter.construct(query), :attributes =>attributes, :return_result =>true)
    end

    def replace(dn, attribute, value)

      @connection.replace_attribute(dn, attribute, value)
    end
  end
end
