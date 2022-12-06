# {{PROBLEM}} Class Design Recipe

## 1. Describe the Problem

Users can list multiple spaces.
Any signed-up user can list a new space.
Users should be able to name their space, provide a short description of the space, and a price per night.

## 2. Design the Class Interface

_Include the initializer and public methods with all parameters and return values._

```ruby
# EXAMPLE

class Listing
  def initialize(title, description) # name is a string
    #
  end

  def set_dates(start_date, end_date)

  end

  def get_listing
  return formatted_listing
  end

end
```

## 3. Create Examples as Tests

_Make a list of examples of how the class will behave in different situations._

```ruby
# EXAMPLE

# 1 creates new listing and retrieves the listing
listing1 = Listing.new("123 Fake Street, Springfield", "a lovely haunted castle")
listing1.get_listing => "The listing is: 123 Fake Street, Springfield, which is: a lovely haunted castle" 

# 2


```

_Encode each example as a test. You can add to the above list as you go._

## 4. Implement the Behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

# 1
RSpec.describe Listing do:
it "creates a new listing and returns it as a string" do
listing1 = Listing.new("123 Fake Street, Springfield", "a lovely haunted castle")
expect(listing1.get_listing).to eq "The listing is: 123 Fake Street, Springfield, which is: a lovely haunted castle" 

# 2



<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---

**How was this resource?**  
[😫](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fgolden-square&prefill_File=resources%2Fsingle_class_recipe_template.md&prefill_Sentiment=😫) [😕](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fgolden-square&prefill_File=resources%2Fsingle_class_recipe_template.md&prefill_Sentiment=😕) [😐](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fgolden-square&prefill_File=resources%2Fsingle_class_recipe_template.md&prefill_Sentiment=😐) [🙂](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fgolden-square&prefill_File=resources%2Fsingle_class_recipe_template.md&prefill_Sentiment=🙂) [😀](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fgolden-square&prefill_File=resources%2Fsingle_class_recipe_template.md&prefill_Sentiment=😀)  
Click an emoji to tell us.

<!-- END GENERATED SECTION DO NOT EDIT -->