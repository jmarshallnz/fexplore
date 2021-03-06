The F test is a general way to assess whether a linear model explains a signficant portion of the variation in the response variable.

The idea is to partition the total variation, or sum of squares, in the response $SS_{tot}$ into variation explained by the linear model $SS_{model}$, and left over, or residual variation $SS_{res}$
$$SS_{tot} = SS_{model} + SS_{res}.$$
The comparative size of $SS_{model}$ and $SS_{res}$ can be used to ascertain whether the model explains a significnat proportion of the variation.
- If $SS_{model}$ is large compared with $SS_{res}$, then it would have been unlikely to have arisen by chance, and so we'd conclude that the relationship observed in our sample is likely to hold for the population.
- If $SS_{model}$ is small compared to $SS_{res}$, then the relationship observed in the data may have arisen by chance, so we make no conclusion regarding the population.

Just how large the variation explained by the model needs to be in order to make the above decision can be found by  computing the F-statistic
$$F = \frac{SS_{model} / p}{SS_{res} / (n-p-1)}$$
where $p$ is the number of parameters in the model (1 for simple linear regression), and $n$ is the sample size.

If the residuals are normally distributed with constant variance (standard assumptions of linear regression) then it turns out that $F$ will have an F distribution with $p$ and $n-p-1$ degrees of freedom.  This allows us to compute the P-value.

The `anova` command in R can do this for us.

Click on the **Data**, **Model**, **Residuals** and **ANOVA** tabs on the right to see how the sum of squares partitions, and use the sliders to see how this changes with sample size, slope and differing amounts of residual variation.
