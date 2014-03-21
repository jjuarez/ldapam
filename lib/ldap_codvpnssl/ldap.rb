require 'uri'
require 'net/ldap'


module LdapCodVPNSSL

  class LDAP

    attr_reader :connection

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
  end
end
