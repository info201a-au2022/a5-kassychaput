# server.R
library(dplyr)

# Data
co2_data <- read.csv("~/Documents/info201/data/co2_data.csv", stringsAsFactors = FALSE)


server <- function(input, output) {
  
  data <- reactive({
    filtered <-
      co2_data %>% 
      filter(country == input$countries,
             year > 1950)
  })
  
  output$barchart <- renderPlotly({
    
    plot <- ggplot(data()) +
      geom_line(mapping = aes_string(x = "year", y = input$source)) +
      labs(
        x = "Year",
        y = "CO2 Emissions (in million tonnes)",
        caption = "ADD CAPTION THAT EXPLAINS IMPORTANCE"
      )
    
    plot
  })
  
}