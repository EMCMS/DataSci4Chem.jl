module DataSci4Chem

using CSV
using DataFrames 
using Plots
import StatsPlots as sp 
using Statistics
using LinearAlgebra
using LsqFit
import Pluto
using IJulia
using Documenter
#using ACS
using RDatasets

include("Added_Functions.jl")


export notebook, plot, plot!, xlabel!, ylabel!, jupyterlab, scatter, scatter!, bar, bar!, xlims!, ylims!, sp, dataset, describe, histogram,
 histogram!, scatter3d, scatter3d!, heatmap, heatmap!, savefig, twinx, transpose, pinv, inv, newton_root, bisection_root, numerical_derivative, 
 find_zero, find_zeros, mean, std, var, midpoint_integration, trapezoid_rule, simpsons_rule


# Write your package code here.

# 1+1
# Plouto.run()



end
