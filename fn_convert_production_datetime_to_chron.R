# Function: convert_production_datetime_to_chron

convert_production_datetime_to_chron <- function(datetime){
  datetime %>%
    {
      chron(
        dates. = substr(., 1, 10)
        , times. = substr(., 12, 19)
        , format = c(dates = "y-m-d", times = "h:m:s")
      )
    }  
}
