# Data visualization and plotting

Here we will explore basics of the data visualization from simple plots to model representations. The content of this section is mainly based on the [Plots.jl](https://docs.juliaplots.org/stable/) package. You should be able to generate all the figures in this tutorial using the *DataSci4Chem.jl* package. For functions that are not exported directly, you can use *DataSci4Chem.fun(-)*. 

## Simple line plot 

If you have one single variable as a vector of numbers, you can use simple line plot ([plot](https://docs.juliaplots.org/stable/tutorial/)). 

```@example vis
using DataSci4Chem

# Generating the data

y = collect(1:0.1:10)

# Plotting the data

plot(y)

```

Here we stored our vector of 100 entries between 0 and 10 in variable *y*. The "x axis" here represents the index of each value while the "y axis" is the assigned value of the *y* at each index. For example, if we multiply the *y* by a number (e.g. 5), the "x axis" will not change while the "y axis" will be adjusted. 

```@example vis
using DataSci4Chem

y1 = 5 .* y

# Plotting the data

plot(y1)

```
In this case the *julia* plotting backend is actually evaluating the below command to generate this figure. 

```@example vis
using DataSci4Chem

y1 = 5 .* y

# Plotting the data

plot(1:length(y1),y1)

```
The first entry in the *plot(-)* is replaced with a vector of indices from 1 to the length of the *y*. This implies that we generally need two variables of the same size to be able to use line plot. In case we have a *x* vector the above plot will be changed to the following. 

```@example vis
using DataSci4Chem


x = sin.(y)

# Plotting the data

plot(x,y)

```
The x values in this plot are the *sin(y)* while the y values remain the same. 

## Frame


You can adjust different parameters associated with the plot axis such as axis labels and range. For doing so you can either modify an existing frame or set these parameters as attributes of *plot(-)*. 

### Axis label

Below you can see how the labels on the x and y axis are set via frame modification. 

```@example vis
using DataSci4Chem


plot(x,y)
xlabel!("sin(y)")              # setting the label of x axis 
ylabel!("y values")            # setting the label of the y axis

```

You can also set these parameters directly in the *plot(-)* function. 

```@example vis
using DataSci4Chem


plot(x,y,xlabel="sin(y)",ylabel="y values")

```
These ways of setting axis labels can be used for any type of plot type as long as the generic ["GR" backend](https://docs.juliaplots.org/stable/gallery/gr/) is used. These approaches are not completely mapped for all the backends, particularly for [PlotlyJS](https://docs.juliaplots.org/stable/gallery/plotlyjs/).  

### Axis limit 

You can also set the range of each axis using the function *lims!(-)*. This function must be adjusted for "x axis" vs "y axis". In other words for "x axis" it will become *xlims!(-)* while for the "y axis" it will be *ylims!(-)*. 

```@example vis
using DataSci4Chem


plot(x,y,xlabel="sin(y)",ylabel="y values")
xlims!(-2,2)                               # Setting the limits of x
ylims!(3,6)                                # Setting the limits of y

```
Similar to the axis label, the same concept can be applied to any plot frame generated via *Plots.jl*. 

### Label/legend

When plotting multiple series or overlaying multiple frames, it is important to label each series accordingly. To do that we need to modify an attribute of the *plot(-)* called "label". If this parameter is not set, the series label is selected automatically to "y1". If you want to change this, you need to provide an input to the attribute "label" while plotting your data. 

```@example vis
using DataSci4Chem


plot(x,y,xlabel="sin(y)",ylabel="y values",label = "Example data")

```

In case you want to remove the label of a data series, you can set the attribute label to *false*, which will result in the removal of the legend completely. 

```@example vis
using DataSci4Chem


plot(x,y,xlabel="sin(y)",ylabel="y values",label = false)

```

### The line settings 

When plotting our data being able to adjust parameters associated with the line is very important. This becomes particularly important for the multivariate data. As a start we can change the line style with the keyword ["linestyle"](https://docs.juliaplots.org/stable/generated/attributes_series/), that is fed directly to the plot function. 

```@example vis
using DataSci4Chem


plot(x,y,xlabel="sin(y)",ylabel="y values",label = false,linestyle=:dash)

```
A shortcut to the "linestyle" parameter is "ls". In other words, you will get the same outcome replacing "linestyle" with "ls" in the above example. The *GR* backend in *Plots.jl* package has several builtin options for the line style. 

!!! note 
    The plotting backend in julia keeps the same the line style for all the plots unless it is specified. You need to set this parameter for each frame separately. 

Another line setting to be adjusted is the line width, which helps with the visibility of the lines in your plot. The keyword for line width setting is "linewidth" or "lw". The parameter must be a real and positive number. For example by setting the "lw" to 2 for the above plot we can increase the visibility of our data. 

```@example vis
using DataSci4Chem


plot(x,y,xlabel="sin(y)",ylabel="y values",label = false,linestyle=:dash,lw=2)

```
For most figures, we also want to set the color of the lines in the plot, particularly when multiple lines are plotted. The parameter to be adjusted here is "linecolor" or "lc". The julia plotting backend, usually, sets a different color to each line in your plot. However, it is useful to be able to set these colors as it fits your needs. There several [colors](https://github.com/JuliaGraphics/Colors.jl/blob/master/src/names_data.jl) builtin the *plots.jl* and can be used without further definition. You can also set these colors manually via [RGB cods](https://en.wikipedia.org/wiki/RGB_color_model). 

```@example vis
using DataSci4Chem


plot(x,y,xlabel="sin(y)",ylabel="y values",label = false,
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

plot(x_m,y_m,xlabel="sin(y)",ylabel="y values")

```
In this case to add the legend to this plot you need to provide a vector of labels to the *plot(-)* function. The same goes for all the line setting attributes. 

```@example vis
using DataSci4Chem

x_m = hcat(x,x)
y_m = hcat(y,y .+ 5)

plot(x_m,y_m,xlabel="sin(y)",ylabel="y values",label=["column 1" "column 2"])

```

!!! warning
    Please note that the entries in the label vector are space separated. Otherwise, the backend will not be able to separate different entries from each other. 


```@example vis
using DataSci4Chem

x_m = hcat(x,x)
y_m = hcat(y,y .+ 5)

plot(x_m,y_m,xlabel="sin(y)",ylabel="y values",label=["column 1" "column 2"],
lc = [:red :green], lw = [2 1], ls = [:dot :dash])

```


### Overlying frames

Another option for plotting multivariate data is the use of overlying frames. For this you need to use the function *plot!(-)*, which modifies the last in memory frame. To use this approach, you first plot your first variable and then overlay the additional variables on top of the already existing frame. 

```@example vis
using DataSci4Chem

x_m = hcat(x,x)
y_m = hcat(y,y .+ 5)

plot(x_m[:,1],y_m[:,1],xlabel="sin(y)",ylabel="y values",label="column 1")
plot!(x_m[:,2],y_m[:,2],xlabel="sin(y)",ylabel="y values",label="column 2")


```

!!! warning 
    The variable ranges, unless set, will take the values relevant to the largest frame. The labels must be set for each series separately to make sure proper display of the plots.

For setting the line attributes, you will have to set them up for each frame separately. Otherwise, julia will use the default settings. 

```@example vis
using DataSci4Chem

x_m = hcat(x,x)
y_m = hcat(y,y .+ 5)

plot(x_m[:,1],y_m[:,1],xlabel="sin(y)",ylabel="y values",label="column 1",lw=2,ls=:dot,lc=:red)
plot!(x_m[:,2],y_m[:,2],xlabel="sin(y)",ylabel="y values",label="column 2",lw=1,ls=:dash)


```

For example, for the above plot in the second frame we do not set the "lc" parameter and as a consequence julia uses the default color sequence for the second line. 

Another way to overlay the frames on top of each other is to store the frame information into a variable that can be retrieved and/or modified. For example, in the below case we are storing all the info of the first frame into variable "p". 

```@example vis
using DataSci4Chem

x_m = hcat(x,x)
y_m = hcat(y,y .+ 5)

p = plot(x_m[:,1],y_m[:,1],xlabel="sin(y)",ylabel="y values",label="column 1",lw=2,ls=:dot,lc=:red)

```

In the next step, one can modify this frame using the function *plot!(-)* by defining the first variable as the previous frame. 

```@example vis
using DataSci4Chem


plot!(p,x_m[:,2],y_m[:,2],xlabel="sin(y)",
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

scatter(x_m,y_m,xlabel="sin(y)",ylabel="y values",label=["column 1" "column 2"])

```

!!! tip 
    All the frame and axis related commands that work for line plots are applicable to scatter plots too.

```@example vis
using DataSci4Chem


scatter(x_m[:,1],y_m[:,1],xlabel="sin(y)",ylabel="y values",label="column 1",lw=2,ls=:dot,lc=:red)
scatter!(x_m[:,2],y_m[:,2],xlabel="sin(y)",ylabel="y values",label="column 2",lw=1,ls=:dash)


```

!!! warning 
    The scatter plot ignores the parameters specific to line plots or other plot types (e.g. "ls"). For example, "lc", "ls", and "lw" parameters associated with line plots are skipped and the backend uses the default values for the scatter plot equivalent attribute. 


There are a few highly relevant attributes specific to scatter plots that will be discussed here. 

#### Marker properties 

You can set both marker size, shape, color, and opacity for your scatter plots. These parameters will help readability of your figures and their interpretation. 

The default marker size is 4 and can be changed by resetting either "markersize" or "ms". For the "ms" please make sure to use a positive and real number. 

```@example vis
using DataSci4Chem


scatter(x_m[:,1],y_m[:,1],xlabel="sin(y)",ylabel="y values",label="column 1",ms=5)
scatter!(x_m[:,2],y_m[:,2],xlabel="sin(y)",ylabel="y values",label="column 2",ms=2)


```

You can also feed a vector of the size of "Y" to your marker size attribute. This will enable to plot higher dimensional data in a 2D plot. 

```@example vis
using DataSci4Chem

ms1 = range(1, stop=10, length=size(y_m,1))

scatter(x_m[:,1],y_m[:,1],xlabel="sin(y)",ylabel="y values",label="column 1",ms=ms1)
scatter!(x_m[:,2],y_m[:,2],xlabel="sin(y)",ylabel="y values",label="column 2",ms=2)


```

Another highly relevant scatter plot attribute is the marker shape, which is by default "circle" and can be changed using either "markershape" or "shape". For example if want to change the marker shape of column 2 in the above plot we can do this by doing the following. 

```@example vis
using DataSci4Chem

ms1 = range(1, stop=10, length=size(y_m,1))

scatter(x_m[:,1],y_m[:,1],xlabel="sin(y)",ylabel="y values"
,label="column 1",ms=ms1)

scatter!(x_m[:,2],y_m[:,2],xlabel="sin(y)",ylabel="y values"
,label="column 2",ms=2,shape=:+)


```

The marker color is the equivalent of "lc" attribute for the line plots. Similar to the "lc" you have access to the same color schemes via either "markercolor" or "mc".

```@example vis
using DataSci4Chem

ms1 = range(1, stop=10, length=size(y_m,1))

scatter(x_m[:,1],y_m[:,1],xlabel="sin(y)",ylabel="y values"
,label="column 1",ms=ms1)

scatter!(x_m[:,2],y_m[:,2],xlabel="sin(y)",ylabel="y values"
,label="column 2",ms=2,shape=:+,mc=:black)


```

The last scatter plot specific attribute discussed here is the marker opacity which is defined by "markerapha" or "ma". This attribute is very helpful with multiple frames' plots where a large amount of data is plotted. 

```@example vis
using DataSci4Chem

ms1 = range(1, stop=10, length=size(y_m,1))

scatter(x_m[:,1],y_m[:,1],xlabel="sin(y)",ylabel="y values"
,label="column 1",ms=ms1,ma=0.5)

scatter!(x_m[:,2],y_m[:,2],xlabel="sin(y)",ylabel="y values"
,label="column 2",ms=3,shape=:+,mc=:black)


```

### Bar

Another commonly used plotting style is [bar plots](https://en.wikipedia.org/wiki/Bar_chart). They are an easy way to get a quick overview of your data, particularly when your independent variable is discreet. However, care needs to be taken when scaling the data to avoid misleading conclusions. For example here we will plot the first 10 values of or first column. 

```@example vis
using DataSci4Chem


bar(x_m[:,1][1:10],y_m[:,1][1:10],label="column 1 - first 10")


```

Similar to the previous plot types we can add more frames to the existing figure to represent multiple data series. 

```@example vis
using DataSci4Chem

measles = [38556, 24472, 14556, 18060, 19549, 8122, 28541, 7880, 3283, 4135, 7953, 1884]
mumps = [20178, 23536, 34561, 37395, 36072, 32237, 18597, 9408, 6005, 6268, 8963, 13882]
chickenPox = [37140, 32169, 37533, 39103, 33244, 23269, 16737, 5411, 3435, 6052, 12825, 23332]


bar(measles,label="measles")

bar!(mumps,label="mumps")

bar!(chickenPox,label="chickenPox")

```

In the figure above each series is plotted on top of the previous one, which may not be the most desirable setup. To solve this issue we need to use a more complete backend/version of *Plots.jl*, which is [*StatsPlots.jl*](https://docs.juliaplots.org/latest/generated/statsplots/). The *StatsPlots.jl* has been exported as "sp" within the *DataSci4Chem.jl* package to avoid any conflicts with other packages. It can be accessed using the following syntax. 

```@example vis
using DataSci4Chem


sp.bar(measles,label="measles")

sp.bar!(mumps,label="mumps")

sp.bar!(chickenPox,label="chickenPox")

```
For this case we need to used the function *groupedbar(-)* to be able to have the bars being plotted side by side. The combination of *groupedbar(-)* and the attribute "bar_position" enables having the bars side by side. 

```@example vis
using DataSci4Chem


sp.groupedbar([measles mumps chickenPox], bar_position = :dodge)

```

A variant of bar plot is [histogram](https://en.wikipedia.org/wiki/Histogram), which is very useful for exploring the distribution of the variables in a dataset. Histograms can be used for a first step during the data visualization. For example, when looking at the ["Iris" dataset](https://en.wikipedia.org/wiki/Iris_flower_data_set), we can explore the distribution of each variable via histograms. To import the data we are taking advantage of [*RDatasets.jl*](https://github.com/JuliaStats/RDatasets.jl) package. 


```@example vis
using DataSci4Chem

data = dataset("datasets", "iris")     # Importing the data
describe(data)                         # Summarizes the dataset

```

Through the function *describe(-)* we can seen that the dataset contains five variables namely: sepal length, sepal width, petal length, petal width, and species. Now we can use histograms to explore the numerical variables. 

```@example vis
using DataSci4Chem

histogram(data[!,"SepalLength"],label=false)

xlabel!("SepalWidth")
ylabel!("Frequency")

```
In this plot the bin size and number is set automatically by julia. However, the automatic choice may not be the best option for your case of data exploration. One of the parameters that can be set here is the number of bins. Let's change the number of bins to 20 instead of 8.

```@example vis
using DataSci4Chem

histogram(data[!,"SepalLength"],label=false,bins =20)

xlabel!("SepalWidth")
ylabel!("Frequency")

```

!!! warning 
    As you can see changing the number of bins may impact the final interpretation of your data. Therefore, you need to be sure that this parameter is adequately selected to correctly reflect the true distribution of your data. 

Another way to change the number of bins or their size is to provide a vector of bins to the parameter "bins" rather than an integer. 

```@example vis
using DataSci4Chem

b_range = range(4, 8, length=21)                            # Generate the individual bins

histogram(data[!,"SepalLength"],label=false,bins =b_range)  # Use those bins for plotting the results

xlabel!("SepalWidth")
ylabel!("Frequency")

```

Similar to the previous plots you can overlay multiple frames on top of each other. For example, below we are plotting the histogram of two separate variables in the "iris dataset" together. 

```@example vis
using DataSci4Chem

histogram(data[!,"SepalLength"],label="Sepal Length", bins=10)
histogram!(data[!,"SepalWidth"],label="Sepal Width", bins=10)

xlabel!("Bins")
ylabel!("Frequency")

```

As you can see from the above plot the two distributions have an overlapping region, which is very difficult to see. To overcome this issue you can use the parameter "fillalpha", which sets the transparency of the bars. Please note that the order of the plotting is highly relevant when setting this parameter. 

```@example vis
using DataSci4Chem

histogram(data[!,"SepalLength"],label="Sepal Length", bins=10)
histogram!(data[!,"SepalWidth"],label="Sepal Width", bins=10,fillalpha=0.6)

xlabel!("Bins")
ylabel!("Frequency")

```

Another highly relevant parameter to adjust when using histograms is the normalization factor set via parameter "norm". The julia default is false (i.e. the pure count). This can be set to ":pdf" resulting in the sum of areas will be set to one while :probability generates a plot where the sum of heights is equal to one. The normalization is very helpful when dealing with datasets with different population sizes. 

```@example vis
using DataSci4Chem

histogram(data[!,"SepalLength"],label="Sepal Length", bins=10,norm = :pdf)
histogram!(data[!,"SepalWidth"],label="Sepal Width", bins=10,fillalpha=0.6, norm = :pdf)

xlabel!("Bins")
ylabel!("Frequency")

```

or 

```@example vis
using DataSci4Chem

histogram(data[!,"SepalLength"],label="Sepal Length", bins=10,norm = :probability)
histogram!(data[!,"SepalWidth"],label="Sepal Width", bins=10,fillalpha=0.6, norm = :probability)

xlabel!("Bins")
ylabel!("Frequency")

```

### Heatmap

[Heatmaps](https://en.wikipedia.org/wiki/Heat_map) are a set of very information rich and versatile plots that can be used for multidimensional data plotting. In heatmaps the 3rd dimension is usually represented through a color scheme indicating the magnitude of the plotted data. Heatmaps either accept an *``D_{m,n}``* or three variables where *``X_{m,1}``* and *``Y_{1,n}``*. 

```@example vis
using DataSci4Chem

D = randn(10,20)

heatmap(D)

xlabel!("Random values")
ylabel!("Random values")

```

or 

```@example vis
using DataSci4Chem

x = range(5, 25, length=10) 
y = range(-5, 3, length=20) 

DataSci4Chem.heatmap(x,y,D)

xlabel!("Random values")
ylabel!("Random values")

```

When working with the heatmaps you can change the color scheme used via "cmap" and different colormaps. For example, below we are setting the [colormap](https://docs.juliaplots.org/latest/colorschemes/) of our data to :jet.  

```@example vis
using DataSci4Chem


heatmap(x,y,D,cmap= :jet)

xlabel!("Random values")
ylabel!("Random values")

```

There are many useful attributes built in the heatmap function to enable you to visualize your data at best. Here we will discuss a few of those. 

#### Color scale limits

You can adjust the color scale in a similar way to the ranges of *X* and/or *Y*. For this you can use the attribute "clim". 

```@example vis
using DataSci4Chem


heatmap(x,y,D,cmap= :turbo,clim=(-1,1))

xlabel!("Random values")
ylabel!("Random values")

```

#### Colorbar title 

You can also add a title to your colorbar as it represent highly relevant information. This can be done with "colorbar_title".


```@example vis
using DataSci4Chem


DataSci4Chem.heatmap(x,y,D,cmap= :turbo,clim=(-1,1),colorbar_title="My title")

xlabel!("Random values")
ylabel!("Random values")

```

#### Colorbar position

You can also set the position of the colorbar, depending on the backend, to improve the way that your data is displayed. For the position of the colorbar you can use the "cbar" attribute. The backend "GR" only supports absence and presence of the colorbar in the position of the legend. For example, below we are removing the colorbar completely.

```@example vis
using DataSci4Chem


heatmap(x,y,D,cmap= :turbo,clim=(-1,1),colorbar_title="My title",cbar= :none)

xlabel!("Random values")
ylabel!("Random values")

```


!!! tip 
    The plot type can be set as on the attributes of *plot(-)* using parameter "seriestype" or "st". In other words, you can use *plot(-)* for all the plot types presented above. 

 



```@example vis
using DataSci4Chem

plot(data[!,"SepalLength"],label="Sepal Length", st = :histogram,bins=10,norm = :probability)
plot!(data[!,"SepalWidth"],label="Sepal Width", st = :histogram, bins=10,fillalpha=0.6, norm = :probability)

xlabel!("Bins")
ylabel!("Frequency")

```

or 

```@example vis
using DataSci4Chem


plot(x,y,D,st = :heatmap,cmap= :turbo,clim=(-1,1),colorbar_title="My title")

xlabel!("Random values")
ylabel!("Random values")

```

## Advanced topics 

This section aims at enabling you to generate publication quality figures. This is only a small selection of things that might be useful for high quality figure generation.

### Frame size

The size of the frame/plot can be set depending on the your needs. This is an attribute called "size", which is [tuple](https://en.wikipedia.org/wiki/Tuple) and has (600,400) as default. For example, we can update the above plot by making it more square. 

```@example vis
using DataSci4Chem


plot(x,y,D,st = :heatmap,cmap= :turbo,clim=(-1,1),colorbar_title="My title",size=(600,600))

xlabel!("Random values")
ylabel!("Random values")

```

### The figure resolution

You can also adjust the resolution of your plots using the attribute "dpi" (i.e. dots per inch). The higher is dpi the higher is the resolution and thus the quality of your plots. Julia sets this at 100 by default. For high quality figures using a value around 300 is recommended. 

```@example vis
using DataSci4Chem


plot(x,y,D,st = :heatmap,cmap= :turbo,clim=(-1,1),colorbar_title="My title",size=(600,600),dpi =300)

xlabel!("Random values")
ylabel!("Random values")

```
!!! note 
    When changing the dpi for a figure, you will not notice any differences at the screen level, given that the figure is rendered as a vector giving you the possibility to zoom in as much as possible. The dpi becomes very important when you are saving your plots.

### Subplots 

Subplots are the combination of multiple plots in separate sub-frames within on main frame. Subplots mainly use a combination of *plot(-)* and the attribute ["layout"](https://docs.juliaplots.org/latest/layouts/) to achieve its goal. The simplest way of making subplots is the following. 

```@example vis
using DataSci4Chem


p1 = plot(x,y,D,st = :heatmap,cmap= :turbo,clim=(-1,1),colorbar_title="My title")

xlabel!("Random values")
ylabel!("Random values")


p2 = plot(data[!,"SepalLength"],label="Sepal Length", st = :histogram,bins=10,norm = :probability)

xlabel!("Bins")
ylabel!("Frequency")

plot(p1,p2,layout = (1,2),size=(800,400))

```

You can also have a set of nested subplots to represent you data. Below you can see an example of such a case.   

```@example vis
using DataSci4Chem


p1 = plot(data[!,"SepalWidth"],label="SepalWidth", st = :histogram,bins=10,norm = :probability)

ylabel!("Frequency")

p2 = plot(data[!,"SepalLength"],label="Sepal Length", st = :histogram,bins=10,norm = :probability)

ylabel!("Frequency")

p3 = plot(x,y,D,st = :heatmap,cmap= :turbo,clim=(-1,1))

xlabel!("Random values")
ylabel!("Random values")



plot(plot(p1,p2),p3,layout = (2,1),margin = (5,:mm))



```

### Saving figures 

You can save your figures using the function *savefig(-)*. This function takes the currently stored plot in the memory and saves it with a given title. You can also save a specific figure using its handle, if that figure is not the last figure stored in the memory. For example, here we are saving the last generated figure (i.e. the subplot). 

```@example vis
using DataSci4Chem


savefig("Example_fig.png")


```

On the other hand, in this example we are saving the figure "p3, which is the heatmap, independently from the last generated figure. 

```@example vis
using DataSci4Chem


savefig(p3,"Example_fig_p3.png")


```

!!! tip 
    By changing the extension of the figure in its name (i.e. ".png" vs ".pdf") you can change the format of the generated file as well as its quality. The extensions such as ".svg", ".tiff", and ".pdf" tend to be of higher quality than ".png" for example. 

## Additional resources 

There are several external resources for making plots and practicing. The main and the most important one is the [*Plots.jl documentation*](https://docs.juliaplots.org/latest/). There are several videos on YouTube with introductory lectures in julia plotting (https://www.youtube.com/watch?v=rtOqvqm5IjE).   