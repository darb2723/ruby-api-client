module Incentco
  class SoapClient
    require 'savon'
    require_relative 'message.rb'
    attr_reader :token

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

    def initialize(base_url= DEV_API_BASE, user= USER, passwd= PASSWD, program_id= PROGRAM_ID, access_key= ACCESS_KEY, secret_key= SECRET_KEY)
      @base= base_url
      @program_id= program_id
      @access_key= access_key
      @secret_key= secret_key
      @token= get_token(user, passwd, program_id, access_key, secret_key)
      @header= auth_header(@program_id, @access_key, @secret_key, @token)
    end

    def award_levels(program_id= @program_id)
      client = Savon.client(wsdl:@base + AWARD_LEVELS, namespaces:NAMESPACES, namespace_identifier:'env', soap_header:@header)
      response= client.call(:read_list_by_program, message:{'program_account_holder_id' => program_id, :attributes! =>
                                                            {'program_account_holder_id' => {'xsi:type' => 'xsd:int'}
                                                            }
      })
      response= client.call(:read_list_by_program, message: Message.new(program_account_holder_id: program_id).generate)
      response.body.values[0][:return][:item]
    end

    private

    def get_client(url, namespace, header)
      Savon.client(wsdl:url, namespaces:namespace, namespace_identifier:'env', soap_header:header) 
    end

    def api_call(call_name, message, path = '',  header=@header)
      client = get_client(@base+path, NAMESPACE, header)
      response = client.call(call_name.to_sym, message:message)
      response.body.values[(call_name + '_response').to_sym][:return][:item]
    end

    def auth_header(program_id, access_key, secret_key, token = nil) 
      header = { 'access_key' => access_key, 'program_id' => program_id, 'secret_key' => secret_key }
      header['token'] = token if token
      { 'ns1:Authenticate' => header }
    end

    def get_token(user, passwd, program_id, access_key, secret_key) 
      header= auth_header(program_id, access_key, secret_key)
      client = Savon.client(wsdl:@base + USERS_WSDL, namespaces:NAMESPACES, namespace_identifier:'env', soap_header:header)
      puts "Program ID #{program_id}" 
      login_ok= client.call(:login, message: {'username'=>user, 'password'=>passwd});
      puts "Login Response: #{login_ok.body}"
      login_ok.body[('login_response').to_sym][:return];
    end

  end
end
