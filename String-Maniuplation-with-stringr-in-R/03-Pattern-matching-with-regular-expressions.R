# --------------------------------------------------- 
# String Manipulation with stringr in R - Pattern matching with
# regular expressions 
# 12 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Regular expressions  -------------------------------------------
# RE area a language for describing patterns in strings
# ^.[\d]+ - it describe the pattern "the start of the string, followed
# by any single character, followed by one or more digits".
# the same RE as rebu's expression: 
# START %R%
#   ANY_CHAR %R%
#   one_or_more(DGT)
# Usefull stringr functoin: 
# str_view() - it takes a string, and a pattern, and will open a html
# view with any matches to the pattern highlighted

# Matching the start or end of the string
library(stringr)
library(rebus)
START # ^ indicates the start of a character
END # $ indicates the end of a character
START %R% "c" # "^c" - strings that start with c
ANY_CHAR # . mathces a single character no matter what character is.
# Some strings to practice with
x <- c("cat", "coat", "scotland", "tic toc")

# Print END
END

# Run me
str_view(x, pattern = START %R% "c")

# Regex form
str_view(x, pattern = "^c")

# Match the strings that start with "co" 
str_view(x, pattern = START %R% "co")

# Regex form
str_view(x, pattern = "^co")

# Match the strings that end with "at"
str_view(x, pattern = "at" %R% END)

# Regex form
str_view(x, pattern = "at$" )

# Match the string that is exactly "cat"
str_view(x, pattern = START %R% "cat" %R% END )
str_view(x, pattern = exactly("cat"))

# Reges form
str_view(x, pattern = "^cat$" )

# Matching any character
# Match two characters, where the second is a "t"
str_view(x, pattern = ANY_CHAR %R% "t")

# Regex form
str_view(x, pattern = ".t")

# Match a "t" followed by any character
str_view(x, pattern = "t" %R% ANY_CHAR)

# Regex form
str_view(x, pattern = "t.")

# Match two characters
str_view(x, pattern = "" %R% ANY_CHAR %R% "" %R% ANY_CHAR)

# Regex form
str_view(x, pattern = "..")

# Match a string with exactly three characters
str_view(x, pattern = START %R% ANY_CHAR %R% ANY_CHAR %R% ANY_CHAR %R% END)

# Regex form
str_view(x, pattern = "^...$")

# Combining with stringr functions
pattern <- "q" %R% ANY_CHAR

# Find names that have the pattern
names_with_q <- str_subset(boy_names, pattern = pattern)

# How many names were there?
length(names_with_q)

# Alternative way to count the pattern frenquency
sum(str_count(boy_names, pattern))

# Regex form
pattern <- "q."
# Find names that have the pattern
names_with_q <- str_subset(boy_names, pattern = pattern)

# How many names were there?
length(names_with_q)

# Alternative way to count the pattern frenquency
sum(str_count(boy_names, pattern))

# Find part of name that matches pattern
part_with_q <- str_extract(boy_names, pattern)

# Get a table of counts
table(part_with_q)

# Did any names have the pattern more than once?
count_of_q <- str_count(boy_names, pattern)

# Get a table of counts
table(count_of_q)

# Which babies got these names?
with_q <- str_detect(boy_names, pattern)

# What fraction of babies got these names?
mean(with_q)

# More regular expressions  -------------------------------------------
# Review
# Pattern             | Regex             | rebus
# Start of string     | ^                 | START
# Endo of string      | $                 | END
# Any single character| .                 | ANY_CHAR
# Literal dot, carat...| \\., \\^, \\$   | DOT, CARAT, DOLLAR

# Remenmber that you need to scpe the backslash then it comes in 
# double
# Alternation - match the pattern a or b. look a lot like a logical 
# OR in R. regex - "?:dog|cat"
# In rebus, you use the function or to construct a regular expression 
# with a set of alternative matches ex. or(dog, cat)
# Character classes - are a bit like ANY_CHAR but wit a restriction
# on what characters are allowed. It maches any single character
# that is in this set. A character class is specified by a square
# brackets. regex ex. "[Aa]"; rebus ex. char_class("Aa")
# A Negated character class, specifies that you should not match any 
# single character that is not in this set. regex ex. [^Aa]
# rebus ex. negated_char_class("Aa").
# Inside a character expression you don't need to scape characters
# that might otherwise have a special meaning
# Repetition
# Pattern             | Regex       | rebus
# Optional            | ?           | optional()
# Zero or more        | *           | zero_or_more()
# One or more         | +           | one_or_more()
# Between m and n times| {n,m}      | repeated()

