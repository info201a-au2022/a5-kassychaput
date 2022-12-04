# server.R
library(dplyr)

# Data
co2_data <- read.csv("~/Documents/info201/data/co2_data.csv", stringsAsFactors = FALSE)


server <- function(input, output) {
  
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
  
  data <- reactive({
    filtered <-
      co2_data %>% 
      filter(country == input$countries,
             year > 1950)
  })
  
  output$barchart <- renderPlotly({
    
    plot <- ggplot(data()) +
      geom_line(mapping = aes_string(x = "year", y = input$source)) +
      scale_y_continuous(labels = scales::comma) +
      labs(
        x = "Year",
        y = "CO2 Emissions (in million tonnes)",
        title = "Carbon Dioxide Emissions by Source"
      )
    
    plot
  })
  
}