require "sinatra/base"
require "sinatra/reloader"
require_relative "lib/database_connection"
require_relative "lib/listing_repository"
require_relative "lib/user_repository"

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  enable :sessions 

  get "/listings" do
    listing_repo = ListingRepository.new
    @listings = listing_repo.all
    return erb(:listings)
  end

  get "/listings/:id" do
    listing_repo = ListingRepository.new
    @listing = listing_repo.find(params[:id])
    @listing_dates = listing_repo.all_avail_dates(params[:id])
    puts @listing_dates
    return erb(:each_listings)
  end

  post "/book" do
    booking_repo = BookingRepository.new()
    booking = Booking.new()
    booking.user_id = params[:user_id]
    booking.listing_id = session[:listing_id]
    p "THIS IS THE DATE:     "
    p params[:chosen_date]
    booking.date_booked = Date.parse(params[:chosen_date])
    booking_repo.create(booking)
    return erb(:booking_success)
  end
end
