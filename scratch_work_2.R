
# Draft up code here:

graph_data %>%
  ddply(
    .variables = colnames(.)
    , 
  )

# Code timer

times <- c()
for(j in 1:50){
  k <- 500
  start.time <- Sys.time()
  
  # Put code to time in here.
 
  
  
  end.time <- Sys.time()
  newtimes <- (end.time - start.time)*nrow(g2)/k 
  
  times %<>% c(newtimes)
}
hist(times/60)
mean(times)/60
sd(times)/60