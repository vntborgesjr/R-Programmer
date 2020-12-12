# --------------------------------------------------- 
# String Manipulation with stringr in R - String basics 
# 12 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Escape sequences  -------------------------------------------
# Back slash (\) means scape. So to scape a double quote (") inside a 
# string you should use \". This is called an escape sequence.
# Atention! If you need a backslash in your string you'll need the 
# sequence \\ .
# Here are some scape sequences:
# \n gives a new line;
# \U followed by 8 hex digits sequences denotes a particular Unicode
# character;
# Find more on escape sequences in the hlep page ?Quotes
# Quotes
# Define line1
line1 <- "The table was a large one, but the three were all crowded together at one corner of it:"

# Define line2
line2 <- '"No room! No room!" they cried out when they saw Alice coming.'

# Define line3
line3 <- "\"There's plenty of room!\" said Alice indignantly, and she sat down in a large arm-chair at one end of the table."

# What you see isn't always what you have
# Putting lines in a vector
lines <- c(line1, line2, line3)

# Print lines
print(lines)

# Use writeLines() on lines
writeLines(lines)

# Write lines with a space separator
writeLines(lines, sep = " ")

# Use writeLines() on the string "hello\n\U1F30D"
writeLines("hello\n\U1F30D")

# Escape sequences
# Should display: To have a \ you need \\
writeLines("To have a \\ you need \\\\")

# Should display: 
# This is a really 
# really really 
# long string
writeLines("This is a really \nreally really \nlong string")

# Use writeLines() with 
writeLines("\u0928\u092e\u0938\u094d\u0924\u0947 \u0926\u0941\u0928\u093f\u092f\u093e")

# Turning numbers into strings  -------------------------------------------
# use format() or formatC()

# Using format() with numbers
# Some vectors of numbers
percent_change  <- c(4, -1.91, 3.00, -5.002)
income <-  c(72.19, 1030.18, 10291.93, 1189192.18)
p_values <- c(0.12, 0.98, 0.0000191, 0.00000000002)

# Format c(0.0011, 0.011, 1) with digits = 1
format(c(0.0011, 0.011, 1), digits = 1)

# Format c(1.0011, 2.011, 1) with digits = 1
format(c(1.0011, 2.011, 1), digits = 1)

# Format percent_change to one place after the decimal point
format(percent_change, digits = 2)

# Format income to whole numbers
format(income, digits = 2)

# Format p_values in fixed format
format(p_values, scientific = FALSE)

# Controllig other aspects of the string

# formatC()
# From the format() exercise
x <- c(0.0011, 0.011, 1)
y <- c(1.0011, 2.011, 1)

# formatC() on x with format = "f", digits = 1
formatC(x, format = "f", digits = 1)

# formatC() on y with format = "f", digits = 1
formatC(y, format = "f", digits = 1)

# Format percent_change to one place after the decimal point
formatC(percent_change, format = "f", digits = 1)

# percent_change with flag = "+"
formatC(percent_change, format = "f", digits = 1, flag = "+")

# Format p_values using format = "g" and digits = 2
formatC(p_values, format = "g", digits = 2)

# Putting strings together  -------------------------------------------
pretty_income <- formatC(income, digits = 0, format = "f", 
                         big.mark = ",", big.interval = 3)
pretty_percent <- formatC(percent_change, digits = 1, flag = "+",
                          format = "f")
years <- 2010:2013

# Annotation of numbers
# Add $ to pretty_income
paste("$", pretty_income, sep = "")

# Add % to pretty_percent
paste(pretty_percent, "%", sep = "")

# Create vector with elements like 2010: +4.0%`
year_percent <- paste(years, paste(pretty_percent, "%", sep = ""), sep = c(": "))

# Collapse all years into single string
paste(year_percent, collapse = ", ")

# A very simple table
# Define the names vector
income_names <- c("Year 0", "Year 1", "Year 2", "Project Lifetime")

# Create pretty_income
pretty_income1 <- format(income, scientific = FALSE, digits = 2,
                        big.mark = ",")
pretty_income2 <- format(income, scientific = FALSE, digits = 2,
                         big.mark = ",", trim = TRUE)

# Create dollar_income
dollar_income1 <- paste("$", pretty_income1, sep = "")
dollar_income2 <- paste("$", pretty_income2, sep = "")

# Create formatted_dollar
formatted_dollar <- format(dollar_income2, justify = "right")
  
# Create formatted_names
formatted_names <- format(income_names, justify = "right")

# Create rows
rows1 <- paste(formatted_names, dollar_income1, sep = "   ")
rows2 <- paste(formatted_names, formatted_dollar, sep = "   ")

# Write rows
writeLines(rows1)
writeLines(rows2)

# Let's order pizza!
toppings <- c("anchovies", "artichoke", "bacon", "breakfast bacon", 
              "Canadian bacon", "cheese", "chicken", "chili peppers",   
              "feta", "garlic", "green peppers", "grilled onions",  
              "ground beef", "ham", "hot sauce", "meatballs",
              "mushrooms", "olives", "onions", "pepperoni",
              "pineapple", "sausage", "spinach", "sun-dried tomato",
              "tomatoes")

# Randomly sample 3 toppings
my_toppings <- sample(toppings, size = 3)

# Print my_toppings
my_toppings

# Paste "and " to last element: my_toppings_and
my_toppings_and <- paste(c("", "", "and "), my_toppings, sep = "")

# Collapse with comma space: these_toppings
these_toppings <- paste(my_toppings_and, collapse = ", ")

# Add rest of sentence: my_order
my_order <- paste("I want to order a pizza with ", 
                  these_toppings, ".", sep = "")

# Order pizza with writeLines()
writeLines(my_order)
