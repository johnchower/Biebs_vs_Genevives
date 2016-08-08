# Function: load_basic_schema

# Function: load_basic_schema

load_basic_schema <- 
  function(
    path_user_connections = "input_csvs/user_connections.csv"
    ,
    path_posts = "input_csvs/posts.csv"
  ){
    user_connections <- path_user_connections %>%
      read.table(
        header = T
        , sep = ','
        , stringsAsFactors = F
      )
    
    posts <- path_posts %>%
      read.table(
        header = T
        , sep = ','
        , stringsAsFactors = F
      )
    
    return(list(
      USER_CONNECTIONS = user_connections
      , POSTS = posts
    ))
}


