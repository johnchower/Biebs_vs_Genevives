# Function: convert_df_graph_to_igraph
# Requires packages igraph and magrittr

# cols specifies which columns hold the user ids

convert_df_graph_to_igraph <- 
  function(
    df
    , data_cols = 1:2
    , connection_type_col = 3
    ,...
    ){
  
  is.directed <- df[, connection_type_col] %>%
    as.character %>%
    {sum(.!="both_ways") > 0}
  
  df[,data_cols] %>%
    apply(
      1
      , function(e){e}
    ) %>% 
    c %>%
    make_graph(
      ...
      , 
      directed = is.directed
    ) %>%
    return
}