# --------------------------------------------------- 
# Workimg with Web Data in R - Handling JSON and XML 
# 10 nov 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# JSON  -------------------------------------------
# All JOSON files are made up of only two kinds of structures: objects and arrays.
# Objects are collections of named values. In JSON, an object starts with a left brace
# and ends with a right brace.Then a named value consists of a name in quotes followed
# by a colon, then the value. Name value pairs are separated by a comma. 
# Arrays are an ordered list of values. An array begins with a left bracket and ends 
# with a right bracket, and values are separated by a comma. In both objects and arrays
# a value can be a string in double quotes, a number, 'true', 'false', 'null', or 
# another object or array.
# Parsing JSON
# Load package
library(pageviews)
library(httr)

# Extracting the response

url_json <- "https://en.wikipedia.org/w/api.php?action=query&titles=Hadley%20Wickham&prop=revisions&rvprop=timestamp%7Cuser%7Ccomment%7Ccontent&rvlimit=5&format=json&rvdir=newer&rvstart=2015-01-14T17%3A12%3A45Z&rvsection=0"
url_xml <- "https://en.wikipedia.org/w/api.php?action=query&titles=Hadley%20Wickham&prop=revisions&rvprop=timestamp%7Cuser%7Ccomment%7Ccontent&rvlimit=5&format=xml&rvdir=newer&rvstart=2015-01-14T17%3A12%3A45Z&rvsection=0"

# Make a GET request to url and save the results
pageview_response_json <- GET(url = url_json)
http_type(pageview_response_json)

pageview_response_xml <- GET(url = url_xml)
http_type(pageview_response_xml)

# Save it to disk with saveRDS()
saveRDS(object = pageview_response_json, file = 'Datasets/had_rev_json.rds')
saveRDS(object = pageview_response_xml, file = 'Datasets/had_rev_xml.rds')

# Function rev_history
rev_history <- function(title, format = "json"){
  if (title != "Hadley Wickham") {
    stop('rev_history() only works for `title = "Hadley Wickham"`')
  }
  
  if (format == "json"){
    resp <- readRDS("Datasets/had_rev_json.rds")
  } else if (format == "xml"){
    resp <- readRDS("Datasets/had_rev_xml.rds")
  } else {
    stop('Invalid format supplied, try "json" or "xml"')
  }
  resp  
}
# Get revision history for "Hadley Wickham"
resp_json <- rev_history('Hadley Wickham')

# Check http_type() of resp_json
http_type(resp_json)

# Examine returned text with content()
content(resp_json, as = 'text')

# Parse response with content()
content(resp_json, as = 'parsed')

# Parse returned text with fromJSON()
library(jsonlite)
fromJSON(content(resp_json, as = 'text'))

# Manipulating JSON  -------------------------------------------
# Lists are the natural R object for storing JSON data becaus they can store 
# hierarchical data just like JOSN. fomJSON() will always return a list. 
# Simplifying the output
# If the argument simpifyVector = TRUE, any arrays of just numbers or strings will be 
# converted to vectors.
# If the argument simplifyDataFrame = TRUE arrays of objects become data frames.
# Manipulating parsed JSON
# Load rlist
library(rlist)

# Examine output of this code
str(content(resp_json), max.level = 4)

# Store revision list
revs <- content(resp_json)$query$pages$`41916270`$revisions

# Extract the user element
user_time <- list.select(revs, user, timestamp)

# Print user_time
user_time

# Stack to turn into a data frame
list.stack(user_time)

# Reformatting JSON
# Load dplyr
library(dplyr)

# Pull out revision list
revs <- content(resp_json)$query$pages$`41916270`$revisions

# Extract user and timestamp
revs %>%
  bind_rows() %>%           
  select('user' , "timestamp")

# XML structure  -------------------------------------------
# The structure of an XML file can be divided into markup and content.
# Markup describes the structure of the data, whereas content is the data ifself.
# Most markup is in the form of what are know as tags (<tag>). 
# They generally occur in pairs (<tag> data </tag>).
# A tag can also contain attributes in the form of name value pairs 
# (< name = value>). Usually attributes are reserved to metadata, that is data about
# the data, and content is used for data.
# Examining XLM documents
# Load xml2
library(xml2)

# Get XML revision history
resp_xml <- rev_history("Hadley Wickham", format = "xml")

# Check response is XML 
http_type(resp_xml)

# Examine returned text with content()
rev_text <- content(resp_xml, as = "text")
rev_text

# Turn rev_text into an XML document
rev_xml <- read_xml(rev_text)

# Examine the structure of rev_xml
xml_structure(rev_xml)

# XPATHS  -------------------------------------------
# It looks a bit like file paths because they use forward slashes to specify levels
# in the XML document tree. 
# Extracting XML data
# Find all nodes using XPATH "/api/query/pages/page/revisions/rev"
xml_find_all(rev_xml, "/api/query/pages/page/revisions/rev")

# Find all rev nodes anywhere in document
rev_nodes <- xml_find_all(rev_xml, "//rev")

# Use xml_text() to get text from rev_nodes
xml_text(rev_nodes)

# Extracting XML attributes
# All rev nodes
rev_nodes <- xml_find_all(rev_xml, "//rev")

# The first rev node
first_rev_node <- xml_find_first(rev_xml, "//rev")

# Find all attributes with xml_attrs()
xml_attrs(first_rev_node)

# Find user attribute with xml_attr()
xml_attr(first_rev_node, attr = 'user')

# Find user attribute for all rev nodes
xml_attr(rev_nodes, attr = 'user')

# Find anon attribute for all rev nodes
xml_attr(rev_nodes, 'anon')

# Wrapup: returning nice API output
get_revision_history <- function(article_title){
  # Get raw revision response
  rev_resp <- rev_history(article_title, format = "xml")
  
  # Turn the content() of rev_resp into XML
  rev_xml <- read_xml(content(rev_resp, "text"))
  
  # Find revision nodes
  rev_nodes <- xml_find_all(rev_xml, "//rev")
  
  # Parse out usernames
  user <- xml_attr(rev_nodes, 'user')
  
  # Parse out timestamps
  timestamp <- readr::parse_datetime(xml_attr(rev_nodes, "timestamp"))
  
  # Parse out content
  content <- xml_text(rev_nodes)
  
  # Return data frame 
  data.frame(user = user,
             timestamp = timestamp,
             content = substr(content, 1, 40))
}

# Call function for "Hadley Wickham"
get_revision_history('Hadley Wickham')
