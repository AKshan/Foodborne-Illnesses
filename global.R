library(dplyr)
library(maps)
library(ggplot2)
library(googleVis)
library(shiny)

outbreaks <- read.csv("outbreaks.csv")

outbreaks_clean = outbreaks %>%
  filter(., !State %in% c("Guam","Puerto Rico", "Multistate", "Washington DC", "Republic of Palau")) %>%
  select(., Year, Month, State, Location, Species, Illnesses, Hospitalizations, Fatalities)

outbreaks_clean[is.na(outbreaks_clean)] <- 0

outbreaks_clean = outbreaks_clean %>%
  mutate(., TotalCases = Illnesses + Hospitalizations + Fatalities)

## tab 1
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
outbreaks_per_year[is.na(outbreaks_per_year)] <- 0

# cases by species
outbreaks_species = outbreaks_clean[!(is.na(outbreaks_clean$Species) |
                                        (outbreaks_clean$Species == "") |
                                        (outbreaks_clean$Species == "Unknown") |
                                        (outbreaks_clean$Species == "Virus")),]

outbreaks_species = outbreaks_species[- grep("unknown", outbreaks_species$Species),]
outbreaks_species = outbreaks_species[- grep(";", outbreaks_species$Species),]

outbreaks_species_grouped = outbreaks_species %>%
  group_by(., Species) %>%
  summarise(., numIllnesses = sum(Illnesses), numHospitalizations = sum(Hospitalizations), numFatalities = sum(Fatalities))

outbreaks_species_top10 = outbreaks_species_grouped %>%
  mutate(., totalCases = numIllnesses + numHospitalizations + numFatalities) %>%
  arrange(., desc(totalCases)) %>%
  head(., 10)

# cases by state
outbreaks_state_year = outbreaks_clean %>%
  group_by(., State, Year) %>%
  summarise(., numCases = sum(TotalCases)) %>%
  select(., State, Year, numCases)
