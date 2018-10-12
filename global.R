library(dplyr)
library(maps)
library(ggplot2)
library(leaflet)

outbreaks <- read.csv("outbreaks.csv")

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