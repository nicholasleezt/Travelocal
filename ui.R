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

header <- dashboardHeader(title = "TravelLocal - Malaysia")  
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Cuti-cuti Malaysia 2022", tabName = "cuticutimalaysia", icon = icon("dashboard")),
    menuItem("Overall Analysis", tabName = "analysis", icon = icon("bar-chart-o")),
    menuItem("Amenities", tabName = "amenities", icon = icon("list-alt")),
    menuItem("Malaysia Cities", tabName = "malaysia_cities", icon = icon("th")),
    menuItem("Covid-19 Travel Requirement", icon = icon("send",lib='glyphicon'), 
             href = "https://mysafetravel.gov.my/"),
    menuItem("Covid-19 Statistics", icon = icon("send",lib='glyphicon'), 
             href = "https://covidnow.moh.gov.my/")
  )
)
body <- dashboardBody(
  tabItems(
    
    tabItem(tabName = "cuticutimalaysia",
            useShinyjs(),
            fluidPage(
              HTML('<iframe width="753" height="424" src="https://www.youtube.com/embed/SYB427zH7Tk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                '))),

    tabItem(tabName = "analysis",
            useShinyjs(),
            fluidPage(
              box(width=10, background = 'green',
                  DT::dataTableOutput('freqtable'))
            )),

    tabItem(tabName = "amenities",
            useShinyjs(),
            fluidPage(
              leafletOutput("mymap"),
              p(),
              selectInput("variables","What kind of Amenity Are You Looking For?",
                          choices=c(UniqueAmenity), multiple=TRUE,
                          selected="cafe"),
              numericInput("count","How Many Location Are You Looking For?",
                           
                           value=10),
              radioButtons("location","East or West",
                           choices=c("West Malaysia" = "wm",
                                     "East Malaysia" = "em"
                           ), selected="wm")
            )),
    
    tabItem(tabName = "malaysia_cities",
            tags$style(type = 'text/css', '#nymap {height: calc(100vh - 80px)
 !important;}'),
            leafletOutput('nymap')
    )))

dashboardPage(title = 'Malaysia', header, sidebar, body, skin='red')
