# Curve fitting

[Curve fitting](https://en.wikipedia.org/wiki/Curve_fitting) is the process of postulating a function that explains the trend in the data only based on how well the variance in the data is explained. Curve fitting may refer to both [data interpolation](https://en.wikipedia.org/wiki/Interpolation) and [regression](https://en.wikipedia.org/wiki/Regression_analysis). Here we will mainly focus on the regression. 

There are several algorithms that are used for solving both linear and non-linear regression problems. One of the most commonly used approaches for regression analysis is the [least squares](https://en.wikipedia.org/wiki/Least_squares#Differences_between_linear_and_nonlinear_least_squares).

## Least squares

For linear regression problems the least squares solution tries to minimize the squared distances between each measured data point and the potential line/function at the same time. Let's imagine a case where we have measured the signal associated with different concentrations of a chemical in solution (i.e. [external standard calibration curve](https://en.wikipedia.org/wiki/Calibration_curve)). 

```@example cft
using DataSci4Chem

cal = [5.871	1
	   16.224	2
	   16.628	2
	   21.9	    3
	   32.172	4
	   33.006	4
	   44.512	5
	   53.285	6
 	   55.985	6
	   104.403	9]

scatter(cal[:,1],cal[:,2],label = "measured data",xlabel = "concentration",ylabel="signal")

```
The solution to this problem is a function *``f(x) = ax + b``*, where *a* and *b* are the slope and intercept of the potential line describing these data. As it was stated before, we are aiming at minimizing the squared distances between the *f(x)* and the data points. The first step will be to define the distance between *``y_i``* and *``f(x_i)``*, defined as the difference between the two points resulting in the following:

```math

\sum_{i=1}^{n} (d_i)^2 \\
\sum_{i=1}^{n} (y_i - f(x_i))^2

```

The least squares algorithm aims at minimizing the sum of these distances (i.e. sum squared residuals) to find the best fitting curve into the data. 

```math

\sum_{i=1}^{n} (y_i - f(x_i))^2 \rightarrow 0

```

Let's assume that our data can be described by *``f(x) = ax + b``*, which is a simple linear solution to our problem. This implies that we can rewrite the above equation by plugging in the value of *f(x)* into our equation. 

```math

\sum_{i=1}^{n} (y_i - (ax_i + b))^2 \rightarrow 0

```

There are different ways of solving this problem namely: analytically and numerically. 

!!! note 
	The analytical solutions are only possible for linear problems while for nonlinear system the solution must be found numerically. 

### Ordinary least squares 

To find the solution to this we could utilize the systems of equations built using the objective function *f(x)* and the data. For example, if selecting four points in our data, we will end up with the below system. 

```math

y_1 = ax_1 + b\\
y_2 = ax_2 + b\\
y_3 = ax_3 + b\\
y_4 = ax_4 + b

```

This system of equations can be translated into a set of matrices.

```math 

\begin{bmatrix} y_1\\ y_2\\ y_3\\ y_4 \end{bmatrix} = \begin{bmatrix} 1 & x_1\\ 1 & x_2\\ 1 & x_3\\ 1 & x_4 \end{bmatrix} \times 

\begin{bmatrix} b \\ a \end{bmatrix}

```

As we saw before we can solve this system using the elimination approach. We also can use the solution of ordinary least squares problem to find the two unknown parameters. 

```math 

\begin{bmatrix} b \\ a \end{bmatrix} = (X^{T}X)^{-1}X^{T}Y 

```
!!! warning 
	Please note the moment the objective function does not meet the linearity criteria this solution will not work. 


```@example cft
using DataSci4Chem

X = cal[:,1]
Y = cal[:,2]

X1 = hcat(ones(length(X),1),X)

beta = pinv(X1'*X1)*X1' * Y 

```

```@example cft
using DataSci4Chem

f(x) = beta[1] .+ beta[2].*x 

plot!(X,f(X),label="model")

```

### Numerical approach

This also can be solved numerically. We still start with an objective function *f(x)* and try to find the parameters of such function through an iterative manner. Let's start with a randomly selected set of parameters for example *a=0* and *b=10*. 

```@example cft
using DataSci4Chem

a_p = 0
b_p = 10

fh(x) = b_p .+ (a_p .* x) 

plot!(X,fh(X),label="random parameters")

```

Now we can calculate the *SSR* as a metric for how well our random parameters are performing in modeling the trend in our data. For this we first calculate the residuals of the potential model, and then these residuals are squared and summed. 

```@example cft
using DataSci4Chem

SSR = sum((fh(X) .- Y).^2)

```

Now we can update the parameters with new values and repeat this process. 

```@example cft
using DataSci4Chem

a_p = collect(range(-1,2,length=10))
b_p = collect(range(-5,5,length=10))

SSR_m = zeros(length(a_p))

for i=1:length(a_p)

	fh(x) = b_p[i] .+ (a_p[i] .* x) 
	SSR_m[i] = sum((fh(X) .- Y).^2)

end 

scatter(SSR_m,label=false, xlabel="try",ylabel="SSR")

```
Where the *SSR* plot has a minimum is the set of model parameters with lowest error and thus the best fit. 

```@example cft
using DataSci4Chem

fh(x) = b_p[argmin(SSR_m)] .+ (a_p[argmin(SSR_m)] .* x) 

scatter(cal[:,1],cal[:,2],label = "measured data",xlabel = "concentration",ylabel="signal")
plot!(X,f(X),label="analytical model")

plot!(X,fh(X),label="numerical model 10 steps",ls =:dot,lw=3)

```

!!! note 
	Higher is the number of the steps, thus higher resolution, of the parameter space exploration, the more accurate results can be obtained. 


```@example cft
using DataSci4Chem

a_p = collect(range(-1,2,length=1000))
b_p = collect(range(-5,5,length=1000))

SSR_m = zeros(length(a_p))

for i=1:length(a_p)

	fh(x) = b_p[i] .+ (a_p[i] .* x) 
	SSR_m[i] = sum((fh(X) .- Y).^2)

end 

fh(x) = b_p[argmin(SSR_m)] .+ (a_p[argmin(SSR_m)] .* x) 

scatter(cal[:,1],cal[:,2],label = "measured data",xlabel = "concentration",ylabel="signal")
plot!(X,f(X),label="analytical model")

plot!(X,fh(X),label="numerical model 1000 steps",ls =:dot,lw=3)

```

!!! tip 
	You can also use a more data deriven approach to exploring the model parameter space, for example [Bayesian regression](https://en.wikipedia.org/wiki/Bayesian_linear_regression). More details on how to do this is provided [here](https://emcms.github.io/ACS.jl/dev/Bayes/). 

## Nonlinear fit 

There are several numerical approaches that are able to solve both linear and nonlinear problems, referred to [nonlinear solvers](https://en.wikipedia.org/wiki/Non-linear_least_squares). For these solvers to work, they need a starting point and the interest window for each parameter. Depending on the implementation, they may have different kernels to solve such systems. For example the package [*LsqFit.jl*](https://julianlsolvers.github.io/LsqFit.jl/latest/) incorporated into *DataSci4Chem.jl* employs the [Gauss-Newton](https://en.wikipedia.org/wiki/Gauss%E2%80%93Newton_algorithm) algorithm. 


To solve linear problems you need to define your objective model as a combination of independent variables and the model parameters. For example, our current system is defined as following. 


```@example cft
using DataSci4Chem

model(x,p) = p[1] .* x .+ p[2]

```

Now that the objective function is already built, we can use our data to fit our data. For that we need to provide the algorithm with a set of starting points as well as the data. 


```@example cft
using DataSci4Chem

p0 = [0.5, 0.5]

fit = curve_fit(model, X, Y, p0)
fit.param

```

!!! warning 
	The starting points must be close to the true value of the parameters otherwise, the algorithm may not be able to find the best fit, particularly for more complex systems. 

For more complex systems, we must provide our algorithm with parameter bounds besides the starting points. These will be particularly helpful for cases that multiple solutions to the system is possible (e.g. Gaussian fit). 


```@example cft
using DataSci4Chem

lb = [-2.0, -2.0]
ub = [2.0, 2.0]

fit = curve_fit(model, X, Y, p0, lower=lb, upper=ub)
fit.param

```

!!! warning 
	The parameter bounds must be float64! If integers are provided, the algorithm will give you an error.

## Goodness of the fit

Now that we have managed to fit an objective function to our model, we need to evaluate whether the fitted model is good enough, or representative of our data. There are different metrics for this assessment. Here we are going to discuss the residuals, root mean squared error (RMSE), and  coefficient of determination (i.e. *``R^2``*).

### Residuals

Residuals are the difference between each *``y_i``* and *``f(x_i)``*. For a model that is able to represent our data well without any systematic error, we want to see a random distribution of the residuals across *X*. 

```@example cft
using DataSci4Chem

fh2(x) = fit.param[1] .* x .+ fit.param[2]

res = fh2(X) - Y 

scatter(X,res,xlabel ="X values", ylabel = "residuals", label =false)
plot!([0,105],[0,0],label=false)

```

As you can see from the above figure, there is not a clear trend in the distribution of the residuals, indicating the our model is able to capture the underlying trend in our data. In case of observed trends, we can deduce that our objective function is not well suited to describe such trends. 

### RMSE

[RMSE](https://en.wikipedia.org/wiki/Root-mean-square_deviation) provides a metrics of the magnitude of the error in the model predictions. As you can deduce from the name, it is a combined measure of residuals. 

```math 

RMSE = \sqrt{mean(Y - f(X))}

```

Smaller RMSE values indicate that the model is able to explain higher levels of variance in the data. There is not a clear cut off for RMSE for accepting or rejecting a model. It is mainly used for comparing two or more models against each other.

### ``R^2``

[``R^2``](https://en.wikipedia.org/wiki/Coefficient_of_determination) similarly to the other measures is an indicator for the goodness of fit. ``R^2`` in practice is showing how much better your model is in describing your data than the average value. Mathematically the ``R^2`` is calculated as below

```math 

R^2 = 1 - \frac{\sum_{i=1}^{n} (y_i - f(x_i))^2}{\sum_{i=1}^{n} (y_i - \bar y)^2}

```
``R^2`` can range between zero, no trend, to one, perfect correlation. The larger ``R^2`` values show that the fitted model a lot better than the *``\bar Y``* in describing our data. For example for our model the ``R^2`` can be calculated as follows.

```@example cft
using DataSci4Chem


res_t = fh2(X) .- mean(Y) 

R2 = 1 - sum(res.^2)/sum(res_t.^2)

```
Usually, ``R^2`` values above 0.6 indicate that the model is able to explain a large portion of variance in the data. 

!!! tip 
	For complex and multivariate systems, ``R^2`` values close to one may indicate an issue of [overfitting](https://en.wikipedia.org/wiki/Overfitting).

!!! note 
	Another metrics that can be used for the assessment of your fit quality is the confidence interval (CI) of your model. The CI of your model can be estimated based on the residuals and the t-distribution. There are also numerical approaches such as [bootstrapping](https://en.wikipedia.org/wiki/Bootstrapping_(statistics)) and [leave one out](https://en.wikipedia.org/wiki/Cross-validation_(statistics)) to do these calculations. 

## Additional resources 

For additional resources, please take a look at this MIT open course ware [here:](https://ocw.mit.edu/courses/18-06-linear-algebra-spring-2010/resources/lecture-16-projection-matrices-and-least-squares/). 
