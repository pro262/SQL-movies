--  Q1 : Print all movie title and release year for Marvel studios movies.
SELECT 
    title, release_year
FROM
    movies
WHERE
    studio = 'marvel studios';
    
    
    --  Q2: Print all movies that have avengers in their name.
    SELECT 
    *
FROM
    movies
WHERE
    title LIKE '%avengers%';
    
    
    -- Q3 : Print all distint movie studios on bollywood industry.
    SELECT 
    distinct studio
FROM
    movies
WHERE
    industry = 'bollywood';
    
    
    -- Q4 : Print all movies whose imdb_rating is greater than equal to 6 and less than equal to 8.
    SELECT 
    *
FROM
    movies
WHERE
    imdb_rating BETWEEN 6 AND 8 ;
    
    
    -- Q5 : print top 5 bollywood movies order by imdb rating .
    SELECT 
    *
FROM
    movies
WHERE
    industry = 'bollywood'
ORDER BY imdb_rating DESC
LIMIT 5


-- Q6 : Print all movies released after 2020 that has imdb rating more than 8 .
SELECT 
    *
FROM
    movies
WHERE
    release_year > 2020
HAVING imdb_rating > 8
    
    -- Q7 : select all movies that are by marvel studios and hombale films.
   SELECT 
    *
FROM
    movies
WHERE
    studio IN ('marvel studio' , 'hombale films')
    
    
    -- Q8 : select all movies that are not from marvel studios .
    SELECT 
    *
FROM
    movies
WHERE
    studio != 'marvel studios'
    
    
    -- 	Q9 : Print min max avg imdb_rating for marvel studio 
  SELECT 
    MIN(imdb_rating) AS min_rating,
    MAX(imdb_rating) AS max_rating,
    AVG(imdb_rating) AS avg_rating
FROM
    movies
WHERE
    studio = 'marvel studios'
    
    
    -- Q10: Print a year and how many movies were released in that year starting with latest year 
    SELECT 
    release_year, COUNT(*) AS movies_count
FROM
    movies
GROUP BY release_year
ORDER BY release_year DESC;


-- 	Q11 : Print all years where more than 2 movies were released .
SELECT 
    release_year, COUNT(*) AS movies_count
FROM
    movies
GROUP BY release_year
HAVING movies_count > 2


-- Q12 : Print profit % for all the movies.
SELECT 
    *,
    (revenue - budget) AS profit,
    (revenue - budget) * 100 / budget AS profit_pct
FROM
    financials;
    
    
    -- Q13 : Print all odd movie_id records.
   SELECT 
    *
FROM
    movies
WHERE
    movie_id % 2 = 1


-- Q14 : Print all movies with their language name.
SELECT 
    movies.title, languages.name
FROM
    movies
        JOIN
    languages ON movies.language_id = languages.language_id;
    
    
    -- Q15: show all telugu movie names(assuming you don't knoe language id for telugu).
SELECT 
    movies.title
FROM
    movies
        JOIN
    languages ON movies.language_id = languages.language_id
WHERE
    languages.name = 'telugu';
    
    
-- Q16 : Retrive movie_id ,title , budhet ,revenue, currency and unit.
SELECT 
    m.movie_id,
    title,
    budget,
    revenue,
    currency,
    unit,
    CASE
        WHEN unit = 'Thousands' THEN ROUND((revenue - budget) / 1000, 1)
        WHEN unit = 'Billions' THEN ROUND((revenue - budget) * 1000, 1)
        ELSE ROUND((revenue - budget), 1)
    END AS profit_millions
FROM
    movies m
        JOIN
    financials f ON m.movie_id = f.movie_id
    
    
    -- Q17 : Retrive titles and actors .
   SELECT 
    m.title,
    GROUP_CONCAT(a.name
        SEPARATOR ' | ') AS actors
FROM
    movies m
        JOIN
    movie_actor ma ON ma.movie_id = m.movie_id
        JOIN
    actors a ON a.actor_id = ma.actor_id
GROUP BY m.movie_id


-- Q18 : Generate all hindi movies sorted by their revenue amount in millions.
SELECT 
    m.title,
    revenue,
    budget,
    currency,
    unit,
    CASE
        WHEN unit = 'thousands' THEN ROUND(revenue / 1000, 1)
        WHEN unit = 'billions' THEN ROUND(revenue * 1000, 1)
        ELSE revenue
    END AS revenue_million
FROM
    movies m
        JOIN
    financials f ON m.movie_id = f.movie_id
        JOIN
    languages l ON m.language_id = l.language_id
WHERE
    l.name = 'hindi'
ORDER BY revenue_million DESC


-- Q19 : select all actors whose age is greater then 70 and less than 85.
SELECT 
    *
FROM
    (SELECT 
        name, YEAR(CURDATE()) - birth_year AS age
    FROM
        actors) AS actors_age
WHERE
    age BETWEEN 70 AND 85
    
                                 [OR CAN USE CTE (COMMON TABLE EXPRESSION)]
WITH 
    actors_age as (select name as actor_name,
    year(curdate())-birth_year as age from actors)
    
	select actor_name ,age 
    from actors_age 
	where age >70 and age <85
					
                                 
    
    -- Q20: Select all movies whose rating is greater than any of the marvel movies rating.
SELECT 
    *
FROM
    movies
WHERE
    imdb_rating > ANY (SELECT 
            imdb_rating
        FROM
            movies
        WHERE
            studio = "marvel studios")
            
            
 --  Q21 : Select all the rows from movies table whose imdb_rating is higher than the average rating.
SELECT 
    *
FROM
    movies
WHERE
    imdb_rating > (SELECT 
            AVG(imdb_rating)
        FROM
            movies)
            
            
 -- Q22 :select all hollywood movies released after year 2000 that made more than 500 million or more profit . 
 ( Note that all hollywood movies have millions as a unit hence u dont need to do unit coversion)
 
 WITH
 CTE AS (select title, release_year,(revenue-budget)as profit
 from movies m
 join financials f
 on m. movie_id = f.movie_id 
 where release_year>  2000 and industry="hollywood")
 
 select * from CTE where profit >500
 
 
 -- Q23 : Movies that produced 500 %  profit  or more and their rating was less than avg rating for all movies
 WITH 
 X as (select *
 (revenue-budget)*100/budget as profit_pct,
 from financials
 where  (revenue-budget)*100/budget >=500 )
 Y as ( select 
 *from movies
 where imdb_rating <(select avg (imdb_rating) from movies))
 
 select 
 X.movie_id ,x.profit_pct ,y.title ,y.imdb_rating,
 from X
 JOIN Y 
 ON X.movie_id =Y.movie_id 
 where profit_pct  >=  500
 