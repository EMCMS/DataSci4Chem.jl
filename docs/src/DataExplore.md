# Data exploration 

Data exploration is a set of tools that you can use to look at, visualize, and infer about an unknown dataset. The tools explored here will include data summary, distribution of variables, missing values, and finally variable reduction. It should be noted that this is not a complete list of potential tools that can be used for data exploration. 

## Data summary

One of the first steps in getting the data summary is to assess the number of variables and measurements. As a convention we tend to put the variables in columns while putting the measurements as rows. For dataframes this is very simple to assess while for matrices this can become tricky. Let's for example take a look at the "iris dataset". 

```@example de
using DataSci4Chem

data = dataset("datasets", "iris");

data[1:5,:]

```
We can see that there are five variables in the dataset. Four of which are numerical while one of the variables is categorical. To be able to explore the data, we should look at the mean, median, maximum, minimum, and standard deviation.

For the calculation of mean (i.e. average) we can use the function *mean(-)*. The mean can be calculated column wise, row wise, and on the full dataset. In this case we are interested to evaluate the mean of each column as here they represent each variable. 

!!! note 
    Please note that functions mean, median, etc work on matrices rather than dataframes. Therefore you must to first convert your data into a matrix via *Matrix(-)*. Also, categorical data cannot be converted to a matrix as matrices cannot hold mixed data.

```@example de
using DataSci4Chem

data_c = Matrix(data[:,1:4])
md = mean(data_c,dims = 1 )

```

Similar to the mean, there are built in functions for *median(-)*, *minimum(-)*, and *maximum(-)*. 

In addition to the data boundaries, we usually want to know about the presence of "NAN" and/or missing values. In the below section a few simple ways of dealing with such entities will be discussed. For the missing values you can use the julia base function *ismissing(-)*, which will generate a logical value of one for "missing" and zeros for the contrary. 

```@example de
using DataSci4Chem

x = [1, missing, 3]

```

To detect this missing value, we can use combination of *ismissing(-)* and the vectorization. 

```@example de
using DataSci4Chem

ismissing.(x)

```
This operation can be expanded to multidimensional matrices as well. Additionally, this output can be used for finding and replacing the missing values with more workable values. 

```@example de
using DataSci4Chem

x1 = deepcopy(x)

x1[ismissing.(x)] .= -99

x1

```
In case of dataframes you can use the function *replace!(-)* provided via *DataFrames.jl* package.

```@example de
using DataSci4Chem

df = DataFrame(x = [1, missing, 3])

```

```@example de
using DataSci4Chem

replace!(df.x, missing => -99)

```

