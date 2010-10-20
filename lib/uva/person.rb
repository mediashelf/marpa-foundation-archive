require 'net/ldap'

module UVA
  
  class Person
    
    attr_reader :ldap_vals
    
    # create a new Person based on the provided computing ID
    def initialize(computing_id)
      ldap = Net::LDAP.new(:host => 'ldap.virginia.edu', :base => 'o=University of Virginia,c=US')
      filter = Net::LDAP::Filter.eq( "userid", computing_id)
      attrs = []
      @vals = {}
      ldap.search( :base => "o=University of Virginia,c=US", :attributes => attrs, :filter => filter, :return_result => true ) do |entry|
        entry.attribute_names.each do |n|
          @vals[n] = entry[n]
        end
      end
    end
    
    def first_name
      @vals[:givenname].first rescue ""
    end
    
    def last_name
      @vals[:sn].first rescue ""
    end
      
  end
  

end