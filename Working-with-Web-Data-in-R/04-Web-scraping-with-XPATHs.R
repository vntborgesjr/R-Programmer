# --------------------------------------------------- 
# Working with Web Data in R - Web scraping with XPATHs 
# 10 nov 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Web scraping 101  -------------------------------------------
# Web scraping consists of grabbing the row HTML of a website and then extracting
# the values from it.
# Load rvest
library(rvest)

# Hadley Wickham's Wikipedia page
test_url <- "https://en.wikipedia.org/wiki/Hadley_Wickham"

# Read the URL stored as "test_url" with read_html()
test_xml <- read_html(test_url)

# Print test_xml
test_xml

# Use html_node() to grab the node with the XPATH stored as `test_node_xpath`
test_node_xpath <- "//*[contains(concat( \" \", @class, \" \" ), concat( \" \", \"vcard\", \" \" ))]"
node <- html_node(x = test_xml, xpath = test_node_xpath)

# Print the first element of the result
node$node

# HTML Structure  -------------------------------------------
# Extracting names
table_element <- node

# Extract the name of table_element
element_name <- html_name(table_element)

# Print the name
element_name

# Extracting values
second_xpath_val <- "//*[contains(concat( \" \", @class, \" \" ), concat( \" \", \"fn\", \" \" ))]"

# Extract the element of table_element referred to by second_xpath_val and store it as page_name
page_name <- html_node(x = table_element, xpath = second_xpath_val)

# Extract the text from page_name
page_title <- html_text(page_name)

# Print page_title
page_title

# Reformatting Data  -------------------------------------------
# Extracting tables
# Turn table_element into a data frame and assign it to wiki_table
wiki_table <- html_table(table_element)

# Print wiki_table
wiki_table

# Cleaning a data frame
# Rename the columns of wiki_table
colnames(wiki_table) <- c("key", "value")

# Remove the empty row from wiki_table
cleaned_table <- subset(wiki_table, !key == "" & !value == "")

# Print cleaned_table
cleaned_table
