#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
   # Application title
   titlePanel("Hello Shiny!"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        selectInput("term", 
                  label = "Term Length", 
                  choices = list("36 months" = "36 months", "60 months" = "60 months"), 
                  selected = 1),
        textInput("my_text", 
                  label = "Text input",
                  value = "Enter text..."),
        numericInput("my_num",
                  label = "Numeric input", 
                  value = 1),
        submitButton(text="Submit"),
        actionButton("do", "Click Me")
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        textOutput("text1")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

   

   output$text1 <- renderText({
     paste("You have selected ", input$term)
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

