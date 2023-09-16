
# Notes - Week 1

## Homework

### Question 7

In question 7 it is mentioned that linear regression gets implemented. The formula is not shared, only instructions in text for the mathematical operations to perform. Therefore the steps containing mathematical operations will be displayed here as formulas.

Question 7 step 4: calculate $(X^TX)$

Question 7 step 5: calculate $(X^TX)^{-1}$

Question 7 step 7: calculate $w=(X^TX)^{-1}X^Ty$

From the result going backwards to the initial formula:

$$
\\begin{align*}
w &= (X^TX)^{-1}X^Ty \\ 
\Leftrightarrow
(X^TX)w &= (X^TX)(X^TX)^{-1}X^Ty \\ 
\Leftrightarrow
X^TXw &= X^Ty \\ 
\Leftrightarrow
Xw &= y
\\end{align*}
$$



Matrix $X$ multiplied by some unknown weights $w$ resulting in $y$.
