require 'date'
require_relative 'booking_repository'
class Listing
  attr_accessor :listing_id, :user_id, :title, :description, :start_date, :end_date, :price, :tempflag, :booking_id

end
