use sakila;

select * from actor;
-- SQL 1a
select 	 first_name
		,last_name
  from actor;

-- SQL 1b
select 	 upper(concat(first_name, ' ', last_name)) as Actor_Name
  from actor;

-- SQL 2a
select actor_id
	  ,first_name
      ,last_name
  from actor
 where first_name = "JOE";
 
 -- SQL 2b
 select actor_id
	  ,first_name
      ,last_name
  from actor
 where last_name like "%GEN%";

 -- SQL 2c
 select actor_id
	  ,first_name
      ,last_name
  from actor
 where last_name like "%LI%"
 order by last_name
		 ,first_name;

-- SQL 2d
 select *
  from country
 where country in ('Afghanistan', 'Bangladesh', 'China');

-- SQL 3a
alter table actor add column description BLOB;

select * from actor;

-- SQL 3b
alter table actor drop column description;

select * from actor;

-- SQL 4a
select last_name
	  ,count(*)
  from actor
group by last_name;

-- SQL 4b
select last_name
	  ,count(*)
  from actor
 group by last_name
 having count(*) >= 2;
 
-- SQL 4C
Update actor
   set first_name = 'GROUCHO'
	,last_name = 'WILLIAMS'
 where first_name = 'HARPO'
   and last_name = 'WILLIAMS';
   
-- SQL 4d
Update actor
   set first_name = 'GROUCHO'
 where first_name = 'HARPO';
 
-- SQL 5a
SHOW CREATE table address;
-- another option to look at the columns only
desc address;

-- SQL 6a
select s.first_name
      ,s.last_name
      ,a.address
   from staff s
	   ,address a
where s.address_id = a.address_id;

-- SQL 6b
select s.first_name
      ,s.last_name
--      ,p.amount
      ,sum(p.payment_date) as tot_payment
   from staff s
	   ,payment p
 where s.staff_id = p.staff_id
  and p.payment_date between '2005-08-01' and '2005-08-31'
group by s.first_name
	    ,s.last_name;

-- SQL 6c
select f.title
	  ,count(actor_id) as 'Num of Actors'
  from film_actor fa
  join film f on fa.film_id = f.film_id
group by f.title;

-- SQL 6d
select count(i.inventory_id) as cnt
--		,f.title
  from inventory i
      ,film f
 where f.film_id = i.film_id
   and f.title = 'Hunchback Impossible';
   
-- SQL 6e
Select c.first_name
	  ,c.last_name
      ,sum(p.amount) as 'Total Amount Paid'
  from customer c
	  ,payment p
where c.customer_id = p.customer_id
group by c.last_name
		,c.first_name;

-- SQL 7a
select f.title
   from film f
       ,language l
where f.language_id = l.language_id
  and l.name = 'English'
  and (   title like 'K%'
       or title like 'Q%');

-- SQL 7b
select first_name
	  ,last_name
   from actor
where actor_id in (
	select actor_id 
	from film_actor
	where film_id in(
		select film_id
		from film
		where title = 'Alone Trip')
        )
;

-- SQL 7c
select cust.first_name
	  ,cust.last_name
      ,cust.email
   from customer cust
       ,address a
       ,country c
       ,city ci
where cust.address_id = a.address_id
  and a.city_id = ci.city_id
  and ci.country_id = c.country_id
  and c.country = 'Canada' 
;

-- SQL 7d
select f.title
  from film f
      ,film_category fc
      ,category c
 where f.film_id = fc.film_id
   and fc.category_id = c.category_id
   and c.name = 'Family';

-- SQL 7e
select f.title
      ,count(rental_id) frequency
from rental r
    ,inventory i
    ,film f
where f.film_id = i.film_id
  and i.inventory_id = r.inventory_id
group by f.title
order by frequency desc; 

-- SQL 7f - Assuming that staff id is specific to a store id.
select s.store_id
	  ,sum(p.amount) as 'Sales in $'
from payment p
    ,staff s
where p.staff_id = s.staff_id
group by s.store_id;

-- SQL 7g
select s.store_id
      ,ci.city
      ,c.country
  from store s
      ,address a
      ,country c
      ,city ci
where s.address_id = a.address_id
  and a.city_id = ci.city_id
  and ci.country_id = c.country_id
;

-- SQL 7h
select c.name
      ,sum(p.amount) as 'Sales'
from category c
    ,film_category fc
    ,inventory i
    ,payment p
    ,rental r
where fc.category_id = c.category_id    -- Obtaining the genere name from the category id of the film
  and i.film_id = fc.film_id			-- Joining film_id
  and r.inventory_id = i.inventory_id   -- a film_id can have more than 1 inventory_id
  and p.rental_id = r.rental_id			-- confirming that the film was rented
group by c.name
order by Sales desc
limit 5;

-- SQL 8a
create view top_five_generes_by_sales as
select c.name
      ,sum(p.amount) as 'Sales'
from category c
    ,film_category fc
    ,inventory i
    ,payment p
    ,rental r
where fc.category_id = c.category_id    -- Obtaining the genere name from the category id of the film
  and i.film_id = fc.film_id			-- Joining film_id
  and r.inventory_id = i.inventory_id   -- a film_id can have more than 1 inventory_id
  and p.rental_id = r.rental_id			-- confirming that the film was rented
group by c.name
order by Sales desc
limit 5;

-- SQL 8b
select * from top_five_generes_by_sales;

-- SQL 8c
drop view top_five_generes_by_sales;