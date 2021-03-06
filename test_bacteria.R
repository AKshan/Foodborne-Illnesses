library(tidyverse)

outbreaks_species = outbreaks_clean[!(is.na(outbreaks_clean$Species) |
                                        (outbreaks_clean$Species == "") |
                                        (outbreaks_clean$Species == "Unknown") |
                                        (outbreaks_clean$Species == "Virus")),]

outbreaks_species = outbreaks_species[- grep("unknown", outbreaks_species$Species),]
outbreaks_species = outbreaks_species[- grep(";", outbreaks_species$Species),]

outbreaks_species_grouped = outbreaks_species %>%
  group_by(., Species) %>%
  summarise(., numIllnesses = sum(Illnesses), numHospitalizations = sum(Hospitalizations), numFatalities = sum(Fatalities))

outbreaks_species_top9 = outbreaks_species_grouped %>%
  mutate(., totalCases = numIllnesses + numHospitalizations + numFatalities) %>%
  arrange(., desc(totalCases)) %>%
  head(., 9)

outbreaks_spread = outbreaks_species_top9 %>%
  select(., Species, Illnesses = numIllnesses, Hospitalizations = numHospitalizations, Fatalities = numFatalities) %>%
  gather(., key = ExtentOfPoisoning, value = number, Illnesses, Hospitalizations, Fatalities)

g = ggplot(outbreaks_spread, aes(x = ExtentOfPoisoning, y = number)) + geom_bar(stat = "identity") + facet_wrap(~Species)
g

gIllnesses = ggplot(outbreaks_species_top9, aes(x = reorder(Species, numIllnesses), y = numIllnesses)) +
  geom_bar(stat = "identity")
gIllnesses

plot(gvisColumnChart(data.frame(outbreaks_species_top9$Species, outbreaks_species_top9$numIllnesses)))





## location based
# cases by state
outbreaks_state_year = outbreaks_clean %>%
  group_by(., State, Year) %>%
  summarise(., numCases = sum(TotalCases)) %>%
  select(., State, Year, numCases)

outbreaks_state = outbreaks_state_year %>%
  filter(., State == "New York")

gState = ggplot(outbreaks_state, aes(x = Year, y = numCases)) + geom_bar(stat = "identity")
gState

# cases by month
outbreaks_month = outbreaks_clean %>%
  group_by(., Month) %>%
  summarise(., numCases = sum(TotalCases)) %>%
  mutate(., month = factor(month.name[Month], levels = month.name)) %>% 
  select(., month, numCases) %>%
  arrange(., month)

plot(gvisColumnChart(outbreaks_month))

# pie chart by location
outbreaks_location = outbreaks_clean %>%
  select(., Location, TotalCases)

outbreaks_location = outbreaks_location[!(outbreaks_location$Location == ""),]
outbreaks_location = outbreaks_location[- grep(";", outbreaks_location$Location),]

# outbreaks_by_location = outbreaks_location %>%
#   group_by(., Location) %>%
#   summarise(., numberCases = sum(TotalCases))
# plot(gvisPieChart(outbreaks_by_location))
