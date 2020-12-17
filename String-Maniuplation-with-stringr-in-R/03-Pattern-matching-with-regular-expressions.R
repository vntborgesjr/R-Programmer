# --------------------------------------------------- 
# String Manipulation with stringr in R - Pattern matching with
# regular expressions 
# 12 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Regular expressions  -------------------------------------------
# Regex area a language for describing patterns in strings
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
# OR in R. regex - "(?:dog|cat)"
# In rebus, you use the function or to construct a regular expression 
# with a set of alternative matches ex. or(dog, cat)

# Character classes - are a bit like ANY_CHAR but with a restriction
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

# Alternation
# Examples
x <- c("grey sky", "gray elephant")

# rebus form
str_view(x, pattern = or("grey", "gray"))
str_view(x, pattern = "gr" %R% or("e", "a") %R% "y")

# Regex form
str_view(x, pattern = "(?:grey|gray)")
str_view(x, pattern = "gr(?:e|a)y")

# Match Jeffrey or Geoffrey
whole_names <- or("Jeffrey", "Geoffrey")
str_view(boy_names, pattern = whole_names, match = TRUE)

whole_names <- or("Je", "Geo") %R% "ffrey"
str_view(boy_names, pattern = whole_names, match = TRUE)

# Regex form
whole_names <- "(?:Jeffrey|Geoffrey)"
str_view(boy_names, pattern = whole_names, match = TRUE)
whole_names <- "(?:Je|Geo)ffrey"
str_view(boy_names, pattern = whole_names, match = TRUE)

# Match Jeffrey or Geoffrey, another way
common_ending <- or("Je", "Geo") %R% "ffrey"
str_view(boy_names, pattern = common_ending, match = TRUE)

# Match with alternate endings
by_parts <- or("Je", "Geo") %R% "ff" %R% or("ry", "ery", "rey", "erey")
str_view(boy_names, pattern = by_parts, match = TRUE)

# Regex form
by_parts <- "(?:Je|Geo)ff(?:ry|ery|rey|erey)"
str_view(boy_names, pattern = by_parts, match = TRUE)

# Match names that start with Cath or Kath
ckath <- or("C", "K") %R% "ath"
str_view(girl_names, pattern = ckath, match = TRUE)

# Regex form
ckath <- "(?:C|K)ath"
str_view(girl_names, pattern = ckath, match = TRUE)

# Character classes
x <- c("grey sky", "gray elephant")
str_view(x, pattern = "gr" %R% char_class("ae") %R% "y")
str_view(x, pattern = "gr[ae]y")

# Create character class containing vowels
vowels <- char_class("aeiouAEIOU")

# Print vowels
vowels

# See vowels in x with str_view()
str_view(x, pattern = vowels)

# See vowels in x with str_view_all()
str_view_all(x, pattern = vowels)

# Regex form 
str_view(x, pattern = "[aeiouAEIOU]")
str_view_all(x, pattern = "[aeiouAEIOU]")

# Number of vowels in boy_names
num_vowels <- str_count(boy_names, pattern = vowels)

# Number of characters in boy_names
name_length <- str_length(boy_names)

# Calc mean number of vowels
mean(num_vowels)

# Calc mean fraction of vowels per name
mean(num_vowels / name_length)

# Repetition
x <- c("ow", "ooh", "yeeeah!", "shh")
str_view(x, pattern = one_or_more(vowels))
str_view(x, pattern = zero_or_more(vowels))

# Regex form
str_view(x, pattern = "[aeiouAEIOU]+")
str_view(x, pattern = "[aeiouAEIOU]*")

# Vowels from last exercise
vowels <- char_class("aeiouAEIOU")

# See names with only vowels
str_view(boy_names, 
         pattern = exactly(one_or_more(vowels)), 
         match = TRUE)

# Regex
str_view(boy_names, 
         pattern = "^[aeiouAEIOU]+$", 
         match = TRUE)

# Use `negated_char_class()` for everything but vowels
not_vowels <- negated_char_class("aeiouAEIOU")

# See names with no vowels
str_view(boy_names, 
         pattern = exactly(one_or_more((not_vowels))), 
         match = TRUE)

# Regex form
str_view(boy_names, 
         pattern = "^[^aeiouAEIOU]+$", 
         match = TRUE)

# Shortcuts  -------------------------------------------
# Range - you can specify a range using -. ex. 0-9
# Match any number between 0 and 9 including
char_class("0-9") # rebus
"[0-9]" # regex
# Match any lower case letter between a and z
char_class("a-z") # rebus
"[a-z]" # regex
# Match any upper case letter
char_class("A-Z") # rebus
"[A-Z]" # regex

