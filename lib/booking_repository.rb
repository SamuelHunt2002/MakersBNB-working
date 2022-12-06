require_relative './booking'

class BookingRepository

    def all
        sql_query = 'SELECT booking_id, user_id, listing_id, date_booked FROM bookings'
        all_bookings = DatabaseConnection.exec_params(sql_query, [])
        bookings =[] 
        all_bookings.each do |eachbooking|
            booking = Booking.new
            booking.booking_id = eachbooking['booking_id'].to_i
            booking.user_id = eachbooking['user_id'].to_i
            booking.listing_id = eachbooking['listing_id'].to_i
            booking.date_booked = eachbooking['date_booked']
            bookings << booking
        end
        return bookings
    end

    def find(id)
        sql_query = 'SELECT booking_id, user_id, listing_id, date_booked FROM bookings WHERE booking_id = $1'
        param = [id]
        return_results = DatabaseConnection.exec_params(sql_query, param)
        booking = return_results[0]
        booking_object = Booking.new
        booking_object.booking_id = booking['booking_id'].to_i
        booking_object.user_id = booking['user_id'].to_i
        booking_object.listing_id = booking['listing_id'].to_i
        booking_object.date_booked = booking['date_booked']
        return booking_object
end
    def update(id, newdate)
        sql_query = 'UPDATE bookings SET date_booked = $1 WHERE booking_id = $2'
        param = [newdate, id]
        DatabaseConnection.exec_params(sql_query, param)
        return "booking changed to #{newdate}"
    end
    def create(booking)
        sql_query = 'INSERT INTO bookings (user_id, listing_id, date_booked) VALUES ($1,$2,$3)'
        param = [booking.user_id, booking.listing_id, booking.date_booked]
        DatabaseConnection.exec_params(sql_query, param)
    end
end