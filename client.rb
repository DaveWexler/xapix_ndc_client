require 'rubygems'
require 'bundler/setup'
require 'securerandom'
require 'xapix_client'

XapixClient.configure do |config|
  config.project_name = "xapix_ndc_air_shopping"
  config.auth_token = ENV['XAPIX_NDC_AIR_SHOPPING_TOKEN']
  config.autoload_models = true
end

IDS = Hash[%i(asrq flight1 rt rct).map { |key| [key, SecureRandom.uuid] }]
params = { # from web form or similar
  traveller1: { passenger_type_code: 'ADT', quantity: '1' },
  flight1: { f_id: IDS[:flight1], departure_date: '2015-11-22', departure_airport_code: 'TXL', arrival_airport_code: 'CGN' },
  cabin_type1: { requested_flight_id: IDS[:flight1], cabin_type_id: 'X' }
}

AirShoppingRequest.transactional_create({ asrq_id: IDS[:asrq], agent_user_id: 'xapix-travel-inc' }, [
  RequestedFlight.new(params[:flight1].merge(f_id: IDS[:flight1], air_shopping_request_id: IDS[:asrq])),
  RequestedTraveller.new(params[:traveller1].merge(rt_id: IDS[:rt], air_shopping_request_id: IDS[:asrq])),
  RequestedCabinType.new(params[:cabin_type1].merge(rct_id: IDS[:rct], air_shopping_request_id: IDS[:asrq]))
])

response = AirShoppingResponse.where(air_shopping_request_id: IDS[:asrq]).includes(:response_flight_segments).to_a.first

puts "Response: #{response.attributes.inspect}"
puts "Flight Segments:"
response.flight_segments.each { |segment| puts "- #{segment.attributes.inspect}" }
