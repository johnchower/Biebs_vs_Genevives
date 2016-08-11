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
  
  graph_timeline_audience_size <- rbind(graph_connections_D, graph_follows_D) %>%
    group_by(user1_id) %>%
    summarise(
      connections_created = length(unique(user2_id))
    ) %>% 
    mutate(membershipable_id = -1)
  
  graph_spaces_D <- graph_spaces_with_membershipableid %>%
    filter(floor(as.numeric(created_at)) == D) %>%
    mutate(connection_type = "space")
  
  graph_spaces_audience_size <- graph_spaces_D %>%
    group_by(user1_id, membershipable_id) %>%
    summarise(
      connections_created_space = length(unique(user2_id))
    ) %>%
    merge(
      select(graph_timeline_audience_size, user1_id, connections_created.y = connections_created)
      , by = "user1_id"
      , all.x = T
    ) %>%
    mutate(
      connections_created_timeline = 
        ifelse(is.na(connections_created.y), 0, connections_created.y)
      , connections_created = connections_created_space + connections_created_timeline
    ) %>%
    select(user1_id, membershipable_id, connections_created) %>%
    
    rbind(graph_timeline_audience_size, graph_spaces_audience_size) %>%
      mutate(
        postable_type =
          ifelse(
            membershipable_id == -1
            , "Timeline"
            , "Space"
          )
      ) %>% 
    return
}
