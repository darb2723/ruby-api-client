require_relative '../lib/incentco/soap_client.rb'

DEV_API_BASE= 'http://dev-api.incentco.com'
PROGRAM_ID= 117592
ACCESS_KEY= 43424
SECRET_KEY= '56925162aa5961739d762cebb19c1b291b540250'
USER= 'dev-manager@cort.incentco.com'
PASSWD= 'test1234'



client= Incentco::SoapClient.new(DEV_API_BASE, USER, PASSWD, PROGRAM_ID, ACCESS_KEY, SECRET_KEY)

award_levels= client.award_levels(PROGRAM_ID)
award_levels= client.award_levels(117596)

puts award_levels
