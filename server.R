library(shiny)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

# Leaflet bindings are a bit slow; for now we'll just sample to compensate
set.seed(100)
# zipdata <- allzips[sample.int(nrow(allzips), 1000000000000),]


# By ordering by centile, we ensure that the (comparatively rare) SuperZIPs
# will be drawn last and thus be easier to see
# zipdata <- zipdata[order(zipdata$centile),]
# select_color_by_variable <- list(
#   Weekday = 'WOCHENTAG_1',
#   Number_of_people_slightly_injured = 'LEICHTVERL',
#   Number_of_people_severely_injured = 'SCHWERVERL',
#   Number_of_people_dead = 'GETOETETE',
#   Total_number_of_people_injured = 'total_injured',
#   Weighted_severety = 'severity'
#   
# )


shinyServer(function(input, output, session) {

  ## Interactive Map ###########################################

  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = 13.44201, lat = 52.46765517, zoom = 15)
  })
  52.46765517
  # A reactive expression that returns the set of zips that are
  # in bounds right now
  zipsInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(zipdata[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)

    subset(zipdata,
      latitude >= latRng[1] & latitude <= latRng[2] &
        longitude >= lngRng[1] & longitude <= lngRng[2])
  })

  # Precalculate the breaks we'll need for the two histograms
#   centileBreaks <- hist(plot = FALSE, allzips$centile, breaks = 20)$breaks

#   output$histCentile <- renderPlot({
#     # If no zipcodes are in view, don't plot
#     if (nrow(zipsInBounds()) == 0)
#       return(NULL)
# 
#     hist(zipsInBounds()$centile,
#       breaks = centileBreaks,
#       main = "SuperZIP score (visible zips)",
#       xlab = "Percentile",
#       xlim = range(allzips$centile),
#       col = '#00DD00',
#       border = 'white')
#   })

#   output$scatterCollegeIncome <- renderPlot({
#     # If no zipcodes are in view, don't plot
#     if (nrow(zipsInBounds()) == 0)
#       return(NULL)
# 
#     print(xyplot(income ~ college, data = zipsInBounds(), xlim = range(allzips$college), ylim = range(allzips$income)))
#   })

  # This observer is responsible for maintaining the circles and legend,
  # according to the variables the user has chosen to map to color and size.
  observe({
    zipdata <- allzips
    zipdata <- zipdata[(as.character(allzips$UNFALLART_) %in% input$UNFALLART_),]
    zipdata <- zipdata[(as.character(allzips$WOCHENTAG_1) %in%  input$WOCHENTAG_1),]
    zipdata <- zipdata[(as.character(allzips$LICHTVERH) %in%  input$LICHTVERH),]
    zipdata <- zipdata[(as.character(allzips$STRASSENZUS) %in%  input$STRASSENZUS),]
    zipdata <- zipdata[(as.character(allzips$B1VERKEHRS) %in%  input$B1VERKEHRS),]
    zipdata <- zipdata[(as.character(allzips$B1URSACHE1) %in%  input$B1URSACHE1),]
    zipdata <- zipdata[(as.character(allzips$month) %in%  input$month),]
    
                
    zipdata <- zipdata %>% filter(date >= as.Date(input$DATUM[1]) & date <= as.Date(input$DATUM[2]))
    
    #zipdata <- zipdata[(allzips[select_color_by_variable[[input$color]]]) > 0, ]
    
#    zipdata <- zipdata[]
#    colorBy <- select_color_by_variable[[input$color]]
#    sizeBy <- 'WOCHENTAG_1'  

#     if (colorBy == "somecolor") {
#       # Color and palette are treated specially in the "superzip" case, because
#       # the values are categorical instead of continuous.
#       colorData <- ifelse(zipdata$lat >= (100 - input$threshold), "yes", "no")
#       pal <- colorFactor("Spectral", colorData)
#     } 
#     else { 
# #      if (colorBy == "severity") {
#         colorData <- na.omit(zipdata[select_color_by_variable[[input$color]]])
#         pal <- colorBin("YlOrRd", colorData, 5, pretty = FALSE)
#         print(pal)
#         
# #       }
# #       else{
# #         #colorData <- unique(zipdata[[colorBy]])
# #         colorData <- c(1:7)
# #         #pal <- colorBin("Spectral", colorData, 7, pretty = FALSE)
# #       }
#     }
    
#     pal <- colorBin("Reds", c(0,1), 6)
# 
#     if (sizeBy == "somecolor") {
#       # Radius is treated specially in the "superzip" case.
#       radius <- ifelse(zipdata$centile >= (100 - input$threshold), 30000, 3000)
#     } else {
#       radius <- zipdata[[sizeBy]] / max(zipdata[[sizeBy]]) * 30000
#     }

radius <- 10 # zipdata[["severity"]] * 5

    leafletProxy("map", data = zipdata) %>%
      clearShapes() %>%
      addCircles(~longitude, ~latitude, radius=radius, layerId=~PAGINIER,
        stroke=FALSE, fillOpacity=0.4, fillColor='red') # %>%  #pal(colorData)
#       addLegend("bottomleft", pal=pal, values=colorData, title=colorBy,
#         layerId="colorLegend")
  })

