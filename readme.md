# IMDB Dataset Analytics
I did some data wrangling, analytics, visulizations for an [IMDB dataset](https://www.kaggle.com/datasets/ngochieunguyen/imdb-extensive) I found on kaggle, I used data in  `movies.csv`, `movies_ratings.csv`

### Tools used:
- Python
- SQL
- Tableau

### Project Appendix:
   1.  Data Cleaning in SQL, Pandas
   2.  Data Exploration: Building a Dashboard Tableau

### 1. Data Cleaning in SQL, Pandas

1. I started off by doing **null analysis** in **pandas** to check which columns are worth **imputing** and which are not. I calculated **Percentage of Nulls** in Each column and I set  **60%** as my threshold for dropping a column instead of imputation.
  
- **Check**: `null_analysis.py`, `null_info.xlxs`
  
2. I Imputed `*_*_avg_vote` columns null values in SQL using the average vote of `*_*_avg_vote` non-null values having the same `year` as the movie you are imputing `*_*_avg_vote` for.
  
3. Fixed the text that was included in some values for `date_published` column as well as other stuff, feel free to check the comments in the SQL script.
  
- **Check:** `data_cleaning.sql`  For all data cleaning done in SQL
  
4. I split the rows using the `genre` column (Since each movie had a `genre` value  with format `genre1,genre2,genre3,...` so the data was useless in this format)
  
- **Check:** `spliting_genre_column.py`. `genre_split_column.csv`
   
- **Final Result:** `IMDB dataset cleaned.rar` For **csv** files after cleaning


### 2. Data Exploration: Building a Dashboard Tableau
- [Dashboard](https://public.tableau.com/app/profile/amir.wagih/viz/Book1_16276894838320/MovieGenresStats_)

