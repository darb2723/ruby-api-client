module Incentco
  class Message

    TYPES = {
      String => 'xsd:string',
      Fixnum => 'xsd:int',
      Hash => 'SOAP-ENC:Struct',
    }

    def initialize params={}
      @params = params
    end

    def add params={}
      @params = @params.merge params
    end

    def generate
      {}.tap do |m|
        attributes = {}
        @params.each_pair do |key,value|
          m[key.to_s] = value
          attributes[key.to_s] = {'xsi:type': TYPES[value.class] || 'xsd:string'}
        end
        m[:attributes!] = attributes
      end
    end

  end
end
