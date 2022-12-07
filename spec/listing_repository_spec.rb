require 'listing'
require 'listing_repository'


def reset_listing_table
  seed_sql = File.read('spec/seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end

describe ListingRepository do
  before(:each) do 
    reset_listing_table
  end

  it "Returns all the listings" do
    listing_repo = ListingRepository.new
    expect(listing_repo.all.count).to eq 5
    expect(listing_repo.all[0].listing_id).to eq 1
    expect(listing_repo.all[0].title).to eq "Cotswolds Cottage"
    expect(listing_repo.all[2].title).to eq "Cornwall Creche"
  end

  it "Finds a specified listing" do
    listing_repo = ListingRepository.new
    selected_listing = listing_repo.find(1)
    expect(selected_listing.listing_id).to eq 1 
    expect(selected_listing.price).to eq 95
  end


  it "Creates a new listing" do
    listing_repo = ListingRepository.new()
    new_listing = Listing.new()
    new_listing.title = "Miami Treehouse"
    new_listing.description = "A sunny duplex"
    new_listing.start_date = "2022-08-30"
    new_listing.end_date = "2022-10-15"
    new_listing.price = 20
    listing_repo.create(new_listing)
    expect(listing_repo.all.count).to eq 6
    expect(listing_repo.find(6).title).to eq "Miami Treehouse"
  end

  it "Returns all of the listings that are available" do
    listing_repo = ListingRepository.new
    date = "2022-12-05"
    all_avail = listing_repo.all_by_date(date)
    expect(all_avail.count).to eq 2
  end

  it "All avail dates returns a list of all available dates" do
    listing_repo = ListingRepository.new
    all_dates = listing_repo.all_avail_dates(1)
    expect(all_dates.count).to eq 7
  end
end 