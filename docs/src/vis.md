# Data visualization and plotting

Here we will explore basics of the data visualization from simple plots to model representations. The content of this section is mainly based on the [Plots.jl](https://docs.juliaplots.org/stable/) package. You should be able to generate all the figures in this tutorial using the *DataSci4Chem.jl* package. For functions that are not exported directly, you can use *DataSci4Chem.fun(-)*. 

## Simple line plot 

If you have one single variable as a vector of numbers, you can use simple line plot ([plot](https://docs.juliaplots.org/stable/tutorial/)). 

```@example vis
using DataSci4Chem

# Generating the data

y = collect(1:0.1:10)

# Plotting the data

DataSci4Chem.plot(y)

```

Here we stored our vector of 100 entries between 0 and 10 in variable *y*. The "x axis" here represents the index of each value while the "y axis" is the assigned value of the *y* at each index. For example, if we multiply the *y* by a number (e.g. 5), the "x axis" will not change while the "y axis" will be adjusted. 

```@example vis
using DataSci4Chem

y1 = 5 .* y

# Plotting the data

DataSci4Chem.plot(y1)

```
In this case the *julia* plotting backend is actually evaluating the below command to generate this figure. 

```@example vis
using DataSci4Chem

y1 = 5 .* y

# Plotting the data

DataSci4Chem.plot(1:length(y1),y1)

```
The first entry in the *plot(-)* is replaced with a vector of indices from 1 to the length of the *y*. This implies that we generally need two variables of the same size to be able to use line plot. In case we have a *x* vector the above plot will be changed to the following. 

```@example vis
using DataSci4Chem


x = sin.(y)

# Plotting the data

DataSci4Chem.plot(x,y)

```
The x values in this plot are the *sin(y)* while the y values remain the same. 

## Frame


You can adjust different parameters associated with the plot axis such as axis labels and range. For doing so you can either modify an existing frame or set these parameters as attributes of *plot(-)*. 

### Axis label

Below you can see how the labels on the x and y axis are set via frame modification. 

```@example vis
using DataSci4Chem


DataSci4Chem.plot(x,y)
DataSci4Chem.xlabel!("sin(y)")              # setting the label of x axis 
DataSci4Chem.ylabel!("y values")            # setting the label of the y axis

```

You can also set these parameters directly in the *plot(-)* function. 

```@example vis
using DataSci4Chem


DataSci4Chem.plot(x,y,xlabel="sin(y)",ylabel="y values")

```
These ways of setting axis labels can be used for any type of plot type as long as the generic ["GR" backend](https://docs.juliaplots.org/stable/gallery/gr/) is used. These approaches are not completely mapped for all the backends, particularly for [PlotlyJS](https://docs.juliaplots.org/stable/gallery/plotlyjs/).  

### Axis limit 

You can also set the range of each axis using the function *lims!(-)*. This function must be adjusted for "x axis" vs "y axis". In other words for "x axis" it will become *xlims!(-)* while for the "y axis" it will be *ylims!(-)*. 

```@example vis
using DataSci4Chem


DataSci4Chem.plot(x,y,xlabel="sin(y)",ylabel="y values")
DataSci4Chem.xlims!(-2,2)                               # Setting the limits of x
DataSci4Chem.ylims!(3,6)                                # Setting the limits of y

```
Similar to the axis label, the same concept can be applied to any plot frame generated via *Plots.jl*. 

### Label/legend

When plotting multiple series or overlaying multiple frames, it is important to label each series accordingly. To do that we need to modify an attribute of the *plot(-)* called "label". If this parameter is not set, the series label is selected automatically to "y1". If you want to change this, you need to provide an input to the attribute "label" while plotting your data. 

```@example vis
using DataSci4Chem


DataSci4Chem.plot(x,y,xlabel="sin(y)",ylabel="y values",label = "Example data")

```

In case you want to remove the label of a data series, you can set the attribute label to *false*, which will result in the removal of the legend completely. 

```@example vis
using DataSci4Chem


DataSci4Chem.plot(x,y,xlabel="sin(y)",ylabel="y values",label = false)

```

### The line settings 

When plotting our data being able to adjust parameters associated with the line is very important. This becomes particularly important for the multivariate data. As a start we can change the line style with the keyword ["linestyle"](https://docs.juliaplots.org/stable/generated/attributes_series/), that is fed directly to the plot function. 

```@example vis
using DataSci4Chem


DataSci4Chem.plot(x,y,xlabel="sin(y)",ylabel="y values",label = false,linestyle=:dash)

```
A shortcut to the "linestyle" parameter is "ls". In other words, you will get the same outcome replacing "linestyle" with "ls" in the above example. The *GR* backend in *Plots.jl* package has several builtin options for the line style. 

!!! note 
    The plotting backend in julia keeps the same the line style for all the plots unless it is specified. You need to set this parameter for each frame separately. 

Another line setting to be adjusted is the line width, which helps with the visibility of the lines in your plot. The keyword for line width setting is "linewidth" or "lw". The parameter must be a real and positive number. For example by setting the "lw" to 2 for the above plot we can increase the visibility of our data. 

```@example vis
using DataSci4Chem


DataSci4Chem.plot(x,y,xlabel="sin(y)",ylabel="y values",label = false,linestyle=:dash,lw=2)

```
For most figures, we also want to set the color of the lines in the plot, particularly when multiple lines are plotted. The parameter to be adjusted here is "linecolor" or "lc". The julia plotting backend, usually, sets a different color to each line in your plot. However, it is useful to be able to set these colors as it fits your needs. There several [colors](https://github.com/JuliaGraphics/Colors.jl/blob/master/src/names_data.jl) builtin the *plots.jl* and can be used without further definition. You can also set these colors manually via [RGB cods](https://en.wikipedia.org/wiki/RGB_color_model). 

```@example vis
using DataSci4Chem


DataSci4Chem.plot(x,y,xlabel="sin(y)",ylabel="y values",label = false,
linestyle=:dash,lw=2,lc=:red)

```

!!! warning 
    There are other parameters that can be set related to the line style settings, which have not been discussed here. For a comprehensive list please refer to the ["Series Attributes"](https://docs.juliaplots.org/stable/generated/attributes_series/) page in *Plots.jl* documentation.   

## Multiple frames 

To plot multiple data series, there are two different options. These options are 1) using multivariate *X* and *Y* matrices or 2) overlay different frames on top of each other. 

### Multivariate data plotting 

When providing multivariate matrices, julia treats each column in your data as a separate variable. This implies that for an *``X_{2 \times 10}``*, two series are plotted. 


```@example vis
using DataSci4Chem

x_m = hcat(x,x)
y_m = hcat(y,y .+ 5)

DataSci4Chem.plot(x_m,y_m,xlabel="sin(y)",ylabel="y values")

```
In this case to add the legend to this plot you need to provide a vector of labels to the *plot(-)* function. The same goes for all the line setting attributes. 

```@example vis
using DataSci4Chem

x_m = hcat(x,x)
y_m = hcat(y,y .+ 5)

DataSci4Chem.plot(x_m,y_m,xlabel="sin(y)",ylabel="y values",label=["column 1" "column 2"])

```

!!! warning
    Please note that the entries in the label vector are space separated. Otherwise, the backend will not be able to separate different entries from each other. 


```@example vis
using DataSci4Chem

x_m = hcat(x,x)
y_m = hcat(y,y .+ 5)

DataSci4Chem.plot(x_m,y_m,xlabel="sin(y)",ylabel="y values",label=["column 1" "column 2"],
lc = [:red :green], lw = [2 1], ls = [:dot :dash])

```


### Overlying frames

Another option for plotting multivariate data is the use of overlying frames. For this you need to use the function *plot!(-)*, which modifies the last in memory frame. To use this approach, you first plot your first variable and then overlay the additional variables on top of the already existing frame. 

```@example vis
using DataSci4Chem

x_m = hcat(x,x)
y_m = hcat(y,y .+ 5)

DataSci4Chem.plot(x_m[:,1],y_m[:,1],xlabel="sin(y)",ylabel="y values",label="column 1")
DataSci4Chem.plot!(x_m[:,2],y_m[:,2],xlabel="sin(y)",ylabel="y values",label="column 2")


```

!!! warning 
    The variable ranges, unless set, will take the values relevant to the largest frame. The labels must be set for each series separately to make sure proper display of the plots.

For setting the line attributes, you will have to set them up for each frame separately. Otherwise, julia will use the default settings. 

```@example vis
using DataSci4Chem

x_m = hcat(x,x)
y_m = hcat(y,y .+ 5)

DataSci4Chem.plot(x_m[:,1],y_m[:,1],xlabel="sin(y)",ylabel="y values",label="column 1",lw=2,ls=:dot,lc=:red)
DataSci4Chem.plot!(x_m[:,2],y_m[:,2],xlabel="sin(y)",ylabel="y values",label="column 2",lw=1,ls=:dash)


```

For example, for the above plot in the second frame we do not set the "lc" parameter and as a consequence julia uses the default color sequence for the second line. 

Another way to overlay the frames on top of each other is to store the frame information into a variable that can be retrieved and/or modified. For example, in the below case we are storing all the info of the first frame into variable "p". 

```@example vis
using DataSci4Chem

x_m = hcat(x,x)
y_m = hcat(y,y .+ 5)

p = DataSci4Chem.plot(x_m[:,1],y_m[:,1],xlabel="sin(y)",ylabel="y values",label="column 1",lw=2,ls=:dot,lc=:red)

```

In the next step, one can modify this frame using the function *plot!(-)* by defining the first variable as the previous frame. 

```@example vis
using DataSci4Chem


DataSci4Chem.plot!(p,x_m[:,2],y_m[:,2],xlabel="sin(y)",
ylabel="y values",label="column 2",lw=1,ls=:dash)

```

!!! tip 
    The same strategy can be used for updating the attributes of the plot.



## Plot types 

There are several plot types implemented within the *Plots.jl* and accessible via *DataSci4Chem.jl*. Here we will discuss the most commonly used plot types. 

### Scatter 

[Scatter plots](https://docs.juliaplots.org/stable/api/#Plots.scatter-Tuple) next to the line plots are one of the most commonly used plotting approaches. Similar to line plots, the inputs of *scatter(-)* are the matrics *X* and *Y* with the same size. 



```@example vis
using DataSci4Chem

x_m = hcat(x,x)
y_m = hcat(y,y .+ 5)

DataSci4Chem.scatter(x_m,y_m,xlabel="sin(y)",ylabel="y values",label=["column 1" "column 2"])

```

!!! tip 
    All the frame and axis related commands that work for line plots are applicable to scatter plots too.

```@example vis
using DataSci4Chem


DataSci4Chem.scatter(x_m[:,1],y_m[:,1],xlabel="sin(y)",ylabel="y values",label="column 1",lw=2,ls=:dot,lc=:red)
DataSci4Chem.scatter!(x_m[:,2],y_m[:,2],xlabel="sin(y)",ylabel="y values",label="column 2",lw=1,ls=:dash)


```

!!! warning 
    The scatter plot ignores the parameters specific to line plots or other plot types (e.g. "ls"). For example, "lc", "ls", and "lw" parameters associated with line plots are skipped and the backend uses the default values for the scatter plot equivalent attribute. 


There are a few highly relevant attributes specific to scatter plots that will be discussed here. 

#### Marker properties 

You can set both marker size, shape, color, and opacity for your scatter plots. These parameters will help readability of your figures and their interpretation. 

The default marker size is 4 and can be changed by resetting either "markersize" or "ms". For the "ms" please make sure to use a positive and real number. 

```@example vis
using DataSci4Chem


DataSci4Chem.scatter(x_m[:,1],y_m[:,1],xlabel="sin(y)",ylabel="y values",label="column 1",ms=5)
DataSci4Chem.scatter!(x_m[:,2],y_m[:,2],xlabel="sin(y)",ylabel="y values",label="column 2",ms=2)


```

You can also feed a vector of the size of "Y" to your marker size attribute. This will enable to plot higher dimensional data in a 2D plot. 

```@example vis
using DataSci4Chem

ms1 = range(1, stop=10, length=size(y_m,1))

DataSci4Chem.scatter(x_m[:,1],y_m[:,1],xlabel="sin(y)",ylabel="y values",label="column 1",ms=ms1)
DataSci4Chem.scatter!(x_m[:,2],y_m[:,2],xlabel="sin(y)",ylabel="y values",label="column 2",ms=2)


```

Another highly relevant scatter plot attribute is the marker shape, which is by default "circle" and can be changed using either "markershape" or "shape". For example if want to change the marker shape of column 2 in the above plot we can do this by doing the following. 

```@example vis
using DataSci4Chem

ms1 = range(1, stop=10, length=size(y_m,1))

DataSci4Chem.scatter(x_m[:,1],y_m[:,1],xlabel="sin(y)",ylabel="y values"
,label="column 1",ms=ms1)

DataSci4Chem.scatter!(x_m[:,2],y_m[:,2],xlabel="sin(y)",ylabel="y values"
,label="column 2",ms=2,shape=:+)


```

The marker color is the equivalent of "lc" attribute for the line plots. Similar to the "lc" you have access to the same color schemes via either "markercolor" or "mc".

```@example vis
using DataSci4Chem

ms1 = range(1, stop=10, length=size(y_m,1))

DataSci4Chem.scatter(x_m[:,1],y_m[:,1],xlabel="sin(y)",ylabel="y values"
,label="column 1",ms=ms1)

DataSci4Chem.scatter!(x_m[:,2],y_m[:,2],xlabel="sin(y)",ylabel="y values"
,label="column 2",ms=2,shape=:+,mc=:black)


```

The last scatter plot specific attribute discussed here is the marker opacity which is defined by "markerapha" or "ma". This attribute is very helpful with multiple frames' plots where a large amount of data is plotted. 

```@example vis
using DataSci4Chem

ms1 = range(1, stop=10, length=size(y_m,1))

DataSci4Chem.scatter(x_m[:,1],y_m[:,1],xlabel="sin(y)",ylabel="y values"
,label="column 1",ms=ms1,ma=0.5)

DataSci4Chem.scatter!(x_m[:,2],y_m[:,2],xlabel="sin(y)",ylabel="y values"
,label="column 2",ms=3,shape=:+,mc=:black)


```

### Bar

Another commonly used plotting style is [bar plots](https://en.wikipedia.org/wiki/Bar_chart). They are an easy way to get a quick overview of your data, particularly when your independent variable is discreet. However, care needs to be taken when scaling the data to avoid misleading conclusions. For example here we will plot the first 10 values of or first column. 

```@example vis
using DataSci4Chem


DataSci4Chem.bar(x_m[:,1][1:10],y_m[:,1][1:10],label="column 1 - first 10")


```

Similar to the previous plot types we can add more frames to the existing figure to represent multiple data series. 

```@example vis
using DataSci4Chem

measles = [38556, 24472, 14556, 18060, 19549, 8122, 28541, 7880, 3283, 4135, 7953, 1884]
mumps = [20178, 23536, 34561, 37395, 36072, 32237, 18597, 9408, 6005, 6268, 8963, 13882]
chickenPox = [37140, 32169, 37533, 39103, 33244, 23269, 16737, 5411, 3435, 6052, 12825, 23332]


DataSci4Chem.bar(measles,label="measles")

DataSci4Chem.bar!(mumps,label="mumps")

DataSci4Chem.bar!(chickenPox,label="chickenPox")

```

In the figure above each series is plotted on top of the previous one, which may not be the most desirable setup. To solve this issue we need to use a more complete backend/version of *Plots.jl*, which is [*StatsPlots.jl*](https://docs.juliaplots.org/latest/generated/statsplots/). The *StatsPlots.jl* has been exported as "sp" within the *DataSci4Chem.jl* package to avoid any conflicts with other packages. It can be accessed using the following syntax. 

```@example vis
using DataSci4Chem


DataSci4Chem.sp.bar(measles,label="measles")

DataSci4Chem.sp.bar!(mumps,label="mumps")

DataSci4Chem.sp.bar!(chickenPox,label="chickenPox")

```
For this case we need to used the function *groupedbar(-)* to be able to have the bars being plotted side by side. The combination of *groupedbar(-)* and the attribute "bar_position" enables having the bars side by side. 

```@example vis
using DataSci4Chem


DataSci4Chem.sp.groupedbar([measles mumps chickenPox], bar_position = :dodge)

```

A variant of bar plot is [histogram](https://en.wikipedia.org/wiki/Histogram), which is very useful for exploring the distribution of the variables in a dataset. Histograms can be used for a first step during the data visualization. For example, when looking at the ["Iris" dataset](https://en.wikipedia.org/wiki/Iris_flower_data_set), we can explore the distribution of each variable via histograms. To import the data we are taking advantage of [*RDatasets.jl*](https://github.com/JuliaStats/RDatasets.jl) package. 


```@example vis
using DataSci4Chem

data = DataSci4Chem.dataset("datasets", "iris")     # Importing the data
DataSci4Chem.describe(data)                         # Summarizes the dataset

```

Through the function *describe(-)* we can seen that the dataset contains five variables namely: sepal length, sepal width, petal length, petal width, and species. Now we can use histograms to explore the numerical variables. 

```@example vis
using DataSci4Chem

DataSci4Chem.histogram(data[!,"SepalLength"])

```