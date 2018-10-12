library(shinydashboard)
library(leaflet)

shinyUI(dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Foodborne Diseases per Year", tabName = "map", icon = icon("map")),
      menuItem("Fatality of Species of Bacteria", tabName = "bacteria", icon = icon("database")))
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "map",
              leafletOutput("mymap"),
              sliderInput("sliderYear", label = h3("Year"), min = 1998, max = 2015, value = 1998)),
      tabItem(tabName = "bacteria",
              "to be replaced with datatable"))
  )
))