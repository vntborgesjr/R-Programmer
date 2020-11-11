# --------------------------------------------------- 
# Working with Web Data in R - CSS Web Scraping and Final Case Study 
# 10 nov 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# CSS web scraping in theory  -------------------------------------------
# Using CSS to scrape nodes
# Hadley Wickham's Wikipedia page
test_url <- "https://en.wikipedia.org/wiki/Hadley_Wickham"

# Read the URL stored as "test_url" with read_html()
test_xml <- read_html(test_url)

# Print test_xml
test_xml

# Select the table elements
html_nodes(test_xml, css = "table")

# Select elements with class = "infobox"
html_nodes(test_xml, css = ".infobox")

# Select elements with id = "firstHeading"
html_nodes(test_xml, css = "#firstHeading")

# Scraping names
# Extract element with class infobox
infobox_element <- html_nodes(test_xml, css = ".infobox")

# Get tag name of infobox_element
element_name <- html_name(infobox_element)

# Print element_name
element_name

# Scraping text
# Extract element with class fn
page_name <- html_node(x = infobox_element, css = ".fn")

# Get contents of page_name
page_title <- html_text(page_name)

# Print page_title
page_title

# Final case study: Introduction  -------------------------------------------
# API calls
# Load httr
library(httr)

# The API url
base_url <- "https://en.wikipedia.org/w/api.php"

# Set query parameters
query_params <- list(action = "parse", 
                        page = "Hadley Wickham", 
                        format = "xml")

# Get data from API
resp <- GET(url = base_url, query = query_params)

# Parse response
resp_xml <- content(resp)

# Extracting information
# Load rvest
library(rvest)

# Read page contents as HTML
page_html <- read_html(xml_text(resp_xml))

# Extract infobox element
infobox_element <- html_node(page_html, css = ".infobox")

# Extract page name element from infobox
page_name <- html_node(infobox_element, css = ".fn")

# Extract page name as text
page_title <- html_text(page_name)

# Normalising information
# Your code from earlier exercises
wiki_table <- html_table(infobox_element)
colnames(wiki_table) <- c("key", "value")
cleaned_table <- subset(wiki_table, !key == "")

# Create a dataframe for full name
name_df <- data.frame(key = "Full name", value = page_title)

# Combine name_df with cleaned_table
wiki_table2 <- rbind(name_df, cleaned_table)

# Print wiki_table
wiki_table2

# Reproducibility
library(httr)
library(rvest)
library(xml2)

get_infobox <- function(title){
  base_url <- "https://en.wikipedia.org/w/api.php"
  
  # Change "Hadley Wickham" to title
  query_params <- list(action = "parse", 
                       page = title, 
                       format = "xml")
  
  resp <- GET(url = base_url, query = query_params)
  resp_xml <- content(resp)
  
  page_html <- read_html(xml_text(resp_xml))
  infobox_element <- html_node(x = page_html, css =".infobox")
  page_name <- html_node(x = infobox_element, css = ".fn")
  page_title <- html_text(page_name)
  
  wiki_table <- html_table(infobox_element)
  colnames(wiki_table) <- c("key", "value")
  cleaned_table <- subset(wiki_table, !wiki_table$key == "")
  name_df <- data.frame(key = "Full name", value = page_title)
  wiki_table <- rbind(name_df, cleaned_table)
  
  wiki_table
}

# Test get_infobox with "Hadley Wickham"
get_infobox(title = "Hadley Wickham")

# Try get_infobox with "Ross Ihaka"
get_infobox(title = "Ross Ihaka")

# Try get_infobox with "Grace Hopper"
get_infobox(title = "Grace Hopper")
