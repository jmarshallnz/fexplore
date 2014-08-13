library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("The F test"),

  # Sidebar with a slider input for the number of bins
  fluidRow(
      column(4,sliderInput("n",
                  "Number of data (n):",
                  min = 5,
                  max = 100,
                  step = 5,
                  value = 10)),

      column(4,sliderInput("eta",
                  "Amount of residual variation:",
                  min = 0,
                  max = 1,
                  step = 0.05,
                  value = 0.3))

      ,column(4,verbatimTextOutput("anova"))
  ),
  hr(),

  plotOutput("distPlot")
))

