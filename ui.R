# ui.R
dashboardPage(
  dashboardHeader(title = "cran.rstudio.com"),
  dashboardSidebar(
    textInput("firebase_node", "Firebase Node", "test3"),
    textInput("firebase_key", "Firebase Key", "int"),
    textInput("symb", "Symbol", "SPY"),
    sliderInput("rateThreshold", "Warn when rate exceeds",
                min = 0, max = 50, value = 3, step = 0.1
    ),
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard"),
      menuItem("Raw data", tabName = "rawdata")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem("dashboard",
              fluidRow(column(12,
                valueBoxOutput(width=4, "count"),              
                valueBoxOutput(width=4, "rate"))
                # valueBoxOutput("count"),
                # column(4,valueBoxOutput("users"))
              )
      ),
      tabItem("rawdata",
              numericInput("maxrows", "Rows to show", 25),
              verbatimTextOutput("rawtable"),
              downloadButton("downloadCsv", "Download as CSV")
      )
    )
  )
)


# 
# ui <- fluidPage(
#   titlePanel("Hello Shiny!"),
#   fluidRow(
#     valueBoxOutput("rate"),
#     valueBoxOutput("count"),
#     valueBoxOutput("users")
#   ),
#   column(6,
#   fluidRow(column(12,
#   mainPanel(
#     sliderInput("obs",
#                 "Number of observations",
#                 min = 1,
#                 max = 5000,
#                 value = 100))),
#     plotOutput("distPlot")
#   )),
#   column(6,
#   fluidRow(column(6,
#         sliderInput("obs2",
#                     "Number of observations",
#                     min = 1,
#                     max = 5000,
#                     value = 300))),
#   fluidRow(column(12,
#         plotOutput("distPlot2"))
#   ))
# )