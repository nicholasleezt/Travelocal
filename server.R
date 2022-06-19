library(shiny) #For Rshiny app
library(shinydashboard)
library(shinyjs)
library(leaflet) #For Open Streetmap
library(data.table) #For dataframe table
library(dplyr)
library(plyr)
library(sp)
library(rgdal)
library(stringi) #For data cleaning and identifying new strings
library(shinyWidgets)
library(maps)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$freqtable <- DT::renderDataTable({
    DT::datatable(ddply(df,.(Amenity,EastORWest), nrow))
  })

  output$nymap <- renderLeaflet({
    leaflet(world.cities %>%
              dplyr::filter(
                country.etc == "Malaysia",
                pop > 100000
              )) %>%
      addTiles() %>%
      addMarkers(lat = ~lat, lng = ~long)
  })
  
  observe({
    print(input$nyMap_bounds)
    print(input$nyMap_shape_click)
  })
  
  points <-reactive(
    {df[sample(
      which(
        df$EastORWest == input$location & df$Amenity == input$variables)
      ,input$count,replace=TRUE)
      ,]
    })
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      setView(lng = 109, lat = 5, zoom = 5.5)%>%
      addTiles%>%
      addMarkers(data=points(),lng= ~long,lat= ~lat, 
                 label=~paste(Place_Name,",",Amenity,",",
                              "long:",round(long,2),"lat:",round(lat,2)),
                 popup=~paste('<a  href="https://google.com/search?q=',
                              Place_Name,Amenity,'Malaysia','">','Google:',Place_Name,'</a>')
      )	
  })

})
