use sakila;
-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name,last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT CONCAT(first_name,' ', last_name) AS 'Actor Name' FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT actor_id, first_name, last_name FROM actor WHERE last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT first_name, last_name FROM actor WHERE last_name like '%LI%' order by last_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM country WHERE country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD description BLOB;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor
DROP description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) from actor group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
 SELECT last_name, COUNT(*) from actor group by last_name HAVING count(*)>1;
 
-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor set first_name='HAPRO' where last_name='WILLIAMS' AND first_name='GROUCHO';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor set first_name='GROUCHO' where last_name='WILLIAMS' AND first_name='HAPRO'; 


-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
 SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON
staff.address_id=address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
-- SELECT staff.first_name, staff.last_name, sum(payment.amount)
SELECT payment.staff_id, staff.first_name, staff.last_name, sum(payment.amount)
FROM staff INNER JOIN payment ON
staff.staff_id = payment.staff_id AND payment_date LIKE '2005-08%'
group by payment.staff_id; 


-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT film.title, count(film_actor.actor_id) as number_of_actors
FROM film join film_actor ON
film_actor.film_id=film.film_id
group by film_actor.film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT film.title, count(inventory.inventory_id) as number_of_copies
FROM film join inventory ON
film.film_id=inventory.film_id
group by inventory.film_id
HAVING film.title='Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT customer.last_name, sum(payment.amount) as Total_Payment
FROM customer join payment ON
customer.customer_id=payment.customer_id
group by payment.customer_id
order by customer.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title from film
where title like 'K%' or title like 'Q%' 
and language_id in  (
		select language_id from language 
        where name='English'
order by title
);
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name from actor
where actor_id in (
	SELECT actor_id from film_actor 
    where film_id in (
		SELECT film_id from film 
        where title = 'Alone Trip'
    )
);
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email from customer
where address_id in (
	SELECT address_id from address
    where city_id in (
		SELECT city_id from city 
        where country_id in (
			SELECT country_id from country
            where country ='Canada'
		)
    )
);

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title from film
where film_id in (
	SELECT film_id from film_category 
    where category_id in (
		SELECT category_id from category 
        where name = 'family'
    )
);

-- 7e. Display the most frequently rented movies in descending order.
SELECT film.title, COUNT(rental.inventory_id) as number_of_rents from rental
join inventory on rental.inventory_id = inventory.inventory_id 
join film on inventory.film_id = film.film_id
group by film.title 
order by number_of_rents desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT distinct a.store_id, a.staff_id, Total_business from staff as a 
join (
	SELECT staff_id, sum(amount) as Total_business from payment
    group by staff_id
	) as b
on a.staff_id = b.staff_id
group by a.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT st.stid, cio.city, cio.country from 
(  
	SELECT c.city_id as ccid, c.city as city, co.country as country from city as c
    join country  as co on c.country_id =co.country_id
) as cio
join (
	SELECT s.store_id as stid, a.city_id as scid from store as s
    join address as a on s.address_id = a.address_id
) as st
on st.scid = cio.ccid;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select c.name, sum(p.amount) Total_Business from category c
join film_category f on c.category_id = f.category_id
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join payment p on r.rental_id = p.rental_id
group by c.name
order by Total_Business desc 
limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
drop view if exists Top_5_Genres;
create view Top_5_Genres as
    select c.name, sum(p.amount) Total_Business from category c
	join film_category f on c.category_id = f.category_id
	join inventory i on f.film_id = i.film_id
	join rental r on i.inventory_id = r.inventory_id
	join payment p on r.rental_id = p.rental_id
	group by c.name
	order by Total_Business desc
    limit 5;
    
-- 8b. How would you display the view that you created in 8a?
select * from Top_5_Genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view if exists Top_5_Genres;