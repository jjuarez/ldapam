require 'uri'
require 'net/ldap'


module LDAPAM

  class Client

    def initialize(options)

      uri = URI.parse(options['uri'])

    	@connection = Net::LDAP.new(
    	  :host       =>uri.host,
        :port       =>uri.port,
        :base       =>options['base'],
        :encryption =>uri.scheme == 'ldaps' ? :simple_tls : nil,
        :auth       =>{
          :method   =>:simple,
          :username =>options['username'],
          :password =>options['password']
        })

      self
    end

    def update(dn, attribute, value)
      @connection.replace_attribute(dn, attribute, value)
    end

    def find_by_uid(uid, attributes =[ ]) 

      @connection.search(
        :filter        =>Net::LDAP::Filter.eq("uid", uid), 
        :attributes    =>attributes, 
        :return_result =>true)
    end
  end
end