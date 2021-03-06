# NDC Air Shopping Client ALPHA

Demo implementation using [xapix_client](https://github.com/pickledolives/xapix_client) and the "xapix_ndc_air_shopping" Project on https://app.xapix.io

The following node.js scripts are triggered on POSTing an AirShoppingRequest ie an AirShoppingOfferRequest: https://gist.github.com/oliver-xapix-io/e3decab860afda6d7078

Be aware the approach we are taking here is to a certain degree inspired by IATA NDC. 

Here I'd like to have the developer XapiX NDC client discussion. This may serve as a playground to evaluate best ways to deal with NDC scenarios and implementations.

We are making heavy use of XapiX BETA Edge features here, so please be aware they might be subject to change at this stage.

Please make good use of Github Issues! Do not forget to hit the "watch" button to subscribe to email notifications.

I'd like to put here our links to available resource documents and code, too.

## PS:

Neither json:api nor json_api_client support it yet, but the ultimate way of triggering a transaction would look like:

```ruby
AirShoppingRequest.new(asrq_id: IDS[:asrq], agent_user_id: AGENT_ID).tap do |r|
  r.travellers << RequestedTraveller.new(params[:traveller1])
  r.flights << RequestedFlight.new(params[:flight1])
  r.cabin_types << RequestedCabinType.new(params[:cabin_type1])
  r.transactional_save
end
```
