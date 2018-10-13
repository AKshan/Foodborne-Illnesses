outbreaks <- read.csv("outbreaks.csv")

# on map, show sum of illnesses, hospitalizations, fatalities over years
outbreaks_clean = outbreaks %>%
  select(., Year, Month, State, Species, Illnesses, Hospitalizations, Fatalities) %>%
  mutate(., TotalCases = Illnesses + Hospitalizations + Fatalities)

outbreaks_clean[is.na(outbreaks_clean)] <- 0

outbreak1998 = outbreaks_clean %>%
  filter(., Year == 1998) %>%
  group_by(., State) %>%
  summarise(., CasesByYear = sum(TotalCases))

outbreaks_per_year = outbreak1998
colnames(outbreaks_per_year) = c('State', 1998)
for (i in 1999:2015) {
  outbreak = outbreaks_clean %>%
    filter(., Year == i) %>%
    group_by(., State) %>%
    summarise(., CasesByYear = sum(TotalCases))
  colnames(outbreak) = c('State', i)
  outbreaks_per_year = merge(outbreaks_per_year, outbreak, all=T)
}
outbreaks_per_year = outbreaks_per_year %>%
  filter(., !State %in% c("Guam","Puerto Rico", "Multistate", "Washington DC", "Republic of Palau"))

library(googleVis)

states <- data.frame(State = state.name, Outbreaks = outbreaks_per_year$`1999`)
outbreaksMap <- gvisGeoChart(states, "State", "Outbreaks",
                          options=list(region="US", 
                                       displayMode="regions", 
                                       resolution="provinces",
                                       width="auto", height="auto"))
plot(outbreaksMap)

outputmap <- gvisGeoChart(outbreaks_per_year, "State", "1998",
                                         options=list(region="US", 
                                                      displayMode="regions", 
                                                      resolution="provinces",
                                                      width=1200, height=800))
plot(outputmap)















