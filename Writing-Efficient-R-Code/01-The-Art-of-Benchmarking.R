# --------------------------------------------------- 
# Writing Efficient R Code - The Art of Benchmarking 
# 09 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# R version
# Print the R version details using version
version

# Assign the variable major to the major component
major <- version$major

# Assign the variable minor to the minor component
minor <- version$minor

# Benchmarking  -------------------------------------------
# Compare runtime of an existing solution with one or more 
# alternatives
# 1. Construct a function around the feture we wish to benchmark
# 2. Time the function under different scenarios with system.time()
# function
# output:
# user time is the CPU time charged for the execution of user instructions
# system time is the CPU time charged for execution by the system
# on behalf of the calling process
# elapsed time is appromoximately the sum of user and system, the number
# we care about
# Microbenchmark package - compares functions with microbenchmark()
# function

# Comparing read times of CSV and RDS files
# How long does it take to read movies from CSV?
system.time(read.csv("Datasets/movies.csv"))

# How long does it take to read movies from RDS?
system.time(readRDS("Datasets/movies.rds"))

# Elapsed time
# Load the microbenchmark package
library(microbenchmark)

# Compare the two functions
compare <- microbenchmark(read.csv("Datasets/movies.csv"), 
                             readRDS("Datasets/movies.rds"), 
                             times = 10)

# Print compare
compare

# How good is your machine?  -------------------------------------------
# My hardware
# Load the benchmarkme package
library(benchmarkme)

# Assign the variable ram to the amount of RAM on this machine
ram <- get_ram()
ram

# Assign the variable cpu to the cpu specs
cpu <- get_cpu()
cpu

# Benchmark DataCamp's machine
# Load the package
library("benchmarkme")

# Run the io benchmark
res <- benchmark_io(runs = 1, size = 50)

# Plot the results
plot(res)
