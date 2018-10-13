library(shinydashboard)
library(leaflet)

shinyUI(dashboardPage(
  dashboardHeader(title = "Foodborne Illnesses from 1998-2015"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Foodborne Diseases per Year", tabName = "map", icon = icon("map")),
      menuItem("Fatality of Species of Bacteria", tabName = "bacteria", icon = icon("database")),
      menuItem("Foodborne Diseases by State", tabName = "state", icon = icon("map-signs")))
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "map",
              fluidRow(box(htmlOutput("mymap"), width = 7)),
              sliderInput("sliderYear", label = h3("Year"), min = 1998, max = 2015, value = 1998)),
      tabItem(tabName = "bacteria",
              fluidRow(box(htmlOutput("illnesses"), width = 12)),
              fluidRow(box(htmlOutput("hospitalizations"), width = 12)),
              fluidRow(box(htmlOutput("fatalities"), width = 12))),
      tabItem(tabName = "state",
              htmlOutput("byState"),
              selectizeInput("selectState",
                             "Select State",
                             choices = outbreaks_state_year$State)))
  )
))