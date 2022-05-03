library(shiny)
library(tidyverse)
library(googlesheets4)
library(leaflet)
library(shinydashboard)
library(DT)


# ui <- fluidPage(
# 	# Dashboard title
# 	titlePanel("Crags Climbed by Joe and Kimiko"),
# 	
#   leafletOutput("mymap"),
#   p(),
#   actionButton("recalc", "New points")
# )

googlesheets4::gs4_deauth()
locations <- read_sheet("https://docs.google.com/spreadsheets/d/1mQcFZHitt_vI2jwdFT7HYhvsNHynVpNDf-Mt_esuFNE/edit?usp=sharing", sheet = "locations") %>% as.data.frame()
locations <- separate(locations, latitude_longitude, c("lat", "lng"), ", ", remove = TRUE) %>% mutate(lat = as.numeric(lat),lng = as.numeric(lng))


ui <- dashboardPage(
	
  dashboardHeader(title = "Crags We've Climbed"),
  dashboardSidebar(),
	
  dashboardBody(
  	
  	fluidRow(
  	
  		  leafletOutput("mymap"),
  			p()
  	),
  	
  	fluidRow(
  		
  		sidebarPanel(
      selectInput("selectedCrag", h4("Crag"), choices = as.list(sort(locations$crag)), selected = "Mickey's Beach"),
      width = 4), 
    	
      #mainPanel(plotOutput(outputId = "route_plot")),
  		
  		#mainPanel(DTOutput("route_table"))

      ),
  	
  	fluidRow(
  		
  		mainPanel(plotOutput(outputId = "route_plot"))	
  		
  	),
  	
  	fluidRow(
  		
  		mainPanel(DTOutput("route_table"))	
  		
  	)
  		
  )
)
