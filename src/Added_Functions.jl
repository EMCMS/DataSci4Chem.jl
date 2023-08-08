using LinearAlgebra
using Statistics

###############################################################################
#
#
###############################################################################
# Newton's method 


function newton_root(f, df, x0; tol=1e-6, max_iter=100)
    # f: the function for which we want to find the root
    # df: the derivative of the function f
    # x0: initial guess for the root
    # tol: tolerance for stopping criteria (default: 1e-6)
    # max_iter: maximum number of iterations (default: 100)
    #################################################
    # Example 
    # f(x) = x.^2 .- a
    # df(x) = 2 .* x
    # x0 = 5
    #
    #################################################

    x = x0
    iter = 0

    while abs(f(x)) > tol && iter < max_iter
        x -= f(x) / df(x)
        iter += 1
    end

    return x
end


###############################################################################
# Numerical derivative


function numerical_derivative(f, x; h=1e-6)
    # f: the function for which we want to calculate the derivative
    # x: the point at which to calculate the derivative
    # h: the step size for finite difference (default: 1e-6)
    #################################################
    # Example 
    # f(x) = x.^2 .+ (2 .* x) + 1
    # x0 = 2.0
    #
    #################################################


    df = (f(x .+ h) .- f(x .- h)) ./ (2 .* h)
    return df
end


###############################################################################
# Bisection method


function bisection_root(f, a, b; tol=1e-6, max_iter=100)
    # f: the function for which we want to find the root
    # a: the lower bound of the initial interval
    # b: the upper bound of the initial interval
    # tol: tolerance for stopping criteria (default: 1e-6)
    # max_iter: maximum number of iterations (default: 100)
    #################################################
    # Example 
    # f(x) = x.^2 .- a
    # a = 0.0
    # b = 25.0
    #################################################

    if f(a) * f(b) > 0
        error("Function must have opposite signs at interval endpoints.")
    end

    iter = 0

    while (b - a) / 2 > tol && iter < max_iter
        c = (a + b) / 2
        if f(c) == 0
            break
        elseif f(a) * f(c) < 0
            b = c
        else
            a = c
        end
        iter += 1
    end

    root = (a + b) / 2
    return root
end



###############################################################################
# Secant method

function secant_root(f, x0, x1, tol=1e-6, max_iter=100)
    # f: the function for which we want to find the root
    # x0: the first guess for the root
    # x1: the second guess for the root
    # tol: tolerance for stopping criteria (default: 1e-6)
    # max_iter: maximum number of iterations (default: 100)
    #################################################
    # Example 
    # f(x) = x.^2 .- a
    # x0 = 0.0
    # x1 = 25.0
    # root = secant_root(f, x0, x1)
    #################################################
    iter = 0
    while abs(f(x1)) > tol && iter < max_iter
        x2 = x1 - f(x1) * (x1 - x0) / (f(x1) - f(x0))
        x0 = x1
        x1 = x2
        iter += 1
    end
    
    if abs(f(x1)) <= tol
        return x1
    else
        error("Secant method did not converge within the maximum number of iterations.")
    end
end
