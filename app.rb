require "sinatra/base"
require "sinatra/reloader"
require_relative "lib/database_connection"
require_relative "lib/listing_repository"
require_relative "lib/user_repository"
require_relative "lib/message_repository"
require "stripe"
require_relative "lib/basket"

Stripe.api_key = "sk_test_51MCiDtAU1MzBZRXFao9IjGfWCr6NaYfJ9sh347K6O4YSAvtt9A7KuEIXBfkKiHMAIXRB3eYJ9mSmyLFuYgxme4N100UwES8QrK"
DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  enable :sessions
  basket = Basket.new
  cost = 0

  get "/basket" do
    class BookingInfo
      attr_accessor :date_booked, :title, :price
    end

    if basket.items == []
      return "There are currently no items in your basket"
    else
      bookings = []
      repo = ListingRepository.new

      basket.items.each do |item|
        bookinginfo = BookingInfo.new
        bookinginfo.date_booked = item.date_booked
        bookinginfo.title = repo.find(item.listing_id).title
        bookinginfo.price = repo.find(item.listing_id).price
        bookings << bookinginfo
      end

      total_price = 0
      bookings.each do |bookings|
        total_price += bookings.price.to_f
        cost += bookings.price.to_f
      end
      @total_price = total_price
      @current_basket = bookings
      #cycle through the basket to get the booking ids, then use that booking_id to get the listing id info
      return erb(:basket)
    end
  end

  get "/payment" do
    @total_cost = cost
    return erb(:payment)
  end

  # This route charges the user's credit card
  post "/charge" do
    # Get the payment amount and token from the form parameters
    #amount should be retrieved from a shopping cart which summarises total cost from cost per night.
    #amount = cost
    card_number = params[:number],
                  card_exp_month = params[:exp_month],
                  card_exp_year = params[:exp_year],
    card_cvc = params[:cvc]
    #input validation, cannot be nil
    if card_number == "" || card_exp_month == "" || card_exp_year == "" || card_cvc == ""
      return "Please do not leave fields empty!"
    end

    #create token
    begin
      get_token = Stripe::Token.create(
        card: {
          number: params[:number],
          exp_month: params[:exp_month],
          exp_year: params[:exp_year],
          cvc: params[:cvc],
        },
      )
    rescue Stripe::CardError => e
      return 'There was an error with your card details, please try again or contact SamHunt@tfl.com <form action="/listings" method="GET">
   <button type="submit">Back to listings</button>
   <button onclick="history.back()">Go Back</button>
   </form>'
    end

    begin
      #creates the stripe token
      token = get_token.id
    rescue NoMethodError => e
      return 'There was an error with your card details, please try again or contact SamHunt@tfl.com <form action="/listings" method="GET">
    <button type="submit">Back to listings</button>
    <button onclick="history.back()">Go Back</button>
    </form>'
    end

    # Create a charge using the Stripe API
    charge = Stripe::Charge.create({
      amount: (cost * 100).to_i,
      currency: "gbp",
      source: token,
      description: "Payment for goods or services",
    })
    # Check if the charge was successful
    if charge.paid
      booking_repo = BookingRepository.new
      basket.items.each do |item|
        booking_repo.create(item)
      end
      basket.clear
      # The payment was successful
      #go home button
      return 'Your payment has sucessfully been processed and is awaiting approval from the owner! Please wait for your confirmation email. If the booking is not approved, you will receive a refund.
    <form action="/listings" method="GET">
    <button type="submit">Back to listings</button>
    </form>'
    else
      # The payment failed
      "Sorry, there was an error with your payment. Please try again later or contact SamHunt@tfl.com"
      #go home button
      '<form action="/listings" method="GET">
   <h1>Your payment was not successful!</h1>
    <button type="submit">Back to listings</button>
    <button onclick="history.back()">Try again</button>
    </form>'
    end
  end

  get "/listings" do
    listing_repo = ListingRepository.new
    @listings = listing_repo.all
    if session[:user_id] == nil
      return erb(:login)
    else
      return erb(:listings)
    end
  end

  get "/jess" do
    return erb(:jess)
  end

  get "/login" do
    if session[:user_id] != nil
      redirect "/listings"
    else
      return erb(:login)
    end
  end

  get "/tanyalogin" do
    return erb(:tanyalogin)
  end

  get "/tanyanavbar" do
    return erb(:tanyanavbar)
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
    @user_name = @user_repo.user_name_by_user_id(id)
    @all_unapproved = @booking_repo.find_unconfirmed_bookings(id)
    @all_listings = @listing_repo.find_listings(id)
    @all_bookings = @booking_repo.find_bookings(id)
    @all_booking_information = @listing_repo.find_booking_listing(id)
    return erb(:account)
  end

  get "/navbar" do
    return erb(:navbar)
  end

  get "/listings/newlisting" do
    return erb(:newlisting)
  end

  get "/practice" do
    return erb(:practice)
  end

  get "/practice2" do
    return erb(:practice2)
  end

  post "/listings" do
    if params[:title] == nil || params[:description] == nil || params[:start_date] == nil || params[:end_date] == nil || params[:price] == nil
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
    new_listing.start_date = Date.parse(start_date)
    new_listing.end_date = Date.parse(end_date)
    new_listing.price = price
    repo = ListingRepository.new
    repo.create(new_listing)
    return "Listing created!"
  end

  get "/logout" do
    if session[:user_id] != nil
      session[:user_id] = nil
      basket.clear
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
    booking.date_booked = Date.parse(params[:chosen_date])
    basket.add(booking)
    return erb(:booking_success)
  end

  get "/signup" do
    return erb(:signup)
  end

  get "/contact" do
    return erb(:contact)
  end

  get "/style.css" do
    return erb(:style.css)
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
    redirect to("/account")
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
    redirect to("/messages")
  end

  post "/accept" do
    booking_repo = BookingRepository.new
    booking_repo.accept(params[:booking_id])
    redirect to("/account")
  end

  post "/deny" do
    booking_repo = BookingRepository.new
    booking_repo.deny(params[:booking_id])
    redirect to("/account")
  end

  get "/" do
    return erb(:index)
  end

  not_found do
    status 404
    return "WRONG PAGE YOU IDIOT"
  end
end
