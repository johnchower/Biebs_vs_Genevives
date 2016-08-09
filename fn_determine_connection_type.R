# Function : determine_connection_type

# If one of the connection types is "both_ways", then the connection type is "both_ways"
# If there are only directional connections, but they go both ways, then output "both_ways"
# If there is only a directional connection one way, then output "1_to_2" in the correct order.

determine_connection_type <- function(df){
  both_ways_appears <- sum(df$connection_type == "both_ways") > 0
  
  distinct_u1_u2 <- df %>%
    select(user1_id, user2_id) %>%
    distinct
  
  both_directions_appear <- distinct_u1_u2 %>%
    nrow %>%
    {. > 1}
  
  
  if(both_ways_appears){
    CONNECTION_TYPE <- "both_ways"
  } else if(both_directions_appear){
    CONNECTION_TYPE <- "both_ways"
  } else {
    CONNECTION_TYPE <- "1_to_2"
  }
  
  
  CONNECTION_TYPE %>%
    {data.frame(connection_type = .)} %>%
    {cbind(distinct_u1_u2[1,], .)} %>%
    return
}