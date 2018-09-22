#1a
USE sakila;
SELECT first_name, last_name
FROM actor;

#1b
SELECT UPPER(CONCAT(first_name, ' ', last_name)) as 'Actor Name'
FROM actor;

#2a
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'JOE';

#2b
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name like '%GEN%';

#2c
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER by last_name, first_name;

#2d
SELECT country_id, country
FROM country
WHERE country IN ('Afhganistan', 'Bangladesh', 'China');

#3a
ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(45) AFTER first_name;

#3b
ALTER TABLE actor
MODIFY COLUMN middle_name BLOB; 

#3c
ALTER TABLE actor
DROP COLUMN middle_name; 

#4a
SELECT last_name, COUNT(last_name) AS COUNT
FROM actor
GROUP BY last_name; 

#4b
SELECT last_name, COUNT(last_name) AS COUNT
FROM actor
GROUP BY last_name
HAVING count >2; 

#4c
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' and last_name = 'WILLIAMS';

#4d
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' and last_name = 'WILLIAMS'; 

#5a
CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

#6a
SELECT staff.first_name, staff.last_name, address.address, city.city, country.country 
FROM staff 
LEFT JOIN address ON staff.address_id = address.address_id
LEFT JOIN city on address.city_id = city.city_id
LEFT JOIN country on address.country_id = country.country_id;

#6b
SELECT staff.first_name,staff.last_name,SUM(payment.amount) as 'total_amount'
FROM staff 
LEFT JOIN payment  ON staff.staff_id=payment.staff_id
GROUP BY staff.first_name,staff.last_name;

#6c
SELECT film.title,COUNT(film_actor.actor_id) AS 'actor_count'
FROM film 
INNER JOIN film_actor ON film.film_id=film_actor.film_id
GROUP BY film.title;

#6d
SELECT COUNT(inventory.film_id) AS 'available_copies'
FROM film 
INNER JOIN inventory ON film.film_id=inventory.film_id
WHERE film.title='Hunchback Impossible';

#6e
SELECT customer.first_name,customer.last_name,SUM(payment.amount) AS 'total_paid'
FROM customer 
LEFT JOIN payment ON customer.customer_id=payment.customer_id
GROUP BY customer.first_name,customer.last_name
ORDER BY customer.last_name;

#7a
SELECT title,language_id
FROM film
WHERE (title LIKE 'Q%' OR title LIKE 'K%') AND language_id IN (SELECT language_id
															 FROM language 
															 WHERE name = 'English');
#7b
SELECT * 
FROM actor
WHERE actor_id IN (
					SELECT actor_id
					FROM film_actor
					WHERE film_id IN ( 
										SELECT film_id
                                        FROM film
                                        WHERE title = 'Alone Trip'
									)
		);
        
#7c
SELECT customer.first_name,customer.last_name,customer.email
FROM customer 
INNER JOIN address ON customer.address_id=address.address_id
INNER JOIN city ON city.city_id=address.city_id
INNER JOIN country ON country.country_id=city.country_id
WHERE country.country='Canada';

#7d
SELECT film.title,category.name
FROM film 
INNER JOIN film_category ON film.film_id=film_category.film_id
INNER JOIN category ON film_category.category_id=category.category_id
WHERE category.name = 'Family';

#7e
SELECT film.title,COUNT(rental.rental_id) AS 'rental_count'
FROM film 
LEFT JOIN inventory ON film.film_id=inventory.inventory_id
LEFT JOIN rental ON inventory.inventory_id=rental.inventory_id
GROUP BY film.title
ORDER BY COUNT(R.rental_id) DESC;

#7f
SELECT store.store_id,SUM(payment.amount) as 'revenue'
FROM staff
INNER JOIN staff ON staff.store_id=store.store_id
INNER JOIN address ON address.address_id=staff.address_id
INNER JOIN payment ON payment.staff_id=store.staff_id
GROUP BY store.store_id;

#7g
SELECT store.store_id,city.city,country.country
FROM store 
INNER JOIN address ON store.address_id=address.address_id
INNER JOIN city ON city.city_id=address.city_id
INNER JOIN country ON city.country_id=country.country_id;

#7h
SELECT  city.name, SUM(payment.amount) AS 'gross_revenue'
FROM film_category 
INNER JOIN category ON film_category.category_id=city.category_id
INNER JOIN inventory ON inventory.film_id=film_category.film_id
INNER JOIN rental ON rental.inventory_id=inventory.inventory_id
INNER JOIN payment ON payment.rental_id=rental.rental_id
GROUP BY city.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

#8a
CREATE VIEW view_top_five_genre AS
SELECT  city.name, SUM(payment.amount) AS 'gross_revenue'
FROM film_category 
INNER JOIN category ON film_category.category_id=category.category_id
INNER JOIN inventory ON inventory.film_id=film_category.film_id
INNER JOIN rental ON rental.inventory_id=inventory.inventory_id
INNER JOIN payment ON payment.rental_id=rental.rental_id
GROUP BY city.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

#8b
SELECT * FROM view_top_five_genre;

#8c
DROP VIEW view_top_five_genre;


