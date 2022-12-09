require "sinatra/base"
require "sinatra/reloader"
require_relative "lib/database_connection"
require_relative "lib/listing_repository"
require_relative "lib/user_repository"
require_relative "lib/message_repository"

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end


  enable :sessions


  get "/listings" do
    listing_repo = ListingRepository.new
    @listings = listing_repo.all
    if session[:user_id] == nil
      return erb(:login)
    else
      return erb(:listings)
    end
  end

  get "/login" do
    if session[:user_id] != nil
      redirect "/listings"
    else
      return erb(:login)
    end
  end

  post "/login" do
    user_repo = UserRepository.new()
    username = params[:user_name]
    password = params[:pass_word]
    user = user_repo.find_by_username(username)
    if user == nil
      @error = "Username not found"
      return erb(:login)
    elsif user.pass_word == password
      session[:user_id] = user.user_id
      redirect "/listings"
    else
      @error = "Incorrect password"
      return erb(:login)
    end
  end


  get "/account" do
    id = session[:user_id]
    @listing_repo = ListingRepository.new
    @booking_repo = BookingRepository.new
    @user_repo = UserRepository.new
    @all_unapproved = @booking_repo.find_unconfirmed_bookings(id)
    @all_listings = @listing_repo.find_listings(id)
    @all_bookings = @booking_repo.find_bookings(id)
    @all_booking_information = @listing_repo.find_booking_listing(id)
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
    new_listing.user_id = session[:user_id]
    new_listing.description = description
    new_listing.start_date = start_date
    new_listing.end_date = end_date
    new_listing.price = price
    repo = ListingRepository.new
    repo.create(new_listing)
    return "Listing created!"
  end 


  get "/logout" do
    if session[:user_id] != nil 
    session[:user_id] = nil
    return erb(:logged_out)
    else 
      redirect "/"
    end 
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
    booking.user_id = session[:user_id]
    booking.listing_id = session[:listing_id]
    p "THIS IS THE DATE:     "
    p params[:chosen_date]
    booking.date_booked = Date.parse(params[:chosen_date])
    booking_repo.create(booking)
    return erb(:booking_success)
  end 
  get "/signup" do
    return erb(:signup)
  end

  post "/signup" do
    user_repo = UserRepository.new()

    user_results = user_repo.find_by_username(params[:user_name])
    email_results = user_repo.find_by_email(params[:email_address])
    if user_results == nil && email_results == nil
      user = User.new()
      user.user_name = params[:user_name]
      user.email_address = params[:email_address]
      user.pass_word = params[:pass_word]
      user_repo.create(user)
      user = user_repo.find_by_username(params[:user_name])
      session[:user_id] = user.user_id

      redirect "/listings"
    elsif user_results == nil && email_results != nil
      @error = "The email is already taken!"
      return erb(:signup)
    elsif user_results != nil && email_results == nil
      @error = "The username is already taken!"
      return erb(:signup)
    else
      @error = "The username and email are already taken!"
      return erb(:signup)
    end
  end

  get "/messages" do
    #if session[:user_id] == nil
     # return erb(:login)
    #else
      @message_repository = MessageRepository.new()
      @all_users_messages = @message_repository.all_recieved_by_user(session[:user_id])
      @user_repo = UserRepository.new()

      return erb(:messages)
    # end
  end

    post "/messages" do
      
      message_repo = MessageRepository.new()
      user_repo = UserRepository.new()
      to = params[:to]
      from = params[:from]
      title = params[:title]
      content = params[:content]
      
    message_repo.send(from, to, title, content)
    # Redirect the user back to the form
redirect to('/account')
  end
    
  post "/messages-reply" do
      
    message_repo = MessageRepository.new()
    user_repo = UserRepository.new()
    to = params[:to]
    from = params[:from]
    title = params[:title]
    content = params[:content]
    
  message_repo.send(from, to, title, content)
  # Redirect the user back to the form
redirect to('/messages')
end


  post "/accept" do
    booking_repo = BookingRepository.new 
    booking_repo.accept(params[:booking_id])
    redirect to('/account')
  end

  post "/deny" do
    booking_repo = BookingRepository.new 
    booking_repo.deny(params[:booking_id])
    redirect to('/account')
  end

  get "/" do
    return erb(:index)
  end

  not_found do 
    status 404 
    return "WRONG PAGE YOU IDIOT"
  end 



end


