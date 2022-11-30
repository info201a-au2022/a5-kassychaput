# ui.R
library(shiny)
library(plotly)
library(dplyr)


# Tab Panel for Introduction
intro_panel <- tabPanel(
  "Introduction",
  titlePanel("CO2 Emissions Analysis"),
  p("Sample paragraph")
)

# Get data for choices

emission_choices <- list(
  "Coal" = "cumulative_coal_co2",
  "Flaring" = "cumulative_flaring_co2",
  "Gas" = "cumulative_gas_co2",
  "Land-Use Change" = "cumulative_luc_co2",
  "Oil" = "cumulative_oil_co2",
  "Other" = "cumulative_other_co2")

# Side Bar Panel for Bar Chart
barchart_sidebar_content <- sidebarPanel(
  selectInput(
    "source",
    label = "Sources",
    choices = emission_choices,
    selected = emission_choices[1]
  ),
  
  selectInput(
    "countries",
    label = "Countries",
    choices = unique(co2_data$country),
    selected = "United States"
  )
)

# Main Panel for Bar Chart
barchart_main_panel <- mainPanel(
  plotlyOutput("barchart")
)

# Tab Panel for Data Visualization
barchart_panel <- tabPanel(
  "CO2 by Country",
  titlePanel("CO2 by Country"),
  
  sidebarLayout(
    barchart_sidebar_content,
    barchart_main_panel
  )
)


# Navigation Bar
ui <- navbarPage(
  "CO2 Emissions",
  intro_panel, 
  barchart_panel
)