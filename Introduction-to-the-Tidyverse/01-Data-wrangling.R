# -------------------------------------------------
# Introduction to Tidyverse - Data wrangling
# 07 set 2020
# VNTBJR
# ------------------------------------------------
# 
# Load packages ------------------------------------------------

library(gapminder)
library(dplyr)

# Look at the gapminder dataset ------------------------------------------------

gapminder

# Filtering data ------------------------------------------------

gapminder %>% 
  filter(year == 2007)

gapminder %>% 
  filter(country == 'United States')

gapminder %>%
  filter(year == 2007, country == 'United States')

# Filter the gapminder dataset for the year 1957 ------------------------------------------------

gapminder %>%
  filter(year == 1957)

# Filter for China in 2002 ------------------------------------------------

gapminder %>% 
  filter(country == 'China', year == 2002)

# Arrange data in ascending order ------------------------------------------------

gapminder %>% 
  arrange(gdpPercap)

# Arrange data in descending order ------------------------------------------------

gapminder %>% 
  arrange(desc(gdpPercap))

# Filter and arrange ------------------------------------------------

gapminder %>% 
  filter(year == 2007) %>% 
  arrange(desc(gdpPercap))

# Sort in ascending order lifeExp ------------------------------------------------

gapminder %>% 
  arrange(lifeExp)

# Sort in descending order of lifeExp ------------------------------------------------

gapminder %>% 
  arrange(desc(lifeExp))

# Filter for the year 1957, then arrange in descending order of population ------------------------------------------------

gapminder %>% 
  filter(year == 1957) %>% 
  arrange(desc(pop)) 

# Change a variable ------------------------------------------------

gapminder %>% 
  mutate(por = pop / 1000000)

# Add a new variable ------------------------------------------------

gapminder %>% 
  mutate(gdp = gdpPercap * pop)

# Combining verbs ------------------------------------------------

gapminder %>% 
  mutate(gdp = gdpPercap * pop) %>% 
  filter(year == 2007) %>% 
  arrange(desc(gdp))

# Change lifeExp to be in months ------------------------------------------------

gapminder %>% 
  mutate(lifeExp = lifeExp * 12)

# Create a new colunm called lifeExpMonths ------------------------------------------------

gapminder %>% 
  mutate(lifeExpMonths = lifeExp * 12)

# Combine filter, mutate, and arrange to find the countries with the highest life expectancy, in months, in the year 2007------------------------------------------------

gapminder %>% 
  filter(year == 2007) %>% 
  mutate(lifeExpMonths = lifeExp * 12) %>% 
  arrange(desc(lifeExpMonths))
