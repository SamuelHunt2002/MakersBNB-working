require 'basket'

describe Basket do
    it "creates an empty basket" do
        basket = Basket.new
        expect(basket.items).to eq []
    end

    it "adds a listing to the basket successfully" do
        listing = Listing.new
        listing.title = 'NewPlace'
        listing.price = 100
        basket = Basket.new
        basket.add(listing)
        expect(basket.items[0].price).to eq 100
        expect(basket.items[0].title).to eq 'NewPlace'
    end
    it "views items in a basket" do
    listing = Listing.new
    listing.title = 'NewPlace'
    listing.price = 100
    listing2 = Listing.new
    listing2.title = 'OldPlace'
    listing2.price = 10
    basket = Basket.new
    basket.add(listing)
    basket.add(listing2)
    basket_items = basket.view_items
    expect(basket.items[0].title).to eq 'NewPlace'
    expect(basket.items[1].title).to eq 'OldPlace'

end
 it "clears the basket" do
    basket = Basket.new
    basket.add("a")
    basket.clear
    expect(basket.items).to eq []
 end
 it "returns the total cost" do
    listing = Listing.new
    listing.title = 'NewPlace'
    listing.price = 100
    listing2 = Listing.new
    listing2.title = 'OldPlace'
    listing2.price = 10
    basket = Basket.new
    basket.add(listing)
    basket.add(listing2)
    basket_items = basket.view_items
    total_cost = basket.total
    expect(total_cost).to eq 110
 end

end
