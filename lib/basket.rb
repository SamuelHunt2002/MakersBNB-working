#basket
  class Basket
    def initialize
      @items = []
    end
  
    # adds a listing to the shopping basket (this will basically be a booking and will need to be implemented on booking?)
    def add(listing)
      items << listing
    end
  
    # Method to view the items on the shopping list
    def view_items
        all_items = []
      @items.each do |item|
        all_items <<item
      end
      return all_items
    end
    #get total cost
    def total
        cost = 0
        @items.each do |item|
            cost += item.price
        end
        return cost
    end
    #clear the basket
    def clear
        @items.clear()
    end
attr_accessor :items
  end
  
