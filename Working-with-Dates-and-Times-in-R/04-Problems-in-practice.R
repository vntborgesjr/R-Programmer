# --------------------------------------------------- 
# Working with Dates and Times in R - Problems in practice
# 22 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Time zones  -------------------------------------------
# Setting the timezone
library(lubridate)

# Game2: CAN vs NZL in Edmonton
game2 <- mdy_hm("June 11 2015 19:00")

# Game3: CHN vs NZL in Winnipeg
game3 <- mdy_hm("June 15 2015 18:30")

# Set the timezone to "America/Edmonton"
game2_local <- force_tz(game2, tzone = "America/Edmonton")
game2_local

# Set the timezone to "America/Winnipeg"
game3_local <- force_tz(game3, tzone = "America/Winnipeg")
game3_local

# How long does the team have to rest?
as.period(game2_local %--% game3_local)

# Viewing in a timezone
# What time is game2_local in NZ?
with_tz(game2_local, tzone = "Pacific/Auckland")

# What time is game2_local in Corvallis, Oregon?
with_tz(game2_local, tzone = "America/Los_Angeles")

# What time is game3_local in NZ?
with_tz(game3_local, tzone = "Pacific/Auckland")

# Timezones in the weather data
# Import hourly weather data
library(lubridate)
library(readr)
library(dplyr)
library(ggplot2)

# Import "akl_weather_hourly_2016.csv"
akl_hourly_raw <- read_csv("Datasets/akl_weather_hourly_2016.csv")

# Print akl_hourly_raw
akl_hourly_raw

# Use make_date() to combine year, month and mday 
akl_hourly  <- akl_hourly_raw  %>% 
  mutate(date = make_date(year = year, month = month, day = mday))

# Parse datetime_string 
akl_hourly <- akl_hourly  %>% 
  mutate(
    datetime_string = paste(date, time, sep = "T"),
    datetime = ymd_hms(datetime_string)
  )

tibble::glimpse(akl_hourly)

# Examine datetime and date_utc columns
head(akl_hourly$datetime)
head(akl_hourly$date_utc)

# Force datetime to Pacific/Auckland
akl_hourly <- akl_hourly %>%
  mutate(
    datetime = force_tz(datetime, tzone = "Pacific/Auckland"))

# Reexamine datetime
head(akl_hourly$datetime)

# Are datetime and date_utc the same moments
table(akl_hourly$datetime - akl_hourly$date_utc)

# Times without dates
library(hms)

# Import auckland hourly data 
akl_hourly <- read_csv("Datasets/akl_weather_hourly_2016.csv")

# Examine structure of time column
str(akl_hourly$time)

# Examine head of time column
head(akl_hourly$time)

# A plot using just time
ggplot(akl_hourly, aes(x = time, y = temperature)) +
  geom_line(aes(group = make_date(year, month, mday)), alpha = 0.2)

# More on importing and exporting datetimes ------------------------------------------------
dates <- akl_hourly$datetime_string

# Fast parsing with fasttime
library(microbenchmark)
library(fasttime)

# Examine structure of dates
str(dates)

# Use fastPOSIXct() to parse dates
fastPOSIXct(dates) %>% str()

# Compare speed of fastPOSIXct() to ymd_hms()
microbenchmark(
  ymd_hms = ymd_hms(dates),
  fasttime = fastPOSIXct(dates),
  times = 20)

# Fast parsing with lubridate::fast_strptime
# Head of dates
head(dates)

# Parse dates with fast_strptime
fast_strptime(dates, 
              format = "%Y-%m-%dT%H:%M:%S") %>% str()

# Comparse speed to ymd_hms() and fasttime
microbenchmark(
  ymd_hms = ymd_hms(dates),
  fasttime = fastPOSIXct(dates),
  fast_strptime = fast_strptime(dates, 
                                format = "%Y-%m-%dT%H:%M:%S"),
  times = 20)

# Outputting pretty dates and times
finished <- "I finished 'Dates and Times in R' on Thursday, September 4, 2017!"

# Create a stamp based on "Saturday, Jan 1, 2000"
date_stamp <- stamp("Saturday, Jan 1, 2000")

# Print date_stamp
date_stamp

# Call date_stamp on today()
date_stamp(today())

# Create and call a stamp based on "12/31/1999"
stamp("12/31/1999")(today())

# Use string finished for stamp()
stamp(finished)(today())
