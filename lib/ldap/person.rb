require 'net/ldap'

module Ldap
  
  class Person
    
    attr_reader :ldap_vals
    
    # create a new Person based on the provided computing ID
    def initialize(computing_id)
      ldap = Net::LDAP.new(:host => LDAP_HOST, :base => LDAP_BASE)
      filter = Net::LDAP::Filter.eq( LDAP_USER_ID, computing_id)
      attrs = []
      @vals = {}
      ldap.search( :base => LDAP_BASE, :attributes => attrs, :filter => filter, :return_result => true ) do |entry|
        entry.attribute_names.each do |n|
          @vals[n] = entry[n]
        end
      end
    end
    
    def first_name
      @vals[LDAP_FIRST_NAME.to_sym].first rescue ""
    end
    
    def last_name
      @vals[LDAP_LAST_NAME.to_sym].first rescue ""
    end
    
    def computing_id
      @vals[LDAP_COMPUTING_ID.to_sym].first rescue ""
    end
    
    def institution
      LDAP_INSTITUTION
    end
    
    def department
      @vals[:uvadisplaydepartment].first rescue ""
    end
  end
  

end
