# --------------------------------------------------- 
# Working with Dates and Times in R - Arithmetic with Dates and Times
# 22 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Taking differences of datetimes -------------------------------------------------
# How long has it been?
library(lubridate)

# The date of landing and moment of step
date_landing <- mdy("July 20, 1969")
moment_step <- mdy_hms("July 20, 1969, 02:56:15", tz = "UTC")

# How many days since the first man on the moon?
difftime(today(), date_landing, units = "days")

# How many seconds since the first man on the moon?
difftime(now(), moment_step, units = "secs")

# How many seconds are in a day?
# Three dates
mar_11 <- ymd_hms("2017-03-11 12:00:00", 
                  tz = "America/Los_Angeles")
mar_12 <- ymd_hms("2017-03-12 12:00:00", 
                  tz = "America/Los_Angeles")
mar_13 <- ymd_hms("2017-03-13 12:00:00", 
                  tz = "America/Los_Angeles")

# Difference between mar_13 and mar_12 in seconds
difftime(mar_13, mar_12, units = "secs")

# Difference between mar_12 and mar_11 in seconds
difftime(mar_12, mar_11, units = "secs")

# Time spans  -------------------------------------------
# Adding or subtracting a time span to a datetime
mar_11 + days(1)
mar_11 + ddays(1)

# Add a period of one week to mon_2pm
mon_2pm <- dmy_hm("27 Aug 2018 14:00")
mon_2pm + weeks(1)

# Add a duration of 81 hours to tue_9am
tue_9am <- dmy_hm("28 Aug 2018 9:00")
tue_9am + dhours(81)

# Subtract a period of five years from today()
today() - years(5)

# Subtract a duration of five years from today()
today() - dyears(5)

# Arithmetic with timespans
# Time of North American Eclipse 2017
eclipse_2017 <- ymd_hms("2017-08-21 18:26:40")

# Duration of 29 days, 12 hours, 44 mins and 3 secs
synodic <- ddays(29) + dhours(12) + dminutes(44) + dseconds(3)

# 223 synodic months
saros <- 223 * synodic

# Add saros to eclipse_2017
eclipse_2017 + saros

# Generating sequences of datetimes
1:10 * days(1) # generate a sequence of periods from 1 day up to 10 days
today() +1:10 * days(1) # sequence of datetimes from 1 day up to 10 days in the future

# Add a period of 8 hours to today
today_8am <- today() + hours(8)

# Sequence of two weeks from 1 to 26
every_two_weeks <- 1:26 * weeks(2)

# Create datetime for every two weeks for a year
today_8am + every_two_weeks

# The tricky thing about months
jan_31 <- ymd("2018-01-31")
ymd("2018-01-31") + months(1)
ymd("2018-01-31") %m+% months(1)

# A sequence of 1 to 12 periods of 1 month
month_seq <- 1:12 * months(1)

# Add 1 to 12 months to jan_31
jan_31 + month_seq

# Replace + with %m+%
jan_31 %m+% month_seq

# Replace + with %m-%
jan_31 %m-% month_seq

# Intervals  -------------------------------------------
# Which kind of time span should I use?
# Use Intervals when you have a start and end
# Use Periods when you are interested in human units
# Use Durations if you are interested in sseconds elapsed

# Examining intervals. Reigns of kings and queens
# Print monarchs


# Create an interval for reign
# Print monarchs
monarchs

# Create an interval for reign
monarchs <- monarchs %>%
  mutate(reign = from %--% to) 

# Find the length of reign, and arrange
monarchs %>%
  mutate(length = int_length(reign)) %>% 
  arrange(desc(length)) %>%
  select(name, length, dominion)

# Comparing intervals and datetimes
# Print halleys
halleys

# New column for interval from start to end date
halleys <- halleys %>% 
  mutate(visible = start_date %--% end_date)

# The visitation of 1066
halleys_1066 <- halleys[14, ] 

# Monarchs in power on perihelion date
monarchs %>% 
  filter(halleys_1066$perihelion_date %within% reign) %>%
  select(name, from, to, dominion)

# Monarchs whose reign overlaps visible time
monarchs %>% 
  filter(int_overlaps(halleys_1066$visible, reign)) %>%
  select(name, from, to, dominion)

# Converting to durations and periods
# New columns for duration and period
monarchs <- monarchs %>%
  mutate(
    duration = as.duration(reign),
    period = as.period(reign)) 

# Examine results    
monarchs %>%
  select(name, duration, period)