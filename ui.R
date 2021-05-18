
library(shiny)

shinyUI(fluidPage(

    # Application title
    titlePanel("An Unequal World"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("year",
                        "Year:",
                        min = 1960,
                        max = 2017,
                        value = 1960,
                        sep = "",
                        animate = TRUE),
            selectInput("region",
                        "Region:",
                        choices = NULL)
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot")
        )
    )
))
