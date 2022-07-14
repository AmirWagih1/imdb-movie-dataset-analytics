import pandas as pd

movs_ratings = pd.read_csv("movie_ratings.csv")

#                       ----Checking amount of nulls , percentage of nulls in each column----
nulls = pd.DataFrame({"number_of_nulls":range(1,len(movs_ratings.columns)+1) , "percent_null":range(1,len(movs_ratings.columns)+1)} , index=movs_ratings.columns)
nulls["number_of_nulls"] = [movs_ratings[col_name].isnull().sum() for col_name in movs_ratings.columns]
nulls["percent_null"] = [(movs_ratings[col_name].isnull().sum()/len(movs_ratings))*100 for col_name in movs_ratings.columns]

# Sorting by percentage desc
nulls_sorted = nulls.sort_values(by="percent_null",ascending=False)

# Exporting the info about the nulls
nulls_sorted.to_csv("null_info.csv")

