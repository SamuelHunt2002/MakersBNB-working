# GET /listings/:id Route Design Recipe

_Copy this design recipe template to test-drive a Sinatra route._

## 1. Design the Route Signature

You'll need to include:
  * the HTTP method
  * the path
  * any query parameters (passed in the URL)
  * or body parameters (passed in the request body)

  Method: GET
  Path: /listings/:id

## 2. Design the Response

The route might return different responses, depending on the result.

For example, a route for a specific blog post (by its ID) might return `200 OK` if the post exists, but `404 Not Found` if the post is not found in the database.

Your response might return plain text, JSON, or HTML code. 

_Replace the below with your own design. Think of all the different possible responses your route will return._

```html
<!-- EXAMPLE -->
<!-- Response when the post is found: 200 OK -->

# 1
Index: 1
Title: Cotswolds Cottage',
Description: 'cute', 
Listed from:'2022-12-01' to: '2022-12-08', 
Price per night:95.00

# 2
Index: 2
Title: 'Skegness Luxury Caravans',
Description: 'Close to Butlins (but not actually in Butlins)', 
Listed from: '2022-12-01', '2022-12-08',
Price per night: 15.00

## 3. Write Examples

_Replace these with your own design._

```
#1 Request:

GET /listings/1
# Expected response:

Response for 200 OK
```

Listing number: 1
Title: 'Cotswolds Cottage',
Description: 'cute', 
Listed from:'2022-12-01' to: '2022-12-08', 
Price per night:95.00
```

#2 Request:

GET /listings/2
# Expected response:

Response for 200 OK
```
Listing number: 2
Title: 'Skegness Luxury Caravans',
Description: 'Close to Butlins (but not actually in Butlins)', 
Listed from: '2022-12-01', '2022-12-08',
Price per night: 15.00



## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET listings/:id" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('listings/1')

      expect(response.status).to eq(200)
    end

    it 'returns 404 Not Found' do
      response = get('listings/666')

      expect(response.status).to eq(404)
    end

    it 'contains the relevant listing' do
    response = get('listings/1')
    expect(response.body).to include "Cotswolds Cottage"
  end
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---

**How was this resource?**  
[😫](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fweb-applications&prefill_File=resources%2Fsinatra_route_design_recipe_template.md&prefill_Sentiment=😫) [😕](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fweb-applications&prefill_File=resources%2Fsinatra_route_design_recipe_template.md&prefill_Sentiment=😕) [😐](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fweb-applications&prefill_File=resources%2Fsinatra_route_design_recipe_template.md&prefill_Sentiment=😐) [🙂](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fweb-applications&prefill_File=resources%2Fsinatra_route_design_recipe_template.md&prefill_Sentiment=🙂) [😀](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fweb-applications&prefill_File=resources%2Fsinatra_route_design_recipe_template.md&prefill_Sentiment=😀)  
Click an emoji to tell us.

<!-- END GENERATED SECTION DO NOT EDIT -->