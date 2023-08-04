# Matrix Manipulation 

[Matrices](https://en.wikipedia.org/wiki/Matrix_(mathematics)) are multi-dimensional data containers, which have very important properties enabling a branch of mathematics called [Linear Algebra](https://en.wikipedia.org/wiki/Linear_algebra). Matrices can have multiple dimensions. However, the most commonly used type is a two dimensional matrix (e.g. *``X_{m,n}``*) or *``m \times n``*. The first dimension of a matrix (i.e. *m*) is the number of rows and the second dimension (i.e. *n*) is the number of columns of that matrix. A matrix with one of dimensions being **one** is called a [vector](https://en.wikipedia.org/wiki/Vector_(mathematics_and_physics)). Matrices may contain one or multiple data types, including mixed data types (e.g. combination of strings and integers). A matrix with multiple type data is called an [Array](https://en.wikipedia.org/wiki/Array_(data_structure)) while the homogeneous data container is a matrix. This module only focuses on the homogeneous matrices containing only numerical entries, given their mathematical properties. 

## Matrix dimensionality

The very first step to be able to work with matrices is being able to handle them, including being able to select specific rows, columns, and/or entries in a matrix. As mentioned before each entry in a matrix has its own coordinates (i.e. the row and column number). For example, the ``a_{2,1}`` represents the entry on the second row and the first column. 

```math 

A_{m,n} = 
\begin{pmatrix}
a_{1,1} & a_{1,2} & \cdots & a_{1,n} \\
a_{2,1} & a_{2,2} & \cdots & a_{2,n} \\
\vdots  & \vdots  & \ddots & \vdots  \\
a_{m,1} & a_{m,2} & \cdots & a_{m,n} 
\end{pmatrix}

```

### Entry selection

In julia to select an entry of a matrix you can use "*[m,n]*", where *m* is the row number and *n* is the column number. It should be noted that these numbers are also referred to as indices. In the below example we first generate a matrix of 15 by 20 filled by random numbers, which will be used for our examples.


```@example mat1
using DataSci4Chem

# Generating the data

m = 15          # number of rows
n = 21          # number of columns

X = randn(m,n)

```

As you can see, we have generated our matrix of random [floats](https://en.wikipedia.org/wiki/Double-precision_floating-point_format) and have stored it in a variable called *X*. Now as our first example we will attempt at selecting the matrix entry at the row 5 and column 20. To do that we use the provided coordinates with "[]". Here we first select the specified entry and store it in the variable "x1" and then printed. 

```@example mat1
using DataSci4Chem

x1 = X[5,20]

println(x1)

```

We can also select more than one entry at a time. For example if we want to select the entries between 3rd and 10th rows on the 2nd column we take advantage of ranges (i.e. 3:10). Similar to the single entry selection we put the relevant range in the spot for rows and select the column #2. 

```@example mat1
using DataSci4Chem

x2 = X[3:10,2]


```

As you can see, the output of this operation is a matrix of 8 by 1, thus a vector of 8 elements. We can perform the range selection in both row and column level at the same time. The example below shows how to select rows 5:10 and columns 1:3. This should result into a 6 by 3 matrix. 

```@example mat1
using DataSci4Chem

X1 = X[5:10,1:3]


```

There are also cases where you would like to select a column or an entire row in a matrix. In this case also we can use ranges expressed by ":". Since this is the full range from 1:end you do not need to specify the details. For example for selecting the second column of the *X* we can use the expression *X[:,2]*, which implies that we are selecting all the rows in the second column. 

```@example mat1
using DataSci4Chem

X2 = X[:,2]


```

!!! note 
    Please note that as a generally accepted rule, the matrices and vectors are represented with CAPITAL letters (e.g. *X*) while the entries are represented with small letters (e.g. *x*). 

You can also select multiple columns or rows of a matrix. In this example we are selecting rows 3:5 of the matrix *X*. 

```@example mat1
using DataSci4Chem

X3 = X[3:5,:]


```
So far we have selected rows and/or columns that are next to each other, thus accessible with ranges. We can also access entries in a matrix that are not next to one another. In the below example we are selecting the columns 1, 3, and 21 of the matrix *X*. For this we need to generate a vector of the column indices (i.e. [1,3,21]), which is used for our operation. 

```@example mat1
using DataSci4Chem

X4 = X[:,[1,3,21]]


```

!!! note 
    When setting indices for a matrix or a dataframe, you must work with [integers](https://en.wikipedia.org/wiki/Integer) that are larger than zero or [boolians](https://en.wikipedia.org/wiki/Boolean_data_type). 

Now that we know how to select entries or chunks of a matrix, we can start working on matrix operations. 

## Matrix operations

### Element wise

Most matrix operations are divided into two categories: element wise and the matrix wise. For the element vise operations the two matrices must have exactly the same size as the desired operation is performed element by element. Consequently, the resulting matrix will have the same size as the starting matrices. 

#### Summation 

An example of such operations is summing or subtracting two matrices. Let's generate two matrices 4 by 5 populated with random numbers called *A* and *B*. 

```@example mat1
using DataSci4Chem

A = rand(4,5)

B = rand(4,5)

```

Now we can try to sum up these two matrices and store the results in the matrix *C*. 

```@example mat1
using DataSci4Chem

C = A + B

```

The matrix *D* is the result of subtraction of two matrices *A* and *B*. 

```@example mat1
using DataSci4Chem

D = A - B

```

!!! tip
    The operation summation has the commutative and associative properties. In other words the following is correct: 
    1. *A* + *B* = *B* + *A* (commutative),
    2. (*A* + *B*) + *C* = *A* + (*B* + *C*) (associative).

#### Transpose

Another very useful element wise matrix operation is the "transpose" operation. When a matrix is transposed its rows and columns are switched. This means that if you have started with *``X2_{3,2}``*, you will end up with matrix *``X2^{T}_{2,3}``*. In the below example we have a 3 by 2 matrix *X2* and we will try to transpose it to *X2_t*. 

```@example mat1
using DataSci4Chem

X2 = [1 2 ; 4 3 ;  5 4]

```

```@example mat1
using DataSci4Chem

X2_t = DataSci4Chem.transpose([1 2 ; 4 3 ;  5 4])

```

!!! note
    A transposed matrix *X* is typically denoted as *``X^{T}``*  or *``X^{'}``*. Within this documentation we will use the *X_t* for the code snippet.

#### Scalar multiplication

Another element wise matrix operation is the multiplication of a [scalar](https://en.wikipedia.org/wiki/Scalar_(mathematics)) (i.e. a number) to a matrix. Here the scalar is multiplied into each element individually, thus element wise. For example if we multiply the scalar 2 to the matrix *X2* we will get the following. 

```@example mat1
using DataSci4Chem

2 * X2

```

#### Element wise multiplication

The last element wise matrix operation that is discussed here is the element-wise matrix multiplication or [Hadamard product](https://en.wikipedia.org/wiki/Hadamard_product_(matrices)). This operation is denoted as "``\odot``" and is performed using ".*" in julia language. 

```@example mat1
using DataSci4Chem

X2 .* (2 * ones(3,2))

```

In the above example with the function *ones(3,2)* we are generating a 3 by 2 matrix of ones, which is multiplied by the scalar 2, resulting in a 3 by 2 matrix of twos. In the next step the two matrices are multiplied element wise. As you can intuitively imagine and combination of these three components will result in the same output. 

```@example mat1
using DataSci4Chem

2 * X2 .* ones(3,2)

```

or 

```@example mat1
using DataSci4Chem

2 * (X2 .* ones(3,2))

```

!!! note
    This can be done due to the [associative](https://en.wikipedia.org/wiki/Associative_property) properties of the element wise matrix multiplication.



### Matrix wise

#### Matrix multiplication 


One of the most important matrix wise operations is the matrix multiplication. Let's say we have a matrix *``A_{m,p}``* and a second matrix *``B_{p,n}``* for these matrices to be multipliable they must have the same inner dimensions.


```math 

A_{m,p} \times B_{p,n} = C_{m,n}


```

As you can see the result of this multiplication is a matrix *``C_{m,n}``*. Each entry in the product matrix is the result of first element-wise multiplication of the first matrix rows to the second matrix columns followed by summation of those products. This process can be described with the below formula. 


```math 

i = 1:m, \\ j = 1:n, \\

c_{i,j} = \sum_{k=1}^{p} a_{i,k}b_{k,j}  


```

Let's see this in practice: 

```math 

A = 
\begin{pmatrix}
1 & 6 \\
9 & 3 
\end{pmatrix}

\\

and\\

B = 
\begin{pmatrix}
0 & -1 \\
-1 & 2 
\end{pmatrix}


```

Based on the above formula the first entry of the *``c_{1,1}``* will be calculated as:


```math 


c_{1,1} = a_{1,1}b_{1,1} +  a_{1,2}b_{2,1} = 1 \times 0 + 6 \times -1 = -6  


```

while the *``c_{1,2}``* is calculated a following.

```math 


c_{1,2} = a_{1,1}b_{1,2} +  a_{1,2}b_{2,2} = 1 \times -1 + 6 \times 2 = 11  


```

Following this process we can calculate the product os *A* and *B*. 

```math 

 
\begin{pmatrix}
1 & 6 \\
9 & 3 
\end{pmatrix}

\times
 
\begin{pmatrix}
0 & -1 \\
-1 & 2 
\end{pmatrix} = 

\begin{pmatrix}
-6 & 11 \\
-3 & -3 
\end{pmatrix}


```


!!! note
    This matrix multiplication has the following properties: 
    1. ``0 \times A = 0``, ``A \times 0 = 0`` 
    2. ``I \times A = A``, ``A \times I = A ``
    3. ``A(B + C) = AB + AC``, ``(A + B)C = AC + BC``
    4. ``(A \times B)^{T} = A^{T} \times B^{T}`` 


#### Matrix powers 

Matrix power is an extension of the matrix multiplication where *``A^{n} = \prod_{i=1}^{n} A``*, which denotes n multiplications of the matrix *A*. However, it should be noted that this is only possible for square matrices as non-squared matrices cannot be multiplied by themselves. 


#### Inverse matrix 

Calculation of the [inverse matrix](https://en.wikipedia.org/wiki/Invertible_matrix) (i.e. *``A^{-1}``*) is one of the most fundamental operations that you will do with matrices. It has applications in regression, optimization, matrix decomposition and many other areas of scientific computing. For a matrix to be "invertible" (i.e. nonsingular), it has to satisfy two criteria: 
1. it must be square 
2. *``A^{-1} \times A = I``*. 


In fact for calculating the inverse of a matrix you can use the second criteria for invertible matrices. Let's look an example for this. 

```math 

\begin{pmatrix}
a & b \\
c & d 
\end{pmatrix}

\times 

\begin{pmatrix}
1 & -1 \\
1 & 2 
\end{pmatrix}

= 

\begin{pmatrix}
1 & 0 \\
0 & 1 
\end{pmatrix}


```

If we solve this problem we will end up with the below matrix. 

```math 

\begin{pmatrix}
a & b \\
c & d 
\end{pmatrix}

\times 

\begin{pmatrix}
1 & -1 \\
1 & 2 
\end{pmatrix}

= 
\begin{pmatrix}
a+b & 2b-a \\
c+d & 2d-c 
\end{pmatrix}

=

\begin{pmatrix}
1 & 0 \\
0 & 1 
\end{pmatrix}


```
Now we have a set of four equations and four variables that can be rewritten as a system of equations. 

```math

a + b = 1\\
2b - a = 0 \\
c + d = 1 \\
2d + c = 0 

```
Solving these equations ultimately will result in the inverse matrix.


```math 

\begin{pmatrix}
1 & -1 \\
1 & 2 
\end{pmatrix}^{-1}

= 
\begin{pmatrix}
0.333 & -0.333 \\
0.333 & -0.666 
\end{pmatrix}


```

You can calculate the inverse of invertible matrices using the functions *inv()* or *pinv(-)* (i.e. [pseudo inverse](https://en.wikipedia.org/wiki/Moore%E2%80%93Penrose_inverse)). 


```@example mat1
using DataSci4Chem

A = [2 1; -1 1]
DataSci4Chem.inv(A)

```

!!! tip 
    For a matrix *X*, which is not square, thus noninvertible, the *``X^{T}X``* matrix is square and has very special characteristics. 

!!! note 
    The inverse matrix also has a lot of interesting properties: 
    1. *``(A^{-1})^{-1} = A``* 
    2. *``(A^{T})^{-1} = (A^{-1})^{-T}``*
    3. if *``y = Ax``* where *x* ``\in R^{n}`` and *A* is invertible, then *``x = A^{-1} y``*. 

## Matrix decomposition

[Matrix decomposition](https://en.wikipedia.org/wiki/Matrix_decomposition) is another important operation where a matrix *X* is decomposed/factorized into product matrices. There are several matrix decomposition methods, depending on the applications. For example for solving systems of equations [LU decomposition](https://en.wikipedia.org/wiki/LU_decomposition) is employed. One of the highly relevant matrix decomposition approaches is [singular value decomposition (SVD)](https://en.wikipedia.org/wiki/Singular_value_decomposition). The SVD decomposes a matrix *X* into the product is three matrices *``U_{m \times n}``*, *``D_{n \times n}``*, and *``V_{n \times n}^{T}``*. The matrix *``U_{m \times n}``* is the left singular matrix and it represents a rotation in the matrix space. The *``D_{n \times n}``* is diagonal matrix and contains the singular values. Finally, *``V_{n \times n}^{T}``* is called the right singular matrix and is associated with rotation. For more details of SVD please look at [SVD course material](https://emcms.github.io/ACS.jl/dev/svd/).

