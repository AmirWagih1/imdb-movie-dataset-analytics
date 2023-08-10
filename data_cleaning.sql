SET GLOBAL local_infile=1;


LOAD DATA LOCAL INFILE 'E:/Career related/IMDB Project/movie_ratings - Copy.csv' INTO TABLE movie_ratings
FIELDS terminated by ',' LINES terminated by '\n';

								   /*      Data Cleaning       */
                                   
#                       --- Converting "imdb_title_id" to varchar(30) ---
ALTER TABLE movie_ratings
MODIFY imdb_title_id VARCHAR(30);

#Adding a primary key
ALTER TABLE movie_ratings
ADD id int unsigned primary key auto_increment
FIRST;

#                            ------Replacing 0s with nulls------

# When importing the csv file, we can notice that SQL converted empty cells to 0 instead of null (amound many other columns)
SELECT females_0age_avg_vote FROM movie_ratings;

#We can confirm that from the number of cells with zero values with the value in our null_info excel sheet
SELECT COUNT(females_0age_avg_vote) FROM movie_ratings
WHERE  females_0age_avg_vote = 0;

# Since some columns got a very high percent of nulls  (the rows in red in the null_info excel sheet  , check the comments aswell) We can consider dropping them instead of finding a way to impute them
ALTER table movie_ratings
DROP females_0age_avg_vote ,
DROP females_0age_votes , 
DROP males_0age_votes , 
DROP males_0age_avg_vote ,
DROP allgenders_0age_avg_vote,
DROP allgenders_0age_votes;

#to make sure that the zeros we are seeing are really nulls and not real value of the avg , we will give a null value only if both the average and the number of votes are zero (although i doupt that a movie can really have mean rating of zero from group of people)
WITH sub_query AS (SELECT (CASE WHEN females_18age_avg_vote = 0 AND females_18age_votes = 0 THEN null ELSE females_18age_avg_vote END) AS females_18age_avg_vote FROM movie_ratings)

#in case of 'females_18age_avg_vote' all zeros turned out to be really nulls
SELECT SUM(CASE WHEN females_18age_avg_vote is null THEN 1 ELSE 0 END) as null_count , SUM(CASE WHEN females_18age_avg_vote = 0  THEN 1 ELSE 0 END) as zero_value_count FROM sub_query;

#Updating orginal table
UPDATE movie_ratings
SET females_18age_avg_vote = (SELECT CASE WHEN females_18age_avg_vote = 0 AND females_18age_votes = 0 THEN null ELSE females_18age_avg_vote END AS females_18age_avg_vote)
WHERE females_18age_avg_vote = 0;

# adding year column from another table
CREATE table movie_years
(imdb_title_id varchar(30) , year_ varchar(10));


ALTER table movie_ratings
ADD COLUMN year_ varchar(10)
AFTER imdb_title_id;

SELECT * from movie_years;


SELECT a.imdb_title_id , b.year_ from movie_ratings a
INNER JOIN
movie_years b
ON a.imdb_title_id = b.imdb_title_id;

SELECT a.imdb_title_id , b.year_ as year_ from movie_ratings a
INNER JOIN
movie_years b
ON a.imdb_title_id = b.imdb_title_id;

UPDATE movie_ratings a
INNER JOIN movie_years b ON a.imdb_title_id = b.imdb_title_id
SET a.year_ = b.year_;

LOAD DATA LOCAL INFILE 'E:/Career related/IMDB Project/movie_years.csv'  INTO TABLE movie_ratings 
 FIELDS terminated by ',' LINES terminated by '\n'
 (year_);

SELECT id , imdb_title_id , year_ FROM movie_ratings
WHERE imdb_title_id is null;

SELECT COUNT(*) from movie_ratings;

DELETE from movie_ratings
WHERE imdb_title_id is null;

		
 #---- Replacing null values with the mean ratings of the movie in the year where the movie is produced----
      

