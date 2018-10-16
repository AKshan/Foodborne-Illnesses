shinyServer(function(input, output) {
   
  output$mymap <- renderGvis({
    states = data.frame(State = state.name,
                        Outbreaks = outbreaks_per_year[,as.character(input$sliderYear)])
    gvisGeoChart(states, "State", "Outbreaks",
                 options=list(region="US", displayMode="regions", 
                              resolution="provinces",
                              width=900, height=600))})
  
  output$illnesses <- renderGvis({
    df = data.frame(Species = outbreaks_species_top10$Species, Illnesses = outbreaks_species_top10$numIllnesses)
    gvisColumnChart(df,
                    options = list(title = "Number of Illnesses",
                                   legend = "none",
                                   hAxis = "{title:'Species'}",
                                   vAxis = "{title:'Count'}",
                                   width = 1200, height = 300))
  })
  
  output$hospitalizations <- renderGvis({
    df = data.frame(Species = outbreaks_species_top10$Species, Hospitalizations = outbreaks_species_top10$numHospitalizations)
    gvisColumnChart(df,
                    options = list(title = "Number of Hospitalizations",
                                   legend = "none",
                                   hAxis = "{title:'Species'}",
                                   vAxis = "{title:'Count'}",
                                   width = 1200, height = 300))
  })
  
  output$fatalities <- renderGvis({
    df = data.frame(Species = outbreaks_species_top10$Species, Fatalities = outbreaks_species_top10$numFatalities)
    gvisColumnChart(df,
                    options = list(title = "Number of Fatalities",
                                   legend = "none",
                                   hAxis = "{title:'Species'}",
                                   vAxis = "{title:'Count'}",
                                   width = 1200, height = 300))
  })
  
  output$byState <- renderGvis({
    outbreaks_state = outbreaks_state_year %>%
      filter(., State == input$selectState) %>%
      rename(., Cases = numCases)
    gvisColumnChart(outbreaks_state, xvar = "Year",
                    options = list(title = "Number of Outbreaks in Each State",
                                   legend = "none",
                                   hAxis = "{title:'Year', format: '',
                                   gridlines: {count: 18}}",
                                   vAxis = "{title:'Number of Outbreaks'}",
                                   height = 500))
  })
  
  output$casesByMonth <- renderGvis({
    outbreaks_month = outbreaks_clean %>%
      group_by(., Month) %>%
      summarise(., Cases = sum(TotalCases)) %>%
      mutate(., month = factor(month.name[Month], levels = month.name)) %>% 
      select(., month, Cases) %>%
      arrange(., month)
    gvisColumnChart(outbreaks_month,
                    options = list(title = "Number of Outbreaks in Each Month",
                                   legend = "none",
                                   hAxis = "{title:'Month'}",
                                   vAxis = "{title:'Number of Outbreaks'}",
                                   width = 1000, height = 500))
  })
})