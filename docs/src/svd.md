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
Looking at the graphs of the data in the first 5 rows, we see that this matrix can not be written as the product of two vectors: looking the intensities at positions 1050 and 1720 of the blue and red row data, it is clear that these two matrix rows are not multiples of each other (and therefore cannot be multiples of one ans the same row vector). In this case, it turns out that the matrix can be very well approximated by a sum of two vector products:
```math 
C = 
\begin{pmatrix}
c_{1,1}\\c_{2,1}\\\vdots\\c_{3000,1}
\end{pmatrix}
\begin{pmatrix}
s_{1,1} & s_{1,2} & \ldots & s_{1,2000}
\end{pmatrix}+
\begin{pmatrix}
c_{1,2}\\c_{2,2}\\\vdots\\c_{3000,2}
\end{pmatrix}
\begin{pmatrix}
s_{2,1} & s_{2,2} & \ldots & s_{2,2000}
\end{pmatrix}
,
```
where we needed an extra index for the $c$ and $s$ vectors since there are two of each.
The values $`c_{i,j}`$ can be interpreted as the concentration of compound $j$ in sample $i$, and the values $`s_{m,n}`$ can be interpreted as the spectrum of compound $m$ at IR frequency $n$.
This can be written more elegantly as a matrix product (and we can interpret the indices as matrix indices):
```math
C = 
\begin{pmatrix}
c_{1,1} & c_{1,2}\\c_{2,1}&c_{2,2}\\\vdots&\vdots\\c_{3000,1}& c_{3000,2}
\end{pmatrix}
\begin{pmatrix}
s_{1,1} & s_{1,2} & \ldots & s_{2000,1}\\
s_{2,1} & s_{2,2} & \ldots & s_{2000,2}
\end{pmatrix}
```
So in this case we need 2(3000+2000) numbers to characterize the matrix, still a huge reduction in data. This idea can be extended to sums of more than two products of vectors.

In many practical situations, matrices turn out to be such sums of a small number of vector products: in the case where that matix contains sample spectra (IR, mass spec, NMR, ...) this is simply the mathematical expression of the fact that the samples contain a finite number of compounds, each with their own spectrum (but with different concentrations in the samples). However, when the number of compounds present is larger than 1 it becomes rather difficult to find out how many there are by just looking at the data (for instance in the case of matrix $`C`$ above, how did we know there were not more than 2 components?). Two questions naturally arise: (1) is there a mathematical way of estimating how many components there are present in a data matrix? and (2) can we quantify how well the sum of component products approaches the original data matrix?

## Singular Value Decomposition

### Definition

### Matrix approximation




## Examples

### Sets of spectra

### Chemical Kinetics

### Image compression

## Doing it yourself 
