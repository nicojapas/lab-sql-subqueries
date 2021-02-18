-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?
use sakila;
select count(*) as count, film_id from inventory
where film_id = (
select film_id from film
where title = 'Hunchback Impossible'
);

-- 2. List all films whose length is longer than the average of all the films.
select title from film
where length > (
	select avg(length) as average_length from film
);

-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.
select concat(first_name, ' ', last_name) as actor from actor
where actor_id in (
	select actor_id from film_actor
	where film_id = (
		select film_id from film
		where title = 'Alone Trip'
	)
);

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title from film
where film_id in (
	select film_id from film_category
    where category_id in (
		select category_id from category
        where name = 'Family'
	)
);

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select concat(first_name, ' ', last_name) as name, email from customer
where address_id in (
	select address_id from address
	where city_id in (
		select city_id from city
		where country_id in (
			select country_id from country
			where country = 'Canada'
		)
	)
);

select concat(first_name, ' ', last_name) as name, email from customer
join
address
using (address_id)
join
city
using (city_id)
join
country
using (country_id)
where country = 'Canada';

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select * from film
where film_id in (
	select film_id from film_actor
	where actor_id = (
		select actor_id as most_prolific_actor_id from film_actor
		group by actor_id
		order by count(*) desc
		limit 1
	)
);

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select * from film
where film_id in (
	select film_id from inventory
	where inventory_id in (
		select inventory_id from rental
		where customer_id = (
			select customer_id from payment
			group by customer_id
			order by sum(amount) desc
			limit 1
		)
	)
);

-- 8. Customers who spent more than the average payments.
select * from customer
where customer_id in (
	select customer_id from payment
	where amount > (
		select avg(amount) as average_payment from payment
	)
	group by customer_id
	order by amount asc
);