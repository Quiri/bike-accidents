library(dplyr)

# allzips <- readRDS("data/superzip.rds")
allzips <- read.csv("data/berlin_bike_accidents_neukoelln_2002_2015.csv")

allzips <- allzips %>% mutate(
  latitude = jitter(lat),
  longitude = jitter(long),
  college = B2ALTER * 100,
  severity = BETEILIGTE + 2*LEICHTVERL + 5*SCHWERVERL + 10*GETOETETE,
  total_injured = LEICHTVERL + SCHWERVERL + GETOETETE
  )


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
