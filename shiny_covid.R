library(shiny)
library(tidyverse)
library(reactable)
library(plotly)
library(ggrepel)
library(leaflet)
library(wordcloud2)


ui <- fluidPage(
  titlePanel("COVID-19 retrospective publication analyis"),
  sidebarLayout(
    sidebarPanel(selectInput("country", "Select country",multiple = TRUE, unique(readyData_for_correlation_covid$Country)),
                 downloadButton("download","Download data"))
  ,
  mainPanel(tabsetPanel(tabPanel("Plot-Total cases",
    plotOutput("country")),tabPanel("Table",DT::dataTableOutput("table")),tabPanel("Map",leafletOutput(
      "map", height = '500px', width = '100%')),tabPanel("Journals_cloud",wordcloud2Output(outputId = "cloud")))))
  

  
)

server <- function(input, output) {
  
  px
  px_1 <- as.data.frame(px)
  px_1
  
 
  zz <- reactive({subset(readyData_for_correlation_covid, Country %in% input$country)}) 
 
  output$country <- renderPlot({ggplot(zz(),aes(x=Total_cases_perMln,y=Articles_perMln)) + geom_point()+ scale_y_log10() + geom_label_repel(aes(label = Country),
                                                                                                                                         box.padding   = 0.5, 
                                                                                                                                         point.padding = 2.0,
                                                                                                                                         segment.color = 'grey50') +
  theme_classic() })
  
  output$table <-DT::renderDataTable(zz())
   
  output$download <- downloadHandler(
    filename = "data.csv",
    content = function(file) {
      
      data <- zz()
      write.csv(data, file, row.names = FALSE)
    })
  
  output$map <- renderLeaflet({
      leaflet(zz()) %>% 
      setView( -98.58, 39.82, zoom = 5) %>%
      addTiles()
  })
  
  output$cloud <- renderWordcloud2({px_1})
  
}
shinyApp(ui= ui, server = server)



