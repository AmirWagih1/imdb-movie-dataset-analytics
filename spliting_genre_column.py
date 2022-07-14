#                       ----Splitting Genre Column to multiple rows----

import pandas as pd

movs = pd.read_csv("movies.csv")

movs_2 = movs[["imdb_title_id" , "genre"]]

num_rows = len(movs)

new_df = pd.DataFrame({"imdb_title_id": [], "genre": []})
for index , row in movs_2.iterrows():
    genre_split = map(lambda val : val.strip(","),row["genre"].split())
    for genra_ in genre_split:
      print(f'{round((index/num_rows)*100 , 2)}% done \n')  # debugging
      new_df = new_df.append({"imdb_title_id": row["imdb_title_id"], "genre": genra_} , ignore_index=True)

print(new_df.head())

new_df = new_df.rename(columns={"genre":"genre_split"})

# Exporting the new converted column

new_df.to_csv("genre_split.csv")

# Joining the original table with split genres

movies = pd.read_csv("movies.csv").drop("genre" , 1)

genre_split = pd.read_csv("genre_split.csv")

joined_df = movies.set_index("imdb_title_id").join(other=genre_split.set_index("imdb_title_id"), how="inner")

joined_df.to_csv("movies_genre_split.csv")
