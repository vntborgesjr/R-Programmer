# --------------------------------------------------- 
# Writing Efficient R Code - Diagnosing Problems: Code Profiling 
# 10 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# What is codde profiling  -------------------------------------------
# Run your code and take snapshots of what the program is doing at 
# regular intervals (ex. every few milliseconds). This gives you data
# on how long each function took to run. 
# Built in tool for code profiling: Rprof()
# But it's not user friendly
# Alternative is use profvis package

# Profvis in action
# Load the data set
data(movies, package = "ggplot2movies") 

# Load the profvis package
library(profvis)

# Profile the following code with the profvis function
profvis({
  # Load and select data
  comedies <- movies[movies$Comedy == 1, ]
  
  # Plot data of interest
  plot(comedies$year, comedies$rating)
  
  # Loess regression line
  model <- loess(rating ~ year, data = comedies)
  j <- order(comedies$year)
  
  # Add fitted line to the plot
  lines(comedies$year[j], model$fitted[j], col = "red")
}) ## Remember the closing brackets!

# Profvis Larger example  -------------------------------------------
# Change the data frame to a matrix
# Load the microbenchmark package
library(microbenchmark)

# The previous data frame solution is defined
# d() Simulates 6 dices rolls
d <- function() {
  data.frame(
    d1 = sample(1:6, 3, replace = TRUE),
    d2 = sample(1:6, 3, replace = TRUE)
  )
}

# Complete the matrix solution
m <- function() {
  matrix(sample(1:6, 6, replace = TRUE), ncol = 2)
}

# Use microbenchmark to time m() and d()
microbenchmark(
    data.frame_solution = d(),
    matrix_solution     = m()
)

# Calculating row sums
roll1 <- c(6, 1, 2)
roll2 <- c(1, 1, 2)
rolls <- matrix(c(roll1, roll2), ncol = 2)

# Example data
rolls

# Define the previous solution 
app <- function(x) {
  apply(x, 1, sum)
}

# Define the new solution
r_sum <- function(x) {
  rowSums(x)
}

# Compare the methods
microbenchmark(
  app_sol = app(rolls),
  r_sum_sol = r_sum(rolls)
)

# Use && instead of &
# Example data
is_double <- c(FALSE, TRUE, TRUE)

# Define the previous solution
move <- function(is_double) {
  if (is_double[1] & is_double[2] & is_double[3]) {
    current <- 11 # Go To Jail
  }
}

# Define the improved solution
improved_move <- function(is_double) {
  if (is_double[1] && is_double[2] && is_double[3]) {
    current <- 11 # Go To Jail
  }
}

# microbenchmark both solutions
# Very occassionally the improved solution is actually a little slower
# This is just random chance
microbenchmark(move(is_double), improved_move(is_double), 
               times = 1e5)

# Monopoly recap  -------------------------------------------
# 10 seconds faster with three minor changes in code!