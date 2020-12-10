# --------------------------------------------------- 
# Writing Efficient R Code - Fine Tuning: Effcient Base R 
# 10 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Memory allocation  -------------------------------------------
# In R, memory allocation happens automatically
# R allocates memory in RAM to store variables
# One way to go R faster is to minimize the amount of memory allocation
# R has to perform
# The first rule of R club: Never grow a vector in R!

# Timings - growing a vector
n <- 30000
# Slow code 
growing <- function(n) {
  x <- NULL
  for (i in 1:n) 
    x <- c(x, rnorm(1))
  x
}

# Use <- with system.time() to store the result as res_grow
system.time(res_grow <- growing(n))

# Timings - pre-allocation
pre_allocate <- function(n) {
  x <- numeric(n) # Pre-allocate
  for (i in 1:n)
    x[i] <- rnorm(1)
  x
}

# Use <- with system.time() to store the result as res_allocate
n <- 30000
system.time(res_allocate <- pre_allocate(n))

# The importance of vectorizing your code  -------------------------------------------
# The second rule of R club: use a vectorized solution wherever 
# possible!

# Vectorized code: multiplication
# Non-vecorized solution
x <- rnorm(10)
x2 <- numeric(length(x))
for (i in 1:10)
  x2[i] <- x[i] * x[i]
x2

# Vectorized solution
# Store your answer as x2_imp
x2_imp <- x * x

microbenchmark(for (i in 1:10)
  x2[i] <- x[i] * x[i]
, x * x, times = 10)

# Vectorized code: calculating a log-sum
# Initial code
n <- 100
total <- 0
x <- runif(n)
for(i in 1:n) 
  total <- total + log(x[i])

# Rewrite in a single line. Store the result in log_sum
log_sum <- sum(log(x))

microbenchmark(for(i in 1:n) 
  total <- total + log(x[i]), sum(log(x)), times = 10)

# Data frames and matrices  -------------------------------------------
# The third rule of R club: use a matrix whenever apropriate

# Data frames and matrices - column selection
mat <- matrix(rnorm(10000), nrow = 100, ncol = 100)
df <- data.frame(mat)

# Which is faster, mat[, 1] or df[, 1]? 
microbenchmark(mat[, 1], df[, 1])

# Row timings
# Which is faster, mat[1, ] or df[1, ]? 
microbenchmark(mat[1, ], df[1, ])

