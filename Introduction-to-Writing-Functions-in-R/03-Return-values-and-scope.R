# --------------------------------------------------- 
# Introduction to Writing Functions in R - Return values and scope 
# 11 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Returning values from functions  -------------------------------------------
# Reasons for returning early
# 1. You already know the answer
# 2. The input is an edge case

# Returning early
is_leap_year <- function(year) {
  # If year is div. by 400 return TRUE
  if(year %% 400 == 0) {
    return(TRUE)
  }
  # If year is div. by 100 return FALSE
  if(year %% 100 == 0) {
    return(FALSE)
  }  
  # If year is div. by 4 return TRUE
  if(year %% 4 == 0) {
    return(TRUE)
  } else {
    # Otherwise return FALSE
    return(FALSE)  
  }
  
}

# Returning invisible
# Using cars, draw a scatter plot of dist vs. speed
plt_dist_vs_speed <- plot(dist ~ speed, data = cars)

# Oh no! The plot object is NULL
plt_dist_vs_speed

# Define a pipeable plot fn with data and formula args
pipeable_plot <- function(data, formula) {
  # Call plot() with the formula interface
  plot(formula, data)
  # Invisibly return the input dataset
  invisible(data)
}

# Draw the scatter plot of dist vs. speed again
plt_dist_vs_speed <- cars %>% 
  pipeable_plot(dist ~ speed)

# Now the plot object has a value
plt_dist_vs_speed

# Returning multiple values from functions  -------------------------------------------
# 1. Using lists
# Multi-assignment using zeallot package's multi-assignment operator.
# In Python, this is called unpacking variables
# library(zeallot)
# c(vrsn, os, pkgs) %<-% session()
# 2. Using attributes

# Returning many things
library(broom)
library(zeallot)

# Look at the structure of model (it's a mess!)
str(model)

# Use broom tools to get a list of 3 data frames
list(
  # Get model-level values
  model = glance(model),
  # Get coefficient-level values
  coefficients = tidy(model),
  # Get observation-level values
  observations = augment(model)
)

# Wrap this code into a function, groom_model
groom_model <- function(model) {
  list(
    model = glance(model),
    coefficients = tidy(model),
    observations = augment(model)
  )
}

# Call groom_model on model, assigning to 3 variables
c(mdl, cff, obs) %<-% groom_model(model)

# See these individual variables
mdl; cff; obs

# Returning metadata
pipeable_plot <- function(data, formula) {
  plot(formula, data)
  # Add a "formula" attribute to data
  attr(data, "formula") <- formula
  invisible(data)
}

# From previous exercise
plt_dist_vs_speed <- cars %>% 
  pipeable_plot(dist ~ speed)

# Examine the structure of the result
str(plt_dist_vs_speed)

# Environments  -------------------------------------------
# Creating and exploring environments
capitals <- tibble(data.frame(city = c("Cape Town", "Bloemfontein", "Pretoria"),
                              type_of_capital = c("Legislative", "Judicial", "Admnistrative")))
national_parks <- c("Addo Elephant National Park",
                    "Agulhas National Park",
                    "Ai-Ais/Richtersveld Transfrontier Park",
                    "Augrabies Falls National Park",
                    "Bontebok National Park", 
                    "Camdeboo National Park",
                    "Golden Gate Highlands National Park",
                    "Hluhluwe–Imfolozi Park",
                    "Karoo National Park",
                    "Kgalagadi Transfrontier Park",
                    "Knysna National Lake Area",
                    "Kruger National Park",
                    "Mapungubwe National Park",
                    "Marakele National Park",
                    "Mokala National Park",
                    "Mountain Zebra National Park",
                    "Namaqua National Park",
                    "Table Mountain National Park",
                    "Tankwa Karoo National Park",
                    "Tsitsikamma National Park",
                    "West Coast National Park",
                    "Wilderness National Park" )
population <- ts(c(40583573, 44819778, 47390900, 51770560, 55908900), 
   data = c(1996, 2001, 2006, 2011, 2016), start = 1996, end = 2016,
   frequency = 0.2)

# Add capitals, national_parks, & population to a named list
rsa_lst <- list(
  capitals = capitals,
  national_parks = national_parks,
  population = population
)

# List the structure of each element of rsa_lst
ls.str(rsa_lst)

# Convert the list to an environment
rsa_env <- list2env(rsa_lst)

# List the structure of each variable
ls.str(rsa_env)

# Find the parent environment of rsa_env
parent <- parent.env(rsa_env)

# Print its name
environmentName(parent)

# Do variables exist?
# Compare the contents of the global environment and rsa_env
ls.str(globalenv())
ls.str(rsa_env)

# Does population exist in rsa_env?
exists("population", envir = rsa_env)

# Does population exist in rsa_env, ignoring inheritance?
exists("population", envir = rsa_env, inherits = FALSE)

# Scope and precedence  -------------------------------------------
