# ms_etl
# This script transforms the data taken from production into two data frames and saves
# them as csv files.
# One contains all of the graph information (user connections, follows, etc.)
# The other contains the "engagement" information (posts, comments, etc.)





library(magrittr)
library(plyr)
library(dplyr)

source('fn_load_basic_schema.r')
source('fn_idvec_2_pairframe.r')
source('fn_convert_df_graph_to_igraph.r')
source('fn_determine_connection_type.r')

df_list <- load_basic_schema()

# "Extract" ####
user_connections <- df_list$USER_CONNECTIONS
posts <- df_list$POSTS
comments <- df_list$COMMENTS
follows <- df_list$FOLLOWS
space_membership <- df_list$SPACE_MEMBERSHIP

# Transform ####

# Create graph of user connections, follows, and shared spaces ####

graph_connections <- user_connections %>%
  select(user1_id = connectable1_id, user2_id =  connectable2_id) %>%
  {
    data.frame(
      user1_id = c(.$user1_id, .$user2_id)
      , user2_id = c(.$user2_id, .$user1_id)
    )
  }

graph_follows <- follows %>%
  select(user1_id = followable_id, user2_id = follower_id) 

graph_spaces <- space_membership %>%
  ddply(
    .variables = .(membershipable_id)
    , .fun = function(df){idvec_2_pairframe(df$member_id) %>% return}
  ) %>%
  select(-membershipable_id) %>%
  rename(user1_id = minimum, user2_id = maximum) %>%
  {
    data.frame(
      user1_id = c(.$user1_id, .$user2_id)
      , user2_id = c(.$user2_id, .$user1_id)
    )
  }

graph_data <- rbind(graph_connections, graph_follows, graph_spaces) %>%
  distinct %>% 
  filter(user1_id != user2_id) %>%
  arrange(user1_id, user2_id)

# Create data frame that contains all info necessary to calculate the energy score ####



# Load ####

graph_data %>%
  write.csv("graph_data.csv")
