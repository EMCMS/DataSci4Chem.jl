# Singular Value Decomposition

## Introduction 
In many cases, a data matrix can be very well approximated by a sum ("linear combination") of products of vectors. As a trivial example, consider the matrix

```math 
A = 
\begin{pmatrix}
1 & 2 & 3 \\
3 & 6 & 9 \\
0 & 0 & 0 \\
2 & 4 & 6
\end{pmatrix}
```
Each row of this matrix is a multiple of the row vector $`\begin{pmatrix} 1 & 2 & 3 \end{pmatrix}`$, and in matrix notation we can write
```math 
A = 
\begin{pmatrix}
1 & 2 & 3 \\
3 & 6 & 9 \\
0 & 0 & 0 \\
2 & 4 & 6
\end{pmatrix}
=
\begin{pmatrix}
1\\3\\0\\2
\end{pmatrix}
\begin{pmatrix}
1 & 2 & 3
\end{pmatrix},
```
so in this case the "sum of products of vectors" is just one term. Here is a larger example: we measure the infrared spectra of 3000 samples and put them in matrix as rows. Each spectrum contains 1400 points, so the data is a 3000$`\times`$1400 matrix. To get a view of this rather large matrix we  translate numbers into color intensity, and we also make plots of the first five rows:
![1component_example.png](https://github.com/EMCMS/DataSci4Chem.jl/blob/main/docs/src/assets/1component_example.png)
It seems that here too, each row is a multiple of the same row vector (note that this will not be exactly so, because the noise on the data will not be the same in each row). The chemical interpretation of this fact is that apparently all the samples contain only one compound, but with different concentrations. To a good approximation we can write 
```math 
B = 
\begin{pmatrix}
u_1\\u_2\\\vdots\\u_{3000}
\end{pmatrix}
\begin{pmatrix}
v_1 & v_2 & \ldots & v_{1400}
\end{pmatrix},
```
where the $`u_i`$ values are (proportional to) the concentrations, and the vector $`\begin{pmatrix} v_1 & v_2 & \ldots & v_{1400} \end{pmatrix}`$ is the spectrum of the compound (=its absorption at 1400 different IR frequencies). Note that we need only 3000+1400 numbers to characterize the entire matrix, which contains 3000$`\times`$1400 numbers, so we have a data reduction by a factor of about 1000! Of course, this situation will not occur very often. As a  more realistic example, here is a different set of IR spectra, again containing 3000 samples (=rows):
![1component_example.png](https://github.com/EMCMS/DataSci4Chem.jl/blob/main/docs/src/assets/2component_example.png)
Looking at the graphs of the first 5 rows, we see that this matrix can not be written as the product of two vectors: comparing the  intensities at positions 550 and 1200 of the blue and red data, it is clear that these two matrix rows are not multiples of each other (and therefore cannot be multiples of one and the same row vector). However, in this case, it turns out that the matrix can be very well approximated by a sum of two vector products:
```math 
C = 
\begin{pmatrix}
u_{1,1}\\u_{2,1}\\\vdots\\u_{3000,1}
\end{pmatrix}
\begin{pmatrix}
v_{1,1} & v_{1,2} & \ldots & v_{1,1400}
\end{pmatrix}+
\begin{pmatrix}
u_{1,2}\\u_{2,2}\\\vdots\\u_{3000,2}
\end{pmatrix}
\begin{pmatrix}
v_{2,1} & v_{2,2} & \ldots & v_{2,1400}
\end{pmatrix}
,
```
where we needed an extra index for the $u$ and $v$ vectors since there are now two of each.
The value $`u_{i,j}`$ can be interpreted as the concentration of compound $j$ in sample $i$, and the value $`v_{i,j}`$ can be interpreted as the spectral absorption intensity of compound $i$ at IR frequency $j$.
This can be written more elegantly as a matrix product (and we can interpret the indices as matrix indices):
```math
C = 
\begin{pmatrix}
u_{1,1} & u_{1,2}\\u_{2,1}&u_{2,2}\\\vdots&\vdots\\u_{3000,1}& u_{3000,2}
\end{pmatrix}
\begin{pmatrix}
v_{1,1} & v_{1,2} & \ldots & v_{1400,1}\\
v_{2,1} & v_{2,2} & \ldots & v_{1400,2}
\end{pmatrix}
```
So in this case we need 2(3000+1400) numbers to characterize the matrix, still a huge reduction in data. This idea can be extended to sums of more than two products of vectors.

In many practical situations, matrices turn out to be such sums of a small number of vector products: in the case where the matrix contains sample spectra (IR, mass, NMR, ...), this is simply the mathematical expression of the fact that the samples contain a finite number of compounds, each with their own spectrum (but with different concentrations in the samples). However, when the number of components is larger than 1 it generally becomes difficult to find out how many there are by just looking at the data. For instance in the case of matrix $`C`$ above, how did we know there were not more than 2 components required to describe it? (we will soon be able to answer this). Two questions naturally arise: (1) is there a mathematical way of estimating how many components there are present in a data matrix? and (2) can we quantify how well the sum of component products approximates the original data matrix?

## Singular Value Decomposition Theorem

Theorem: any $`m \times n`$ matrix $A$ (with $`m\ge n`$) can be decomposed as
```math
\begin{pmatrix}
~\\~\\~\\~~~~~~~~~~~~A~~~~~~~~~~~~\\~\\~\\~
\end{pmatrix}
=
\begin{pmatrix}
~\\~\\~\\~~~~~~~~~~~~U~~~~~~~~~~~~\\~\\~\\~
\end{pmatrix}
\begin{pmatrix}
s_1 & & & \\ & s_2 & & \\ & & \ddots & \\ & & & s_n
\end{pmatrix}
\begin{pmatrix}
  & & & & & \\ &  & & & & \\ & & &  \!\!\!V^T   & & \\  && &  & & \\ & & & & &
\end{pmatrix},
```
where the middle matrix $`S`$ is a diagonal $`n\times n`$  matrix with positive or zero elements (the singular values, basically "weights"), $U$ has the same dimensions as $`A`$ and has columns that are orthonormal vectors, and $V^T$ is a square $`n\times n`$ matrix with rows that are orthonormal vectors (so that 4`V`$ is a square matrix with colums that are orthonormal vectors). This latter orthogonal-vector property of the columns of $U$ and the rows of $V^T$ (or $V$) can be written explicitly as
```math
\sum_i u_{ij}u_{ik} = \delta_{jk}\\
```
```math
\sum_j v_{ij}v_{ik} = \delta_{jk} 
```
If the $`s_i`$ are sorted by order of decreasing value, this decomposition is unique (apart from forming linear combinations of columns of $U$ and rows of $V^T$ that have the same $s_i$ values). The names $`U,S,V^T`$ of the matrices in the product are standard.
Note that the diagonal matrix $`S`$ in the middle "picks out" columns from the left matrix and rows from the right matrix, and that we can also write the above decomposition as a so-called "dyadic summation":
```math
\begin{align} 
\begin{pmatrix}
~\\~\\~\\~~~~~~~~~~~~A~~~~~~~~~~~~\\~\\~\\~
\end{pmatrix}
&= s_1
\begin{pmatrix}
u_{1,1}\\u_{2,1}\\ \vdots \\ u_{m,1}
\end{pmatrix}
\begin{pmatrix}
v_{1,1} &v_{1,2} & \ldots & v_{1,n}  
\end{pmatrix}
+
s_2
\begin{pmatrix}
u_{1,2}\\u_{2,2}\\ \vdots \\ u_{m,2}
\end{pmatrix}
\begin{pmatrix}
v_{2,1} &v_{2,2} & \ldots & v_{2,n}  
\end{pmatrix}
+\ldots+
s_n
\begin{pmatrix}
u_{1,n}\\u_{2,n}\\ \vdots \\ u_{m,n}
\end{pmatrix}
\begin{pmatrix}
v_{n,1} &v_{n,2} & \ldots & v_{n,n}  
\end{pmatrix}\\
&=s_1{\bf u}_1 {\bf v}^T_1+s_2{\bf u }_2 {\bf v}^T_2+\ldots+s_n{\bf u}_n {\bf v}^T_n
\end{align} 
```
where in the second line we used boldface letters to denote column vectors (with the transposes ${\bf v}^T_k$ being row vectors). This shows that the example matrices $`A,B,C`$ above were special cases in which the only nonzero $`s_i`$ were the first (for $`A`$ and $`B`$) and the first and second (for $`C`$).
#### Example 
For matrix the $A$ above we have
```math
\begin{pmatrix}
1 & 2 & 3 \\
3 & 6 & 9 \\
0 & 0 & 0 \\
2 & 4 & 6
\end{pmatrix} =
\begin{pmatrix}
  0.267 &  0.951 &  -0.153\\
 0.802 & -0.132  &  0.583\\
  0.0      &  0.0     &   0.0\\
 0.535 & -0.278 & -0.798
\end{pmatrix}
\begin{pmatrix}
14 &  &  \\
 & 0 &  \\
 & & 0
\end{pmatrix}
\begin{pmatrix}
1 & 2 & 3 \\
3 & 6 & 9 \\
0 & 0 & 0 \\
2 & 4 & 6
\end{pmatrix}
= 14 \begin{pmatrix}
  0.267 \\
 0.802 \\
  0.0  \\
 0.535
\end{pmatrix}
\begin{pmatrix}
1 & 2 & 3
\end{pmatrix}
```

The SVD decomposition (and the dyadic summation) is exact. In addition, for many data matrices that one encounters in practice, it turns out that the first few weights $`s_i`$ are much larger than all the others. This means that if we truncate the dyadic summation after a small number of terms, we still get a good approximation of the original matrix. How good?

### Matrix approximation
To define quantitatively how well we approximate a given matrix $X$ with another matrix $\tilde{X}$, we sum the squares of the differences per element:
```math
||X-\tilde{X}||=\sum_i \sum_j |x_{ij}-\tilde{x}_{ij}|^2
```
Then it can be shown that of all possible $r$-term summations 
```math
\tilde{X} = \sum_{k=1}^r s_k {\bf u}_k {\bf v}^T_k
```
the minimum value of the difference $||X-\tilde{X}||$ is obtained precisely for the truncated $r$-term summation obtained from the first $k$ weights in the singular-value decomposition. In this sense, the truncated dyadic summation of vector products that we obtain from the SVD of a given matrix is the best possible approximation of this matrix.

## Doing it yourself 
Julia has a function ``svd`` that returns the SVD of any matrix. This function can be loaded (together with many other matrix functions) with ``using LinearAlgebra``.
```@example
A = [[1,3,0,2] [2,6,0,4] [3,9,0,6]]
F = svd(A)
```
after which the matrices $`U,S,V^T`$ are contained in ``F.U``, ``F.S`` and ``F.Vt`` (the nontransposed matrix $`V`$ is contained in ``F.V``). The SVD is calculated numerically, and in the case of matrix $`A`$ we run into the machine precision:
```
julia> F.S
3-element Vector{Float64}:
 14.0
  4.43199111387671e-16
  4.7982681877701203e-32
```


## Applications

### Sets of sample spectra
Let us calculate the SVD of matrix $C$ above, and have a look at the first 5 weights $s_1,\ldots,s_{5}$:
```@example
julia> F = svd(C)
julia> F.S[1:10]
5-element Vector{Float64}:
 312.83248348826254
 124.30327344440433
   0.9221245484802668
   0.9160134372171663
   0.914885397452181
```
Clearly the list of weights is completely dominated by the first two. This is the quantitative version of our earlier hunch that each sample in the matrix $C$ contained only two compounds. Note that unlike the SVD of matrix $A$, the remaining weights are not zero, but very small. This is because the data in $C$ also contain a noise contribution, which is contained in the remaining singular vectors. How well can we approximate $C$ with the first two terms in the summation? We plot the first row of $C$ and of its approxiation obtained from the first two components of the SVD:
```@example
julia> Capprox = F.S[1]*F.U[:,1]*Transpose(F.Vt[1,:]) + F.S[2]*F.U[:,2]*Transpose(F.Vt[2,:])
julia> plot([C[1,:] Capprox[1,:]], label=["C" "Capprox"])
```
![](https://github.com/EMCMS/DataSci4Chem.jl/blob/main/docs/src/assets/svd_approx.png)
Isn't that nice? The approximation is actually smoother than the original data! Try to think why this is the case. More importantly, the SVD method to analyze a data matrix also works when the number of components is larger (and it would be difficult to "guess" the number of components contained in the samples): very often the list of weights ("singular values") is dominated by the first few, and they represent the components present in the data set.

### Chemical Kinetics

### Image compression

## Further reading
[D. Kalman, "A Singularly Valuable Decomposition: The SVD of a Matrix"](https://sites.math.washington.edu/~morrow/464_16/svd.pdf)


[S. L. Brunton, "Data Driven Science & Engineering", chapter 1: Singular Value Decomposition](https://www.researchgate.net/publication/332751929)