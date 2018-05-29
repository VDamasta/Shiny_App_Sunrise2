#install.packages("shinydashboard")

library(shiny)
library(shinydashboard)
library(DT)
library(data.table)

ui <- dashboardPage(
  dashboardHeader(title = "Run Results Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Results", tabName = "resuts", icon = icon("signal")),
      menuItem("Analysis", tabName = "analysis", icon = icon("dashboard"))
    )
    
  ),
  dashboardBody(
    
  box(fileInput("file1", "Choose CSV File",
                          multiple = FALSE,
                          accept = c("text/csv"))),
  
  box(radioButtons("sep", "Separator",
               choices = c(Comma = ",",
                           Semicolon = ";",
                           Tab = "\t"),
               selected = ",")),
  
  box(selectInput("scen",
              "Scenario",
              c("All",
                unique(as.character("1")))),
      
      selectInput("var",
                  "Variable",
                  c("All",
                    unique(as.character("ANN_LIAB_CF")))),
      
      selectInput("prod",
                  "level",
                  c("All",
                    unique(as.character("F_PULK004"))))
      
      ),
  
  box(selectInput("oper",
                  "Output",
                  c("Mean", "StDev", "Sum")),
      selectInput("group",
                  "Group by",
                  c("Variable", "Scenario", "Product")),
      downloadButton("data2")
      ),
  
  DT::dataTableOutput("data1")
  
  
  #box(downloadButton("data2", "Download"),
   #   downloadButton("data3", "Download")
    #  )
  
))

server <- function(input, output) { 
  output$data1 <- DT::renderDataTable(DT::datatable({
    req(input$file1)
    
    tryCatch(
      {
        df <- read.csv(input$file1$datapath,
                       header = TRUE,
                       sep = input$sep,
                       quote = )
        #df <- data.table(df)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
    if (input$scen != "All") {
      df <- df[df$iter == input$scen,]
    }
    
    if (input$var != "All") {
      df <- df[df$attribute == input$var,]
    }
    
    if (input$prod != "All") {
      df <- df[df$level == input$prod,]
    }
    
    # add a reset button to put default to all
    
    df
    
  })
    
    
  )
  
  }

shinyApp(ui, server)

# so the idea is to create a first Sidebar that would be an equivalent of Proj and Stoch_result
# both would be possible a the same time
# Panel 1 
# 1) You load the csv file 
# 2) You ask the varable you want 
# 3) you say the scenario you want it on and what kind of data you want (Mean, Stdev ..., or simply all)
# 4) Product agregation as well, 2 things product name and spcode 
# 4) You get this loaded in an excel file 

# Panel 2 : Run comparisons 
# 

