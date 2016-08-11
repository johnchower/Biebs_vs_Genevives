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
  melt(
    id.vars = c("date", "user_id")
    , variable.name = "postable_type"
    , value.name = "number_of_connections_created"
  ) %>%
  mutate(
    postable_type_lower = gsub("_connections_created", "", postable_type)
    , postable_type = 
        paste0(
          toupper(substr(postable_type_lower, 1, 1))
          , substr(postable_type_lower, 2, nchar(postable_type_lower))
        )
  ) %>%
  select(-postable_type_lower)