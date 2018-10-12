library(dplyr)
library(maps)
library(ggplot2)
library(leaflet)
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

# map it per year
# 1998
usa <- leaflet() %>%
  addTiles() %>%
  setView(lng = -93.85, lat = 37.45, zoom = 4)

usa2 <-leaflet() %>%
  addTiles() %>%
  setView(lng = -100, lat = 50, zoom =3)

## trial 3
# pal <- colorNumeric(
#   palette = "Blues",
#   domain = outbreaks_per_year$`1998`)
# 
# usa %>%
#   addPolygons(data = colStates, stroke = FALSE, smoothFactor = 0.2, fillOpacity = 0.5,
#               fillColor = ~pal(outbreaks_per_year$'1998'))


## trial 2
# colStates <- map("state", fill = TRUE,
#                  plot = FALSE,
#                  region = tolower(outbreaks_per_year$State))
# 
# addPolygons(usa, data=colStates,
#             stroke = FALSE)



## trial 1
# colStates <- maps::map("state", fill = TRUE, plot = FALSE)
# 
# qpal <- colorNumeric("Blues", outbreaks_per_year$`1998`)
# 
# usa %>%
#   addPolygons(data = colStates, stroke = TRUE, smoothFactor = 0.2, fillOpacity = 1, color = "#000000", weight = 1,
#               fillColor = ~qpal(outbreaks_per_year$'1998')) %>%
#   addLegend("bottomright", pal = qpal, values = outbreaks_per_year$'1998',
#             title = "Number of Outbreaks",
#             opacity = 1)


## trial 4
colStates <- maps::map("state", fill = TRUE, plot = FALSE, region = tolower(outbreaks_per_year$State))

binpal <- colorBin("Blues", outbreaks_per_year$`1998`, 6, pretty = FALSE)

usa %>%
  addPolygons(data = colStates, stroke = TRUE, smoothFactor = 0.2, fillOpacity = 1, color = "#000000", weight = 1,
              fillColor = ~binpal(outbreaks_per_year$'1998')) %>%
  addLegend("bottomright", pal = binpal, values = outbreaks_per_year$'1998',
            title = "Number of Outbreaks",
            opacity = 1)



















