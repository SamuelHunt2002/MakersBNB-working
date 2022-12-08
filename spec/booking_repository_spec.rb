require "booking_repository"

def reset_bookings_table
  seed_sql = File.read("spec/seeds.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "makersbnb_test" })
  connection.exec(seed_sql)
end

describe BookingRepository do
  before(:each) do
    reset_bookings_table
  end
  it "gets all the bookings" do
    repo = BookingRepository.new
    bookings = repo.all
    expect(bookings[0].user_id).to eq 1
    expect(bookings[0].listing_id).to eq 1
    expect(bookings[0].date_booked).to eq "2022-12-05"
    expect(bookings[1].user_id).to eq 2
    expect(bookings[1].listing_id).to eq 2
    expect(bookings[1].date_booked).to eq "2022-12-06"
  end
  it "gets a single booking" do
    repo = BookingRepository.new
    bookings = repo.find(1)
    expect(bookings.user_id).to eq 1
    expect(bookings.listing_id).to eq 1
    expect(bookings.date_booked).to eq "2022-12-05"
  end
  it "updates a date" do
    repo = BookingRepository.new
    expect(repo.update(1, "2023-01-01")).to eq "booking changed to 2023-01-01"
    bookings = repo.find(1)
    expect(bookings.date_booked).to eq "2023-01-01"
  end
  it "creates a new entry" do
    repo = BookingRepository.new
    booking = Booking.new
    booking.user_id = 1
    booking.listing_id = 5
    booking.date_booked = "2022-12-07"
    repo.create(booking)
    bookings = repo.find(6)
    expect(bookings.user_id).to eq 1
    expect(bookings.listing_id).to eq 5
    expect(bookings.date_booked).to eq "2022-12-07"
  end

  it "Returns a list of booking dates" do
    repo = BookingRepository.new()
    all_dates = repo.find_all_dates(1)
    expect(all_dates.length).to eq 1
    booking = Booking.new()
    booking.user_id = 2
    booking.listing_id = 1 
    booking.date_booked = "2022-12-07"
    repo.create(booking)
    new_all_dates = repo.find_all_dates(1)
    expect(repo.all.count).to eq 6
    expect(new_all_dates.length).to eq 2
  end
  it "returns all 2 bookings from user_id = 1" do
    repo = BookingRepository.new
    bookings = repo.find_bookings(1)
    booking5 = Booking.new
    booking5.user_id = 1
    booking5.listing_id = 4
    booking5.date_booked ='2022-12-10'
    repo.create(booking5)
    all_bookings = repo.all
    expect(all_bookings[0].user_id).to eq 1
    expect(all_bookings[0].listing_id).to eq 1
    expect(all_bookings[0].date_booked).to eq '2022-12-05'
    expect(all_bookings[5].user_id).to eq 1
    expect(all_bookings[5].listing_id).to eq 4
    expect(all_bookings[5].date_booked).to eq '2022-12-10'
end
# it "gets all listing information for a booking based on user id = 1 (there will be 2 bookings)" do
#   bookings = BookingRepository.new
#   booking = Booking.new
#   booking.title = "Here"
#   booking.description = "it's here"
#   booking.date_booked = '2022-10-10'
#   all_details = bookings.get_booking_details(2)
#   expect(all_details[0].title).to eq 'Cotswolds Cottage'
#   expect(all_details[0].description).to eq 'cute'
#   expect(all_details[0].date_booked).to eq '2022-12-05'
#   expect(all_details[1].title).to eq "Here"
#   expect(all_details[1].description).to eq "it's here"
#   expect(all_details[1].date_booked).to eq '2022-10-10'
#   reset_table
# end
end