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

scatter(cal[:,1],cal[:,2],label = "calibration line",xlabel = "concentration",ylabel="signal")

```