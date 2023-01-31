# Shiny App: STATS780-W23 Assignment 1
# Konrad Swierczek
# LINK TO APP: https://swierckj.shinyapps.io/assignment1/
# Imports
library(shiny)
library(ggplot2)

# Load Data
load("tidy_data.RData")
###############################################################################
# App UI
ui <- fluidPage(
  titlePanel("Monthly average retail prices for selected products"),

  mainPanel("First select a product: 
            the average of all 110 products is selected by default. 
            Next, choose a region. 
            Canada displays the average value for all provinces,
            while All Provinces displays colour-coded lines for each province.
            This can help understand how product type and province 
            influence the price of a product over time. 
            For instance, the price of laundry detergent fluctuates in Quebec, 
            but not Ontario."),

  selectInput(inputId = "x_var",
            label = "Select a Product",
            choices = unique(tidy_data$Products),
            selected  = "All Products"),
  selectInput(inputId = "which_plot",
            label = "Region",
            choices = c("Canada", "All Provinces"),
            selected  = "Canada"),

  plotOutput(outputId = "plot"

  )
)
###############################################################################
# App Server
server <- function(input, output) {
  output$plot <- renderPlot({
    title <- "retail prices over time"
    if (input$which_plot == "Canada") {
      ggplot(data = subset(subset(tidy_data, Products == input$x_var),
                           GEO == "Canada")) +
        geom_line(aes(x = date, y = VALUE)) +
        labs(title = paste("Price of ", input$x_var, " over 2022", sep = "")) +
        xlab("Month (2022)") +
        ylab("Product Price (Canadian Dollar)") +
        scale_x_date(date_breaks = "months", date_labels = "%b") +
        theme(text = element_text(size = 20))
    }else {
      ggplot(data = subset(subset(tidy_data, Products == input$x_var),
                           GEO != "Canada")) +
        geom_line(aes(x = date, y = VALUE, colour = GEO)) +
        labs(colour = "Province",
             title = paste("Price of ", input$x_var, " over 2022", sep = "")) +
        xlab("Month (2022)") +
        ylab("Product Price (Canadian Dollar)") +
        scale_x_date(date_breaks = "months", date_labels = "%b") +
        theme(text = element_text(size = 20))
    }

  })
}
###############################################################################
# Run App
shinyApp(ui, server)
###############################################################################