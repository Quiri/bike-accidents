library(shiny)
library(leaflet)

# Choices for drop-downs
# vars <- c(
#   "Is SuperZIP?" = "somecolor",
#   "Centile score" = "centile",
#   "College education" = "college",
#   "Median income" = "income",
#   "Population" = "adultpop"
# )

# select_color_by <- c(
#   "Number_of_people_slightly_injured",
#   "Number_of_people_severely_injured",
#   "Number_of_people_dead",
#   "Total_number_of_people_injured",
#   "Weighted_severety"
# )


WOCHENTAG_1_list <- c("Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag")
UNFALLART_list <- unique(as.character(allzips$UNFALLART_))
LICHTVERH_list = c("Tageslicht", "Daemmerung","Dunkelheit")
STRASSENZUS_list = unique(as.character(allzips$STRASSENZUS))
B1VERKEHRS_list = unique(as.character(allzips$B1VERKEHRS))
B1URSACHE1_list = unique(as.character(allzips$B1URSACHE1))
month_list = c("01", "02", "03", "04", "05", "06" ,"07", "08", "09", "10", "11", "12" )

shinyUI(
#   navbarPage("Berlin Neukölln Bike Accidents", id="nav",

                   fluidPage(  tags$h4("Berlin Neukölln Bike Accidents"),
                     fluidRow(

                     column(9,
#  tabPanel("Interactive map",
    div(class="outer",

      tags$head(
        # Include our custom CSS
        includeCSS("styles.css"),
        includeScript("gomap.js")
      ),

      leafletOutput("map", width="100%", height="100%")
      # ,

      # Shiny versions prior to 0.11 should use class="modal" instead.
#       absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
#         draggable = TRUE, top = 60, left =20 , right ="auto", bottom = "auto",
#         width = 250, height = "auto",
# 
#         h2("Filter"),
# 
# 
#         #selectInput("color", "Color by", select_color_by),
#         #selectInput("size", "Size", vars, selected = "adultpop"),
# #         selectInput("color", "Color", vars),
# #         selectInput("size", "Size", vars, selected = "adultpop"),
# 
# dateRangeInput("DATUM", label = h3("Date range"), startview = "year", start = "2002-01-01"),
# selectInput("LICHTVERH", "Lightning condition", day_time, multiple = TRUE, selected = day_time, selectize=FALSE),
# selectInput("UNFALLART_", "Kind of accident", accident_kind, multiple = TRUE, selected = accident_kind, selectize=FALSE),
# selectInput("WOCHENTAG_1", "Day of week", wdays, multiple = TRUE, selected = wdays, selectize=FALSE),
# selectInput("STRASSENZUS", "Road condition", strassenzust_list, multiple = TRUE, selected = strassenzust_list, selectize=FALSE),
# selectInput("B1VERKEHRS", "Causer", B1VERKEHRS_list, multiple = TRUE, selected = "Radfahrer", selectize=FALSE),
# selectInput("B1URSACHE1", "Cause for accident", B1URSACHE1_list, multiple = TRUE, selected = B1URSACHE1_list, selectize=FALSE)
# 
# 
# 
# # , 
# #         , 
# # 
# #          conditionalPanel("input.color == 'superzip' || input.size == 'superzip'",
# #            # Only prompt for threshold when coloring or sizing by superzip
# #            numericInput("threshold", "SuperZIP threshold (top n percentile)", 5)
# #          )
# 
# 
# #         ,
# 
# #         plotOutput("histCentile", height = 200),
# #         plotOutput("scatterCollegeIncome", height = 250)
#       )
# ,

#       tags$div(id="cite",
#         'Data compiled for ', tags$em('Coming Apart: The State of White America, 1960–2010'), ' by Charles Murray (Crown Forum, 2012).'
#       )
    ),
#  ),

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
  dateRangeInput("DATUM", "Date range", startview = "year", start = "2002-01-01"),
  selectInput("month", "Month", month_list, multiple = TRUE, selected = month_list, selectize=FALSE),
  selectInput("LICHTVERH", "Lightning condition", LICHTVERH_list, multiple = TRUE, selected = LICHTVERH_list, selectize=FALSE),
  selectInput("UNFALLART_", "Kind of accident", UNFALLART_list, multiple = TRUE, selected = UNFALLART_list, selectize=FALSE),
  selectInput("WOCHENTAG_1", "Day of week", WOCHENTAG_1_list, multiple = TRUE, selected = WOCHENTAG_1_list, selectize=FALSE),
  selectInput("STRASSENZUS", "Road condition", STRASSENZUS_list, multiple = TRUE, selected = STRASSENZUS_list, selectize=FALSE),
  selectInput("B1VERKEHRS", "Causer", B1VERKEHRS_list, multiple = TRUE, selected = "Radfahrer", selectize=FALSE),
  selectInput("B1URSACHE1", "Cause for accident", B1URSACHE1_list, multiple = TRUE, selected = B1URSACHE1_list, selectize=FALSE),
  style = "overflow-y:auto;border-right:solid, height: 600px"
)))
)
#)
)