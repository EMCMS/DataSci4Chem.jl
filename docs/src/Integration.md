# Numerical Integration

[Numerical integration](https://en.wikipedia.org/wiki/Numerical_integration) is a set of numerical methods that aim at integrating the *f(x)* over a defined window. Here the aim is to find the area under a curve without calculating the analytical derivative of *f(x)*. Let's assume that the function *f(x)* is continuous and defined between *a* and *b*.

```math

\int_a^b f(x)dx 

```
The integration algorithms provide an approximation of the area under the curve for *f(x)*. Independently from the method used, they all tend to divide the interval (i.e. *a:b*) into smaller chunks that could be integrated providing high enough accuracy for the true integral of the function. 

## Midpoint method

[Midpoint method](https://en.wikipedia.org/wiki/Midpoint_method) is one of the simplest numerical integration methods. The basic principal of this method is that the integral of a function can be approximated by one or more rectangles. Let's say we have the below function and we would like to integrate this between *a* and *b*. 

```math

\int_a^b (-x^2 + 50)dx 

```


```@example nint
using DataSci4Chem

x = collect(-10:0.1:10)

f(x) = (- x.^2) .+ 50

plot(x,f(x),label = "f(x)", xlabel = "x values", ylabel = "f(x)")
plot!([-10,10],[0,0], label = "y = 0")

```

Let's say that the integration window is between -5 and 5. 

With the integral of assuming *C = 0*.

```math

F(-5:5) = -\frac{x^{3}}{3} + 50x + C = 416.666

```
Now to perform the same calculations numerically, we need to calculate the midpoint in this window as the first step. 


```@example nint
using DataSci4Chem

a = -5
b = 5

mp = mean([a,b])

plot(x,f(x),label = "f(x)", xlabel = "x values", ylabel = "f(x)")
plot!([-10,10],[0,0], label = "y = 0")
plot!([a,a],[0,f(mp)],label = "a",lc =:black)
plot!([b,b],[0,f(mp)],label = "b",lc =:black)
scatter!([mp],[f(mp)],label = "midpoint")

```
In the next step we need to form a rectangle from *a*, *b*, and *f(midpoint)*, which will have a with of *b - a* and the length of *f(midpoint)*. 


```@example nint
using DataSci4Chem

a = -5
b = 5

mp = mean([a,b])

plot(x,f(x),label = "f(x)", xlabel = "x values", ylabel = "f(x)")
plot!([-10,10],[0,0], label = "y = 0")
plot!([a,a],[0,f(mp)],label = false,lc =:black)
plot!([b,b],[0,f(mp)],label = false,lc =:black)
plot!([a,b],[f(mp),f(mp)],label = "rectangle",lc =:black)
scatter!([mp],[f(mp)],label = "midpoint")

```
In the last step, we assume that the area of this rectangle is a good approximation of the area under the *f(x)* within the set interval. As we remember from our high school math the area of a rectangle is calculated as: 

```math

area = L \times W.

```

This implies the following:

```math

\int_a^b f(x)dx \approx L \times W


```

```math


\int_a^b f(x)dx \approx f(\frac{b+a}{2})(b-a)

```

Let's do this integration and compare the results of the two methods. 

```@example nint
using DataSci4Chem


int_mdp(f,a,b) = f(mean([a,b])) * (b - a)

int_anal = 416.666

int_err = int_anal -  int_mdp(f,a,b)


```

As you can see from the figure this single rectangle is not able to cover the full area under the curve. To solve this problem we can increase the number of rectangles within the defined window. For example we can perform the same calculations with four windows. 

```@example nint
using DataSci4Chem

n_win = 5
n_mp = 4

wins = collect(range(a,b,length = (n_win + n_mp)))   # Calculating the edges of the windows and their midpoints
mps = wins[2:2:length(wins)]                         # Collecting only the midpoints 
edges = wins[1:2:length(wins)]

f_mps = f(mps)                                       # Evaluating the midpoints 


```


```@example nint
using DataSci4Chem


plot(x,f(x),label = "f(x)", xlabel = "x values", ylabel = "f(x)")
plot!([-10,10],[0,0], label = "y = 0")
scatter!(mps,f_mps,label="midpoints")
bar!(mps,f_mps,label="rectangles",fillalpha = 0.3 )



```
With four windows we are getting a lot better at following the tend of the curve and we expect lower integration error compared to a single rectangle. For calculating the area under the curve with multiple rectangles, we need to multiply the evaluated midpoints by the width of the windows. Given that all the windows are equal size, we can use the first two edges for our width calculations. We also need to sum up the areas of all the rectangles to estimate the integral of the *f(x)*. 


```math


\int_a^b f(x)dx \approx \sum_{i=1}^{n} f(\frac{x_{i}+x_{i+1}}{2})\Delta x

```

```@example nint
using DataSci4Chem

est_int = sum(f_mps .* (edges[2] - edges[1]))

int_er_4 =  int_anal - est_int

```

Here by increasing the number of windows from 1 to four we have drastically reduced the estimation error from -83 to -5. We can further increase the number of windows to get an acceptable accuracy. For example for the case where we have 10 or more windows, intuitively we can see that the algorithm is getting better at following the trend line in *f(x)*. 

```@example nint
using DataSci4Chem

n_win = 20
n_mp = n_win - 1 

wins = collect(range(a,b,length = (n_win + n_mp)))   # Calculating the edges of the windows and their midpoints
mps = wins[2:2:length(wins)]                         # Collecting only the midpoints 
edges = wins[1:2:length(wins)]

f_mps = f(mps)  

plot(x,f(x),label = "f(x)", xlabel = "x values", ylabel = "f(x)")
plot!([-10,10],[0,0], label = "y = 0")
scatter!(mps,f_mps,label="midpoints")
bar!(mps,f_mps,label="rectangles",fillalpha = 0.3 )


```
```@example nint
using DataSci4Chem

est_int = sum(f_mps .* (edges[2] - edges[1]))

int_er_10 =  int_anal - est_int

```
As expected the error of area estimation has become very small. 

!!! note 
    The higher is the number of windows the better is the accuracy of integration. However, in real case scenarios this may  be computationally expensive (e.g. high dimensional problems). Therefore, you need to find a balance between the number of windows and the needed accuracy. 

## Trapezoid rule 

Another more accurate approach with a similar level of simplicity is [trapezoid rule](https://en.wikipedia.org/wiki/Trapezoidal_rule) for numerical integration. Let's go back to our previous example (i.e. *f(x)*) with two windows. For the midpoint case, we generate two rectangles to predict the area under the curve. On the other hand for trapezoid rule we generate trapezoids by connecting the *f(x)* at the edges of the windows. 


```@example nint
using DataSci4Chem

n_win = 3                                            # hide
n_mp = n_win - 1                                     # hide

wins = collect(range(a,b,length = (n_win + n_mp)))   # hide
mps = wins[2:2:length(wins)]                         # hide
edges = wins[1:2:length(wins)]                       # hide

f_mps = f(mps)                                       
f_edges = f(edges)  

p1 = plot(x,f(x),label = "f(x)", xlabel = "x values", ylabel = "f(x)")
plot!([-10,10],[0,0], label = "y = 0")
scatter!(mps,f_mps,label="midpoints")
bar!(mps,f_mps,label="rectangles",fillalpha = 0.3 , legend= :bottom)

p2 = plot(x,f(x),label = "f(x)", xlabel = "x values", ylabel = "f(x)")
plot!([-10,10],[0,0], label = "y = 0")
scatter!(edges,f_edges,label="edges", legend= :bottom)
plot!([-5,-5],[0,f_edges[1]],label = false, lc =:black)
plot!([5,5],[0,f_edges[1]],label = false, lc =:black)
plot!([0,0],[0,f_edges[2]],label = false, lc =:black)
plot!([-5,0],[f_edges[1],f_edges[2]],label = false, lc =:black)
plot!([0,5],[f_edges[2],f_edges[3]],label = false, lc =:black)


plot(p1,p2)

```

As you can see from the figure above, trapezoids are a lot better at approximating the area under the curve compared to the rectangles. In terms of math the area of a trapezoid can be calculated using the following equation.

```math


Area_{trap} = \frac{L+W}{2}h

```
If we rewrite this to fit our case we will have the below equation.

```math

Area_{trap} = \frac{f(x_{i})+f(x_{i+1})}{2}\Delta x

```

This implies that our total area approximation will become as: 

```math


\int_a^b f(x)dx \approx \frac{\Delta x}{2}(f(x_1) + 2f(x_{2}) + ... + 2f(x_{n-1}) + f(x_{n}))

```

Now that we have the formula for approximation of area under the *f(x)* using trapezoid rule, we can test it for two windows. 


```@example nint
using DataSci4Chem

est_int_trap = (0.5 * (b-a)/n_mp) * (f_edges[1] + 2* f_edges[2] + f_edges[3])

int_er_trap_2 =  int_anal - est_int_trap

```

```@example nint
using DataSci4Chem

est_int = sum(f_mps .* (b-a)/n_mp)

int_er_2 =  int_anal - est_int

```

!!! note 
    As you can see from the results above the trapezoid method tends to underestimate the area under the curve while the midpoint method has a tendency to overestimate the integrals. However, with enough intervals both method are able to achieve high levels of accuracy. 


## Simpson's rule

So far we have been using linear functions to perform our integration. However, as you may imagine, the linear function (i.e. *f(x) = ax + b*) may not be the best function to describe the trend in the objective curve. On the other hand, a function that is very well able to cover any trends is a parabola (i.e. *``f(x) = ax^2 + bx + c``*), which is the basic principal of [Simpson's rule](https://en.wikipedia.org/wiki/Simpson%27s_rule). A variation of parabola can, theoretically, cover any kind of objective function. To be able to do this we need to fit a parabola into at least three consecutive points, which will be unique. Let's write our system of equations: 

```math

f(x_i) = a(x_{i+1} - \Delta x)^2 + b(x_{i+1} - \Delta x) + c \\
f(x_{i+1}) = a(x_{i+1})^2 + b(x_{i+1}) + c \\
f(x_{i+2}) = a(x_{i+1} + \Delta x)^2 + b(x_{i+1} + \Delta x) + c \\

```

Now if we solve this system of equations we will end up with the following equation:

```math

\int_{x_{i+1} - \Delta x}^{x_{i+1} + \Delta x} (ax^2 + bx + c)dx = \sum_{0}^{n} \frac{\Delta x}{3}(f(x_i) + 4f(x_{i+1}) + f(x_{i+2})),

```
which will ultimately result in the below equation. 

```math

\int_{x_{i+1} - \Delta x}^{x_{i+1} + \Delta x} (ax^2 + bx + c)dx = \\

 \frac{\Delta x}{3}(f(x_0) + 4f(x_1) + 2f(x_2) + 4f(x_3) + ... + 2f(x_{n−2})+4f(x_{n−1})+f(x_n))

```

Here the pattern is that the first and the last terms stay as they are while the odd indexed terms are multiplied by four and the even ones are multiplied by two. By selecting a small enough *``\Delta x``* this method is able to provide a fairly accurate estimation of the area under the curve. 

## Additional resources

There are additional resources for the numerical integration, for example this [MIT open course](https://ocw.mit.edu/courses/18-01-single-variable-calculus-fall-2006/). 