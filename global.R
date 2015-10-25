library(dplyr)
library(shiny)
library(FNN)
library(sp)

options(shiny.port = 2410)

# allzips <- readRDS("data/superzip.rds")
allzips <- accidents <- read.csv("data/berlin_bike_accidents_neukoelln_2002_2015.csv")

coordinates(accidents) <- c("X_SOLDNER", "Y_SOLDNER")
proj4string(accidents) <- CRS("+init=epsg:3068")
CRS.new <- CRS("+init=epsg:4326")
accidents.coords <- spTransform(accidents, CRS.new)
accidentsSp <- SpatialPoints(accidents.coords)
cc <- coordinates(accidentsSp) %>% data.frame

xing <- read.csv("data/re_vms_detailnetz.csv")
names(xing) <- c("long", "lat", "xid")

r <- get.knnx(
  xing %>% select(long, lat) %>% data.matrix, 
  allzips %>% select(long, lat) %>% data.matrix, 
  1
) 

allzips$lat <- cc$Y_SOLDNER
allzips$long <- cc$X_SOLDNER

allzips <- allzips %>% mutate(
  B1URSACHE1 = B1URSACHE1 %>% gsub("\"", "", .),
  latitude = jitter(lat),
  longitude = jitter(long),
  college = B2ALTER * 100,
  severity = BETEILIGTE + 2*LEICHTVERL + 5*SCHWERVERL + 10*GETOETETE,
  date = as.Date(DATUM), 
  year=as.numeric(substr(DATUM,1,4)),
  total_injured = LEICHTVERL + SCHWERVERL + GETOETETE,
  month=substr(allzips$DATUM,6,7),
  xing = xing[r$nn.index,"xid"],
  xingdist = r$nn.dist[,1],
  bike = (B1VERKEHRS == "Radfahrer" & B1URS1 > 0) | (B2VERKEHRS == "Radfahrer" & B2URS1 > 0),
  car = (B1VERKEHRS != "Radfahrer" & B1URS1 > 0) | (B2VERKEHRS != "Radfahrer" & B2URS1 > 0)
  )

nicons <- function(ic, n) {
  i <- icon(ic) %>% as.character
  res <- paste(replicate(n, i), collapse = "")
  return(HTML(res))
}

#allzips <- allzips %>% filter(xing == 5655 & xingdist < 0.0005)



cleantable <- allzips 
