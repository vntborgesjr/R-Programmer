# -------------------------------------------------
# Introduction to Tidyverse - Data visualization
# 08 set 2020
# VNTBJR
# ------------------------------------------------
# 
# Load packages ------------------------------------------------

library(gapminder)
library(dplyr)
library(ggplot2)

# Variable assignment ------------------------------------------------

gapminder_2007 <- gapminder %>% 
  filter(year == 2007)
gapminder_2007

# Visualizing with ggplot2 ------------------------------------------------

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

# Log scale ------------------------------------------------

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp)) +
  geom_point() +
  scale_x_log10()

# Additional variables - the color aesthetic ------------------------------------------------

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point() +
  scale_x_log10()

# Additional variables - the size aesthetic ------------------------------------------------

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp, color = continent, size = pop)) +
  geom_point() +
  scale_x_log10()

# Faceting by continent ------------------------------------------------

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp)) +
  geom_point() +
  scale_x_log10() + 
  facet_wrap(~ continent)

# Faceting by year ------------------------------------------------

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, color = continent, size = pop)) +
  geom_point() +
  scale_x_log10() + 
  facet_wrap(~ year)

# Create gapminder_1952 ------------------------------------------------

gapminder_1952 <- gapminder %>% 
  filter(year == 1952)

# Comparing populaion and GDP per capita ------------------------------------------------

ggplot(gapminder_1952, aes(x = pop, y = gdpPercap)) +
  geom_point()

# Comparing population and life expectancy ------------------------------------------------

ggplot(gapminder_1952, aes(x= pop, y = lifeExp)) +
  geom_point()

# Putting the x-axis on a log scale ------------------------------------------------

ggplot(gapminder_1952, aes(x = pop, y = lifeExp)) + 
  geom_point() +
  scale_x_log10()

# Putting the x- and y-axes on a log scale ------------------------------------------------

ggplot(gapminder_1952, aes(x = pop, y = gdpPercap)) + 
  geom_point() +
  scale_x_log10() +
  scale_y_log10()

# Assing color to a scatter plot ------------------------------------------------

ggplot(gapminder_1952, aes(x = pop, y = lifeExp, color = continent)) +
  geom_point() + 
  scale_x_log10()

# Adding size and color ------------------------------------------------

ggplot(gapminder_1952, aes(x = pop, y = lifeExp, color = continent, size = gdpPercap)) +
  geom_point() + 
  scale_x_log10()

# Creating a subgraph fpr each continent ------------------------------------------------

ggplot(gapminder_1952, aes(x = pop, y = lifeExp)) +
  geom_point() +
  scale_x_log10() +
  facet_wrap(~ continent)

# Faceting by year ------------------------------------------------

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, color = continent, size = pop)) +
  geom_point() +
  scale_x_log10() +
  facet_wrap(~ year)