##  Show a popup at the given location
  showZipcodePopup <- function(id, lat, lng) {
    u <- allzips %>% filter(PAGINIER == id)
    selectedXing <- allzips %>% 
      filter(xing == u$xing) %>%
      filter(xingdist < 0.0005)
    
        
    cat(nrow(allzips), nrow(u), nrow(selectedXing), id, sum(selectedXing$LEICHTVERL))
    
    streetview <- sprintf("http://maps.google.com/maps?q=&layer=c&cbll=%s,%s&cbp=12,%s,0,0,%s",
                          u$lat,u$long,90,10)
    
    content <- as.character(tagList(
      tags$a(href = streetview, "Street View"),
      br(),
      tags$h3("Unfall"),
      div(tags$strong("Leichtverletze: "), HTML(nicons("male", u$LEICHTVERL))),
      div(tags$strong("Schwerverletze: "), HTML(nicons("male", u$SCHWERVERL))),
      div(tags$strong("Getötete: "), HTML(nicons("male", u$GETOETETE))),
      div(tags$strong("Verursacher: "),
          if(u$car) { icon("car") }, 
          if(u$bike) { icon("bicycle") }
      ),
      tags$h3("Kreuzung"),
      div(tags$strong("Leichtverletze: "), HTML(nicons("male",sum(selectedXing$LEICHTVERL)))),
      div(tags$strong("Schwerverletze: "), HTML(nicons("male",sum(selectedXing$SCHWERVERL)))),
      div(tags$strong("Getötete: "), HTML(nicons("male",sum(selectedXing$GETOETETE)))),
      div(tags$strong("Verursacher: "), 
          HTML(nicons("car", sum(selectedXing$car))),
          HTML(nicons("bicycle", sum(selectedXing$bike)))
      ),
      div(u$xing)
    ))
    leafletProxy("map") %>% 
      addPopups(lng, lat, content, layerId = id, 
                options = popupOptions(minWidth = 200, maxWidth = 800))
  }
  
## 

## When map is clicked, show a popup with city info
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
#    print(names(event))
#    cat(event$id, event$lat, event$lng, "\n")
    if (is.null(event))
      return()

    isolate({
      showZipcodePopup(event$id, event$lat, event$lng)
    })
  })


  ## Data Explorer ###########################################

#   observe({
#     cities <- if (is.null(input$states)) character(0) else {
#       filter(cleantable, State %in% input$states) %>%
#         `$`('City') %>%
#         unique() %>%
#         sort()
#     }
#     stillSelected <- isolate(input$cities[input$cities %in% cities])
#     updateSelectInput(session, "cities", choices = cities,
#       selected = stillSelected)
#   })
# 
#   observe({
#     zipcodes <- if (is.null(input$states)) character(0) else {
#       cleantable %>%
#         filter(State %in% input$states,
#           is.null(input$cities) | City %in% input$cities) %>%
#         `$`('Zipcode') %>%
#         unique() %>%
#         sort()
#     }
#     stillSelected <- isolate(input$zipcodes[input$zipcodes %in% zipcodes])
#     updateSelectInput(session, "zipcodes", choices = zipcodes,
#       selected = stillSelected)
#   })
# 
#   observe({
#     if (is.null(input$goto))
#       return()
#     isolate({
#       map <- leafletProxy("map")
#       map %>% clearPopups()
#       dist <- 0.5
#       zip <- input$goto$zip
#       lat <- input$goto$lat
#       lng <- input$goto$lng
#       showZipcodePopup(zip, lat, lng)
#       map %>% fitBounds(lng - dist, lat - dist, lng + dist, lat + dist)
#     })
#   })

#   output$ziptable <- DT::renderDataTable({
#     df <- cleantable %>%
#       filter(
#         Score >= input$minScore,
#         Score <= input$maxScore,
#         is.null(input$states) | State %in% input$states,
#         is.null(input$cities) | City %in% input$cities,
#         is.null(input$zipcodes) | Zipcode %in% input$zipcodes
#       ) %>%
#       mutate(Action = paste('<a class="go-map" href="" data-lat="', Lat, '" data-long="', Long, '" data-zip="', Zipcode, '"><i class="fa fa-crosshairs"></i></a>', sep=""))
#     action <- DT::dataTableAjax(session, df)
# 
#     DT::datatable(df, options = list(ajax = list(url = action)), escape = FALSE)
#   })
})
