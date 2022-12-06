require "sinatra/base"
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/listing_repository'
require_relative 'lib/user_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get "/listings" do
    listing_repo = ListingRepository.new
    @listings = listing_repo.all
    return erb(:listings)
  end

end
