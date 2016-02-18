require_relative '../lib/incentco/soap_client.rb'

DEV_API_BASE= 'http://dev-api.incentco.home'
PROGRAM_ID= 3
ACCESS_KEY= 2
SECRET_KEY= '56c34178a5cd7e9d0faa602e4e0e384160942b3b'
USER= 'dave@darbsworld.com'
PASSWD= 'this4now'



client= Incentco::SoapClient.new(DEV_API_BASE, USER, PASSWD, PROGRAM_ID, ACCESS_KEY, SECRET_KEY)

award_levels= client.award_levels(PROGRAM_ID)
award_levels= client.award_levels(3)
puts award_levels

user_info= {
  'email' => 'newuser@darbsworld.com',
  'organization_uid' => '1234u',
  'first_name' => 'New',
  'last_name' => 'User',
}

puts client.invite_participant(user_info, PROGRAM_ID, 1)

