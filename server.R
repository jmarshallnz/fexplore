library(shiny)

get_xy <- function(n)
{
  x <- (rnorm(n, 0, 0.2) + 1:n) / (n+1)
  y <- rnorm(n, 0, 1)
  list(x=x-mean(x), y=y)
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot


  current_n  <- isolate(input$n)
  current_xy <- get_xy(current_n)

  get_current <- reactive({
      if (current_n != input$n)
      {
        current_n  <<- input$n
        current_xy <<- get_xy(current_n)
        cat("n updated to", current_n, "\n")
      }
      x <- current_xy$x
      y <- input$beta*x + current_xy$y * input$eta
      y <- y - mean(y)
      list(x=x, y=y)
    })

  output$anova <- renderPrint({
    d <- get_current();
    anova(lm(y ~ -1 + x, data=get_current()))
  })

  output$dataPlot <- renderPlot({
    d <- get_current();
    ss_y <- sum(d$y^2)
    par(mai=rep(0.1,4))
    plot(NULL, xlim=c(-0.5, 0.5), ylim = c(-4, 4), xlab="", ylab="", xaxt="n", yaxt="n")

    abline(h=0, lty="dashed")
    segments(d$x, 0, d$x, d$y, col="blue")
    points(d$x,d$y, pch=19)
    text(0.4, -3.2, bquote(SS[y] == .(round(ss_y, 2))), col="blue", cex=1.5)
  })

  output$linePlot <- renderPlot({
    d <- get_current();
    ss_x <- sum(d$x^2)
    par(mai=rep(0.1,4))
    plot(NULL, xlim=c(-0.5, 0.5), ylim = c(-4, 4), xlab="", ylab="", xaxt="n", yaxt="n")

    bhat <- coef(lm(y ~ -1 + x, data=d))
    abline(h=0, lty="dashed")
    abline(a=0, b=bhat, lwd=2)

    under <- ifelse(bhat*d$x < 0, bhat*d$x, 0)
    over  <- ifelse(bhat*d$x > 0, bhat*d$x, 0)
    segments(d$x, ifelse(under < d$y, under, d$y), d$x, under, lty="dotted")
    segments(d$x, ifelse(over > d$y, over, d$y), d$x, over, lty="dotted")
    segments(d$x, 0, d$x, bhat*d$x, col="red")

    points(d$x,d$y, pch=19)
    text(0.4, -3.2, bquote(SS[model] == .(round(bhat^2*ss_x, 2))), col="red", cex=1.5)
  })

  output$residPlot <- renderPlot({
    d <- get_current();
    par(mai=rep(0.1,4))
    plot(NULL, xlim=c(-0.5, 0.5), ylim = c(-4, 4), xlab="", ylab="", xaxt="n", yaxt="n")

    bhat <- coef(lm(y ~ -1 + x, data=d))
    rss <- sum((d$y - bhat*d$x)^2)

    abline(a=0, b=bhat, lwd=2)
    segments(d$x, bhat*d$x, d$x, d$y, col="red")
    points(d$x, d$y, pch=19)
    text(0.4, -3.2, bquote(SS[res] == .(round(rss, 2))), col="red", cex=1.5)
  })
})

