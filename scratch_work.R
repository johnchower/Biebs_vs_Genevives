# Scratch Work

# Does the conversion function work?
source('fn_convert_df_graph_to_igraph.r')

bonacich.frame.I <- 
  data.frame(tail = c(1,2,3,4), tip = c(3,3,4,5))

bonacich.frame.II <-
  data.frame(tail = c("B", "C", "D", "E"), tip = rep("A", times = 4))

bonacich.frame.III <-
  data.frame(tail = c("a", "b", "c", "d", "e"), tip = c("b", "c", "d", "a", "a"))

bonacich.graph.I <- convert_df_graph_to_igraph(bonacich.frame.I)
bonacich.graph.II <- convert_df_graph_to_igraph(bonacich.frame.II)
bonacich.graph.III <- convert_df_graph_to_igraph(bonacich.frame.III)

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



