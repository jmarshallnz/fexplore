library(shiny)
library(markdown)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

#  mainPanel(

  titlePanel("The F test for linear models", "F-test for linear models"),
  hr(),

  sidebarLayout(
    sidebarPanel(
                 withMathJax(includeMarkdown("ftest.md"))

    ),
    mainPanel(
      tabsetPanel(
       tabPanel("Data",
        h3("Total variation in data"),
        plotOutput("dataPlot"),
        p("The total variation in the data is found by finding the sum of the square distances (blue lines) between the data and the mean under the null model, where we have only an intercept (the dashed line)."),
        p("As y depends on x, we'd expect the variation in y to increase as the slope is larger in magnitude and also increase as the amount of additional variation increases.")
       ),
       tabPanel("Model",
        h3("Variation explained by the model"),
        plotOutput("linePlot"),
        p("The variation explained by the model is found by the sum of the square distances (blue lines) between the mean under the null model, where we have only an intercept (the dashed line), and the mean under the full model (the solid line)."),
        p("This will depend on the strength of the relationship, or the magnitude slope.")
       ),
       tabPanel("Residuals",
        h3("Residual variation"),
        plotOutput("residPlot"),
        p("The residual variation is what is left over after explaining the model, i.e. the sum of the squared distances (blue lines) between the data and the mean of the full model (the solid line)."),
        p("This is mostly governed by the residual variation slider.  Notice that the variation explained by the model plus the residual variation add to give total variation.")
       ),
       tabPanel("ANOVA",
        h3("ANOVA table"),
        verbatimTextOutput("anova"),
        fluidRow(column(7,
          p("The ANOVA table shows us the computation for the F statistic, and uses the F distribution to convert it to a P-value."),
          p("A low P-value (less than 0.05) indicates that the linear model describes significantly more variation in the response than the null model.  A high P-value (more than 0.05) indicates that the linear model doesn't describe more variation in the response as the null model, so we should prefer the null model.")
                       ),
                 column(5,
                   plotOutput("fdist", height="200px")
                       )
                )
       )
      ),
      wellPanel(fluidRow(
                column(4,sliderInput("n",
                  "Size of sample data:",
                  min = 10,
                  max = 100,
                  step = 5,
                  value = 30)),
                column(4,sliderInput("eta",
                  "Amount of residual variation:",
                  min = 0.05,
                  max = 1,
                  step = 0.05,
                  value = 0.6)),
               column(4,sliderInput("beta",
                  "Magnitude of slope:",
                  min = -3,
                  max = 3,
                  step = 0.01,
                  ticks = F,
                  value = 3)))
      )
    )
  )
))

