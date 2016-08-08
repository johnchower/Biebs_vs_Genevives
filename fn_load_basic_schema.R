# Function: load_basic_schema

# Function: load_basic_schema

load_basic_schema <- 
  function(
    path_user_connections = "input_csvs/user_connections.csv"
    ,
    path_posts = "input_csvs/posts.csv"
    ,
    path_comments = "input_csvs/comments.csv"
    ,
    path_follows = "input_csvs/follows.csv"
    ,
    path_space_membership = "input_csvs/space_membership.csv"
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
    
    comments <- path_comments %>%
      read.table(
        header = T
        , sep = ','
        , stringsAsFactors = F
      )
    
    follows <- path_follows %>%
      read.table(
        header = T
        , sep = ','
        , stringsAsFactors = F
      )
    
    space_membership <- path_space_membership %>%
      read.table(
        header = T
        , sep = ','
        , stringsAsFactors = F
      )
    
    return(list(
      USER_CONNECTIONS = user_connections
      , POSTS = posts
      , COMMENTS = comments
      , FOLLOWS = follows
      , SPACE_MEMBERSHIP = space_membership
    ))
}


