require_relative "listing"
require_relative "booking_repository"

class ListingRepository
  def all
    listings = []
    sql = "SELECT listing_id, title, description, price, start_date, end_date, user_id FROM listings;"
    result_set = DatabaseConnection.exec_params(sql, [])

    result_set.each do |record|
      listing = Listing.new
      listing.listing_id = record["listing_id"].to_i
      listing.title = record["title"]
      listing.description = record["description"]
      listing.price = record["price"]
      listing.start_date = record["start_date"]
      listing.end_date = record["end_date"]
      listing.user_id = record["user_id"]

      listings << listing
    end

    return listings
  end

  def find(listing_id)
    sql = "SELECT listing_id, title, description, price, start_date, end_date, user_id FROM listings WHERE listing_id = $1;"
    params = [listing_id]
    result = DatabaseConnection.exec_params(sql, params)
    listing = Listing.new
    listingobject = result[0]
    listing.listing_id = listingobject["listing_id"].to_i
    listing.title = listingobject["title"]
    listing.description = listingobject["description"]
    listing.price = listingobject["price"].to_i
    listing.start_date = listingobject["start_date"]
    listing.end_date = listingobject["end_date"]
    listing.user_id = listingobject["user_id"]
    return listing
  end

  def create(listing)
    sql = "INSERT INTO listings (user_id, title, description, start_date, end_date, price) VALUES ($1, $2, $3, $4, $5, $6);"
    result_set = DatabaseConnection.exec_params(sql, [listing.user_id, listing.title, listing.description, listing.start_date, listing.end_date, listing.price])

    return nil
  end

  def all_by_date(date)
    # This returns all the available listings by date
    listings = []
    sql = "SELECT *
    FROM listings
    WHERE listing_id NOT IN (
      SELECT listing_id
      FROM bookings
      WHERE date_booked = TO_DATE($1, 'YYYY-MM-DD')
    ) AND TO_DATE($1, 'YYYY-MM-DD') BETWEEN start_date AND end_date
    ;"

    result_set = DatabaseConnection.exec_params(sql, [date])

    result_set.each do |record|
      listing = Listing.new
      listing.listing_id = record["listing_id"].to_i
      listing.title = record["title"]
      listing.description = record["description"]
      listing.price = record["price"]
      listing.start_date = record["start_date"]
      listing.end_date = record["end_date"]
      listing.user_id = record["user_id"]

      listings << listing
    end

    return listings
  end

  def all_avail_dates(listing_id)
    # This does the opposite to the method above. This returns all the available DATES for the specified listing.
    sql = "SELECT start_date, end_date FROM listings WHERE listing_id = $1;"
    result_set = DatabaseConnection.exec_params(sql, [listing_id])[0]
    start_date = result_set["start_date"]
    end_date = result_set["end_date"]

    booking_repo = BookingRepository.new()

    # Check the format of the dates in the all_dates_booked array
    all_dates_booked = booking_repo.find_all_dates(1)

    all_dates_booked = booking_repo.find_all_dates(listing_id)
    all_dates = (start_date..end_date).to_a

    filtered_dates = all_dates - all_dates_booked

    return filtered_dates
  end

  def find_listings(id)
    sql_query = "SELECT listing_id, user_id, title, description, start_date, end_date, price FROM listings WHERE user_id = $1"
    param = [id]
    result_set = DatabaseConnection.exec_params(sql_query, param)
    all_listings = []
    result_set.each do |eachlisting|
      listing = Listing.new
      listing.listing_id = eachlisting["listing_id"].to_i
      listing.user_id = eachlisting["user_id"].to_i
      listing.title = eachlisting["title"]
      listing.description = eachlisting["description"]
      listing.start_date = eachlisting["start_date"]
      listing.end_date = eachlisting["end_date"]
      listing.price = eachlisting["price"].to_f #prices are floats :)
      all_listings << listing
    end
    return all_listings
  end

  def find_booking_listing(user_id)
    sql_query = "SELECT bookings.booking_id AS booking_id, bookings.date_booked, listings.listing_id, listings.user_id, title, description, start_date, end_date, price 
                FROM listings 
                INNER JOIN bookings on listings.listing_id = bookings.listing_id
                WHERE bookings.user_id = $1 AND bookings.booking_status = true"
    param = [user_id]
    result_set = DatabaseConnection.exec_params(sql_query, param)
    all_listings = []
    result_set.each do |eachlisting|
      listing = Listing.new
      listing.listing_id = eachlisting["listing_id"].to_i
      listing.user_id = eachlisting["user_id"].to_i
      listing.title = eachlisting["title"]
      listing.description = eachlisting["description"]
      listing.start_date = eachlisting["start_date"]
      listing.end_date = eachlisting["end_date"]
      listing.price = eachlisting["price"].to_f #prices are floats :)
      listing.tempflag = eachlisting["date_booked"]
      listing.booking_id = eachlisting["booking_id"]
      all_listings << listing
    end
    return all_listings
  end

  def return_listing_name_via_id(listing_id)
    sql = "SELECT title FROM listings WHERE listing_id = $1"
    param = [listing_id]
    result_set = DatabaseConnection.exec_params(sql, param)[0]
    return result_set["title"]
  end

  #method for getting info from the basket

  def find_listing_by_booking_id(booking_id)
    sql_query = "SELECT bookings.date_booked, title, description, price 
                FROM listings 
                INNER JOIN bookings on listings.listing_id = bookings.listing_id
                WHERE bookings.booking_id = $1"
    param = [booking_id]
    result_set = DatabaseConnection.exec_params(sql_query, param)
    listing = Listing.new
    result_set.each do |eachlisting|
      listing.title = eachlisting["title"]
      listing.description = eachlisting["description"]
      listing.price = eachlisting["price"].to_f #prices are floats :)
      listing.tempflag = eachlisting["date_booked"]
    end
    return listing
  end
end
