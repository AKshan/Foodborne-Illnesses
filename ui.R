library(shinydashboard)

shinyUI(dashboardPage(
  dashboardHeader(title = "Foodborne Illnesses from 1998-2015",
                  titleWidth = 400),
  dashboardSidebar(
    width = 400,
    sidebarMenu(
      menuItem("Foodborne Diseases per Year", tabName = "map", icon = icon("map")),
      menuItem("Fatality of Species of Bacteria", tabName = "bacteria", icon = icon("database")),
      menuItem("Foodborne Diseases by State", tabName = "state", icon = icon("map-signs")),
      menuItem("Cases by Month", tabName = "month", icon = icon("calendar")))
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "map",
              titlePanel("Number of Outbreaks by State and Year"),
              fluidRow(box(htmlOutput("mymap"), width = 8)),
              sliderInput("sliderYear", label = h3("Year"), min = 1998, max = 2015, value = 1998)),
      tabItem(tabName = "bacteria",
              titlePanel("Number of Illnesses, Hospitalizations, and Fatalities by the Top Ten Bacteria or Virus"),
              fluidRow(box(htmlOutput("illnesses"), width = 10)),
              fluidRow(box(htmlOutput("hospitalizations"), width = 10)),
              fluidRow(box(htmlOutput("fatalities"), width = 10))),
      tabItem(tabName = "state",
              titlePanel("Total Number of Outbreaks by Year"),
              htmlOutput("byState"),
              selectizeInput("selectState",
                             "Select State",
                             choices = outbreaks_state_year$State)),
      tabItem(tabName = "month",
              titlePanel("Total Number of Outbreaks by Month"),
              fluidRow(box(htmlOutput("casesByMonth"), width = 9))))
  )
))