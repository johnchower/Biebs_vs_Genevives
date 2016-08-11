# Function: calculate_connections_created

calculate_connections_created <- function(df){
  D <- df$date
  
  # 2
  
  graph_connections_D <- graph_connections %>% 
    filter(floor(as.numeric(created_at)) == D) %>%
    mutate(membershipable_id = -1, connection_type = "user_connection")
  
  graph_follows_D <- graph_follows %>%
    filter(floor(as.numeric(created_at)) == D) %>%
    mutate(membershipable_id = -1, connection_type = "follow")
  
  graph_spaces_D <- graph_spaces_with_membershipableid %>%
    filter(floor(as.numeric(created_at)) == D) %>%
    mutate(connection_type = "space")
  
  graph_connections_for_posts <- rbind(graph_connections_D, graph_follows_D, graph_spaces_D) %>% 
    group_by(user1_id) %>%
    summarise(
      timeline_connections_created = length(unique(user2_id[connection_type %in% timeline_connection_types]))
      , space_connections_created = length(unique(user2_id[connection_type %in% space_connection_types]))
    ) %>%
    rename(user_id = user1_id)
  
  # 3
  
  # user_postabletype_date_connectionscreated_D <- rbind(graph_connections_for_space_posts, graph_connections_for_timeline_posts) %>%
  #   group_by(user1_id, postable_type, membershipable_id) %>%
  #   summarise(
  #     connections_created = length(unique(user2_id))
  #   ) %>%
  #   mutate(date = D)
  
  return(graph_connections_for_posts)
}
