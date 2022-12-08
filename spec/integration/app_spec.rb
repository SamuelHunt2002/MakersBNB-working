require "spec_helper"
require "rack/test"
require_relative "../../app"
require "json"

def reset_table
  seed_sql = File.read("spec/seeds.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "makersbnb_test" })
  connection.exec(seed_sql)
end

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  # Write your integration tests below.
  # If you want to split your integration tests
  # accross multiple RSpec files (for example, have
  # one test suite for each set of related features),
  # you can duplicate this test file to create a new one.

  xit "gets all listings" do
    response = get("/listings")
    expect(response.status).to eq 200
    expect(response.body).to include "Cotswolds Cottage"
    expect(response.body).to include "Skegness"
  end

  context "GET /account" do
    xit "gets account info for id = 1" do
      response = get("/account", id=1)
      expect(response.status).to eq 200
      expect(response.body).to include "Cotswolds Cottage"
      expect(response.body).to include "2022-12-05"
    end

    context "GET/listings/newlisting" do
      it "gets the page for the newlisting form" do
        response = get("/listings/newlisting")
        expect(response.status).to eq 200
        expect(response.body).to include '<form action="/listings" method="POST">'
      end
    end

    context "POST /listings" do
      xit "adds a listing to /listings" do
        response = post("/listings", title: "Maldives", description: "cute and quaint, waterfront palm tree studio shack", start_date: "2022-12-24", end_date: "2022-12-25", price: 300.00)
        expect(response.status).to eq 200
        expect(response.body).to eq "Listing created!"
        response2 = get("/listings")
        expect(response2.body).to include "Maldives"
        expect(response2.body).to include "cute and quaint, waterfront palm tree studio shack"
        reset_table
      end
      it "doesn't add a listing and returns status 400 if no values given" do
        response = post("/listings", title: nil, description: "cute and quaint, waterfront palm tree studio shack", start_date: "2022-12-24", end_date: "2022-12-25", price: 300.00)
        expect(response.status).to eq 400
        expect(response.body).to eq "Please fill out the fields"
      end
      it "Login page appears" do
        response = get("/login")
        expect(response.status).to eq 200
        expect(response.body).to include "Log in to"
      end

      it "Login posts a request successfully" do
        response = post("/login", user_name: "user1", pass_word: "pass1")
        expect(response.status).to eq 302
      end
    end
  end
end
