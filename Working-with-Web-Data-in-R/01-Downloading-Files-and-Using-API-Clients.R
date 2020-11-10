# --------------------------------------------------- 
# Working with Web Data in R - Downloading Files and Using API Clients 
# 09 nov 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Introduction: Working with Web Data in R  -------------------------------------------
# Downloading files and reading them into R
# Here are the URLs! As you can see they're just normal strings
csv_url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1561/datasets/chickwts.csv"
tsv_url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_3026/datasets/tsv_data.tsv"

# Read a file in from the CSV URL and assign it to csv_data
csv_data <- read.csv(csv_url)

# Read a file in from the TSV URL and assign it to tsv_data
tsv_data <- read.delim(tsv_url)

# Examine the objects with head()
head(csv_data)
head(tsv_data)

# Saving raw files to disk
# Download the file with download.file()
download.file(url = csv_url, destfile = 'Datasets/feed_data.csv')

# Read it in with read.csv()
csv_data <- read.csv('Datasets/feed_data.csv')

# Saving formatted files to disk
# Add a new column: square_weight
csv_data$square_weight <- csv_data$weight ** 2

# Save it to disk with saveRDS()
saveRDS(object = csv_data, file = 'Datasets/modified_feed_data.RDS')

# Read it back in with readRDS()
modified_feed_data <- readRDS(file = 'Datasets/modified_feed_data.RDS')

# Examine modified_feed_data
str(modified_feed_data)

# Understanding Application Programming Interfaces  -------------------------------------------
# Using API clients
# Load pageviews
library(pageviews)

# Get the pageviews for "Hadley Wickham"
hadley_pageviews <- article_pageviews(project = "en.wikipedia", 'Hadley Wickham')

# Examine the resulting object
str(hadley_pageviews)

# Access Tokens and APIs  -------------------------------------------
# Using access tokens
api_key <- "d8ed66f01da01b0c6a0070d7c1503801993a39c126fbc3382"

# Load birdnik
library(birdnik)

# Get the word frequency for "vector", using api_key to access it
vector_frequency <- word_frequency(key = api_key, words = 'vector')
