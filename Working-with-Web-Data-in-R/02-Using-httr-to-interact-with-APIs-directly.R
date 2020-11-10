# --------------------------------------------------- 
# Working with Web Data in R - Using httr to interact with APIs directly 
# 09 nov 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# GET and POST requests in theory  -------------------------------------------
# GET requests in practice
# Load the httr package
library(httr)

# Make a GET request to http://httpbin.org/get
get_result <- GET('http://httpbin.org/get')

# Print it to inspect it
print(get_result)

# POST requests in practice
# Load the httr package
library(httr)

# Make a POST request to http://httpbin.org/post with the body "this is a test"
post_result <- POST(url = 'http://httpbin.org/post', body = 'this is a test')

# Print it to inspect it
post_result

# Extracting the response
url <- "https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia.org/all-access/all-agents/Hadley_Wickham/daily/20170101/20170102"

# Make a GET request to url and save the results
pageview_response <- GET(url = url)

# Call content() to retrieve the data the server sent back
pageview_data <- content(pageview_response)

# Examine the results with str()
str(pageview_data)

# Graceful httr  -------------------------------------------
# Handling http failures
fake_url <- "http://google.com/fakepagethatdoesnotexist"

# Make the GET request
request_result <- GET(fake_url)

# Check request_result
if(http_error(request_result)){
  warning('The request failed')
} else {
  content(request_result)
}

# Constructing queries (Part I)
# Construct a directory-based API URL to `http://swapi.co/api`,
# looking for person `1` in `people`
directory_url <- paste('http://swapi.co/api', "people", '1', sep = '/')

# Make a GET call with it
result <- GET(directory_url)

# Constructing queries (Part II)
# Create list with nationality and country elements
query_params <- list(nationality = 'americans', 
                     country = 'antigua')

# Make parameter-based call to httpbin, with query_params
parameter_response <- GET('https://httpbin.org/get', query = query_params)

# Print parameter_response
print(parameter_response)

# Respectful API usage  -------------------------------------------
# Using user agents
# Do not change the url
url <- "https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/all-agents/Aaron_Halfaker/daily/2015100100/2015103100"

# Add the email address and the test sentence inside user_agent()
server_response <- GET(url, user_agent('my@email.address this is a test'))

# Rate-limiting
# Construct a vector of 2 URLs
urls <- c('http://httpbin.org/status/404',
          'http://httpbin.org/status/301')

for(url in urls){
  # Send a GET request to url
  result <- GET(url = url)
  # Delay for 5 seconds between requests
  Sys.sleep(time = 5)
}

# Tying it all together
get_pageviews <- function(article_title){
  url <- paste(
    "https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/all-agents", 
    article_title, 
    "daily/2015100100/2015103100", 
    sep = "/"
  ) 
  
  # Get the webpage  
  response <- GET(url, config = user_agent("my@email.com this is a test")) 

  # Is there an HTTP error?
  if(http_error(response)){ 
  # Throw an R error
  stop("the request failed") 
  } 
  
  # Return the response's content
  content(response)
}