with sub_query as (Select females_18age_avg_vote  ,  year_ , AVG(females_18age_avg_vote) AS avg_ from movie_ratings
GROUP BY year_)

SELECT b.females_18age_avg_vote , a.year_ , a.avg_ FROM sub_query a
INNER JOIN movie_ratings b
ON a.year_ = b.year_
WHERE b.females_18age_avg_vote is null;

#Time to update nulls in the orginal table

with sub_query as (Select a.females_18age_avg_vote as  females_18age_avg_vote , a.year_ as year_ , AVG(a.females_18age_avg_vote) AS avg_ from movie_ratings a
GROUP BY year_)

UPDATE movie_ratings b
INNER JOIN sub_query a
ON a.year_ = b.year_
SET b.females_18age_avg_vote = a.avg_
WHERE b.females_18age_avg_vote is null;


#to make sure all nulls are removed (output : 0)
SELECT COUNT(females_18age_avg_vote) FROM movie_ratings
WHERE females_18age_avg_vote is null;

#Doing that for other columns (Creating a stored procedure to make it easier for us)

DELIMITER //
CREATE PROCEDURE replace_nulls_with_mean_year(IN column_name VARCHAR(30))
BEGIN

SET @s = CONCAT('UPDATE movie_ratings
SET ' , column_name , ' = (SELECT CASE WHEN ' , REPLACE(column_name ,'avg_vote' , 'votes') ,  ' = 0 AND ' , column_name , ' = 0 THEN null ELSE '  , column_name , ' END AS ' , column_name , ')
WHERE ' , column_name , ' = 0;');

SET @s2 = CONCAT('
SELECT b.' , column_name , ' , a.year_ , a.avg_ FROM
(Select ' , column_name , ' ,  year_ , AVG(' , column_name , ') AS avg_ from movie_ratings
GROUP BY year_) as a
INNER JOIN movie_ratings b
ON a.year_ = b.year_
WHERE b.' , column_name ,' is null;');

SET @s3 = CONCAT('
UPDATE movie_ratings b
INNER JOIN
(Select ' , column_name , ' ,  year_ , AVG(' , column_name , ') AS avg_ from movie_ratings
GROUP BY year_) as a
ON a.year_ = b.year_
SET b.' , column_name , ' = a.avg_
WHERE b.' , column_name ,' is null'
);



SELECT @s , @s2 , @s3;
PREPARE stmt FROM @s;
PREPARE stmt2 FROM @s2;
PREPARE stmt3 FROM @s3;
EXECUTE stmt;
EXECUTE stmt2;
EXECUTE stmt3;
DEALLOCATE PREPARE stmt;
DEALLOCATE PREPARE stmt2;
DEALLOCATE PREPARE stmt3;

END //
DELIMITER ;

CALL replace_nulls_with_mean_year('females_45age_avg_vote');
CALL replace_nulls_with_mean_year('males_18age_avg_vote');
CALL replace_nulls_with_mean_year('females_30age_avg_vote');
CALL replace_nulls_with_mean_year('allgenders_18age_avg_vote');
CALL replace_nulls_with_mean_year('males_45age_avg_vote');
CALL replace_nulls_with_mean_year('females_allages_avg_vote');
CALL replace_nulls_with_mean_year('allgenders_45age_avg_vote');
CALL replace_nulls_with_mean_year('males_30age_avg_vote');
CALL replace_nulls_with_mean_year('allgenders_30age_avg_vote');

#Outputs zero
SELECT COUNT(*) FROM movie_ratings
WHERE allgenders_30age_avg_vote is null or females_45age_avg_vote is null or males_18age_avg_vote is null or females_30age_avg_vote is null 
or allgenders_18age_avg_vote is null or males_45age_avg_vote is null or females_allages_avg_vote is null or allgenders_45age_avg_vote is null
or males_30age_avg_vote is null or allgenders_30age_avg_vote is null;

#It looks way cleaner now 
SELECT * FROM movie_ratings;



#          ----------- After spliting "genre" column into rows in pandas -----------

#Improting movies table after "genre" is split 
ALTER table movies
DROP genre;

DELETE FROM movies
WHERE true;


LOAD DATA LOCAL INFILE 'E:/Career related/IMDB Project/movies_genre_split.csv' INTO Table movies 
Fields Terminated by ',' enclosed by '"' Lines Terminated by '\n' IGNORE 1 lines;

SELECT * FROM movies;

SELECT MAX(CHAR_LENGTH(original_title)) from movies;

#It looks usa_gross_income , worlwide_gross_income , metascore have lots of nulls so they may be not be of great value to us
SELECT COUNT(usa_gross_income) , COUNT(worlwide_gross_income) , COUNT(metascore) from movies
WHERE usa_gross_income = '' OR worlwide_gross_income = '' OR metascore = '';



#                       -------- Fixing some years with text in it --------

SELECT year , REGEXP_REPLACE(year , '[[:alpha:][:blank:]]+' , '') AS year_modified FROM movies
WHERE REGEXP_LIKE(year , '[[:alpha:][:blank:]]+');

UPDATE movies
SET year = REGEXP_REPLACE(year , '[[:alpha:][:blank:]]+' , '') 
WHERE REGEXP_LIKE(year , '[[:alpha:][:blank:]]+');

 #                    ------------- Altering columns data types -------------
 
 UPDATE movies
SET reviews_from_critics = null
WHERE reviews_from_critics = '';

UPDATE movies
SET reviews_from_users = null
WHERE reviews_from_users = '';

ALTER table movies
MODIFY imdb_title_id varchar(10) ,
MODIFY title varchar(196) , 
MODIFY original_title varchar(196) ,
MODIFY year int , 
MODIFY duration int ,
MODIFY country varchar(225) ,
MODIFY language varchar(163),
MODIFY director varchar(62),
MODIFY writer varchar(64),
MODIFY production_company varchar(101),
MODIFY actors varchar(415),
MODIFY description varchar(402),
MODIFY avg_vote double,
MODIFY votes int,
MODIFY reviews_from_users  int,
MODIFY reviews_from_critics  int;


#number of null countries
SELECT SUM(CASE WHEN TRUE THEN 1 END) as null_counterties_count FROM 
(SELECT * FROM movies
WHERE country = '' 
GROUP BY imdb_title_id) AS sub;

SELECT MAX(char_length(genre_split)) FROM movies;


ALTER table movies 
change column genre_split genre VARCHAR(12)
AFTER date_published;


(SELECT 'id', 'imdb_title_id', 'year_', 'weighted_average_vote', 'total_votes', 'mean_vote', 'median_vote', 'votes_10', 'votes_9', 'votes_8', 'votes_7', 'votes_6', 'votes_5', 'votes_4', 'votes_3', 'votes_2', 'votes_1', 'allgenders_18age_avg_vote', 'allgenders_18age_votes', 'allgenders_30age_avg_vote', 'allgenders_30age_votes', 'allgenders_45age_avg_vote', 'allgenders_45age_votes', 'males_allages_avg_vote', 'males_allages_votes', 'males_18age_avg_vote', 'males_18age_votes', 'males_30age_avg_vote', 'males_30age_votes', 'males_45age_avg_vote', 'males_45age_votes', 'females_allages_avg_vote', 'females_allages_votes', 'females_18age_avg_vote', 'females_18age_votes', 'females_30age_avg_vote', 'females_30age_votes', 'females_45age_avg_vote', 'females_45age_votes', 'top1000_voters_rating', 'top1000_voters_votes', 'us_voters_rating', 'us_voters_votes', 'non_us_voters_rating', 'non_us_voters_votes')
UNION
SELECT * FROM movie_ratings
INTO OUTFILE 'E:/Career related/IMDB Project/movies_ratings_nulls_fixed.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'





