shinyServer(function(input, output) {
   
  output$mymap <- renderGvis({
    states = data.frame(State = state.name,
                        Outbreaks = outbreaks_per_year[,as.character(input$sliderYear)])
    gvisGeoChart(states, "State", "Outbreaks",
                 options=list(region="US", displayMode="regions", 
                              resolution="provinces",
                              width=900, height=600))})
  
  # output$numcases <- renderPlot({ggplot(outbreaks_species_top9,
  #                                            aes(x = Species,
  #                                                y = input$selectBacteria)) +
  #                                       geom_bar(stat = "identity")})
  
  output$illnesses <- renderGvis({
    df = data.frame(outbreaks_species_top9$Species, outbreaks_species_top9$numIllnesses)
    gvisColumnChart(df)
  })
  
  output$hospitalizations <- renderGvis({
    df = data.frame(outbreaks_species_top9$Species, outbreaks_species_top9$numHospitalizations)
    gvisColumnChart(df)
  })
  
  output$fatalities <- renderGvis({
    df = data.frame(outbreaks_species_top9$Species, outbreaks_species_top9$numFatalities)
    gvisColumnChart(df)
  })
  
  output$byState <- renderGvis({
    outbreaks_state = outbreaks_state_year %>%
      filter(., State == input$selectState)
    gvisColumnChart(outbreaks_state, xvar = "Year")
  })
})