# Singular Value Decomposition

## Introduction 
In many cases, a data matrix can be very well approximated by a sum ("linear combination") of products of vectors. As a trivial example, consider the matrix

```math 
A = 
\begin{pmatrix}
1 & 2 & 3 \\
3 & 6 & 9 \\
0 & 0 & 0 \\
2 & 4 & 6 \\
-1 & -2 & -3
\end{pmatrix}
```
Note that each row is a multiple of the row vector $`\begin{pmatrix} 1 & 2 & 3 \end{pmatrix}`$, and therefore in matrix notation we have
```math 
A = 
\begin{pmatrix}
1 & 2 & 3 \\
3 & 6 & 9 \\
0 & 0 & 0 \\
2 & 4 & 6 \\
-1 & -2 & -3
\end{pmatrix}
=
\begin{pmatrix}
1\\3\\0\\2\\-1
\end{pmatrix}
\begin{pmatrix}
1 & 2 & 3
\end{pmatrix},
```
so in this case the sum of products of vectors is just one term. Here is a larger example: we measure the infrared spectra of 3000 samples and put them in matrix as rows. Each spectrum contains 2000 points, so the data is a 3000$`\times`$2000 matrix. To get a view of this matrix we can translate numbers into color intensity, and make plots of the first five rows:
![1component_example.png](https://github.com/EMCMS/DataSci4Chem.jl/blob/main/docs/src/assets/1component_example.png)
It seems that here too, each row is a multiple of the same row vector (note that this will not be exactly so, because the noise on the data will not be the same in each row). The chemical interpretation of this fact is that apparently all the samples contain only one compound, but with different concentrations. To a good approximation we can write 
```math 
B = 
\begin{pmatrix}
c_1\\c_2\\\vdots\\c_{3000}
\end{pmatrix}
\begin{pmatrix}
s_1 & s_2 & \ldots & s_{2000}
\end{pmatrix},
```
where the $`c_i`$ values are (proportional to) the concentrations, and the vector $`\begin{pmatrix} s_1 & s_2 & \ldots & s_{1000} \end{pmatrix}`$ is the spectrum of the compound. Note that we need only 3000+2000 numbers to characterize the entire matrix, which contains 3000$`\times`$2000 numbers, so we have a data reduction by a factor of more than 1000! Of course, this situation will not occur very often. As a slightly more complicated example, have a look at a different set of IR spectra, again for 2000 samples:
![1component_example.png](https://github.com/EMCMS/DataSci4Chem.jl/blob/main/docs/src/assets/2component_example.png)
Inspection of the data in the first 5 rows shows that this matrix can not be written as the product of two vectors: looking the intensities at positions 1050 and 1720 of the blue and red row data, it is clear that these two matrix rows are not multiples of each other (and therefore cannot be multiples of one ans the same row vector). In this case, it turns out that the matrix can be very well approximated by a sum of two vector products:
```math 
C = 
\begin{pmatrix}
c_{1,1}\\c_{1,2}\\\vdots\\c_{1,3000}
\end{pmatrix}
\begin{pmatrix}
s_1 & s_2 & \ldots & s_{2000}
\end{pmatrix},
```
The values $`c_{i,j}`$ can be interpreted as the concentration of compound $j$ in sample $i$.
This can be written more elegantly as a matrix product:
```math
B = 
\begin{pmatrix}
c_1\\c_2\\\vdots\\c_{3000}
\end{pmatrix}
\begin{pmatrix}
s_1 & s_2 & \ldots & s_{2000}
\end{pmatrix},
```
But in many cases matrices do turn out to be sums of such vector products: in the case of sample spectra (IR, mass spec, NMR, ...) this is simply the mathematical expression of the fact that the samples contain a finite number of compounds, each with different concentrations. 

## Singular Value Decomposition

### Definition

### Matrix approximation




## Examples

### Sets of spectra

### Chemical Kinetics

### Image compression

## Doing it yourself 
