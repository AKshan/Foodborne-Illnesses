shinyServer(function(input, output) {
   
  output$mymap <- renderGvis({
    states = data.frame(State = state.name,
                        Outbreaks = outbreaks_per_year[,as.character(input$sliderYear)])
    gvisGeoChart(states, "State", "Outbreaks",
                 options=list(region="US", displayMode="regions", 
                              resolution="provinces",
                              width=900, height=600))})
})