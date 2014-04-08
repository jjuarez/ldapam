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

    
    def find_by_uid(uid, attributes=[ ]) 

      filter = Net::LDAP::Filter.eq("uid", uid)

      @connection.search(
        :filter        =>filter, 
        :attributes    =>attributes, 
        :return_result =>true)
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