# Testing the post_audience calculation

source('fn_calculate_connections_created.r')

earliest_connection <- graph_data %>%
  {.$created_at} %>%
  min %>%
  floor 

latest_connection <- graph_data %>%
  {.$created_at} %>%
  max %>%
  floor 

date_sequence <- data.frame(date = earliest_connection:latest_connection)


user_date_connectionscreated <- date_sequence %>% 
  group_by(date) %>%
  do(calculate_connections_created(.)) %>%
  rename(user_id = user1_id) 

user_date_connectionscreated %>%
  group_by(user_id, membershipable_id, postable_type) %>%
  arrange(date) %>%
  mutate(existing_connections = cumsum(connections_created)) %>%
  ungroup %>%
  arrange(user_id, membershipable_id, postable_type, date) %>%
  View

user_date_connectionsexisting <- user_date_connectionscreated %>%
  group_by(user_id, membershipable_id, postable_type) %>%
  arrange(date) %>%
  mutate(connections_existing = cumsum(connections_created)) %>% ungroup %>%
  select(-connections_created) %>%
  mutate(space_id = membershipable_id)

posts %<>%
  mutate(
    date = floor(as.numeric(created_at))
    , space_id = ifelse(postable_type == "Timeline", -1, postable_id)
  )

start.time <- Sys.time()
post_reach_0 <- posts %>%
   left_join(user_date_connectionsexisting, by = c("postable_type", "user_id", "date", "space_id"))

post_reach_na <- post_reach_0 %>%
  filter(is.na(connections_existing))

post_reach <- post_reach_0 %>% filter(!is.na(connections_existing))

num_iterations <- 0
while(nrow(post_reach_na) > 0){
  post_reach_i <- post_reach %>%
    mutate(date = date - 1) %>%
    select(-connections_existing) %>%
    left_join(user_date_connectionsexisting, by = c("postable_type", "user_id", "date", "space_id"))
  
  post_reach_na <- post_reach_i %>%
    filter(is.na(connections_existing))
  
  post_reach <- post_reach_i %>% 
    filter(!is.na(connections_existing))
  
  num_iterations %<>% {. + 1}
  print(num_iterations)
}

end.time <- Sys.time() 
end.time-start.time

   
   