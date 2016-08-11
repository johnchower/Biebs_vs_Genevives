# Testing the post_audience calculation

earliest_connection <- graph_data %>%
  {.$created_at} %>%
  min %>%
  floor

D <- earliest_connection + 365

graph_connections_D <- graph_connections %>% 
  filter(floor(as.numeric(created_at)) <= D)

graph_follows_D <- graph_follows %>%
  filter(floor(as.numeric(created_at)) <= D)

graph_spaces_D <- graph_spaces %>%
  filter(floor(as.numeric(created_at)) <= D)


graph_data_D <- rbind(graph_connections_D, graph_follows_D, graph_spaces_D) %>% 
  distinct %>% 
  group_by(user1_id, user2_id) %>%
  summarise(created_at = min(created_at))
