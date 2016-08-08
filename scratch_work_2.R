


graph_data %>%
  arrange(desc(user1_id, user2_id, connection_type)) %>%
  distinct %>% 
  {
    ddply(.
      , .variables = colnames(.)
      , .fun = function(df){
        data.frame(
          min_id = min(df$user1_id, df$user2_id)
          , max_id = max(df$user1_id, df$user2_id)
        )
      }
    ) 
  } %>% 
  group_by(min_id, max_id) %>%
  summarise(
    connection_type_0 = ifelse(
      sum(connection_type == "both_ways") > 0
      , "both_ways"
      , # This is going to get complicated. Make a function.
    )
  )