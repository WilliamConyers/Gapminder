
library(shiny)
library(tidyverse)
library(plotly)

# Define UI for application
ui <- fluidPage(

    # Application title
    titlePanel(h1("GapMinder by William Conyers", align = "center")),

    # Sidebar with all input elements
    sidebarLayout(
        sidebarPanel(
            sliderInput("year",
                        "Year:",
                        min = 1960,
                        max = 2017,
                        value = 1960,
                        sep = "",
                        animate = TRUE),
            hr(),
            selectInput("region",
                        "World Region:",
                        choices = NULL),
            selectInput("country",
                        "Country:",
                        choices = NULL,
                        multiple = TRUE),
            hr(),
            selectInput("xvar",
                        "X Variable: (not functional)",
                        choices = NULL),
            selectInput("yvar",
                        "Y Variable: (not functional)",
                        choices = NULL)
        ),


        # Show a plot of the generated distribution
        mainPanel(
           plotlyOutput("distPlot")
        )
    )
)

# Define server logic required to draw graph
server <- function(input, output, session) {
    
    #Load in the data set
    path <- "WorldBankData.csv"
    data <- read_csv(path)
    
    #get year from sliderInput
    year <- reactive({
        input$year
    })
    
    #populate the region list
    observeEvent(input$region, {
        updateSelectInput(session, "region", choices = c("All Regions", unique(data$Region)))
    }, once = TRUE)
    
    #get region from selectInput
    region <- reactive({
        input$region
    })
    
    observeEvent(input$region,{
        if (input$region == "All Regions") mychoices <- unique(data$Country)
        else mychoices <- data %>% select(Region, Country) %>% filter(Region==input$region) %>% distinct(Country)
        updateSelectInput(session, "country", choices = mychoices)
    })
    
    #get region from selectInput
    country <- reactive({
        input$country
    })
    
    variables <- names(data[,4:6])
    
    #populate the xvar list
    observeEvent(input$xvar, {
        updateSelectInput(session, "xvar", choices = variables)
    }, once = TRUE)
    
    #populate the yvar list
    observeEvent(input$yvar, {
        updateSelectInput(session, "yvar", choices = variables)
    }, once = TRUE)
    
    #get xvar from Input
    xvar <- reactive({
        input$xvar
    })
    
    #get yvar from Input
    yvar <- reactive({
        input$yvar
    })
    
    #build plotly plot of two chosen variables
    output$distPlot <- renderPlotly({
        
        currentyear <- year()
        currentregion <- region()
        currentcountry <- country()
        # currentxvar <- as.symbol(xvar())
        # currentyvar <- as.symbol(yvar())
        
        yeardata = subset(data,Year==currentyear)
        
        if (is.null(currentcountry)) {
            if (currentregion != "All Regions") {
                yeardata = subset(yeardata, Region==currentregion)
            }
        } else {
            yeardata = subset(yeardata, Country %in% currentcountry)
        }
        
        xminmax <- c(min(data$Fertility, na.rm=T), max(data$Fertility, na.rm=T))
        yminmax <- c(min(data$LifeExpectancy, na.rm=T), max(data$LifeExpectancy, na.rm=T))
        
        plot_ly(data = yeardata,
                type = 'scatter',
                mode = 'markers',
                x = ~Fertility,
                y = ~LifeExpectancy,
                size = ~Population,
                color = ~Region,
                marker = list(sizeref=.2,
                              opacity = 0.65),
                height = 600,
                text = ~Country,
                hoverinfo = "text"
        ) %>%
            layout(xaxis = list(range = xminmax),
                   yaxis = list(range = yminmax),
                   legend = list(itemsizing='constant',
                                 x = 0.025,
                                 y = 0.025)
            )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