Another entity that can be found in large and complex datasets is ["NaN"](https://en.wikipedia.org/wiki/NaN). Most functions in have difficulties dealing with "NaN. For example the sum of NaN and any number will result in a NaN. 

```@example de
using DataSci4Chem

2 + NaN

```

To mitigate the issues associated with NaN, you can either remove/replace them with a number or us can exclude them from your calculations. To find and replace the NaN values, you need to work with matrices and you can use the function *isnan(-)*, which operates the same way as the function *ismissing(-)*. 

```@example de
using DataSci4Chem

x = [1, NaN, 3]

```
```@example de
using DataSci4Chem

x1 = deepcopy(x)

x1[isnan.(x)] .= -199

x1

```


!!! tip 
    Within the *DataFrames.jl* package implemented in the *DataSci4Chem.jl* you have access to the function *describe(-)* which is able to parse a dataframe and provide you with this basic information about your table. This command can handle both numerical and categorical data as in a dataframes, the columns independent from each other. 


```@example de
using DataSci4Chem

describe(data)

```

## Missing values

In this section we are tackling issues related to missing values as well as outliers etc. The main idea behind this is that one or more data points are removed or replaced due to uncertainty or the fact that they are undefined. In the previous section we learned how to identify these data points. Here we will go through different strategies to handle this problem. There are two main strategies for dealing with missing values, namely: removal and imputation. 

### Removal

If there are a few data points missing in your dataset, you can remove those measurements (i.e. rows) from your dataset prior to model building. However, this may cause removal of several measurements from your dataset, reducing your degrees of freedom. Another option is the removal of the variable with a high frequency of "NaN" and/or "missing" values. This option can be used when there are enough variables to be used for your model. The removal based methods can be used only when we are dealing with a small number of data points that must be replaced. 

### Imputation 

[Imputation](https://en.wikipedia.org/wiki/Imputation_(statistics)) is the process of the replacing a missing value with the most likely estimate for that data point. There are several tools ranging from simple random replacement to more sophisticated methods such as external regression to replace the missing values. Here we will discuss hot-deck, mean/median imputation, and regression. 

#### Hot-deck

This method tends to first sort the data in ascending order. In the next step the last observation is carried over to replace the missing value. 

```@example de
using DataSci4Chem

df = DataFrame(:a => [1.0, 2.0, missing, missing, 5.0], :b => [1.1, 2.2, 3.3, missing, 5.5])

```

```@example de
using DataSci4Chem

# Imputed DF

df = DataFrame(:a => [1.0, 2.0, 2, 2, 5.0], :b => [1.1, 2.2, 3.3, 3.3, 5.5]) 

```

!!! warning 
    Please note that your data must be sorted. Applying the sort function in most cases puts the missing values at the top or the bottom of the matrix/dataframe. This implies that you are replacing the missing values with the largest or the smallest measurements.


#### Mean/median 

Another strategy for imputing the missing values is to use the mean or the median of each variable to replace the missing values in that specific variable. The main advantage of this method is that the mean or the median of the data will remain constant, which may be advantageous depending on the scope of the study. 

```@example de
using DataSci4Chem

# Imputed DF

df = DataFrame(:a => [1.0, 2.0, 4, 4, 5.0], :b => [1.1, 2.2, 3.3, 4.3, 5.5]) 

```

!!! warning 
    Depending on the number of missing points this approach may change the structure of your dataset, thus impacting your final model.

#### Regression 

Regression is another important approach for imputation of missing values. If the regression strategy only uses the variable in question itself, it is called [interpolation](https://en.wikipedia.org/wiki/Interpolation). On the other hand, if the other variables in your dataset are used the variable with missing values, this is called conventional regression based imputation. In this case, all the other variables in your dataset are used to predict the variable with missing values. In the next step, this model is used for imputation of the missing values. 

!!! warning 
    This method depending on the number of imputed values may bias your system towards the regression model used for imputation. Using a stochastic approach where some of the variables are excluded at random has shown a potential for higher accuracy imputation.

There are also more sophisticated approaches for data imputation, for example SVD. There is julia package called [*Impute.jl*](https://invenia.github.io/Impute.jl/latest/api/imputation/#Impute.Imputor) fully dedicated to different imputation approaches. 


## Data dimensionality 

In many cases, our datasets have multiple dimensions (i.e. variables). However, not all the variables contribute to a potential model in the same manner. Sometimes these variables are redundant, for example highly correlating variables. In those cases, you do not need to have all those variables included in your model, as one of them will bring enough information for the potential model. The very first step to detect such cases is to detect such potential redundancies. 

### Correlation analysis

The best approach to perform such assessment is calculate pair wise [correlation coefficient](https://en.wikipedia.org/wiki/Correlation_coefficient) analysis. The correlation coefficients can be calculated for a linear relationship (i.e. [Pearson correlation](https://en.wikipedia.org/wiki/Pearson_correlation_coefficient)) or for a nonlinear case (i.e [Spearman correlation](https://en.wikipedia.org/wiki/Spearman%27s_rank_correlation_coefficient)). 

**Pearson** correlation assesses the linear relationship between two variables as follows: 

```math 

r_{x_i,x_{i+1}} = \frac{cov(x_i,x_{i+1})}{\sigma _{x_i} \sigma _{x_{i+1}}}

```

These calculations can be performed using the function *cor(-)* implemented via this package. 

```@example de
using DataSci4Chem

r_p = cor(data_c) 

```
Here since we have provided a matrix to the function, we have a square matrix with diagonal of one. This is exactly what we expect as the diagonal represents the autocorrelation between each variable and itself. The other pixels, on the other hand, indicate the relationship between two pairs of variables. For example the location *r_p[4,1] = 0.8179* is the linear correlation coefficient between first and fourth variables. 

```@example de
using DataSci4Chem

heatmap(r_p,xlabel = "variable number" , ylabel = "variable number", colorbar_title = "Pearson correlation")


```

The ``|r_p|`` closer to one indicates a more significant linear relationship between two sets of variables. We can see these relationships clearly in the below scatter plots. 

```@example de
using DataSci4Chem

l_c = r_p[4,1]

scatter(data_c[:,1],data_c[:,4], xlabel = "Sepal Length", ylabel = "Petal Width", label = "$l_c")

```

```@example de
using DataSci4Chem

l_nc = r_p[2,1]

scatter(data_c[:,1],data_c[:,2], xlabel = "Sepal Length", ylabel = "Sepal Width", label = "$l_nc")

```

**Spearman correlation** is for detection of monotonic relationship between two variables, independently from its linearity. Spearman correlation is a non parametric method and thus works with the ranks rather than the actual values. To calculate Spearman correlation coefficient between a set of variables you can use the function *corspearman(-)* in a similar manner to the *cor(-)* function. 

!!! tip 
    Looking at the correlation matrix above, I would use only variable one and two for any future model building as variables three and four are covered by the first variable. 


### Matrix decomposition 

Another approach for the dimensionality reduction is the application of matrix decomposition tools such as [SVD](https://emcms.github.io/ACS.jl/dev/svd/) or [PCA](https://en.wikipedia.org/wiki/Principal_component_analysis) where the scores' matrix for a selected number of principal components represent a large enough variance in the dataset to be used for further model building. An example of such systems is [Principal Component Regression](https://en.wikipedia.org/wiki/Principal_component_regression). 