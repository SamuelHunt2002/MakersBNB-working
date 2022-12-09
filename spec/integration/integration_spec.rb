require 'user'
require 'listing'
require 'spec_helper'
require "rack/test"
require_relative "../../app"
require "json"
require_relative "../../lib/database_connection"
require_relative "../../lib/listing_repository"
require_relative "../../lib/user_repository"
require_relative "../../lib/message_repository"


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

end 