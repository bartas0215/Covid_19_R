install.packages("shiny")
library(shiny)
library(tidyverse)




ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(selectInput("country", "Select country", multiple = TRUE, unique(readyData_for_correlation_covid$Country)))
  ,
  mainPanel(plotOutput("country")))
  
  
  
)

server <- function(input, output) {
  
 zz <- reactive({readyData_for_correlation_covid %>% filter(Country == input$country)})
  
  output$country <- renderPlot({ggplot(zz(),aes(x=Total_cases_perMln,y=Articles_perMln)) + geom_point() + geom_smooth()})
  
  
}
shinyApp(ui= ui, server = server)

