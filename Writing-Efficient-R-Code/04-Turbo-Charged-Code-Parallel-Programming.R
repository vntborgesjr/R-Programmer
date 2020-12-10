# --------------------------------------------------- 
# Writing Efficient R Code - Turbo Charged Code: Parallel Programming 
# 10 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# CPUs- why do we have more than one  -------------------------------------------
# How many cores does this machine have? 4!
# Load the parallel package
library(parallel)

# Store the number of cores in the object no_of_cores
no_of_cores <- detectCores()

# Print no_of_cores
no_of_cores

# What sort of problems benefit from parallel computing?  -------------------------------------------
# Run 8 Monte-Carlo simulations, one simulation per core, and 
# combine the results at the end. This call Embarrassingly parallel
# Little effort is needed to separate the problem into separate tasks
# In aprallel computing we can't guarantee the order of operations
# Rule of thumb of parallel computing
# the loop runned forward and backwards still gives the same
# result

# The parallel package - parApply  -------------------------------------------
# Moving to parApplly
dd <- data.frame(matrix(rnorm(1000000), ncol = 10000))

# Determine the number of available cores
detectCores()

# Create a cluster via makeCluster
cl <- makeCluster(2)

# Parallelize this code
parApply(cl, dd, 2, median)

# Benchmarking
microbenchmark(apply(dd, 2, median), 
               parApply(cl, dd, 2, median))
# Stop the cluster
stopCluster(cl)

# The parallel package - parSapply  -------------------------------------------
# Bootstrapping
# In a perfect world, we would resample from the population; but we
# can't
# Instead, we assume the original sample is representative of the 
# population 
# 1. Sample with replacement from your data
# 2. Calculate the correlation statistics from your new sample
# 3. Repeat these two steps multiple times
# The distribution of correlation values, gives us a measure of
# uncertainty about the correlation statistic
# To run in parallel...
# 1. Load parallel package
# 2. Create a cluster object using makeCluster()
# 3. Create a function that create a single bootstrap. The function
# has one argument, the data set
# 4. Export function and data set using clusterExport()
# 5. Wrap this function with parSapply and
# 6. Shut down the cluster

# Using parSapply()
play <- function() {
  total <- no_of_rolls <- 0
  while(total < 10) {
    total <- total + sample(1:6, 1)
    
    # If even. Reset to 0
    if(total %% 2 == 0) total <- 0 
    no_of_rolls <- no_of_rolls + 1
  }
  no_of_rolls
}

library("parallel")
# Create a cluster via makeCluster (2 cores)
cl <- makeCluster(2)

# Export the play() function to the cluster
clusterExport(cl, "play")

# Re-write sapply as parSapply
res <- parSapply(cl, 1:100, function(i) play())

# Stop the cluster
stopCluster(cl)

# Timings parSapply()
# Set the number of games to play
no_of_games <- 1e5

## Time serial version
system.time(serial <- sapply(1:no_of_games, function(i) play()))

## Set up cluster
cl <- makeCluster(4)
clusterExport(cl, "play")

## Time parallel version
system.time(par <- parSapply(cl, 1:no_of_games, function(i) play()))

## Stop cluster
stopCluster(cl)
