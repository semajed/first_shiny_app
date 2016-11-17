#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library("RCurl")
library("rjson")

# Define UI for application that draws a histogram
ui <- fluidPage(
  
   # Application title
   titlePanel("Prediction Calculator"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        selectInput("term", 
                  label = "Term Length", 
                  choices = list("36 months" = "36 months", 
                                 "60 months" = "60 months"), 
                  selected = 1),
        numericInput("int_rate",
                  label = "Interest Rate",
                  value = .2),
        numericInput("installment",
                     label = "Installment",
                     value = 1000),
        selectInput("emp_length", 
                    label = "Employee Length", 
                    choices = list("< 1 year" = "1 year", 
                                   "2 years" = "2 years",
                                   "3 years" = "3 years",
                                   "4 years" = "4 years",
                                   "5 years" = "5 years",
                                   "6 years" = "6 years",
                                   "7 years" = "7 years",
                                   "8 years" = "8 years",
                                   "9 years" = "9 years",
                                   "10+ years" = "10+ years"
                    ), 
                    selected = 1),
        selectInput("home_ownership", 
                    label = "Home Ownership", 
                    choices = list("MORTGAGE" = "MORTGAGE",
                                   "OWN" = "OWN",
                                   "RENT" = "RENT"
                    ),
                    selected = 1),
        numericInput("ann_inc",
                     label = "Annual Income",
                     value = 30000),
        selectInput("is_inc_v", 
                    label = "Is income verified?", 
                    choices = list("Verified" = "Verified",
                                   "Not Verified" = "Not Verified",
                                   "Source Verified" = "Source Verified"
                    ),
                    selected = 1),
        selectInput("purpose", 
                    label = "Purpose of loan?", 
                    choices = list("Car" = "car",
                                   "Home Improvement" = "home_improvement",
                                   "House" = "house",
                                   "Debt Consolidation" = "debt_consolidation",
                                   "Vacation" = "vacation",
                                   "Wedding" = "wedding"
                    ),
                    selected = 1),
        numericInput("dti",
                     label = "Debt-to-income ratio?",
                     value = .2),
        actionButton("do", "Click here if you're not a robot"),
        br(),
        submitButton(text="Submit")
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        textOutput("result_score")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$text1 <- renderText({
    paste("You have selected ", input$term)
  })
  
  observeEvent(input$do, {
    options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
    
    h = basicTextGatherer()
    hdr = basicHeaderGatherer()
    
    req =  list(
      Inputs = list(
        "input1"= list(
          list(
            'id' = "1",
            'member_id' = "1",
            'loan_amnt' = "1",
            'term' = input$term,
            'int_rate' = input$int_rate,
            'installment' = input$installment,
            'grade' = "A",
            'sub_grade' = "A1",
            'emp_length' = input$emp_length,
            'home_ownership' = input$home_ownership,
            'annual_inc' = input$ann_inc,
            'is_inc_v' = input$is_inc_v,
            'loan_status' = "Current",
            'purpose' = input$purpose,
            'addr_state' = "TX",
            'dti' = input$dti,
            'delinq_2yrs' = "1",
            'earliest_cr_line' = "1",
            'inq_last_6mths' = "1",
            'open_acc' = "1",
            'pub_rec' = "1",
            'revol_bal' = "1",
            'revol_util' = "1",
            'total_acc' = "1",
            'out_prncp' = "1",
            'total_pymnt' = "1",
            'total_rec_prncp' = "1",
            'total_rec_int' = "1",
            'pub_rec_bankruptcies' = "1",
            'tax_liens' = "1"
          )
        )
      ),
      GlobalParameters = setNames(fromJSON('{}'), character(0))
    )
    
    body = enc2utf8(toJSON(req))
    api_key = "NeHH1PSWKUQsFspUl+7sjTUHCTgQHWmCy3GNcV30UAOibmb/1Hi2NkIl97mQgpb/od8N1ryohkENQ5jTe545mw==" # Replace this with the API key for the web service
    authz_hdr = paste('Bearer', api_key, sep=' ')
    
    h$reset()
    curlPerform(url = "https://ussouthcentral.services.azureml.net/workspaces/97ac4e49472e428c94edbac1a06de9c0/services/2c9a5b22712e4bf59492a12e13bcbf8f/execute?api-version=2.0&format=swagger",
                httpheader=c('Content-Type' = "application/json", 'Authorization' = authz_hdr),
                postfields=body,
                writefunction = h$update,
                headerfunction = hdr$update,
                verbose = TRUE
    )
    
    headers = hdr$value()
    httpStatus = headers["status"]
    if (httpStatus >= 400)
    {
      print(paste("The request failed with status code:", httpStatus, sep=" "))
      
      # Print the headers - they include the requert ID and the timestamp, which are useful for debugging the failure
      print(headers)
    }
    
    print("THIS IS YOUR RESULT:")
    result = h$value()
    print(result)
    print(fromJSON(result))
    
    result_score = substring(result, 25)
    print(result_score)
    print(class(result_score))
    output$result_score = renderText({result_score})
    
    
  })
   

   
}

# Run the application 
shinyApp(ui = ui, server = server)

