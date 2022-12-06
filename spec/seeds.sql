DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS listings;
DROP TABLE IF EXISTS users;


CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    user_name text
);
TRUNCATE TABLE users RESTART IDENTITY;
INSERT INTO users(user_name) VALUES('user1');
INSERT INTO users(user_name) VALUES('user2');
INSERT INTO users(user_name) VALUES('user3');
INSERT INTO users(user_name) VALUES('user4');
INSERT INTO users(user_name) VALUES('user5');
CREATE TABLE listings(
    listing_id SERIAL PRIMARY KEY,
    user_id int,
    title text,
    description text,
    start_date date,
    end_date date,
    price float,
    CONSTRAINT fk_user_id foreign key(user_id) references users(user_id)
);
TRUNCATE TABLE listings RESTART IDENTITY;
INSERT INTO listings(user_id, title, description, start_date, end_date, price) VALUES (1,'Cotswolds Cottage','cute', '2022-12-01', '2022-12-08', 95.00);
INSERT INTO listings(user_id, title, description, start_date, end_date, price) VALUES (2,'Skegness Luxury Caravans','Close to Butlins (but not actually in Butlins)', '2022-12-01', '2022-12-08', 15.00);
INSERT INTO listings(user_id, title, description, start_date, end_date, price) VALUES (3,'Cornwall Creche','in Cornwall', '2022-12-01', '2022-12-08', 195.00);
INSERT INTO listings(user_id, title, description, start_date, end_date, price) VALUES (4,'Montpellier Bristol','loads of grafitti (tasteful)', '2022-12-07', '2022-12-08', 65.00);
INSERT INTO listings(user_id, title, description, start_date, end_date, price) VALUES (5,'Scotland','Scotland, sleep where you want', '2022-12-06', '2022-12-07', 70.00);
CREATE TABLE bookings (
    booking_id SERIAL,
    user_id int,
    listing_id int,
    date_booked date,
    constraint fk_user foreign key(user_id) references users(user_id),
    constraint fk_listing foreign key(listing_id) references listings(listing_id)
);
TRUNCATE TABLE bookings RESTART IDENTITY;
INSERT INTO bookings (user_id, listing_id, date_booked) VALUES (1,1,'2022-12-05');
INSERT INTO bookings (user_id, listing_id, date_booked) VALUES (2,2,'2022-12-06');
INSERT INTO bookings (user_id, listing_id, date_booked) VALUES (3,3,'2022-12-07');
INSERT INTO bookings (user_id, listing_id, date_booked) VALUES (4,4,'2022-12-08');
INSERT INTO bookings (user_id, listing_id, date_booked) VALUES (5,5,'2022-12-09');