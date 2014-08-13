library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot

  beta <- 0.5


  output$anova <- renderPrint({
    x <- rnorm(input$n, 0, 0.2) + 1:input$n
    y <- beta*x + rnorm(input$n, 0, input$eta * beta * input$n)
    x <- x-mean(x)
    y <- y-mean(y)
    anova(lm(y ~ -1 + x))}
  )

  output$distPlot <- renderPlot({

    x <- rnorm(input$n, 0, 0.2) + 1:input$n
    y <- beta*x + rnorm(input$n, 0, input$eta * beta * input$n)

    x <- x-mean(x)
    y <- y-mean(y)

    bhat <- coef(lm(y ~ -1 + x))

    # ok, work out ss_y
    ss_y <- sum(y^2)
    ss_x <- sum(x^2)
    ss_xy <- sum(x*y)

    # work out rss
    rss <- sum((y - bhat*x)^2)

    # factor ss_y into rss

    # plot x vs y
    par(mfrow=c(1,3))
    plot(NULL, xlim=max(abs(x)) * c(-1, 1), ylim = max(abs(y)) * c(-1, 1), xlab="", ylab="", xaxt="n", yaxt="n")

    abline(h=0, lty="dashed")
    segments(x, 0, x, y, col="blue")
    points(x,y, pch=19)
    text(0.8*max(abs(x)), -0.8*max(abs(y)), bquote(SS[y] == .(round(ss_y, 2))), col="blue", cex=1.5)

    plot(NULL, xlim=max(abs(x)) * c(-1, 1), ylim = max(abs(y)) * c(-1, 1), xlab="", ylab="", xaxt="n", yaxt="n")
    abline(h=0, lty="dashed")
    abline(a=0, b=bhat, lwd=2)

    under <- ifelse(bhat*x < 0, bhat*x, 0)
    over  <- ifelse(bhat*x > 0, bhat*x, 0)
    segments(x, ifelse(under < y, under, y), x, under, lty="dotted")
    segments(x, ifelse(over > y, over, y), x, over, lty="dotted")
    segments(x, 0, x, bhat*x, col="red")

    points(x,y, pch=19)
    text(0.8*max(abs(x)), -0.8*max(abs(y)), bquote(SS[line] == .(round(bhat^2*ss_x, 2))), col="red", cex=1.5)

    plot(NULL, xlim=max(abs(x)) * c(-1, 1), ylim = max(abs(y)) * c(-1, 1), xlab="", ylab="", xaxt="n", yaxt="n")
    abline(a=0, b=bhat, lwd=2)
    segments(x, bhat*x, x, y, col="red")
    points(x,y, pch=19)
    text(0.8*max(abs(x)), -0.8*max(abs(y)), bquote(SS[res] == .(round(rss, 2))), col="red", cex=1.5)
  })
})

