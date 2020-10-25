install.packages("shiny")
install.packages("reactable")
install.packages("plotly")
install.packages("ggrepel")
library(shiny)
library(tidyverse)
library(reactable)
library(plotly)
library(ggrepel)



ui <- fluidPage(
  titlePanel("COVID-19 retrospective publication analyis"),
  sidebarLayout(
    sidebarPanel(selectInput("country", "Select country",multiple = TRUE, unique(readyData_for_correlation_covid$Country)))
  ,
  mainPanel(tabsetPanel(tabPanel("Plot-Total cases",
    plotOutput("country")),tabPanel("Table",reactableOutput("table")))))
  

  
)

server <- function(input, output) {
  
 
zz <- reactive({subset(readyData_for_correlation_covid, Country %in% input$country)}) 
 
  output$country <- renderPlot({ggplot(zz(),aes(x=Total_cases_perMln,y=Articles_perMln)) + geom_point()+ scale_y_log10() + geom_label_repel(aes(label = Country),
                                                                                                                                         box.padding   = 0.5, 
                                                                                                                                         point.padding = 2.0,
                                                                                                                                         segment.color = 'grey50') +
   theme_classic() })
  output$table <- renderReactable({reactable(zz())})
  
}
shinyApp(ui= ui, server = server)

