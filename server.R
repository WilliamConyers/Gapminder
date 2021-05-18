#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    data <- read.csv("/Users/williamconyers/Desktop/Stat 310/Shiny/GapMinder/WorldBankData.csv")
    
    # observeEvent(input$region{
    #     updateSelectInput(session, "region", choices = c("All Regions", unique(data$Region)))
    # }, 
    # once=TRUE
    # )

    output$distPlot <- renderPlot({
        
        plot1 <- plot_ly(data = data,
                type = 'scatter',
                mode = 'markers',
                x = ~Fertility,
                y = ~LifeExpectancy,
                size = ~Population)
        
    })

})
