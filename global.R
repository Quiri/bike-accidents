library(dplyr)

# allzips <- readRDS("data/superzip.rds")
allzips <- read.csv("berlin_bike_accidents_neukoelln_2002_2015.csv")
allzips$latitude <- jitter(allzips$lat)
allzips$longitude <- jitter(allzips$long)
allzips$college <- allzips$B2ALTER * 100
# allzips$zipcode <- formatC(allzips$zipcode, width=5, format="d", flag="0")
# row.names(allzips) <- allzips$zipcode

# cleantable <- allzips %>%
#   select(
#     City = city.x,
#     State = state.x,
#     Zipcode = zipcode,
#     Rank = rank,
#     Score = centile,
#     Superzip = superzip,
#     Population = adultpop,
#     College = college,
#     Income = income,
#     Lat = latitude,
#     Long = longitude
#   )

cleantable <- allzips 
