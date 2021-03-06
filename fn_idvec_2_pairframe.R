# Function: idvec_2_pairframe

# Converts a vector, v, to a data frame with (length(v) choose 2) rows and 2 columns.
# Each row is a pair of elements of v.

idvec_2_pairframe <- function(df){
  
  if(nrow(df) <= 1){
    return(data.frame())
  } else{
    df %>%
      select(member_id, created_at) %>% 
      {
        merge(
          x = .
          , y = .
          , by = c()
        )
      } %>% 
      filter(member_id.x < member_id.y) %>%
      distinct(member_id.x, member_id.y, .keep_all = T) %>% 
      group_by(member_id.x, member_id.y) %>% 
      mutate(created_at = max(created_at.x, created_at.y)) %>% 
      ungroup %>% 
      select(user1_id = member_id.x, user2_id = member_id.y, created_at) %>% 
      mutate(membershipable_id = df$membershipable_id[1]) %>%
      return 
  }
}