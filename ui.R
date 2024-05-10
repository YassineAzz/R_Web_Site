library(shiny)
library(leaflet)

ui <- fluidPage(
  titlePanel("Lab 5 - shinyapps"),  # Titre de l'application
  sidebarLayout(
    sidebarPanel(
      width = 3,  # Largeur du panneau latéral
      selectInput("city", "Municipality:", choices = c("Stockholm", "Göteborg", "Malmö")),
      radioButtons("poiType", "POI type:", choices = c("Café", "Restaurant", "Pub")),
      actionButton("go", "Import POIs"),
      hr(),  # Une ligne horizontale pour séparer les sections
      h4("Total Records")  # Titre pour le total des enregistrements
    ),
    mainPanel(
      leafletOutput("mapPlot")  # Widget de carte Leaflet
    )
  )
)
