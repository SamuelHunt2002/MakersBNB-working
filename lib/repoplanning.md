# {{TABLE NAME}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table


Table: users
Columns:
user_id (PK)| user_name |email_address

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
    user_name text,
    email_address text
)
TRUNCATE TABLE user RESTART IDENTITY; 

INSERT INTO users (user_name, email_address) VALUES ('user1', 'email@email.com');
INSERT INTO users (user_name, email_address) VALUES ('user2', 'email@email.com');
INSERT INTO users (user_name, email_address) VALUES ('user3', 'email@email.com');
INSERT INTO users (user_name, email_address) VALUES ('user4', 'email@email.com');
INSERT INTO users (user_name, email_address) VALUES ('user5', 'email@email.com');

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

class Student

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

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: users

# Repository class
# (in lib/user_repository.rb)

class StudentRepository

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


#    def create(student)
#    end

#   def update(student)
#   end

#   def delete(student)
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
# create a new user
user = User.new
user.user_name = 'a'
user.email_address = 'b'
repo = UserRepository.new
repo.create(user)
=> returns 'created'
=> repo.all to include a and b
```

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

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---

**How was this resource?**  
[😫](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😫) [😕](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😕) [😐](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😐) [🙂](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=🙂) [😀](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😀)  
Click an emoji to tell us.

<!-- END GENERATED SECTION DO NOT EDIT -->