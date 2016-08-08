# ms_etl

library(magrittr)
library(dplyr)

source('fn_load_basic_schema.r')

df_list <- load_basic_schema()

# "Extract"
user_connections <- df_list$USER_CONNECTIONS
posts <- df_list$POSTS
comments <- df_list$COMMENTS
follows <- df$FOLLOWS
space_membership <- df$SPACE_MEMBERSHIP

# Transform

# Load

user_connections %>%
  write.csv(file = "user_connections.csv")

posts %>%
  write.csv(file = "posts.csv")

comments %>% 
  write.csv(file = "comments.csv")

follows %>%
  write.csv(file = "follows.csv")

space_membership %>%
  write.csv(file = "space_membership.csv")