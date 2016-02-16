module Incentco


  class ApiKey

    DEV_KEY_ID= 43424
    DEV_SECRET= '56925162aa5961739d762cebb19c1b291b540250'
    DEV_PROGRAM_ID= 117592

    # creates accessible (read only) variables
    attr_reader :key, :secret, :program_id
  
    def initialize(key_id= DEV_KEY_ID, secret= DEV_SECRET, program_id= DEV_PROGRAM_ID)
      @access_key= key_id
      @secret_key= secret
      @program_id= program_id
    end

    def to_s
      self.inspect
    end
  end

end
