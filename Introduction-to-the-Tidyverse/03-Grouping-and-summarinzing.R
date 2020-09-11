# -------------------------------------------------
# Introduction to Tidyverse - Grouping and summarizing
# 08 set 2020
# VNTBJR
# ------------------------------------------------
# 
# Load packages ------------------------------------------------

library(gapminder)
library(dplyr)
library(ggplot2)

# Extracting data ------------------------------------------------

gapminder %>% 
  filter(year == 2007)

# The summarize verb ------------------------------------------------

gapminder %>% 
  summarize(meanLifeExp = mean(lifeExp))

# Summarizing one year ------------------------------------------------

gapminder %>% 
  filter(year == 2007) %>% 
  summarize(meanLifeExp = mean(lifeExp))

# Summarizing into multiple columns ------------------------------------------------

gapminder %>% 
  filter(year == 2007) %>% 
  summarize(meanLifeExp = mean(lifeExp), 
            totalPop = sum(pop))

# Summarizing the median life expectancy ------------------------------------------------


# Summarizing the median life expectancy in 1957 ------------------------------------------------

gapminder %>% 
  filter(year == 1957) %>% 
  summarize(medianLifeExp = median(lifeExp))

# Summarizing multiple variables in 1957 ------------------------------------------------

gapminder %>% 
  filter(year == 1957) %>% 
  summarize(medianLifeExp = median(lifeExp), maxGdpPercap = max(gdpPercap))

# The group_by verb ------------------------------------------------

gapminder %>% 
  group_by(year) %>% 
  summarize(meanLifeExp = mean(lifeExp), totalPop = sum(pop))

# Summarizing by continent ------------------------------------------------

gapminder %>% 
  filter(year == 2007) %>% 
  group_by(continent) %>% 
             summarize(meanLifeExp = mean(lifeExp),
                       totalPop = sum(pop))

# Summarizing by continent and year ------------------------------------------------

gapminder %>% 
  group_by(year, continent) %>% 
  summarize(meanLifeExp = mean(lifeExp),
            totalPop = sum(pop))

# Summarizing by year ------------------------------------------------

gapminder %>% 
  group_by(year) %>% 
  summarize(medianLifeExp = median(lifeExp), 
            maxGdpPercap = max(gdpPercap))

# Summarizing by continent ------------------------------------------------

gapminder %>% 
  filter(year == 1957) %>% 
  group_by(continent) %>% 
  summarize(medianLifeExp = median(lifeExp), 
            maxGdpPercap = max(gdpPercap))

# Summarizing by continent and year ------------------------------------------------

gapminder %>% 
  group_by(continent, year) %>% 
  summarize(medianLifeExp = median(lifeExp),
            maxGdpPercap = max(gdpPercap))

# Visualizing summarized data ------------------------------------------------

by_year <- gapminder %>% 
  group_by(year) %>% 
  summarize(totalPop = sum(pop),
            meanLifeExp = mean(lifeExp))

by_year

# Visualizing poputlation iver time ------------------------------------------------

ggplot(by_year, aes(x = year, y = totalPop)) +
  geom_point() +
  expand_limits(y = 0)

# Summarizing by year and continent ------------------------------------------------

by_year_continent <- gapminder %>% 
  group_by(year, continent) %>% 
  summarize(totalPop = sum(pop),
            meanLifeExp = mean(lifeExp))

by_year_continent

# Visualizing population by year and continent ------------------------------------------------

ggplot(by_year_continent, aes(x = year, y = totalPop, color = continent)) +
  geom_point() +
  expand_limits(y = 0)

# Visualizing median life expectancy over time ------------------------------------------------

by_year <- gapminder %>%
  group_by(year) %>%
  summarize(medianLifeExp = median(lifeExp),
            maxGdpPercap = max(gdpPercap))

ggplot(by_year, aes(x = year, y = medianLifeExp)) +
  geom_point() + 
  expand_limits(y = 0)

# Visualizing median GDP per capta per continent over time ------------------------------------------------

by_year_continent <- gapminder %>% 
  group_by(continent, year) %>% 
  summarize(medianGdpPercap = median(gdpPercap))

ggplot(by_year_continent, aes(x = year, y = medianGdpPercap, color = continent)) +
  geom_point() +
  expand_limits(y = 0)

# Comparing median life expectancy and median GDP per continent in 2007 ------------------------------------------------

by_continent_2007 <-  gapminder %>% 
  filter(year == 2007) %>% 
  group_by(continent) %>% 
  summarize(medianLifeExp = median(lifeExp),
            medianGdpPercap = median(gdpPercap))

ggplot(by_continent_2007, aes(x = medianGdpPercap, 
                              y = medianLifeExp, 
                              color = continent)) + 
  geom_point() +
  expand_limits(y = 0)
