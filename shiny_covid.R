install.packages("shiny")
install.packages("reactable")
library(shiny)
library(tidyverse)
library(reactable)



ui <- fluidPage(
  titlePanel("COVID-19 retrospective publication analyis"),
  sidebarLayout(
    sidebarPanel(selectInput("country", "Select country", unique(readyData_for_correlation_covid$Country)))
  ,
  mainPanel(tabsetPanel(tabPanel("Plot",
    plotOutput("country")),tabPanel("Table",reactableOutput("table")))))
  
  
  
)

server <- function(input, output) {
  
 zz <- reactive({readyData_for_correlation_covid %>% filter(Country == input$country)})
  
  output$country <- renderPlot({ggplot(zz(),aes(x=Total_cases_perMln,y=Articles_perMln)) + geom_point() + geom_smooth()})
  output$table <- renderReactable({reactable(zz())})
  
}
shinyApp(ui= ui, server = server)

