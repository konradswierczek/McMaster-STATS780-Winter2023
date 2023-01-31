library(shiny)
library(ggplot2)

load("tidyData.RData")

ui <- fluidPage(
  selectInput(inputId = "x_var", 
            label = "Select a Product", 
            choices = unique(tidyData$Products),
            selected  = "All Products"),
  selectInput(inputId = "which_plot", 
            label = "Region", 
            choices = c("Canada", "All Provinces"),
            selected  = "Canada"),
  
#  selectInput(inputId = "y_var", 
#              # for internal use
#            label = "Choose variable for y axis", 
#            # tells the user what to do
#            choices = c("price"),
#            # additional argument 
#            # so that input function can do it's job
#            selected  = "price"),
  
  plotOutput(outputId = "plot" 
    
  )
)

server <- function(input, output){
  output$plot <- renderPlot({
    title <- "retail prices over time"
    if(input$which_plot == "Canada"){
      ggplot(data = subset(subset(tidyData, Products == input$x_var), GEO == "Canada")) +
        geom_line(aes(x = date, y = VALUE)) +
        labs(title = paste("Price of ", input$x_var, " over 2022", sep = "")) +
        xlab("Month (2022)") +
        ylab("Product Price (Canadian Dollar)") +
        scale_x_date(date_breaks = "months", date_labels = "%b") +
        theme(text = element_text(size = 20)) 
    }else{
      ggplot(data = subset(subset(tidyData, Products == input$x_var), GEO != "Canada")) +
        geom_line(aes(x = date, y = VALUE, colour = GEO)) +
        labs(colour = "Province", title = paste("Price of ", input$x_var, " over 2022", sep = "")) +
        xlab("Month (2022)") +
        ylab("Product Price (Canadian Dollar)") +
        scale_x_date(date_breaks = "months", date_labels = "%b") +
        theme(text = element_text(size = 20)) 
    }
    
  })
}

shinyApp(ui, server)
