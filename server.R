library(shiny)

get_xy <- function(n)
{
  x <- (rnorm(n, 0, 0.2) + 1:n) / (n+1)
  y <- rnorm(n, 0, 1)
  # get rid of residual variation in y
  x <- x - mean(x)

  b <- coef(lm(y ~ x))[2]
  y <- y - b*x

  list(x=x, y=y)
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
      }
      x <- current_xy$x
      y <- input$beta*x + current_xy$y * input$eta
      y <- y - mean(y)
      list(x=x, y=y)
    })

  output$fdist <- renderPlot({
    f <- anova(lm(y ~ -1 + x, data=get_current()))$F[1]
    n <- input$n; p <- 1
    xm <- qf(c(0.5, 0.95, 0.9999), p, n-p-1)
    xm[3] <- max(xm[3], f)
    x <- seq(xm[1],xm[3],length.out=100)
    y <- df(x, p, n-p-1)
    par(mai=c(0.5,0.1,0.1,0.1))
    plot(NULL,xlab="F", ylab="", xlim=c(0, max(x)), ylim=range(y), type="l", yaxt="n", main="")
    if (f < xm[3]) {
      xp <- seq(f, xm[3],length.out=100)
      yp <- df(xp, p, n-p-1)
      polygon(c(f,xp,xm[3]),c(0,yp,0), col="grey90", border="grey70")
    }
    lines(x,y)
    abline(v=xm[2], lty="dotted")
    abline(v=f, col="red")
  })

  output$anova <- renderPrint({
    anova(lm(y ~ -1 + x, data=get_current()))
  })

  output$dataPlot <- renderPlot({
    d <- get_current();
    ss_y <- sum(d$y^2)
    par(mai=rep(0.1,4))
    plot(NULL, xlim=c(-0.5, 0.5), ylim = c(-4, 4), xlab="", ylab="", xaxt="n", yaxt="n")

    abline(h=0, lty="dashed")
    segments(d$x, 0, d$x, d$y, col="blue", lwd=1.5)
    points(d$x,d$y, pch=19)
    text(0.4, -3.2, bquote(SS[tot] == .(round(ss_y, 2))), col="blue", cex=1.5)
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
    segments(d$x, ifelse(under < d$y, under, d$y), d$x, under, lty="dotted", col="grey60")
    segments(d$x, ifelse(over > d$y, over, d$y), d$x, over, lty="dotted", col="grey60")
    segments(d$x, 0, d$x, bhat*d$x, col="blue", lwd=1.5)

    points(d$x,d$y, pch=19)
    text(0.4, -3.2, bquote(SS[model] == .(round(bhat^2*ss_x, 2))), col="blue", cex=1.5)
  })

  output$residPlot <- renderPlot({
    d <- get_current();
    par(mai=rep(0.1,4))
    plot(NULL, xlim=c(-0.5, 0.5), ylim = c(-4, 4), xlab="", ylab="", xaxt="n", yaxt="n")

    bhat <- coef(lm(y ~ -1 + x, data=d))
    rss <- sum((d$y - bhat*d$x)^2)

    abline(a=0, b=bhat, lwd=2)
    segments(d$x, bhat*d$x, d$x, d$y, col="blue", lwd=1.5)
    points(d$x, d$y, pch=19)
    text(0.4, -3.2, bquote(SS[res] == .(round(rss, 2))), col="blue", cex=1.5)
  })
})

