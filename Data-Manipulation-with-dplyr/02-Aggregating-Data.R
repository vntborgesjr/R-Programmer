# --------------------------------------------------- 
# Data Manipulation with dplyr - Aggregating Data
# 20 set 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# The count verb  -------------------------------------------
# Counting by region
counties_selected <- counties %>% 
  select(region, state, population, citizens)

# Use count to find the number of counties in each region
counties_selected %>%
  count(region, sort = TRUE)

# Find number of counties per state, weighted by citizens
counties_selected %>%
  count(state, wt = citizens, sort = TRUE)

# Mutating and counting
counties_selected <- counties %>% 
  select(region, state, population, walk)

counties_selected %>%
  # Add population_walk containing the total number of people who walk 
  # to work 
  mutate(population_walk = walk * population / 100) %>% 
  # Count weighted by the new column
  count(state, wt = population_walk, sort = TRUE)
   
######################################################################
# The group_by, summarize and ungroup verbs  -------------------------------------------
# Summarizing
counties_selected <- counties %>% 
  select(county, population, income, unemployment)

# Summarize to find minimum population, maximum unemployment, and average income
counties_selected %>%
  summarize(min_poputlation = min(population), 
            max_unemployment = max(unemployment),
            average_income = mean(income))
  
# Summarizing by state
counties_selected <- counties %>% 
  select(state, county, population, land_area)

# Group by state and find the total area and population
counties_selected %>%
  group_by(state) %>% 
  summarize(total_area = sum(land_area), total_population = sum(population))
  
# Add a density column, then sort in descending order
counties_selected %>%
  group_by(state) %>%
  summarize(total_area = sum(land_area),
            total_population = sum(population), 
            density = total_population / total_area) %>%
  arrange(desc(density))
  
# Summarize by state and region
counties_selected <- counties %>% 
  select(region, state, county, population)

# Summarize to find the total population
counties_selected %>%
  group_by(region, state) %>% 
  summarize(total_pop = sum(population))

# Calculate the average_pop and median_pop columns 
counties_selected %>%
  group_by(region, state) %>%
  summarize(total_pop = sum(population)) %>%
  
# Calculate the average_pop and median_pop columns 
counties_selected %>%
  group_by(region, state) %>%
  summarize(total_pop = sum(population)) %>%  
  summarise(average_pop = mean(total_pop), 
            median_pop = median(total_pop))
 
######################################################################
