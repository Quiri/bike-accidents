library(rgdal) 
library(rgeos)

accidents <- read.csv('berlin_bike_accidents_neukoelln_2002_2015.csv')
intersections <- read.csv('re_vms_detailnetz.csv')

coordinates(accidents) <- c("long", "lat")
coordinates(intersections) <- c("x_wks84", "y_wks84")

proj4string(accidents) <- CRS("+init=epsg:4326")
proj4string(intersections) <- CRS("+init=epsg:4326")

# WGS84
CRS.new <- CRS("+init=epsg:4326")

accidents.coords <- spTransform(accidents, CRS.new)
intersections.coords <- spTransform(intersections, CRS.new)

accidentsSp <- SpatialPoints(accidents.coords)
intersectionsSp<- SpatialPoints(intersections.coords)
accidents$nearest_intersection <- apply(gDistance(accidentsSp, intersectionsSp, byid=TRUE), 1, which.min)
