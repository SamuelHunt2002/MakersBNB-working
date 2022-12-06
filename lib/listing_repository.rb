require_relative 'listing'

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
    listing = Listing.new()
    listing.listing_id = result[0]["listing_id"].to_i
    listing.title = result[0]["title"]
    listing.description = result[0]["description"]
    listing.price = result[0]["price"].to_i
    listing.start_date = result[0]["start_date"]
    listing.end_date = result[0]["end_date"]
    listing.user_id = result[0]["user_id"]
    return listing
  end

  def create(listing)
    sql = "INSERT INTO listings (user_id, title, description, start_date, end_date, price) VALUES ($1, $2, $3, $4, $5, $6);"
    result_set = DatabaseConnection.exec_params(sql, [listing.user_id, listing.title, listing.description, listing.start_date, listing.end_date, listing.price])

    return nil
  end

  def all_by_date(date)
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
end
