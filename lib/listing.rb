class Listing
  
  
    def set_dates(start_date, end_date)
  
    end
  
    def get_listing
    formatted_listing = "The listing is: #{@title}, which is: #{@description}"
    return formatted_listing
    end
  

    attr_accessor :listing_id, :user_id, :title, :description, :start_date, :end_date, :price 

  end