library(tidyverse)

outbreaks_species = outbreaks_clean[!(is.na(outbreaks_clean$Species) |
                                        (outbreaks_clean$Species == "") |
                                        (outbreaks_clean$Species == "Unknown") |
                                        (outbreaks_clean$Species == "Virus")),]

outbreaks_species_grouped = outbreaks_species %>%
  group_by(., Species) %>%
  summarise(., numIllnesses = sum(Illnesses), numHospitalizations = sum(Hospitalizations), numFatalities = sum(Fatalities))

outbreaks_species_top20 = outbreaks_species_grouped %>%
  mutate(., totalCases = numIllnesses + numHospitalizations + numFatalities) %>%
  arrange(., desc(totalCases)) %>%
  head(., 9)

outbreaks_spread = outbreaks_species_top20 %>%
  select(., Species, Illnesses = numIllnesses, Hospitalizations = numHospitalizations, Fatalities = numFatalities) %>%
  gather(., key = ExtentOfPoisoning, value = number, Illnesses, Hospitalizations, Fatalities)

g = ggplot(outbreaks_spread, aes(x = ExtentOfPoisoning, y = number)) + geom_bar(stat = "identity") + facet_wrap(~Species)
g
