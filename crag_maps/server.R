library(shiny)
library(tidyverse)
library(googlesheets4)
library(leaflet)
library(shinydashboard)
library(gridExtra)
library(DT)


googlesheets4::gs4_deauth()
locations <- read_sheet("https://docs.google.com/spreadsheets/d/1mQcFZHitt_vI2jwdFT7HYhvsNHynVpNDf-Mt_esuFNE/edit?usp=sharing") %>% as.data.frame()
locations <- separate(locations, latitude_longitude, c("lat", "lng"), ", ", remove = TRUE) %>% mutate(lat = as.numeric(lat),lng = as.numeric(lng))
routes <- read_sheet("https://docs.google.com/spreadsheets/d/1mQcFZHitt_vI2jwdFT7HYhvsNHynVpNDf-Mt_esuFNE/edit?usp=sharing", sheet = "routes") %>% as.data.frame()

# locations %>% 
# leaflet() %>%
# addProviderTiles(providers$Esri.WorldImagery, group = "World Imagery") %>%
# addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
# addLayersControl(baseGroups = c("Toner Lite", "World Imagery")) %>%
# addMarkers(label = locations$crag)

server <- function(input, output, session) {

  # points <- eventReactive(input$recalc, {
  #   cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
  # }, ignoreNULL = FALSE)

  output$mymap <- renderLeaflet({
    locations %>% 
leaflet() %>%
addProviderTiles(providers$Esri.WorldImagery, group = "World Imagery") %>%
addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
addLayersControl(baseGroups = c("Toner Lite", "World Imagery")) %>%
addMarkers(label = locations$crag)
  })
  
  
  output$route_plot <- renderPlot({
  	
  	selected_crag <- input$selectedCrag

		p1 <- filter(routes,crag == selected_crag, type == "boulder") |>
			ggplot(aes(difficulty)) + 
			geom_bar() +
			theme_minimal() +
			theme(axis.title.x=element_text(size=14),
					  axis.title.y=element_text(size=14),
						axis.title=element_text(size=14),
						axis.text=element_text(size=14)) +
			xlim(0,5) + ylab("") + ggtitle("Boulders")

 

		p2 <- filter(routes,crag == selected_crag, type == "sport") |>
			ggplot(aes(difficulty)) + 
			geom_bar() +
			theme_minimal() +
			theme(axis.title.x=element_text(size=14),
					  axis.title.y=element_text(size=14),
						axis.title=element_text(size=14),
						axis.text=element_text(size=14)) +
			xlim(0,5) + ylab("") + ggtitle("Sport Climbs")
		
		grid.arrange(p1,p2, nrow = 2)

  })
  
  output$route_table <- renderDataTable({
  	
  	selected_crag <- input$selectedCrag
		tab <- filter(routes,crag == selected_crag) |> select(-c(crag))
  	datatable(tab) 

  })
  
#   mod_selctedCrag <- shiny::reactiveValues(x = input)
#   
#   output$route_table <- DT::renderDT({
#                 
#     isolate(mod_selctedCrag$x)
#                 
# 	}, options = list(paging = FALSE, processing = FALSE))
  
}

# https://shiny.rstudio.com/tutorial/written-tutorial/lesson7/
# https://towardsdatascience.com/making-interactive-maps-in-r-with-less-than-15-lines-of-code-bfd81f587e12
# https://www.r-bloggers.com/2020/04/hands-on-how-to-build-an-interactive-map-in-r-shiny-an-example-for-the-covid-19-dashboard/

#library(shiny)
#runApp()
#library(rsconnect)
#deployApp()

# r <- filter(routes,crag == "Mickey's Beach", type == "boulder")
# 			ggplot(r,aes(difficulty, fill = rating)) + 
# 			geom_bar() +
# 			theme_minimal() +
# 			theme(axis.title.x=element_text(size=14),
# 					  axis.title.y=element_text(size=14),
# 						axis.title=element_text(size=14),
# 						axis.text=element_text(size=14)) +
# 			xlim(0,5) + ylab("routes climbed\n") + ggtitle("Boulders")



