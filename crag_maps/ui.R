library(shiny)
library(tidyverse)
library(googlesheets4)
library(leaflet)


ui <- fluidPage(
	titlePanel("Crags Climbed by Joe and Kimiko"),
  leafletOutput("mymap"),
  p(),
  actionButton("recalc", "New points")
)

