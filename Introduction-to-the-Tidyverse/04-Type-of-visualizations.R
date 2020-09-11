# -------------------------------------------------
# Introduction to Tidyverse - Type of visualizations
# 08 set 2020
# VNTBJR
# ------------------------------------------------
# 
# Load packages ------------------------------------------------

library(gapminder)
library(dplyr)
library(ggplot2)

# Line plots ------------------------------------------------

year_continent <- gapminder %>% 
  group_by(year, continent) %>% 
  summarize(meanLifeExp = mean(lifeExp))

ggplot(year_continent, aes(x = year, y = meanLifeExp, color = continent)) +
  geom_line() + 
  expand_limits(y = 0)

# Visualizing median GDP per capta over time ------------------------------------------------

by_year <- gapminder %>% 
  group_by(year) %>% 
  summarize(medianGdpPercap = median(gdpPercap))

ggplot(by_year, aes(x = year, y = medianGdpPercap)) +
  geom_line() +
  expand_limits(y = 0)

# Visualizing median GDP per capita by continent over time ------------------------------------------------

by_year_continent <- gapminder %>% 
  group_by(year, continent) %>% 
  summarize(medianGdpPercap = median(gdpPercap))

ggplot(by_year_continent, aes(x = year, y = medianGdpPercap, color = continent)) +
  geom_line() + 
  expand_limits(y = 0)

# Bar plots ------------------------------------------------

by_continent <- gapminder %>% 
  filter(year ==2007) %>% 
  group_by(continent) %>% 
  summarize(meanLifeExp = mean(lifeExp))

by_continent

ggplot(by_continent, aes(x = continent, y = meanLifeExp)) +
  geom_col()

# Visualizing median GDP per capita by continent ------------------------------------------------

by_continent <- gapminder %>% 
  filter(year == 1952) %>% 
  group_by(continent) %>% 
  summarize(medianGdpPercap = median(gdpPercap))

ggplot(by_continent, aes(x = continent, y = medianGdpPercap)) +
  geom_col()

# Visualizing GDP per caipta by country in Oceania ------------------------------------------------

oceania_1952 <- gapminder %>% 
  filter(continent == "Oceania", year == 1952)

ggplot(oceania_1952, aes(x = country, y = gdpPercap)) +
  geom_col()

# Histograms ------------------------------------------------

ggplot(gapminder_2007, aes(x = lifeExp)) + 
  geom_histogram()

ggplot(gapminder_2007, aes(x = lifeExp)) + 
  geom_histogram(binwidth = 5)

# Visualizing population ------------------------------------------------

gapminder_1952 <- gapminder %>% 
  filter(year == 1952) %>% 
  mutate(pop_by_mil = pop / 1000000)

ggplot(gapminder_1952, aes(x = pop_by_mil)) +
  geom_histogram(bins = 50)

# Visualizing population with x-axis on a log scale ------------------------------------------------

gapminder_1952 <- gapminder %>% 
  filter(year == 1952)

ggplot(gapminder_1952, aes(x = pop)) +
  geom_histogram() +
  scale_x_log10()

# Boxplot ------------------------------------------------

ggplot(gapminder_2007, aes(x = continent, y = lifeExp)) +
  geom_boxplot()

# Comparing GDP per capita across continents ------------------------------------------------

gapminder_1952 <- gapminder %>% 
  filter(year == 1952)

ggplot(gapminder_1952, aes(x = continent, y = gdpPercap)) +
  geom_boxplot() +
  scale_y_log10()

# Adding a title to your graph ------------------------------------------------

ggplot(gapminder_1952, aes(x = continent, y = gdpPercap)) +
  geom_boxplot() +
  scale_y_log10() +
  ggtitle(label = "Comparing GDP per capita across continents")

