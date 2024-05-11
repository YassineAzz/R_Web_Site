ui <- fluidPage(
  useShinyjs(),
  titlePanel("UrbanSpotter - In the 20 largest Sweden cities"),  
  sidebarLayout(
    sidebarPanel(
      width = 4,  
      selectInput("city", "Municipality:", choices = c("Stockholm", "Göteborg", "Malmö", "Uppsala", "Västerås", "Örebro", "Linköping", "Helsingborg", "Jönköping", "Norrköping", "Lund", "Umeå", "Gävle", "Borås", "Eskilstuna", "Södertälje", "Karlstad", "Täby", "Växjö", "Halmstad"
)),
      radioButtons("poiType", "POI type:", choices = c("Café", "Restaurant", "Pub")),
      actionButton("go", "Import POIs"),
      hr(), 
      h4("Total Records"),
      verbatimTextOutput("totalRecords"),
      DTOutput("poiTable") 
    ),
    mainPanel(
      leafletOutput("mapPlot")
    )
  )
)
