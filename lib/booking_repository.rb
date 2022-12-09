require_relative "./booking"

class BookingRepository
  def all
    sql_query = "SELECT booking_id, user_id, listing_id, date_booked FROM bookings"
    all_bookings = DatabaseConnection.exec_params(sql_query, [])
    bookings = []
    all_bookings.each do |eachbooking|
      booking = Booking.new
      booking.booking_id = eachbooking["booking_id"].to_i
      booking.user_id = eachbooking["user_id"].to_i
      booking.listing_id = eachbooking["listing_id"].to_i
      booking.date_booked = eachbooking["date_booked"]
      bookings << booking
    end
    return bookings
  end

  def find(id)
    sql_query = "SELECT booking_id, user_id, listing_id, date_booked FROM bookings WHERE booking_id = $1"
    param = [id]
    return_results = DatabaseConnection.exec_params(sql_query, param)
    booking = return_results[0]
    booking_object = Booking.new
    booking_object.booking_id = booking["booking_id"].to_i
    booking_object.user_id = booking["user_id"].to_i
    booking_object.listing_id = booking["listing_id"].to_i
    booking_object.date_booked = booking["date_booked"]
    return booking_object
  end

  def update(id, newdate)
    sql_query = "UPDATE bookings SET date_booked = $1 WHERE booking_id = $2"
    param = [newdate, id]
    DatabaseConnection.exec_params(sql_query, param)
    return "booking changed to #{newdate}"
  end


  def accept(id) 
    sql = "UPDATE bookings SET booking_status = true WHERE booking_id = $1"
    param = [id]
    DatabaseConnection.exec_params(sql, param)
    return nil 
  end 

  def deny(id) 
    sql = "DELETE FROM bookings WHERE booking_id = $1"
    param = [id]
    DatabaseConnection.exec_params(sql, param)
    return nil 
  end 

  def create(booking)
    sql_query = "INSERT INTO bookings (user_id, listing_id, date_booked) VALUES ($1,$2,$3)"
    param = [booking.user_id, booking.listing_id, booking.date_booked]
    DatabaseConnection.exec_params(sql_query, param)
  end

  def find_all_dates(id)
    sql_query = "SELECT date_booked FROM bookings WHERE listing_id = $1 AND booking_status = true"
    param = id
    date_list = []
    return_results = DatabaseConnection.exec_params(sql_query, [param])
    return_results.each do |result| 
      date_list << result["date_booked"].to_s
    end 
    return date_list
  end 

  def find_unconfirmed_bookings(id)
    all_bookings = []
    sql_query = 'SELECT b.* 
    FROM bookings b 
    INNER JOIN listings l ON b.listing_id = l.listing_id 
    WHERE b.booking_status = false AND l.user_id = $1'
    
    param = [id]
    return_results = DatabaseConnection.exec_params(sql_query, param)
    return_results.each do |bookingresult|
      booking = Booking.new
      booking.user_id = bookingresult['user_id']
      booking.booking_id = bookingresult['booking_id']
      booking.listing_id = bookingresult['listing_id']
      booking.date_booked = bookingresult['date_booked']
      booking.owner_id  = bookingresult['owner_id']
      all_bookings << booking
    end
    return all_bookings 
  end 


  def find_bookings(id)
  all_bookings = []
  sql_query = 'SELECT user_id, booking_id, listing_id, date_booked FROM bookings WHERE user_id = $1 AND booking_status = true'
  param = [id]
  return_results = DatabaseConnection.exec_params(sql_query, param)
  return_results.each do |bookingresult|
    booking = Booking.new
    booking.user_id = bookingresult['user_id']
    booking.booking_id = bookingresult['booking_id']
    booking.listing_id = bookingresult['listing_id']
    booking.date_booked = bookingresult['date_booked']
    all_bookings << booking
  end
  return all_bookings
  end


  
end
