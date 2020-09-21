# --------------------------------------------------- 
# Data Manipulation with dplyr - Case Study: The babynames Dataset 
# 21 set 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Load packages
library(dplyr)
library(ggplot2)

# Load data
babynames <- readRDS("Datasets/babynames.rds")

# The babynames data  -------------------------------------------
glimpse(babynames)

# Filtering and arranging for one year
babynames %>%
  # Filter for the year 1990
  filter(year == 1990) %>% 
  # Sort the number column in descending order 
  arrange(desc(number))

# Using top_n with babynames
# Find the most common name in each year
babynames %>%
  group_by(year) %>% 
  top_n(1, number)

# Visualizing names with ggplot2
# Filter for the names Steven, Thomas, and Matthew 
selected_names <- babynames %>%
  filter(name %in% c("Steven", "Thomas", "Matthew"))

# Plot the names using a different color for each name
ggplot(selected_names, aes(x = year, y = number, color = name)) +
  geom_line()
 
######################################################################
# Grouped mutates  -------------------------------------------
# Finding the year each name is most common
# Calculate the fraction of people born each year with the same name
babynames %>%
  group_by(year) %>%
  mutate(year_total = sum(number)) %>%
  ungroup() %>%
  mutate(fraction = number / year_total) %>% 
# Find the year each name is most common
group_by(name) %>%
  top_n(1, fraction)

# Adding the total and maximum fir each name
# Add columns name_total and name_max for each name
names_normalized <- babynames %>%
  group_by(name) %>% 
  mutate(name_total = sum(number),
         name_max = max(number)) %>%
  # Ungroup the table 
  ungroup() %>% 
  # Add the fraction_max column containing the number by the name maximum 
  mutate(fraction_max = number / name_max)

# Visualizing the normalized change in popularity
# Filter for the names Steven, Thomas, and Matthew
names_filtered <- names_normalized %>%
  filter(name %in% c("Steven", "Thomas", "Matthew"))
  
# Visualize these names over time
ggplot(names_filtered, aes(x = year, y = fraction_max, color = name)) + 
  geom_line()
 
######################################################################
# Window functions  -------------------------------------------
# Using ratios to describe the frequency of a name
babynames_fraction <- babynames %>%
  group_by(year) %>%
  mutate(year_total = sum(number)) %>%
  ungroup() %>%
  mutate(fraction = number / year_total)

babynames_fraction %>%
  # Arrange the data in order of name, then year 
  arrange(name, year) %>% 
  # Group the data by name
  group_by(name) %>% 
  # Add a ratio column that contains the ratio between each year 
  mutate(ratio = fraction / lag(fraction))

# Biggest jumps in a name
babynames_ratios_filtered <- babynames_fraction %>%
  arrange(name, year) %>%
  group_by(name) %>%
  mutate(ratio = fraction / lag(fraction)) %>%
  filter(fraction >= 0.00001)

babynames_ratios_filtered %>%
  # Extract the largest ratio from each name 
  group_by(year) %>%
  filter(ratio == max(ratio)) %>% 
  # Sort the ratio column in descending order 
  top_n(1, ratio) %>% 
  # Filter for fractions greater than or equal to 0.001
  filter(fraction >= 0.001)
