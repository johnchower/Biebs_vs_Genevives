# ms_etl
# This script transforms the data taken from production into two data frames and saves
# them as csv files.
# One contains all of the graph information (user connections, follows, etc.)
# The other contains the "engagement" information (posts, comments, etc.)





library(magrittr)
library(plyr)
library(dplyr)
library(chron)

source('fn_load_basic_schema.r')
source('fn_idvec_2_pairframe.r')
source('fn_convert_df_graph_to_igraph.r')
source('fn_determine_connection_type.r')
source('fn_convert_production_datetime_to_chron.r')

df_list <- load_basic_schema()

# "Extract" ####
user_connections <- df_list$USER_CONNECTIONS 

convert_at_variables_commands <- user_connections %>%
  colnames %>%
  grep("_at", ., value = T) %>%
  paste(
    "user_connections %>% "
    , "mutate("
    , .
    , " = convert_production_datetime_to_chron("
    , .
    , "))"
    , sep = ""
  ) %>%
  as.list 

convert_at_variables_commands %>%
  lapply(FUN = function(string)
    {
      x <- eval(parse(text = string))
      assign("user_connections", x, envir = globalenv())
    }) %>% 
  invisible

rm(convert_at_variables_commands)

posts <- df_list$POSTS %>%
  mutate(created_at = convert_production_datetime_to_chron(created_at))

comments <- df_list$COMMENTS %>%
  mutate(created_at = convert_production_datetime_to_chron(created_at))

follows <- df_list$FOLLOWS %>%
  mutate(created_at = convert_production_datetime_to_chron(created_at))

space_membership <- df_list$SPACE_MEMBERSHIP %>%
  mutate(created_at = convert_production_datetime_to_chron(created_at))

rm(df_list)

# Transform ####

# Create graph of user connections, follows, and shared spaces ####

graph_connections <- user_connections %>%
  select(user1_id = connectable1_id, user2_id =  connectable2_id, created_at = updated_at) %>%
  {
    data.frame(
      user1_id = c(.$user1_id, .$user2_id)
      , user2_id = c(.$user2_id, .$user1_id)
      , created_at = rep(.$created_at, times = 2)
    )
  }

# Spaces graphs
graph_spaces_0 <- space_membership %>%
  group_by(membershipable_id) %>%
  do(idvec_2_pairframe(.))

graph_spaces_with_membershipableid <- graph_spaces_0 %>%
  group_by(user1_id, user2_id, membershipable_id) %>% 
  summarise(created_at = min(created_at)) %>% 
  {
    data.frame(
      user1_id = c(.$user1_id, .$user2_id)
      , user2_id = c(.$user2_id, .$user1_id)
      , created_at = rep(.$created_at, times = 2)
      , membershipable_id = rep(.$membershipable_id, times = 2)
    )
  }

graph_spaces_without_membershipableid <- graph_spaces_0 %>%
  group_by(user1_id, user2_id) %>% 
  summarise(created_at = min(created_at)) %>% 
  {
    data.frame(
      user1_id = c(.$user1_id, .$user2_id)
      , user2_id = c(.$user2_id, .$user1_id)
      , created_at = rep(.$created_at, times = 2)
    )
  }
######################

graph_follows <- follows %>%
  select(user1_id = followable_id, user2_id = follower_id, created_at) 

graph_data <- 
  rbind(
    graph_connections
    , graph_follows
    , graph_spaces_without_membershipableid
  ) %>% 
  distinct %>% 
  group_by(user1_id, user2_id) %>%
  summarise(created_at = min(created_at))

# Create data frame that contains all info necessary to calculate the energy score ####

# Comments on posts



comments %>%
  select(user_id, post_id) %>%
  left_join(
    select(posts, id, owner_id)
    , by = c ("post_id" = "id")
  ) %>% 
  group_by(owner_id, post_id) %>%
  summarise(number_of_comments = n()) %>% 
  ungroup %>%
  group_by(owner_id) %>%
  summarise(
    number_of_posts = length(unique(post_id))
    , number_of_comments = sum(number_of_comments)
  ) %>%
  arrange(desc(number_of_comments), owner_id) %>% View
  

# Load ####

graph_data %>%
  write.csv("graph_data.csv")
