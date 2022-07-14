
#                       ---- Combining 'duration' column with movie_ratings table ----
(SELECT 'id', 'imdb_title_id', 'year_', 'weighted_average_vote', 'total_votes', 'mean_vote', 'median_vote', 'votes_10', 'votes_9', 'votes_8', 'votes_7', 'votes_6', 'votes_5', 'votes_4', 'votes_3', 'votes_2', 'votes_1', 'allgenders_18age_avg_vote', 'allgenders_18age_votes', 'allgenders_30age_avg_vote', 'allgenders_30age_votes', 'allgenders_45age_avg_vote', 'allgenders_45age_votes', 'males_allages_avg_vote', 'males_allages_votes', 'males_18age_avg_vote', 'males_18age_votes', 'males_30age_avg_vote', 'males_30age_votes', 'males_45age_avg_vote', 'males_45age_votes', 'females_allages_avg_vote', 'females_allages_votes', 'females_18age_avg_vote', 'females_18age_votes', 'females_30age_avg_vote', 'females_30age_votes', 'females_45age_avg_vote', 'females_45age_votes', 'top1000_voters_rating', 'top1000_voters_votes', 'us_voters_rating', 'us_voters_votes','non_us_voters_rating', 'non_us_voters_votes','duration')
UNION
(SELECT a.* , b.duration FROM
(SELECT * FROM movie_ratings) AS a
INNER JOIN
(SELECT imdb_title_id , min(duration) as duration FROM movies
GROUP by imdb_title_id) AS b
ON a.imdb_title_id = b.imdb_title_id)
INTO OUTFILE 'E:/Career related/IMDB Project/movies_ratings_nulls_fixed_with_duration.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n';



#  ---                             Ages, Rating Cross tabulation (Males Only)              ---

SELECT 
COUNT(IF(males_18age_avg_vote <= 10 and males_18age_avg_vote >= 7.5 , '-10' , null)) as _4,
COUNT(IF(males_18age_avg_vote < 7.5 and males_18age_avg_vote >= 5 , '-7.5', null)) as _3,
COUNT(IF(males_18age_avg_vote < 5 and males_18age_avg_vote >= 2.5 , '-5', null)) as _2,
COUNT(IF(males_18age_avg_vote < 2.5 and males_18age_avg_vote >= 0 , '-2.5',null)) as _1
FROM (SELECT * FROM movie_ratings) AS a
INNER JOIN
(SELECT imdb_title_id , min(duration) as duration FROM movies
GROUP by imdb_title_id) AS b
ON a.imdb_title_id = b.imdb_title_id
UNION ALL
SELECT 
COUNT(IF(males_30age_avg_vote <= 10 and males_30age_avg_vote >= 7.5 , '-10' , null)) as _4,
COUNT(IF(males_30age_avg_vote < 7.5 and males_30age_avg_vote >= 5 , '-7.5', null)) as _3,
COUNT(IF(males_30age_avg_vote < 5 and males_30age_avg_vote >= 2.5 , '-5', null)) as _2,
COUNT(IF(males_30age_avg_vote < 2.5 and males_30age_avg_vote >= 0 , '-2.5',null)) as _1
 FROM (SELECT * FROM movie_ratings) AS a
INNER JOIN
(SELECT imdb_title_id , min(duration) as duration FROM movies
GROUP by imdb_title_id) AS b
ON a.imdb_title_id = b.imdb_title_id
UNION ALL
SELECT 
COUNT(IF(males_45age_avg_vote <= 10 and males_45age_avg_vote >= 7.5 , '-10' , null)) as _4,
COUNT(IF(males_45age_avg_vote < 7.5 and males_45age_avg_vote >= 5 , '-7.5', null)) as _3,
COUNT(IF(males_45age_avg_vote < 5 and males_45age_avg_vote >= 2.5 , '-5', null)) as _2,
COUNT(IF(males_45age_avg_vote < 2.5 and males_45age_avg_vote >= 0 , '-2.5',null)) as _1
FROM (SELECT * FROM movie_ratings) AS a
INNER JOIN
(SELECT imdb_title_id , min(duration) as duration FROM movies
GROUP by imdb_title_id) AS b
ON a.imdb_title_id = b.imdb_title_id;

#  ---                             Ages, Rating Cross tabulation (Females Only)              ---

