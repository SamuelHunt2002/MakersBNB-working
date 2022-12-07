require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'

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



    xit 'gets all listings' do
      response = get('/listings')
      expect(response.status).to eq 200
      expect(response.body).to include "Cotswolds Cottage"
      expect(response.body).to include "Skegness"
    end

    it "Login page appears" do
      response = get('/login')
      expect(response.status).to eq 200
      expect(response.body).to include "Log in to"
    end

    it "Login posts a request successfully" do
      response = post('/login', user_name: "user1", pass_word: "pass1")
      expect(response.status).to eq 302
    end
  end

