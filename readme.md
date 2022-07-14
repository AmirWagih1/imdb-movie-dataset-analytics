# IMDB Dataset Analytics

### Quick Summary:
I did some data wrangling, analytics, visulizations for an [IMDB dataset](https://www.kaggle.com/datasets/ngochieunguyen/imdb-extensive) I found on kaggle, I used data in  `movies.csv`, `movies_ratings.csv`

### Tools used:
- Python
- SQL
- Tablue
- R
- Excel

### The project has been divided to two parts:
 **Content**:
   1.  Data Wrangling (Data Cleaning, Data Exploration) in SQL, Pandas
   2.  Data Analysis in R
   3. Tablue Visualizations

### 1. Data Wrangling
- #### For Data Cleaning:
  - I Started off by doing **null analysis** in **pandas** to check which columns are worth **imputing** and which are not. I Calculated **Percentage of Nulls** in Each column and I set  **60%** as my thrushold for dropping a column Instead of imputing it (Since it was clear just by visualizing that next bigger percentage of nulls was much much smaller than 60%) 
      - **Check** : `null_analysis.py`, `null_info`
  - I Imputed `*_*_avg_vote` columns null values in SQL using the average vote of `*_*_avg_vote` non-null values having the same `year` as the movie you are imputing `*_*_avg_vote` for.
  - Fixed the text that was included in some values for `date_published` column as well as other stuff, feel free to check the comments in the SQL script 
  
  **Check** :  `data_cleaning.sql`  For all data cleaning done in SQL 
  - I Split the rows using `genre` column (Since each movie had `genre` value  with format `genre1,genre2,genre3,...` so the data was useless in this format)
     - **Check** `spliting_genre_column.py`. `genre_split_column.csv`
   
  **Check** : `IMDB dataset cleaned.rar` For **csv** files after cleaning
- #### For Data Exploration:
	 - I Created **Cross-tabulations** for:
	      - Movie Rating, Gender
		  - Movie Rating, Age
		  
  **Check:** `all cross-tabulations combined.xlsx`
   
	 - I Created new columns
	    - `year_avg_rating` column : Which is the **average rating** for all movies in a specific year
	    - `percent_change_from_prev_year` column : Which is the **percentage change** in average rating or movies from previous year
		- `cat` column : classifies `percent_change_from_prev_year`  as either `MAX` or `MID` or `MIN` 
		
  **Check:** `year_average_rating_year.csv`

 **Check** : `data_exploration.sql` For all data exploration scripts
		  
### 2. Analysis in R
I did analysis in R to check whether `age` and `gender` variables affect average move ratings, I calculated some **statistical measures** as well as some **statistical plots** using ggplot2 to better explain our hypothesis

**Check :** plots , R code in `R vizs` folder, check **comments** in `analysis.R` 

### 3. Tablue Visulizations
- I Created :
   -  [Dashboard](https://public.tableau.com/app/profile/amir.wagih/viz/Book1_16276894838320/MovieGenresStats_) : Related to Genre Statistics
      - You may consider opening each visuluzation in dashbaord separetly for clearer view
   -  [Movie Ratings Time Series](https://public.tableau.com/app/profile/amir.wagih/viz/Book3_16312254161750/AverageRatingofMoviesOverYears)