SELECT 
COUNT(IF(females_18age_avg_vote <= 10 and females_18age_avg_vote >= 7.5 , '-10' , null)) as _4,
COUNT(IF(females_18age_avg_vote < 7.5 and females_18age_avg_vote >= 5 , '-7.5', null)) as _3,
COUNT(IF(females_18age_avg_vote < 5 and females_18age_avg_vote >= 2.5 , '-5', null)) as _2,
COUNT(IF(females_18age_avg_vote < 2.5 and females_18age_avg_vote >= 0 , '-2.5',null)) as _1
FROM (SELECT * FROM movie_ratings) AS a
INNER JOIN
(SELECT imdb_title_id , min(duration) as duration FROM movies
GROUP by imdb_title_id) AS b
ON a.imdb_title_id = b.imdb_title_id
UNION ALL
SELECT 
COUNT(IF(females_30age_avg_vote <= 10 and females_30age_avg_vote >= 7.5 , '-10' , null)) as _4,
COUNT(IF(females_30age_avg_vote < 7.5 and females_30age_avg_vote >= 5 , '-7.5', null)) as _3,
COUNT(IF(females_30age_avg_vote < 5 and females_30age_avg_vote >= 2.5 , '-5', null)) as _2,
COUNT(IF(females_30age_avg_vote < 2.5 and females_30age_avg_vote >= 0 , '-2.5',null)) as _1
 FROM (SELECT * FROM movie_ratings) AS a
INNER JOIN
(SELECT imdb_title_id , min(duration) as duration FROM movies
GROUP by imdb_title_id) AS b
ON a.imdb_title_id = b.imdb_title_id
UNION ALL
SELECT 
COUNT(IF(females_45age_avg_vote <= 10 and females_45age_avg_vote >= 7.5 , '-10' , null)) as _4,
COUNT(IF(females_45age_avg_vote < 7.5 and females_45age_avg_vote >= 5 , '-7.5', null)) as _3,
COUNT(IF(females_45age_avg_vote < 5 and females_45age_avg_vote >= 2.5 , '-5', null)) as _2,
COUNT(IF(females_45age_avg_vote < 2.5 and females_45age_avg_vote >= 0 , '-2.5',null)) as _1
FROM (SELECT * FROM movie_ratings) AS a
INNER JOIN
(SELECT imdb_title_id , min(duration) as duration FROM movies
GROUP by imdb_title_id) AS b
ON a.imdb_title_id = b.imdb_title_id;


#                         --- Percent change of average rating of movies each year ---

WITH sub AS (
SELECT d.year_ , d.year_avg_rating , d.prev_year_avg_rating , ROUND(d.percent_change,3) as percent_change FROM (
SELECT a.year_ , ROUND(a.year_avg_rating,2) as year_avg_rating 
, ROUND(LEAD(a.year_avg_rating) OVER (ORDER BY a.year_ DESC),2) AS prev_year_avg_rating
, (a.year_avg_rating - LEAD(a.year_avg_rating) OVER (ORDER BY a.year_ DESC))*100/LEAD(a.year_avg_rating) OVER (ORDER BY a.year_ DESC) AS percent_change  FROM (
SELECT year_ , AVG(weighted_average_vote) as year_avg_rating
FROM movie_ratings
GROUP BY year_
) as a) as d
ORDER BY percent_change DESC)

SELECT c.year_ , c.year_avg_rating, c.prev_year_avg_rating, c.percent_change, c.cat FROM (
SELECT a.* , b.max , b.min , IF(a.percent_change = max,'MAX',IF(a.percent_change = min,'MIN','MID')) AS cat FROM SUB as a
INNER JOIN (SELECT year_ , MAX(percent_change) as max , MIN(percent_change) as min FROM SUB) as b
ON true) AS C;

#Outputing
SELECT 'year' , 'year_avg_rating' , 'prev_year_avg_rating' , 'percent_change_from_prev_year' , 'cat'
UNION ALL 
SELECT c.year_ , c.year_avg_rating, c.prev_year_avg_rating, c.percent_change, c.cat FROM (
SELECT a.* , b.max , b.min , IF(a.percent_change = max,'MAX',IF(a.percent_change = min,'MIN','MID')) AS cat FROM SUB as a
INNER JOIN (SELECT year_ , MAX(percent_change) as max , MIN(percent_change) as min FROM SUB) as b
ON true) AS C
INTO OUTFILE 'E:/Career related/IMDB Project/year_rating_data.csv'
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n';




