library(dplyr)
library(shiny)
library(FNN)

options(shiny.port = 2410)

# allzips <- readRDS("data/superzip.rds")
allzips <- read.csv("data/berlin_bike_accidents_neukoelln_2002_2015.csv")
xing <- read.csv("data/re_vms_detailnetz.csv")

names(xing) <- c("long", "lat", "xid")

r <- get.knnx(
  xing %>% select(long, lat) %>% data.matrix, 
  allzips %>% select(long, lat) %>% data.matrix, 
  1
) 

allzips <- allzips %>% mutate(
  latitude = jitter(lat),
  longitude = jitter(long),
  college = B2ALTER * 100,
  severity = BETEILIGTE + 2*LEICHTVERL + 5*SCHWERVERL + 10*GETOETETE,
  date = as.Date(DATUM), 
  total_injured = LEICHTVERL + SCHWERVERL + GETOETETE,
  month=substr(allzips$DATUM,6,7),
  xing = xing[r$nn.index,"xid"],
  xingdist = r$nn.dist[,1]
  )

#allzips <- allzips %>% filter(xing == 633 & xingdist < 0.0005)



cleantable <- allzips 
