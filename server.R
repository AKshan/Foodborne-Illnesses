shinyServer(function(input, output) {
  
  outbreaks_map <-leaflet() %>%
    addTiles() %>%
    setView(lng = -93.85, lat = 37.45, zoom = 4)
  
  output$year = renderPrint({input$sliderYear})
  
  # observe(
  #   print(class(as.character(input$sliderYear)))
  #   print(class('1998'))
  # )
  
  colStates <- maps::map("state", fill = TRUE, plot = FALSE)
  binpal <- colorBin("Blues", outbreaks_per_year$`1998`, 6, pretty = FALSE)
  
  output$mymap <- renderLeaflet({
    outbreaks_map %>%
      addPolygons(data = colStates, stroke = TRUE, smoothFactor = 0.2, fillOpacity = 1, color = "#000000", weight = 1,
                  fillColor = ~binpal(outbreaks_per_year[,as.character(input$sliderYear)])) %>%
      addLegend("bottomright", pal = binpal, values = outbreaks_per_year[,as.character(input$sliderYear)],
                title = "Number of Outbreaks",
                opacity = 1)
  })
})