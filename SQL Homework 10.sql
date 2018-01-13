---  Set the database to be used to sakila  
USE sakila;

--- 1a. Display the first and last names of all actors from the table actor. 
SELECT first_name, last_name
FROM actor

--- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT concat(UPPER(first_name), ' ', UPPER(last_name)) as 'Actor Name'
FROM actor

--- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name = 'Joe'

--- 2b. Find all actors whose last name contain the letters GEN:
SELECT actor_id, first_name, last_name 
FROM actor
WHERE last_name like '%GEN%'

--- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT actor_id, first_name, last_name 
FROM actor
WHERE last_name like '%LI%'
ORDER BY last_name, first_name

--- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country in ('Afghanistan', 'Bangladesh', 'China')

--- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE `sakila`.`actor` 
ADD COLUMN `middle_name` VARCHAR(50) NULL AFTER `first_name`;

--- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER TABLE `sakila`.`actor` 
CHANGE COLUMN `middle_name` `middle_name` BLOB NULL DEFAULT NULL ;

--- 3c. Now delete the middle_name column.
ALTER TABLE `sakila`.`actor` 
DROP COLUMN `middle_name`;

--- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, count(actor_id)
FROM actor	
GROUP BY last_name
ORDER BY last_name

--- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, count(actor_id)
FROM actor	
GROUP BY last_name
HAVING COUNT(actor_id) > 1
ORDER BY last_name

--- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
SET first_name = 'HARPO' 
WHERE first_name = 'Groucho' 
and last_name = 'Williams' 

--- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE actor
SET first_name = IF(first_name = 'HARPO' , 'GROUCHO','MUCHO GORUCHO')
WHERE actor_id = 172
	   
--- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE  sakila.address

--- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT s.first_name
, s.last_name
, a.address
, a.address2
FROM staff as s
INNER JOIN address as a
ON s.address_id = a.address_id
 
--- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT s.staff_id
, s.first_name
, s.last_name
, SUM(p.amount) as TotAmt
FROM staff as s
INNER JOIN payment as p
ON s.staff_id = p.staff_id
WHERE payment_date BETWEEN '2005-08-01' and '2005-08-31'
GROUP BY s.staff_id, s.first_name, s.last_name
ORDER BY s.last_name

--- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.film_id
, f.title
, COUNT(fa.actor_id) as NumActors
FROM film as f
INNER JOIN film_actor as fa
ON f.film_id = fa.film_id
GROUP BY f.film_id, f.title
ORDER by f.title

--- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.film_id
, f.title
, COUNT(i.inventory_id) as CntInventory
FROM film as f
INNER JOIN inventory as i
ON f.film_id = i.film_id
and f.title = 'Hunchback Impossible'
GROUP BY f.film_id, f.title
ORDER BY f.title

--- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.customer_id
, c.last_name
, c.first_name
, SUM(p.amount) as TotalPayments
FROM customer as c 
INNER JOIN payment as p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY c.last_name

--- 	![Total amount paid](Images/total_payment.png)
--- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT f.film_id
, f.title
FROM film as f
INNER JOIN `language` as l
ON f.language_id = l.language_id
and l.name = 'English'
and (f.title like 'k%' or f.title like 'q%')

--- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT a.first_name
, a.last_name
FROM actor as a
INNER JOIN film_actor as fa
on a.actor_id = fa.actor_id
WHERE fa.film_id IN
	(SELECT f.film_id
		FROM film as f
        WHERE f.title = 'Alone Trip'
	)

--- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT cs.last_name
, cs.first_name
, cs.email
FROM customer as cs
INNER JOIN address as a
ON cs.address_id = a.address_id
INNER JOIN city as ci
ON a.city_id = ci.city_id
INNER JOIN country as co
ON ci.country_id = co.country_id
and co.country = 'Canada'


--- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
SELECT f.film_id
, f.title
, c.name as Category
FROM film as f
INNER JOIN film_category as fc
ON f.film_id = fc.film_id
INNER JOIN category as c
ON fc.category_id = c.category_id
and c.name = 'Family'

--- 7e. Display the most frequently rented movies in descending order.
SELECT f.film_id
, f.title
, COUNT(r.inventory_id) as NumRents
FROM rental as r
INNER JOIN inventory as i
ON r.inventory_id = i.inventory_id
INNER JOIN film as f
ON i.film_id = f.film_id
GROUP BY f.film_id, f.title
ORDER BY COUNT(r.inventory_id) DESC

--- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id
, a.address 
, SUM(p.amount)
FROM store as s
INNER JOIN customer as c
ON s.store_id = c.store_id
INNER JOIN payment as p
ON c.customer_id = p.customer_id
INNER JOIN address as a 
ON s.address_id = a.address_id
GROUP BY s.store_id, a.address
ORDER BY s.store_id

--- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id
, ci.city
, co.country
FROM store as s
INNER JOIN address as a 
ON s.address_id = a.address_id
INNER JOIN city as ci
ON a.city_id = ci.city_id
INNER JOIN country as co
ON ci.country_id = co.country_id

--- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name
, SUM(p.amount) as GrossRevenue
FROM payment as p
INNER JOIN rental as r
ON p.rental_id = r.rental_id
INNER JOIN inventory as i
ON r.inventory_id = i.inventory_id
INNER JOIN film_category as fc
ON i.film_id = fc.film_id
INNER JOIN category as c
ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY SUM(p.amount) DESC
LIMIT 5

--- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW TopCategoryRevenue_vw as 
SELECT c.name
, SUM(p.amount) as GrossRevenue
FROM payment as p
INNER JOIN rental as r
ON p.rental_id = r.rental_id
INNER JOIN inventory as i
ON r.inventory_id = i.inventory_id
INNER JOIN film_category as fc
ON i.film_id = fc.film_id
INNER JOIN category as c
ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY SUM(p.amount) DESC
LIMIT 5

--- 8b. How would you display the view that you created in 8a?
SELECT * 
FROM TopCategoryRevenue_vw

--- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW TopCategoryRevenue_vw