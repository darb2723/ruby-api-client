require 'savon'

module Incentco
  class SoapClient

    # CONSTANTS
    DEV_API_BASE= 'http://dev-api.incentco.com'
    PROGRAM_ID= 117592
    ACCESS_KEY= 43424
    SECRET_KEY= '56925162aa5961739d762cebb19c1b291b540250'
    USER= 'dev-manager@cort.incentco.com'
    PASSWD= 'test1234'

    NAMESPACES= {'xmlns:env'=>'http://schemas.xmlsoap.org/soap/envelope/','xmlns:ns1'=>'Auth', 'xmlns:xsi'=>'http://www.w3.org/2001/XMLSchema-instance'}
    USERS_WSDL= "/users?wsdl"
    PROGRAMS_WSDL= "/programs?wsdl"
    ACCOUNTS_WSDL= "/account?wsdl"
    AWARD_LEVELS= "/award_levels?wsdl"


    # constructor
    def initialize(base_url= DEV_API_BASE, user= USER, passwd= PASSWD, program_id= PROGRAM_ID, access_key= ACCESS_KEY, secret_key= SECRET_KEY)
      @base= base_url
      @program_id= program_id
      @access_key= access_key
      @secret_key= secret_key
      @token= nil

      @token= get_token(user, passwd, program_id, access_key, secret_key)
      puts "Token= #{@token}"

      @header= auth_header(@program_id, @access_key, @secret_key, @token)

    end

    def get_token(user, passwd, program_id, access_key, secret_key) 

      header= auth_header(program_id, access_key, secret_key)
      client = Savon.client(wsdl:@base + USERS_WSDL, namespaces:NAMESPACES, namespace_identifier:'env', soap_header:header)
      puts "Program ID #{program_id}" 
      #login_ok= client.call(:login, message: {'username'=>user, 'password'=>passwd});
      #login_ok= client.call(:login_by_recursion, message: {'program_account_holder_id' => program_id, :attributes! => {'program_account_holder_id' => {'xsi:type' => 'xsd:int'}}, 'username'=>user, 'password'=>passwd});
      login_ok= client.call(:login, message: {'username'=>user, 'password'=>passwd});
      puts "Login Response: #{login_ok.body}"
      @token= login_ok.body[:login_response][:return]

    end

    def auth_header(program_id, access_key, secret_key, token= nil) 
      header= { 'access_key' => access_key, 'program_id' => program_id, 'secret_key' => secret_key }

      if (token != nil)
        header= { 'access_key' => access_key, 'program_id' => program_id, 'secret_key' => secret_key, 'token' => token }
      end
      
      { 'ns1:Authenticate' => header }
    end

    def award_levels(program_id= @program_id)
        client = Savon.client(wsdl:@base + AWARD_LEVELS, namespaces:NAMESPACES, namespace_identifier:'env', soap_header:@header)

        response= client.call(:read_list_by_program, message:{'program_account_holder_id' => program_id, :attributes! => {'program_account_holder_id' => {'xsi:type' => 'xsd:int'} }})
        response.body.values[0][:return][:item]

    end

  end
end
