# {{TABLE NAME}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table


Table: users
Columns:
user_id (PK)| user_name

-----------------------

Table: bookings
columns:
booking_id (PK) |user_id (FK) | listing_id (FK) | date_booked

=======================
Table: listings
columns:
listing_id (PK) | user_id (FK) | title | description | start_date | end_date

-- (file: spec/seeds_user.sql)

-- Write your SQL seed here. 

CREATE TABLE users (
    user_id SERIAL,
    user_name text
)
TRUNCATE TABLE user RESTART IDENTITY; 

INSERT INTO users (user_name) VALUES ('user1');
INSERT INTO users (user_name) VALUES ('user2');
INSERT INTO users (user_name) VALUES ('user3');
INSERT INTO users (user_name) VALUES ('user4');
INSERT INTO users (user_name) VALUES ('user5');

----- 

file: spec/seeds_bookings.sql
CREATE TABLE bookings (
    booking_id SERIAL, 
    user_id int,
    listing_id int,
    date_booked date,
    constraint fk_user foreign key(user_id) references users(user_id),
    constraint fk_listing foreign key(listing_id) references listings(listing_id)
);

INSERT INTO bookings (user_id, listing_id, date_booked) VALUES (1,1,'2022-12-05')
INSERT INTO bookings (user_id, listing_id, date_booked) VALUES (2,2,'2022-12-06')
INSERT INTO bookings (user_id, listing_id, date_booked) VALUES (3,3,'2022-12-07')
INSERT INTO bookings (user_id, listing_id, date_booked) VALUES (4,4,'2022-12-08')
INSERT INTO bookings (user_id, listing_id, date_booked) VALUES (5,5,'2022-12-09')

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.


========================

file: spec/seeds_listings.sql
CREATE TABLE listings(
    listing_id SERIAL, 
    user_id int,
    title text,
    description text,
    start_date date,
    end_date date,
    price float,
    constraint fk_user foreign key(user_id) references users(user_id)
);

INSERT INTO listings (user_id, title, description, start_date, end_date, price) VALUES (1,"Cotswolds Cottage","It's cute", '2022-12-05', '2022-12-06', 95.00);
INSERT INTO listings (user_id, title, description, start_date, end_date, price) VALUES (2,"Skegness Luxury Caravans","It's close to Butlins (but not actually in Butlins)", '2022-12-01', '2022-12-02', 15.00);
INSERT INTO listings (user_id, title, description, start_date, end_date, price) VALUES (3,"Cornwall Creche","It's in Cornwall", '2022-12-08', '2022-12-09', 195.00);
INSERT INTO listings (user_id, title, description, start_date, end_date, price) VALUES (4,"Montpellier Bristol","They say they're hip but there's just loads of grafitti (it's tasteful)", '2022-12-07', '2022-12-08', 65.00);
INSERT INTO listings (user_id, title, description, start_date, end_date, price) VALUES (5,"Scotland","It's Scotland, sleep where you want", '2022-12-06', '2022-12-07', 70.00);



=======
bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names


Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: user

# Model class
# (in lib/user.rb)
class User
end

# Repository class
# (in lib/user_repository.rb)
class UserRepository
end
```
=====================================

ruby

# Table name: bookings

# Model class
# (in lib/bookings.rb)
class Booking
end

# Repository class
# (in lib/booking_repository.rb)
class BookingRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: users

# Model class
# (in lib/user.rb)

class User

  # Replace the attributes by your own columns.
  attr_accessor :user_id, :user_name
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# student = Student.new
# student.name = 'Jo'
# student.name
```
```ruby
# EXAMPLE
# Table name: bookings

# Model class
# (in lib/booking.rb)

class Booking

  attr_accessor :booking_id, :user_id, :listing_id, date_booked
end




*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# Table name: users

# Repository class
# (in lib/user_repository.rb)

class UsersRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, name, cohort_name FROM students;

    # Returns an array of Student objects.
  end

#   # Gets a single record by its ID
#   # One argument: the id (number)
#   def find(id)
#     # Executes the SQL query:
#     # SELECT id, name, cohort_name FROM students WHERE id = $1;

#     # Returns a single Student object.
#   end


=====================================
# Table name: bookings

# Repository class
# (in lib/booking_repository.rb)

class BookingRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT booking_id, user_id, listing_id, date_booked FROM bookings;

    # Returns an array of Booking objects.
  end

#   # Gets a single record by its ID
#   # One argument: the id (number)
#   def find(id)
#     # Executes the SQL query:
    # SELECT booking_id, user_id, listing_id, date_booked FROM bookings WHERE booking_id = $1;

#     # Returns a single Booking object.
#   end


#    def create(booking)
#    execute the sql query => INSERT INTO bookings (booking_id, user_id, listing_id, date_booked) VALUES ($1,$2,$3,$4)
    params = [booking.booking_id, booking.user_id, booking.listing_id, booking.date_booked]
    return nothing.
#    end

#   updates the date_booked
#   def update(id,newdate)
#   execute the sql query => UPDATE bookings SET date_booked = $1 WHERE booking_id = $2
#   params = [newdate, id]
    
#   return "booking changed to #{newdate}"
#   end

====== instead of delete - perhaps another column on the bookings table for 'status' => completed, upcoming, in-progress, cancelled? 
#   def delete()
#   end
# end
# ```




## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all users

repo =  UserRepository.new

users = repo.all

users.length # =>  5

users[0].id # =>  1
users[0].name # =>  'User1'


users[1].id # =>  2
users[1].name # =>  'User2'


# 2
# Get a single student

repo = StudentRepository.new

student = repo.find(1)

student. # =>  1
student.name # =>  'David'
student.cohort_name # =>  'April 2022'

# Add more examples for each method
```

============================================
BookingsRepo methods:
# 1
# Get all bookings
repo =  BookingRepository.new
bookings = repo.all
bookings.lenght =>  5
bookings[0].user_id =>  1
bookings[0].listing_id =>  1
bookings[0].date_booked => '2022-12-05'
bookings[1].user_id =>  2
bookings[1].listing_id => 2
bookings[1].date_booked => '2022-12-06'


# 2
# Get a single booking
repo = BookingRepository.new
bookings = repo.find(1)
bookings[0].user_id =>  1
bookings[0].listing_id =>  1
bookings[0].date_booked => '2022-12-05'

# 3
# updates the booking.date_booked for id 1
repo = BookingRepository.new
expect(repo.update(1,'2023-01-01')).to eq 'booking changed to "2023-01-01"'
bookings[0].date_booked => '2023-01-01'


# 4
# creates an entry
repo = BookingRepository.new
booking = Booking.new
booking.user_id = 1
booking.listing_id = 5
booking.date_booked = '2022-12-07'
repo.create(booking)
bookings = find(6)
bookings[0].user_id =>  6
bookings[0].listing_id =>  5
bookings[0].date_booked => '2022-12-07'

# 5 
# returns all bookings by user_id
repo = BookingRepository.new
bookings = repo.find(1)
bookings[0].user_id =>  1
bookings[0].listing_id =>  1
bookings[0].date_booked => '2022-12-05'
bookings[5].user_id =>  1
bookings[5].listing_id =>  4
bookings[5].date_booked => '2022-12-10'

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_students_table
  seed_sql = File.read('spec/seeds_students.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'students' })
  connection.exec(seed_sql)
end

describe StudentRepository do
  before(:each) do 
    reset_students_table
  end

BookingsRepo methods:
# 1
# Get all bookings
it "gets all the bookings" do
repo = BookingRepository.new
bookings = repo.all
expect(bookings[0].user_id).to eq 1
expect(bookings[0].listing_id).to eq 1
expect(bookings[0].date_booked).to eq '2022-12-05'
expect(bookings[1].user_id).to eq 2
expect(bookings[1].listing_id).to eq 2
expect(bookings[1].date_booked).to eq '2022-12-06'
end


# 2
# Get a single booking
it "gets a single booking" do
repo = BookingRepository.new
bookings = repo.find(1)
expect(bookings[0].user_id).to eq 1
expect(bookings[0].listing_id).to eq 1
expect(bookings[0].date_booked).to eq '2022-12-05'
end 

# 3
# updates the booking.date_booked for id 1
it "updates a date" do
repo = BookingRepository.new
expect(repo.update(1,'2023-01-01')).to eq 'booking changed to "2023-01-01"'
bookings[0].date_booked => '2023-01-01'
end


# 4
# creates an entry
it "creates a new entry" do
repo = BookingRepository.new
booking = Booking.new
booking.user_id = 1
booking.listing_id = 5
booking.date_booked = '2022-12-07'
repo.create(booking)
bookings = find(6)
expect(bookings[0].user_id).to eq  6
expect(bookings[0].listing_id).to eq 5
expect(bookings[0].date_booked.to eq '2022-12-07'
```
end
```
#5
returns ALL bookings by user id
it "returns all 2 bookings from user_id = 1" do
repo = BookingRepository.new
bookings = repo.find_bookings(1)
all_bookings = repo.all
expect(all_bookings[0].user_id).to eq 1
expect(all_bookings[0].listing_id).to eq 1
expect(all_bookings[0].date_booked).to eq '2022-12-05'
expect(all_bookings[5].user_id).to eq 1
expect(all_bookings[5].listing_id).to eq 4
expect(all_bookings[5].date_booked).to eq '2022-12-10'

Encode this example as a test.
## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---

**How was this resource?**  
[😫](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😫) [😕](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😕) [😐](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😐) [🙂](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=🙂) [😀](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😀)  
Click an emoji to tell us.

<!-- END GENERATED SECTION DO NOT EDIT -->