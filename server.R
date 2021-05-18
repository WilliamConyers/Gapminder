
library(shiny)
library(plotly)

shinyServer(function(input, output) {
    
    data <- read.csv("/Users/williamconyers/Desktop/Stat 310/Shiny/GapMinder/WorldBankData.csv")

    output$distPlot <- renderPlot({
        
        plot1 <- plot_ly(data = data,
                type = 'scatter',
                mode = 'markers',
                x = ~Fertility,
                y = ~LifeExpectancy,
                size = ~Population)
        
    })

})
