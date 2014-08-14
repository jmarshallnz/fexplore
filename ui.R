library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

#  mainPanel(

  fluidRow(
      column(6,h1("The F test for linear models"),
               p("The F test is a general way to assess whether a linear model explains a signficant portion of the variaion in the response variable."),
               p("The idea is to partition the variation in the response into variation explained by the linear model, and left over, or residual variation."),
               tags$ul(tags$li("If the amount explained by the model is quite large compared to the amount of residual variation, then it would have been unlikely to have arisen by chance, and so we'd conclude that the relationship observed in our sample is likely to hold for the population."), tags$li("If the amount explained by the model is small compared to the amount of residual variation, then the relationship observed in the data may have arisen by chance, so we make no conclusion regarding the population.")),
               p("How large the variation explained by the model needs to be in order to make the above decision can be found by  computing the F-statistic"),
              withMathJax(helpText("$$F = \\frac{SS_{model} / p}{SS_{res} / (n-p-1)}$$")),
              p("where \\(p\\) is the number of parameters in the model (1 for simple linear regression)."),
              p("If the residuals are normally distributed with constant variance (standard assumptions of linear regression) then it turns out that \\(F\\) will have an F distribution with \\(p\\) and \\(n-p-1\\) degrees of freedom.  This allows us to compute the P-value.")
      ),
      column(2,sliderInput("n",
                  "Size of sample data:",
                  min = 5,
                  max = 100,
                  step = 5,
                  value = 10),
               sliderInput("eta",
                  "Amount of residual variation:",
                  min = 0,
                  max = 1,
                  step = 0.05,
                  value = 0.3),
               sliderInput("beta",
                  "Magnitude of slope:",
                  min = -3,
                  max = 3,
                  step = 0.01,
                  ticks = F,
                  value = 1)
      ),
      column(4,verbatimTextOutput("anova"))
  ),
  hr(),

  fluidRow(
      column(4,
        h3("Total variation in data"),
        plotOutput("dataPlot"),
        p("The total variation in the data is found by finding the sum of the square distances (blue lines) between the data and the mean under the null model, where we have only an intercept (the dashed line)"),
        p("As y depends on x, we'd expect the variation in y to increase as the slope is larger in magnitude and also increase as the amount of additional variation increases")
      ),
      column(4,
        h3("Variation explained by the model"),
        plotOutput("linePlot"),
        p("The variation explained by the model is found by the sum of the square distances (red lines) between the mean (the null model, where we have only an intercept (the dashed line), and the mean under the full model (the solid line)"),
        p("This will depend on the strength of the relationship, or the magnitude slope")
      ),
      column(4,
        h3("Residual variation"),
        plotOutput("residPlot"),
        p("The residual variation is what is left over after explaining the model, i.e. the sum of the squared distances (red lines) between the data and the mean of the full model (the solid line)"),
        p("This is mostly governed by the residual variation slider.  Notice that the variation explained by the model plus the residual variation add to give total variation.")
     )
  )
 # )
))

