# Scratch Work

# Does the conversion function work?
source('fn_convert_df_graph_to_igraph.r')

connections.frame <- 
  data.frame(tip = c(1,2,3,4), tail = c(3,3,4,5))

connections.graph <- convert_df_graph_to_igraph(connections.frame)

# How long does it take on a large graph?
# Hundredths of a second on a graph with 30,000 vertices and 10,000 edges (which is where Gloo is)

vertices <- 1:30000
edges <- data.frame()
for(i in 1:10000){
  new_edge <- sample(vertices, 2, replace = F) %>%
    t %>%
    data.frame %>%
    {
      colnames(.) <- c("tip", "tail")
      return(.)
    }
  
  edges %<>% 
    rbind(new_edge) 
}

edges %<>% unique
system.time(large.graph <- convert_df_graph_to_igraph(edges))



