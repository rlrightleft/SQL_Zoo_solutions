/*
7_MORE_JOIN_operations.sql
MySQL syntax
Solutions for SQLZoo "More JOIN operations" section
*/

-- Problem 1: List the films where the yr is 1962 [Show id, title]
SELECT id, title
FROM movie 
WHERE yr = 1962;

-- Problem 2: Give year of 'Citizen Kane'.
SELECT yr
FROM movie
WHERE title = 'Citizen Kane';

-- Problem 3: List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr;

-- Problem 4: What id number does the actor 'Glenn Close' have?
SELECT id
FROM actor
WHERE name = 'Glenn Close';

-- Problem 5: What is the id of the film 'Casablanca'
SELECT id
FROM movie
WHERE title = 'Casablanca';

-- Problem 6: Obtain the cast list for 'Casablanca'.
-- What is a cast list? The cast list is the names of the actors who were in the movie.
-- Use movieid=11768, (or whatever value you got from the previous question)
SELECT actor.name
FROM actor JOIN casting ON (actor.id = casting.actorid)
WHERE casting.movieid = 11768;

/* Reflection:
**JOIN** retrieves all actors associated with the movie ID 11768 (Casablanca).
*/

-- Problem 7: Obtain the cast list for the film 'Alien'
SELECT actor.name
FROM actor JOIN casting ON (actor.id = actorid)
WHERE movieid =
  (
  SELECT id
  FROM movie
  WHERE title = 'Alien'
  );

/* Reflection:
Use a **subquery** to find the movie ID dynamically.
*/

-- Problem 8: List the films in which 'Harrison Ford' has appeared
SELECT title
FROM movie JOIN casting on (movie.id = movieid)
WHERE actorid =
(
SELECT id
FROM actor
WHERE name = 'Harrison Ford'
);

/* Reflection:
Find all movie titles where Harrison Ford appears using a **subquery** for the actor ID.
*/

-- Problem 9: List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
SELECT title
FROM movie JOIN casting ON (movie.id = movieid)
WHERE ord > 1 
AND actorid =
  (
  SELECT id
  FROM actor
  WHERE name = 'Harrison Ford'
  );

/* Reflection:
Use ord > 1 to exclude lead roles while still listing supporting roles.
*/

-- Problem 10: List the films together with the leading star for all 1962 films.
SELECT movie.title, actor.name
FROM casting
  JOIN movie ON (movieid = movie.id)
  JOIN actor ON (actorid = actor.id)
WHERE yr = 1962
AND ord = 1;

/* Reflection:
You can JOIN more than 2 tables.
*/

-- Problem 11: Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT yr, COUNT(title) 
FROM movie 
  JOIN casting ON movie.id = movieid
  JOIN actor   ON actorid = actor.id
WHERE name = 'Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;

/* Reflection:
Use **HAVING** to filter years where Rock Hudson acted in more than 2 films.
*/

-- Problem 12: List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT DISTINCT movie.title, actor.name
FROM casting
JOIN movie ON (movieid = movie.id)
JOIN actor ON (actorid = actor.id)
WHERE ord = 1
AND movie.id IN
  (SELECT movieid 
  FROM casting
  WHERE actorid = 
     (
    SELECT id
    FROM actor
    WHERE name = 'Julie Andrews'
     )
  );

/* Reflection:
Use subqueries to dynamically retrieve all movies that include Julie Andrews (but where Julie Andrews may or may not be the leading actor).
*/

-- Problem 13: Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
SELECT DISTINCT actor.name
FROM actor 
  JOIN casting ON (actor.id = actorid)
WHERE ord = 1
GROUP BY actorid
HAVING COUNT(actorid) >= 15
ORDER BY actor.name;

/* Reflection:
**GROUP BY** groups actors, and **HAVING COUNT()** filters those with 15 or more starring roles.
*/

-- Problem 14: List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT movie.title, COUNT(actorid)
FROM movie 
  JOIN casting ON (movie.id = movieid) 
WHERE yr = 1978
GROUP BY movieid
ORDER BY 
  COUNT(actorid) DESC, 
  movie.title;

/* Reflection:
Use **COUNT(actorid)** to measure cast size and sort by **title** in case of ties.
To show movies with the largest cast size first, ORDER BY **descending** COUNT(actorid).
*/

-- Problem 15: List all the people who have worked with 'Art Garfunkel'.
SELECT actor.name
FROM actor 
  JOIN casting ON (actor.id = actorid)
WHERE actor.name <> 'Art Garfunkel'
AND movieid IN
  (
  SELECT movieid
  FROM casting
  WHERE actorid = 
    (
    SELECT actor.id
    FROM actor
    WHERE actor.name = 'Art Garfunkel'
    )
  );

/* Reflection:
Use subqueries to find all movie IDs featuring Art Garfunkel, then list all other actors in those movies.
Exclude Art Garfunkel using **actor.name <> 'Art Garfunkel'**.
*/