# DGT in rebus \\d or [:digit:] regex specifies any digits
DGT %R% 1

# WRD or \w specifies a word character

# SPC or \s specifies a white space 

# Hunting for phone numbers 
contact <- c("Call me at 555-555-0191",
             "123 Main St",
             "(555) 555 0191",
             "Phone: 555.555.0191 Mobile: 555.555.0192")

# Create a three digit pattern
three_digits <- DGT %R% DGT %R% DGT

# Test it
str_view_all(contact, pattern = three_digits)

# Regex form
str_view_all(contact, pattern = "\\d\\d\\d")

# Create a separator pattern
separator <- or("-", ".", "(", ")", " ")

# Test it
str_view_all(contact, pattern = separator)

# Regex form
str_view_all(contact, pattern = "[-.() ]")
str_view_all(contact, pattern = "[\\-\\.\\(\\)\\s]")

# Create phone pattern
four_digits <- dgt(4)
phone_pattern <- optional(OPEN_PAREN) %R%
  three_digits %R%
  zero_or_more(separator) %R%
  three_digits %R% 
  zero_or_more(separator) %R%
  four_digits

# Test it           
str_view_all(contact, pattern = phone_pattern)

# Regex form
str_view_all(contact, pattern = "[(]?\\d\\d\\d[-.() ]*\\d\\d\\d[-.() ]*\\d\\d\\d\\d")

# Extract phone numbers
str_extract(contact, pattern = phone_pattern)

# Extract ALL phone numbers
str_extract_all(contact, pattern = phone_pattern)

# Extracting age and gender from accident narratives
# Pattern to match one or two digits
narratives <- c("19YOM-SHOULDER STRAIN-WAS TACKLED WHILE PLAYING FOOTBALL W/ FRIENDS ",
                "31 YOF FELL FROM TOILET HITITNG HEAD SUSTAINING A CHI ",
                "ANKLE STR. 82 YOM STRAINED ANKLE GETTING OUT OF BED ",
                "TRIPPED OVER CAT AND LANDED ON HARDWOOD FLOOR. LACERATION ELBOW, LEFT. 33 YOF*",
                "10YOM CUT THUMB ON METAL TRASH CAN DX AVULSION OF SKIN OF THUMB ",
                "53 YO F TRIPPED ON CARPET AT HOME. DX HIP CONTUSION ",
                "13 MOF TRYING TO STAND UP HOLDING ONTO BED FELL AND HIT FOREHEAD ON RADIATOR DX LACERATION",
                "14YR M PLAYING FOOTBALL; DX KNEE SPRAIN ",
                "55YOM RIDER OF A BICYCLE AND FELL OFF SUSTAINED A CONTUSION TO KNEE ",
                "5 YOM ROLLING ON FLOOR DOING A SOMERSAULT AND SUSTAINED A CERVICAL STRA IN")
age <- one_or_more(DGT)
age <- DGT %R% optional(DGT)

# Test it
str_view(narratives, pattern = age)

# Reges form
str_view(narratives, pattern = "[\\d]+")
str_view(narratives, pattern = "[\\d][\\d]?")

# Pattern to match units 
unit <- optional(" ") %R% char_class("YO", "YR", "MO")
unit <- optional(SPC) %R% or("YO", "YR", "MO")

# Test pattern with age then units
str_view(narratives, pattern = age %R% unit)

# Regex form
str_view(narratives, pattern = "[\\d][\\d]?[ ]?(?:YO|YR|MO)")

# Pattern to match gender
gender <- optional(SPC) %R% or("M", "F")

# Test pattern with age then units then gender
str_view(narratives, pattern = age %R% unit %R% gender)

# Regex form
str_view(narratives, pattern = "[\\d][\\d]?[ ]?(?:YO|YR|MO)[ ]?(?:M|F)")

# Extract age, unit, gender
age_gender <- str_extract(narratives, pattern = age %R% unit %R% gender)

# Parsing age and gender into pieces
# age_gender, age, gender, unit are pre-defined
ls.str()

# Extract age and make numeric
ages_numeric <- as.numeric(str_extract(narratives, age))

# Replace age and units with ""
genders <- str_remove(age_gender, pattern = age %R% unit)

# Replace extra spaces
str_remove_all(genders, pattern = one_or_more(SPC))

# Extract units 
time_units <- str_extract(age_gender, pattern = unit)

# Extract first word character
time_units_clean <- str_extract(time_units, pattern = WRD)

# Turn ages in months to years
ifelse(time_units_clean == "Y", ages_numeric, ages_numeric/12)

