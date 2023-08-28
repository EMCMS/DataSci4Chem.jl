# Julia Programming Language



## Installation
### Julia 
1.	Download the long term support (LTS) release for Julia from: [https://julialang.org/downloads/](https://julialang.org/downloads/)

2.	Execute the file and follow the installation steps. Make sure to write down the installation path or use the default path (This information will be required in a later step).

![julia_down](https://github.com/EMCMS/ACS.jl/blob/main/docs/assets/juliaLTS.PNG?raw=true)



### Visual Studio Code
1.	Download and install Visual Studio Code (VScode) from: [https://code.visualstudio.com/download](https://code.visualstudio.com/download)

2.	To open the extension marketplace, press (Ctrl+Shift+X) or press the marketplace button on the left side of the screen

3.	Search for julia. 

4.	Select the first package named Julia and install. 

5.	After installation restart VS Code for the next steps.

![julia_ex](https://github.com/EMCMS/ACS.jl/blob/main/docs/assets/JuliaExtension.PNG?raw=true)



To ensure that VS Code can find the installed Julia language:

1.	Go to: file -> preferences -> settings. 

2.	Search for the Julia.executablePath (Figure below).

3.	Fill in the path (i.e., installation path noted before) to the Julia executable (Julia.exe). 


- In case you do not have the path you can do the following:

- Default path for Windows: C:\\Users\\[INSERTUSERNAME]\\AppData\\Local\\Programs\\Julia1.5.3\\bin\\julia.exe

- For windows, double slashes (\\) need to be used instead of single (\) because the single slash is interpreted as escape.

 
- To locate appdata folder, you can press the windows key and type: %appdata%

- Copy path and add \\Local......:

- [Copied path ending with \\AppData]\\Local\\Programs\\Julia-x.x.x\\bin \\julia.exe


- Default path for Mac: 

- MacintoshHD/users/[INSERTUSERNAME]/Applications/Julia-x.x.x.app/Contents/Resources/julia/bin/Julia


![julia_path](https://github.com/EMCMS/ACS.jl/blob/main/docs/assets/executablePath.PNG?raw=true)





### Julia package installation
To install packages we first need to start up Julia. To open the Julia REPL for executing commands press **Crtl+Shift+P** and search for **Julia: Start REPL** and press enter, opening up the following window:

![REPL](https://github.com/EMCMS/ACS.jl/blob/main/docs/assets/REPL.PNG?raw=true)


In the REPL execute the following lines of code in order to install packages. After a single command is executed, “julia >” re-appears and the next line can be executed (it might take a bit for the packages to finish downloading). Also, the lines are capital sensitive.

```julia
using Pkg
# Julia official packages
Pkg.add("CSV")

# Julia unofficial packages from repository
Pkg.add(PackageSpec(url="https://github.com/EMCMS/DataSci4Chem.jl"))
```
The second package that is being installed contains all relevant functions and information for the course.




## Basic programming knowledge
### Loading packages
Packages are loaded with the **using** keyword

```julia
using DataSci4Chem

mean([2,4,2])  #shows that the mean function was loaded from the ACS package

```



### [Repeated evaluation](https://docs.julialang.org/en/v1/manual/control-flow/#man-loops)
#### For loops
For loops can be used when repeated evaluations of the same code are required. The example below shows the basic functionality of for loops. After the keyword **for**, comes a range of values for which the code needs to be executed. Then for each of the values in this range (*i*) the code is executed, which is a simple print function for the example below:
```julia
for i = 1:11    #iterator
    println(i)  #code to execute for each value of i
end
```

Alternatively, the step size can be adjusted to skip values that are not of interest.
```julia
for i = 1:4:11
    println(i)
end
```

For loops can also be used for iterating over certain indexes to obtain values, modify them, and saving these in an alternative variable. For example:
```julia
a = collect(1:6)

extract = [2, 3, 6]
b = zeros(length(extract))

for x = 1:length(extract)
    b[x] = a[extract[x]] * 2 
end

println(b)
```



#### While
In case there is not a clear range over which the iteration must take place, while loops could be used, which continue until the condition is not true is reached. The example below prints and adds 1 to the variable *i* until *i* = 9, for which the *i* <= 8 yields false.
```julia
i = 1
while i <= 8
    println(i)
    i = i + 1
end
```



### Flow control
The flow of the data through you code can also be controlled with [conditional evaluations](https://docs.julialang.org/en/v1/manual/control-flow/#man-conditional-evaluation). Allowing to execute different parts of code depending on the situation.

For example, using an if-else statement, only the even numbers can be printed by adding a if statement in the for loop that evaluates the remained by dividing a value by 2. 
```julia
for i = 1:12
    if rem(i,2) .== 0   
        println(i)
    end
end
```

Or we can even make the for loop show for each number of it is even or uneven.
```julia
for i in [1, 100, 123, 141, 144]
    if rem(i,2) .== 0   
        println("The number $i is even")
    else
        println("The number $i is uneven")
    end
end
```



### Functions
There might be cases where you build a code that need to be applied more than once. In these cases, both for cleanness of the code itself and convenience, the code can be put in a function. These function can then be used in the same manner as, for example, the *sum()* function, which comes by default with Julia. 

For example, we could grab the code from the previous for loop and convert it to a function. 

```julia
function EvenOrUneven(numbers)
    for i in numbers
        if rem(i,2) .== 0   
            println("The number $i is even")
        else
            println("The number $i is uneven")
        end
    end
end

EvenOrUneven([1, 3, 6, 2, 3])
```

Apart from printing results in the REPL, function can also return values with the **return** keyword:

```julia
function IsEven(numbers)
    res = zeros(length(numbers))
    for i = 1:length(numbers)
        if rem(numbers[i],2) .== 0   
            res[i] = 1
        end
    end
    return res
end

out = IsEven([1, 3, 6, 2, 3])
println(out)
```



#### Scope
One thing to consider when building functions is the scope of the variables. A variable can have a local or a global scope. Variables with a local scope can, for example, only be seen within a function, while global variables can be seen through out the "file", but not within functions. That is why these variables need to be passed down to a function, for example the variable numbers in the case below. Same as to why we need to return *res* to be able to used is outside the function in the global scope, which is saved in variable *out*. When running the code below you will notice that println(res) will actually return an error, since to the global scope this variable is not defined.

```julia
function IsEven(numbers)
    res = zeros(length(numbers))
    for i = 1:length(numbers)
        if rem(numbers[i],2) .== 0   
            res[i] = 1
        end
    end
    return res
end

out = IsEven([1, 3, 6, 2, 3])
println(res)
println(out)
```



### Loading/saving data
Loading and saving of DataFrames can be done through the following lines from .csv files.
```julia
#loading data from csv files
data =  CSV.load("path2data", DataFrame)

#saving data to a csv file
CSV.write("path2savelocation", data)
```



## Additional Resources
Here you can find more resources related to basic Julia usage: 
* [Julia resource learning page](https://julialang.org/learning/)