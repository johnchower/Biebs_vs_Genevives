# Function find_number_of_connections

find_number_of_connections <- function(
  user.id
  , postable.type = "Space"
  , date.of.post = 17021
  , connections_created_data
){
  connections_created_data %>%
    filter(
      user_id == user.id
      , postable_type == postable.type
      , created_at <= date.of.post
    ) %>%
    {.$number_of_connections_created} %>%
    sum
}