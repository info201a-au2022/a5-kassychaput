# ui.R
library(shiny)
library(plotly)
library(dplyr)
library(shinythemes)

# highest co2 per capita recently
co2_cap_recent <- co2_data %>% 
  filter(year == max(year)) %>% 
  filter(co2_including_luc_per_capita == max(co2_including_luc_per_capita, na.rm = TRUE)) %>% 
  pull(co2_including_luc_per_capita)

# average co2 per capita
co2_cap_average <- co2_data %>% 
  filter(year == max(year, na.rm = TRUE)) %>% 
  summarize(co2_including_luc_per_capita = mean(co2_including_luc_per_capita, na.rm = TRUE)) %>% 
  pull(co2_including_luc_per_capita)

# current co2 per capita for United States
co2_us <- co2_data %>% 
  filter(year == max(year)) %>% 
  filter(country == "United States") %>% 
  pull(co2_including_luc_per_capita)

# Tab Panel for Introduction
intro_panel <- tabPanel(
  "Introduction",
  titlePanel("CO2 Emissions Analysis"),
  p("This analysis displays a graphic dependent on country of choice and source of carbon
    dioxide emissions. I have chosen to analyze these specific variables because when
    looking to reduce carbon dioxide emissions overall, it is crucial to investigate what
    specifially is causing the emission levels to be high in certain areas. I also decided
    to sort the data set by country and allow user's to choose their desired country of
    interest because emissions from various sources will be higher or lower depending on
    the country. To provide a baseline for this investigation, I have found that the most
    recent, highest carbon dioxide emissions per capita is", 
    round(co2_cap_recent, digits = 2), "tonnes per person and the average carbon dixoide
    emissions per capita for the most recent year in the dataset is",
    round(co2_cap_average, digits = 2), "tonnes per person. To put this in perspective,
    I have also found the United States' carbon dioxide emissions per capita for the most
    recent year, which was found to be", round(co2_us, digits = 2), "tonnes per person.")
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
  plotlyOutput("barchart"),
  p(align = "center", "This chart displays the overall trends of various carbon dioxide 
    emissions for different countries ranging from 1950 to 2022. In many of the countries
    each of the sources shows a significant increase in the amount of CO2 emissions since
    1950, thus accounting for an overall increase of carbon dioxide emissions across
    the globe over the past 70 years.")
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
  barchart_panel,
  theme = shinytheme("cerulean"),
)