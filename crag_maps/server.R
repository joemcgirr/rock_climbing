library(shiny)
library(tidyverse)
library(googlesheets4)
library(leaflet)

googlesheets4::gs4_deauth()
sites <- read_sheet("https://docs.google.com/spreadsheets/d/1mQcFZHitt_vI2jwdFT7HYhvsNHynVpNDf-Mt_esuFNE/edit?usp=sharing") %>% as.data.frame()
sites <- separate(sites, latitude_longitude, c("lat", "lng"), ", ", remove = TRUE) %>% mutate(lat = as.numeric(lat),lng = as.numeric(lng))

sites %>% 
leaflet() %>%
addProviderTiles(providers$Esri.WorldImagery, group = "World Imagery") %>%
addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
addLayersControl(baseGroups = c("Toner Lite", "World Imagery")) %>%
addMarkers(label = sites$crag)

server <- function(input, output, session) {

  points <- eventReactive(input$recalc, {
    cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
  }, ignoreNULL = FALSE)

  output$mymap <- renderLeaflet({
    sites %>% 
leaflet() %>%
addProviderTiles(providers$Esri.WorldImagery, group = "World Imagery") %>%
addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
addLayersControl(baseGroups = c("Toner Lite", "World Imagery")) %>%
addMarkers(label = sites$crag)
  })
}


# library(shiny)
# runApp()

# library(rsconnect)
# deployApp()