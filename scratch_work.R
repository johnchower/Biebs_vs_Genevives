# Scratch Work

# Does the conversion function work?
source('fn_convert_df_graph_to_igraph.r')

bonacich.graph.I <- 
  data.frame(tail = c(1,2,3,4), tip = c(3,3,4,5)) %>%
  convert_df_graph_to_igraph

bonacich.graph.II <-
  data.frame(tail = c("B", "C", "D", "E"), tip = rep("A", times = 4)) %>%
  convert_df_graph_to_igraph

bonacich.graph.III <-
  data.frame(tail = c("a", "b", "c", "d", "e"), tip = c("b", "c", "d", "a", "a")) %>%
  convert_df_graph_to_igraph

# Playing with centrality measures

toy_graph <- bonacich.graph.II

toy_graph %>% 
  get.adjacency %>% 
  eigen

toy_graph %>%
  alpha_centrality(alpha = 10^(2)) %>%
#  {./sum(.)} %>%
#  {.*100} %>%
  round(1)

toy_graph %>%
  power_centrality


# How long does it take on a large graph?
# Hundredths of a second on a graph with 30,000 vertices and 10,000 edges (which is where Gloo is)

vertices <- 1:30000
edges <- data.frame()
for(i in 1:choose(30000, 2)/200){
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




