# Function: idvec_2_pairframe

# Converts a vector, v, to a data frame with (length(v) choose 2) rows and 2 columns.
# Each row is a pair of elements of v.

idvec_2_pairframe <- function(v){
  v %>%
    {
      merge(
        x = data.frame(vec1 = .)
        , y = data.frame(vec2 = .)
        , all = T
      )
    } %>%
    group_by(vec1, vec2) %>%
    mutate(minimum = min(vec1, vec2), maximum = max(vec1, vec2)) %>% 
    ungroup %>%
    distinct(minimum, maximum) %>% 
    filter(minimum != maximum) %>%
    return
}