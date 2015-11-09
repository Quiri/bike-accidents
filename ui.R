library(shiny)
library(leaflet)

WOCHENTAG_1_list <- c("Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag")
UNFALLART_list <- unique(as.character(allzips$UNFALLART_))
LICHTVERH_list = c("Tageslicht", "Daemmerung","Dunkelheit")
STRASSENZUS_list = unique(as.character(allzips$STRASSENZUS))
B1VERKEHRS_list = unique(as.character(allzips$B1VERKEHRS))
B1URSACHE1_list = unique(as.character(allzips$B1URSACHE1))
month_list = c("01", "02", "03", "04", "05", "06" ,"07", "08", "09", "10", "11", "12" )

shinyUI(

 fluidPage(  tags$h4("Berlin Bike Accidents - random data, no real accidents"),
   fluidRow(
     column(9,
      div(class="outer",

      tags$head(
        # Include our custom CSS
        includeCSS("styles.css"),
        includeScript("gomap.js")
      ),

      leafletOutput("map", width="100%", height="100%")
      # ,

    ),

#   tabPanel("Data explorer",
#     fluidRow(
#       column(3,
#         selectInput("states", "States", c("All states"="", structure(state.abb, names=state.name), "Washington, DC"="DC"), multiple=TRUE)
#       ),
#       column(3,
#         conditionalPanel("input.states",
#           selectInput("cities", "Cities", c("All cities"=""), multiple=TRUE)
#         )
#       ),
#       column(3,
#         conditionalPanel("input.states",
#           selectInput("zipcodes", "Zipcodes", c("All zipcodes"=""), multiple=TRUE)
#         )
#       )
#     ),
#     fluidRow(
#       column(1,
#         numericInput("minScore", "Min score", min=0, max=100, value=0)
#       ),
#       column(1,
#         numericInput("maxScore", "Max score", min=0, max=100, value=100)
#       )
#     ),
#     hr(),
#     DT::dataTableOutput("ziptable")
#   ),

  conditionalPanel("false", icon("crosshair"))
),
column(3,wellPanel(
  # plotOutput('plot1'),
  sliderInput("year","Year", min = 2002, max = 2014, value = c(2002,2014), animate=animationOptions(interval=2000), sep = "", ticks = FALSE),
  sliderInput("month","Month", min = 1, max = 12, value= c(1,12) , animate=animationOptions(interval=2000), ticks = FALSE),
  dateRangeInput("DATUM", "Date range", startview = "year", start = "2002-01-01"),
  selectInput("LICHTVERH", "Lightning condition", LICHTVERH_list, multiple = TRUE, selected = LICHTVERH_list, selectize=FALSE),
  selectInput("UNFALLART_", "Kind of accident", UNFALLART_list, multiple = TRUE, selected = UNFALLART_list, selectize=FALSE),
  selectInput("WOCHENTAG_1", "Day of week", WOCHENTAG_1_list, multiple = TRUE, selected = WOCHENTAG_1_list, selectize=FALSE),
  selectInput("STRASSENZUS", "Road condition", STRASSENZUS_list, multiple = TRUE, selected = STRASSENZUS_list, selectize=FALSE),
  selectInput("B1VERKEHRS", "Causer", B1VERKEHRS_list, multiple = TRUE, selected = B1VERKEHRS_list, selectize=FALSE),
  selectInput("B1URSACHE1", "Cause for accident", B1URSACHE1_list, multiple = TRUE, selected = B1URSACHE1_list, selectize=FALSE),
  style = "overflow-y:auto;border-right:solid, height: 600px"
)))
)
#)
)
