The F test is a general way to assess whether a linear model explains a signficant portion of the variaion in the response variable.

The idea is to partition the total variation, or sum of squares, in the response $SS_{tot}$ into variation explained by the linear model $SS_{model}$, and left over, or residual variation $SS_{res}$.
- If the amount explained by the model $SS_{model}$ is quite large compared to the amount of residual variation $SS_{res}$, then it would have been unlikely to have arisen by chance, and so we'd conclude that the relationship observed in our sample is likely to hold for the population.
- If the amount explained by the model $SS_{model}$ is small compared to the amount of residual variation $SS_{res}$, then the relationship observed in the data may have arisen by chance, so we make no conclusion regarding the population.

How large the variation explained by the model needs to be in order to make the above decision can be found by  computing the F-statistic
$$F = \frac{SS_{model} / p}{SS_{res} / (n-p-1)}$$
where $p$ is the number of parameters in the model (1 for simple linear regression), and $n$ is the sample size.

If the residuals are normally distributed with constant variance (standard assumptions of linear regression) then it turns out that $F$ will have an F distribution with $p$ and $n-p-1$ degrees of freedom.  This allows us to compute the P-value.

The `anova` command in R can do this for us.
