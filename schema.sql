CREATE DATABASE cosmetic_app;

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    brand VARCHAR(200),
    name VARCHAR(200) not null,
    image_link VARCHAR(500),
    price INTEGER
);


CREATE TABLE dishes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) not null,  -- name validation : shouldn't be empty
    image_url VARCHAR(500)
);


INSERT INTO dishes (name, image_url) VALUES ('cake', 'https://i.redd.it/flmfgum1fns21.jpg');

INSERT INTO dishes (name, image_url) VALUES ('burger cake', 'https://cdn.crownmediadev.com/dims4/default/5579f24/2147483647/thumbnail/726x410%3E/quality/80/?url=https%3A%2F%2Fcdn.crownmediadev.com%2F97%2F08%2F8692b000425b973c754ca4552cc3%2Fhome-family-cheeseburger-cake.jpg');


-- AUTHENTICATION 

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(300),
    password_digest VARCHAR(400)
    -- user_id INTEGER,
    -- FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE -- when deleted, all children to be deleted
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(300),
    password_digest VARCHAR(400),
    gender VARCHAR(100),
    age INTEGER,
    skin_type VARCHAR(200),
    skin_trouble VARCHAR(300)
);


INSERT INTO users (email, password_digest) VALUES ('proust01@yahoo.com.au', '$2a$12$/Y9sKs6K/rUq57CmbnvkK.A4XqSjXgIHU1ucytiM1gvN.0O5Xfu2y');

-- add another user_id column/secton inside table
ALTER TABLE dishes ADD COLUMN user_id INTEGER;

ALTER TABLE products ADD COLUMN user_id INTEGER;


-- constraint with unique constraint
ALTER TABLE users ADD CONSTRAINT unique_email UNIQUE (email);

-- ALTER TABLE CONSTRAINT constraint_name FOREIGN KEY (c1) REFERENCES parents table (p1)
ALTER TABLE dishes ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;

-- ALTER TABLE dishes ALTER COLUMN user_id set not null;

-- change data type in column
ALTER TABLE products ALTER COLUMN price TYPE decimal(10, 2);

-- delete column
ALTER TABLE products DROP user_id;
