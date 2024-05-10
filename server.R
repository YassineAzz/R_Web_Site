library(httr)
library(jsonlite)
library(sf)
library(tmap)

# Fonction pour obtenir les coordonnées basées sur la ville sélectionnée
getCityCoordinates <- function(city) {
  switch(city,
         "Stockholm" = c(59.3293, 18.0686),
         "Göteborg" = c(57.7089, 11.9746),
         "Malmö" = c(55.6050, 13.0038),
         NULL)  # Retourne NULL si la ville n'est pas trouvée
}

server <- function(input, output) {
  observeEvent(input$go, {
    if (is.null(input$city) || is.null(input$poiType)) {
      output$mapPlot <- renderTmap({
        tmap_mode("view")
        tm_shape() + tm_basemap(server = "OpenStreetMap")
      })
      return()
    }
    
    coordinates <- getCityCoordinates(input$city)
    if (is.null(coordinates)) {
      print("Coordinates not found for the specified city")  # Debug
      output$mapPlot <- renderTmap({
        tmap_mode("view")
        tm_shape() + tm_basemap(server = "OpenStreetMap")
      })
      return()
    }
    
    url <- "https://gisdataapi.cetler.se/data101"
    params <- list(
      dbName = 'OSM',
      ApiKey = "v24yasazdu.sew5BUuppB!j5Orj8fNWFEPZQCjia2ryTeIY5OHsgqrCVCt1ThNh",  # Replace with your actual API key
      bufferType = "radius",
      dataType = "poi",
      centerPoint = paste(coordinates, collapse=","),
      radius = "5000",
      V = "1",
      key = "amenity",
      value = ifelse(input$poiType == "Restaurant", "restaurant", ifelse(input$poiType == "Café", "cafe", "pub"))
    )
    
    response <- GET(url, query = params)
    if (status_code(response) == 200) {
      json_data <- fromJSON(content(response, "text"))
      if (!is.null(json_data) && "longitude" %in% names(json_data) && "latitude" %in% names(json_data)) {
        data <- st_as_sf(json_data, coords = c("longitude", "latitude"), crs = 4326, agr = "constant")
        output$mapPlot <- renderTmap({
          tmap_mode("view")
          tm_shape(data) + tm_symbols(size = 0.1, col = "blue")
        })
      } else {
        print("Error in received data structure")  # Debug
        output$mapPlot <- renderTmap({
          tmap_mode("view")
          tm_shape() + tm_basemap(server = "OpenStreetMap")
        })
      }
    } else {
      print(paste("Error in API response:", status_code(response)))  # Debug server error
      output$mapPlot <- renderTmap({
        tmap_mode("view")
        tm_shape() + tm_basemap(server = "OpenStreetMap")
      })
    }
  })
}
