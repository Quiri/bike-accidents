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
select_color_by_variable <- list(
  Weekday = 'WOCHENTAG_1',
  Number_of_people_slightly_injured = 'LEICHTVERL',
  Number_of_people_severely_injured = 'SCHWERVERL',
  Number_of_people_dead = 'GETOETETE',
  Total_number_of_people_injured = 'total_injured',
  Weighted_severety = 'severity'
  
)


shinyServer(function(input, output, session) {

  ## Interactive Map ###########################################

  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = 13.42743, lat = 52.45615, zoom = 13)
  })

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
<<<<<<< HEAD
    zipdata <- zipdata %>% filter(date >= as.Date(input$DATUM[1]) & date <= as.Date(input$DATUM[2]))
#     colorBy <- input$color
#     sizeBy <- input$size
    cat()
    colorBy <- 'WOCHENTAG_1'
=======
    print(str(select_color_by_variable[[input$color]][1]))
    print(allzips$select_color_by_variable[[input$color]])
    zipdata <- zipdata[(allzips[select_color_by_variable[[input$color]]]) > 0, ]
    # zipdata[(as.numeric(allzips$LEICHTVERL)>0),]
    zipdata <- zipdata[]
    colorBy <- select_color_by_variable[[input$color]]
>>>>>>> db21297295284c18cf15bfbb880cb499026a3165
    sizeBy <- 'WOCHENTAG_1'  
    head(zipdata['severity'])
    if (colorBy == "somecolor") {
      # Color and palette are treated specially in the "superzip" case, because
      # the values are categorical instead of continuous.
      colorData <- ifelse(zipdata$lat >= (100 - input$threshold), "yes", "no")
      pal <- colorFactor("Spectral", colorData)
    } 
    else { 
#      if (colorBy == "severity") {
        colorData <- na.omit(zipdata[select_color_by_variable[[input$color]]])
        pal <- colorBin("YlOrRd", colorData, 5, pretty = FALSE)
        print(pal)
        
#       }
#       else{
#         #colorData <- unique(zipdata[[colorBy]])
#         colorData <- c(1:7)
#         #pal <- colorBin("Spectral", colorData, 7, pretty = FALSE)
#       }
    }
    
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
<<<<<<< HEAD
      addCircles(~longitude, ~latitude, radius=radius, layerId=~PAGINIER,
        stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData)) %>%
=======
      addCircles(~longitude, ~latitude, radius=radius, layerId=~lat,
        stroke=FALSE, fillOpacity=0.4, fillColor='red') %>%  #pal(colorData)
>>>>>>> db21297295284c18cf15bfbb880cb499026a3165
      addLegend("bottomleft", pal=pal, values=colorData, title=colorBy,
        layerId="colorLegend")
  })

##  Show a popup at the given location
  showZipcodePopup <- function(id, lat, lng) {
    selectedZip <- allzips %>% filter(PAGINIER == id)
    
    cat(nrow(allzips), nrow(selectedZip))
    cat(id)
    
    streetview <- sprintf("http://maps.google.com/maps?q=&layer=c&cbll=%s,%s&cbp=12,%s,0,0,%s",
                          lat,lng,90,10)
    
    content <- as.character(tagList(
      tags$a(href = streetview, "Street View"),
      if(selectedZip$B1URS1 > 0) { icon("car") }, 
      if(selectedZip$B2URS1 > 0) { icon("bicycle") },
      tags$strong(HTML(sprintf("%s, %s %s",
        selectedZip$city.x, selectedZip$state.x, selectedZip$zipcode
      ))), tags$br(),
    ))
    leafletProxy("map") %>% addPopups(lng, lat, content, layerId = id)
  }
  
## 

## When map is clicked, show a popup with city info
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    print(names(event))
    cat(event$id, event$lat, event$lng, "\n")
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
