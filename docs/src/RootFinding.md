# Numerical root finding 

[Root finding](https://en.wikipedia.org/wiki/Root-finding_algorithms) is the process of solving an equation for a specific variable. For example, the only root of *f(x) = ax + b* is the intersection between the *f(x)* and the x axis. In practice you are solving the below system of equations. 

```math 

f(x) = ax + b \\
f(x) = 0 

```

For simpler and low order equations the root finding can be performed in analytical manner while for complex systems [numerical methods](https://en.wikipedia.org/wiki/Numerical_analysis) are utilized. Generally speaking, the numerical root finding methods are divided in four categories: bounded needing derivative (will not be discussed), unbounded with derivative, bounded without derivative, and those unbounded without derivative. Each of these methods have their own advantages and disadvantages.

## Unbounded with derivative

### Newton's method

#### Theory

This strategy is one of the most commonly used approach to numerical root finding with [Newton's method](https://en.wikipedia.org/wiki/Newton%27s_method) being the most well known of these methods. This is an iterative method where during the first iteration an initial guess *``x_0``* for the potential root is made. Then both the *f(x)* and *f'(x)* are solved for *``x_0``*, which provides the intercept with the x axis. This value is assumed to be a better estimation of the root compared to the initial guess. Let's drive the Newton's method. 

```math 

f(x) = f'(x)x + c

```
Here *f'(x)* is the slope of the *f(x)* and *c* is the intercept. If we want to drive the equation of the tangent (i.e. slope) of the line that goes through *f(x)* and 0, we will end up with the below equation.

```math 

f'(x) = \frac{f(x_n) - 0}{x_n - x_{n+1}}

```

Now we can solve this for *``x_{n+1}``*, which will give us the new estimate of the root of *f(x)*. 

```math 

x_{n+1} = x_n - \frac{f(x_n)}{f'{x_n}}

```

Each iteration will give us a better estimate of the root. 

#### Example Newton's method

Let's try find the root of an example function *``f(x) = x^{2} - 9``*. The very first step here is to plot this function to see how ot looks. 

```@example nrf
using DataSci4Chem

x = collect(0:0.1:10)

f(x) = x.^2 .- 9

plot(x,f(x),label = "Example function", xlabel = "x values", ylabel = "f(x)")
plot!([0,10],[0,0], label = "f(x) = 0")

```

Now let's pick a random *x* value as our first guess for example *``x = 0.5``*. Let's first evaluate the *f(0.5)* as our first step.  

```@example nrf
using DataSci4Chem

x_n = 0.5

y1 = f(x_n)

plot(x,f(x),label = "Example function", xlabel = "x values", ylabel = "f(x)")
plot!([0,10],[0,0], label = "f(x) = 0")
scatter!([x_n], [y1], label = "f(0.5)")

```
The next step is to calculate the *f'(x)* in order to evaluate the *f'(0.5)*. From our calculus we know that the first derivative of *f(x)* (i.e. *f'(x)*) is *``f'(x) = 2x``*. Now we can calculate the *``x_{n+1}``*, given that we have all parts of the above equation. 

```@example nrf
using DataSci4Chem

df(x) = 2 .* x


x_n1 = x_n - f(x_n)/df(x_n)

```

```@example nrf
using DataSci4Chem


plot(x,f(x),label = "Example function", xlabel = "x values", ylabel = "f(x)")
plot!([0,10],[0,0], label = "f(x) = 0")
scatter!([0.5], [y1], label = "f(0.5)")
scatter!([x_n1], [0], label = "f'(x_n1)")
plot!([0.5,x_n1],[y1,0],label ="slope")

```

At this point we have the updated *``x_n``*, which we called *x_n1*. To move forward we need to repeat the previous process using the new *``x_n``*. 

```@example nrf
using DataSci4Chem

x_n = deepcopy(x_n1)
y2 = f(x_n)
x_n1 = x_n - f(x_n)/df(x_n)

plot(x,f(x),label = "Example function", xlabel = "x values", ylabel = "f(x)")
plot!([0,10],[0,0], label = "f(x) = 0")
scatter!([0.5], [y1], label = "f(0.5)")
scatter!([x_n1], [0], label = "f'(x_n1)")
plot!([0.5,x_n1],[y1,0],label ="slope")
plot!([x_n,x_n1],[y2,0],label ="slope, iter = 2")


```
And for the 3rd iteration:

```@example nrf
using DataSci4Chem

x_n = deepcopy(x_n1)
y2 = f(x_n)
x_n1 = x_n - f(x_n)/df(x_n)

plot(x,f(x),label = "Example function", xlabel = "x values", ylabel = "f(x)")
plot!([0,10],[0,0], label = "f(x) = 0")
scatter!([0.5], [y1], label = "f(0.5)")
scatter!([x_n1], [0], label = "f'(x_n1)")
plot!([0.5,x_n1],[y1,0],label ="slope")
plot!([x_n,x_n1],[y2,0],label ="slope, iter = 3")


```

As you can see after each iteration we get one step closer to the actual root of the function. For the algorithm to stop, you need to set a stopping criterion. The stopping criterion for iterative algorithm is either the number of iterations or a set tolerance for the desired value. For the set number of iterations, for example, you can say stop the algorithm after 10 iteration, independently from the accuracy of the results. On the other hand for the accuracy you can set a minimum accuracy needed for the outcome to be acceptable.

!!! tip 
    Normally the stopping criterion is a combination of the two methods in order to minimize the number of evaluations needed as well as the number of iterations.  

!!! note 
    The conventional Newton method is very simple, robust, and fast. However, it assumes continuity, it needs the derivative to be provided, and performs root finding for one variable at a time. 


### Secant method
#### Theory

As mentioned above for Newton Method to work you need to be able to calculate the derivative of your *f(x)*, which is not always possible. A solution to this problem was provided by Secant method, where the derivative is numerically approximated. From our calculus, we know that we can use the below equation as an approximation of *f'(x)*. 

```math 

f'(x) \approx \frac{f(x_n) - f(x_{n -1})}{x_n - x_{n-1}}

```
We also know the main equation from the Newton's method. 

```math 

x_{n+1} = x_n - \frac{f(x_n)}{f'(x_n)}

```

In the next step we can replace the *f'(x)* with its approximation from the derivative equation. 

```math 

x_{n+1} = x_n - \frac{f(x_n)}{\frac{f(x_n) - f(x_{n -1})}{x_n - x_{n-1}}}

```
Which will become the following after a bit of simplification. 

```math 

x_{n+1} = x_n - \frac{f(x_n)(x_n - x_{n-1})}{f(x_n) - f(x_{n -1})}

```
This ultimately results in the below equation. 

```math 

x_{n+1} = \frac{f(x_n)x_{n-1} - f(x_{n-1})x_n}{f(x_n) - f(x_{n -1})}

```

!!! note 
    The Secant method, generally needs more iterations and at the start of each iteration in needs two points rather than one.


#### Secant method example. 

Let's try to solve the previous problem (i.e. *``f(x) = x^{2} - 9``*) using Secant method. As it was mentioned in the theory part we need to select two random points to have the algorithm started.

```@example nrf
using DataSci4Chem

x = collect(-10:0.1:10)

x_n = 0.5

x_n1 = -5


plot(x,f(x),label = "Example function", xlabel = "x values", ylabel = "f(x)")
plot!([-10,10],[0,0], label = "f(x) = 0")
scatter!([x_n], [f(x_n)], label = "f(0.5)")
scatter!([x_n1], [f(x_n1)], label = "f(-5)")


```

Now we need to calculate the *``f(x_n)``* and ``f(x_{n-1})`` using these two values. 


```@example nrf
using DataSci4Chem


x_n2 = (f(x_n) * x_n - f(x_n1) * x_n1) / (f(x_n) - f(x_n1)) 

```

```@example nrf
using DataSci4Chem


plot(x,f(x),label = "Example function", xlabel = "x values", ylabel = "f(x)")
plot!([-10,10],[0,0], label = "f(x) = 0")
scatter!([x_n], [f(x_n)], label = "f(0.5)")
scatter!([x_n1], [f(x_n1)], label = "f(-5)")
scatter!([x_n2], [f(x_n2)], label = "f(x_n2)")


```

Now we have the new *``x_n``*, we can use the combination of this and one of the randomly selected points for the next iteration. For this the point closest to the new *``x_n``* may be the best choice. 

```@example nrf
using DataSci4Chem


x_n1 = -5

x_n3 = (f(x_n2) * x_n1 - f(x_n1) * x_n2) / (f(x_n2) - f(x_n1)) 

plot(x,f(x),label = "Example function", xlabel = "x values", ylabel = "f(x)")
plot!([-10,10],[0,0], label = "f(x) = 0")
scatter!([x_n], [f(x_n)], label = "f(0.5)")
scatter!([x_n1], [f(x_n1)], label = "f(-5)")
scatter!([x_n2], [f(x_n2)], label = "f(x_n2)")
scatter!([x_n3], [f(x_n3)], label = "f(x_n3)")


```

In this case we converged to one of the roots after two iterations. However, in real-world cases this process may take longer than two or three iterations. 

## Bounded without derivative

The bounded methods are able to function without the use of derivative due to the fact that they use a predefined window for finding the root of the function. 

### Bisection method

This method is usable for a single variable function as long as the singes of the provided bounds are different. The algorithm finds the middle of the bound by using summing the bound values and then dividing it by two. This new point will be used for replacing one of the initial bounds depending of the signs of the *``f(b)``*. Over each iteration the bounds move closer to the root of the function. Let's look at a very simple example fo root finding case with bisection method. Say we have *``f(x) = x^2 - 25``* as our test function. 


```@example nrf
using DataSci4Chem

x = -30:0.1:30 

f(x) = x.^2 .- 25 

plot(x,f(x), label="test function")
plot!([-10,10],[0,0],label ="f(x) = 0")
xlabel!("x values")
ylabel!("f(x)")


```

To set the initial guess of the bounds, we need to choose points that have different signs. In this case *b0 = 0* and *b1 = 25* fulfil this criterion as *f(0) = -25* and *f(25) = 600*. 

```@example nrf
using DataSci4Chem


plot(x,f(x), label="test function")
plot!([-10,10],[0,0],label ="f(x) = 0")
xlabel!("x values")
ylabel!("f(x)")
scatter!([0,25],[f(0),f(25)],label = "bounds")


```
For the first iteration we will calculate the average of the bounds. In this case it will be 12.5. Now we need to select one of the two windows (i.e. larger than 12.5 or smaller that 12.5) for the next iteration. 

```@example nrf
using DataSci4Chem


plot(x,f(x), label="test function")
plot!([-10,10],[0,0],label ="f(x) = 0")
xlabel!("x values")
ylabel!("f(x)")
scatter!([0,25],[f(0),f(25)],label = "bounds")
scatter!([12.5],[f(12.5)], label = "middle bound")


```

As you can see from the plot the lower bound appears to meet the needed criteria while the higher one does not. So now we are finding the middle of the lower bound, which is 6.25. Let's perform what we did before again. 

```@example nrf
using DataSci4Chem


plot(x,f(x), label="test function")
plot!([-10,10],[0,0],label ="f(x) = 0")
xlabel!("x values")
ylabel!("f(x)")
scatter!([0,25],[f(0),f(25)],label = "bounds")
scatter!([12.5],[f(12.5)], label = "middle bound 1st itr")
scatter!([6.25],[f(6.25)], label = "middle bound 2nd itr")


```

In this case again we are choosing the lower bound. However, as you can intuitively see, the fourth iteration will select the upper bound. Ultimately, the bounds become smaller and smaller until either we meet the accuracy tolerance or the max number of iteration criteria. 

## Additional resources 

There are several other numerical root finding methods that can be used for your work (e.g. [*Roots.jl*](https://juliamath.github.io/Roots.jl/stable/)). Please note that all optimization and root finding problems could be converted to another. So these tools may be useful for applications beyond simple root finding. 