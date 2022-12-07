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
end
