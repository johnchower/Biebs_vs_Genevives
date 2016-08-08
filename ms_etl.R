# ms_etl

library(magrittr)
library(plyr)
library(dplyr)

source('fn_load_basic_schema.r')
source('fn_idvec_2_pairframe.r')
source('fn_convert_df_graph_to_igraph.r')

df_list <- load_basic_schema()

# "Extract" ####
user_connections <- df_list$USER_CONNECTIONS
posts <- df_list$POSTS
comments <- df_list$COMMENTS
follows <- df_list$FOLLOWS
space_membership <- df_list$SPACE_MEMBERSHIP

# Transform ####

# Create graph of user connections, follows, and shared spaces

graph_connections <- user_connections %>%
  select(user1_id = connectable1_id, user2_id =  connectable2_id) %>%
  mutate(connection_type = "both_ways")

graph_follows <- follows %>%
  select(user1_id = followable_id, user2_id = follower_id) %>%
  mutate(connection_type = "1_to_2")

graph_spaces <- space_membership %>%
  ddply(
    .variables = .(membershipable_id)
    , .fun = function(df){idvec_2_pairframe(df$member_id) %>% return}
  ) %>%
  select(-membershipable_id) %>%
  rename(user1_id = minimum, user2_id = maximum) %>%
  mutate(connection_type = "both_ways")

graph_data <- rbind(graph_connections, graph_follows, graph_spaces)
  

# Load ####

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