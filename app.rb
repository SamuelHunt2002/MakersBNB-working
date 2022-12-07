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

  get "/account/:id" do
    id = params[:id]
    listing_repo = ListingRepository.new
    booking_repo = BookingRepository.new
    @all_listings = listing_repo.find_listings(id)
    @all_bookings = booking_repo.find_bookings(id)
    @all_booking_information = listing_repo.find_booking_listing(id)
    return erb(:account)
  end

  get "/listings/newlisting" do
  return erb(:newlisting)
  end

  post "/listings" do
    if params[:title] == nil || params[:description] == nil || params[:start_date] == nil|| params[:end_date] == nil || params[:price] == nil
      status 400
      return "Please fill out the fields"
    end
    title = params[:title]
    description = params[:description]
    start_date = params[:start_date]
    end_date = params[:end_date]
    price = params[:price]
    new_listing = Listing.new
    new_listing.title = title
    new_listing.description = description
    new_listing.start_date = start_date
    new_listing.end_date = end_date
    new_listing.price = price
    repo = ListingRepository.new
    repo.create(new_listing)
    return "Listing created!"
  end
end
