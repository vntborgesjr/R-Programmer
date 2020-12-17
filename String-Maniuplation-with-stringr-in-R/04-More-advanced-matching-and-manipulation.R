# --------------------------------------------------- 
# String Manipulation with stringr in R - More advanced matching 
# and manipulation 
# 12 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
library(rebus)
library(stringr)
# Capturing  -------------------------------------------
# Capturing allows you to capture and refer to parts of a regular 
# expression
# capture() is simple a way to goup parts of pattern together. Capture
# doesn't change the pattern that is matched it simpy indicates you
# want to do something with a piece of the pattern. 
capture(ANY_CHAR) %R% "a" # rebus form
"(.)a"
# str_match() is designed to work with patterns that include captures
# It wil return matrix, where each row corresponds to an input string
# The first column woll be the entire match, the same as you'd get from 
# str_extract(). Then, there is a column for each captured group, with
# just the piece that matched part of the captures pattern.
# Imagine for example you want to pull out the dolars from the cents
# To do so you simply capture the pattern that captured that dollar 
# and the piece that patures the cents part: in combination with 
# str_match() you get the dollars in one column and cents in another
pattern_rebus <- DOLLAR %R% 
  capture(DGT %R% optional(DGT)) %R%
  DOT %R%
  capture(dgt(2))
str_match(c("$5.50", "$32.00"), pattern = pattern_rebus)
pattern_regex <- "\\$(\\d[\\d]?)\\.(\\d{2})"
str_match(c("$5.50", "$32.00"), pattern = pattern_regex)

# Capturing parts of a pattern
hero_contacts <- c("(wolverine@xmen.com)",
                    "wonderwoman@justiceleague.org",
                    "thor@avengers.com" )

# Capture parts between @ and . and after .
email <- capture(one_or_more(WRD)) %R% 
  "@" %R% capture(one_or_more(WRD)) %R% 
  DOT %R% capture(one_or_more(WRD))

# Check match hasn't changed
str_view(hero_contacts, pattern = email)

# Regex form
email_regex <- "([\\w]+)@([\\w]+)+\\.([\\w]+)"
str_view(hero_contacts, pattern = email_regex)

# Pull out match and captures
email_parts <- str_match(hero_contacts, pattern = email)
email_parts

# Save host
host <- email_parts[, 3]
host

# Pulling out parts of a phone number
# View text containing phone numbers
contact

# Add capture() to get digit parts
phone_pattern <- capture(three_digits) %R% zero_or_more(separator) %R% 
  capture(three_digits) %R% zero_or_more(separator) %R%
  capture(four_digits)

phone_pattern_regex <- "(\\d{3})[-\\.() ]*(\\d{3})[-\\.() ]*(\\d{4})"
# Pull out the parts with str_match()
phone_numbers <- str_match(contact, pattern = phone_pattern_regex)

# Put them back together
str_c(
    "(",
    phone_numbers[, 2],
    ")",
    " ",
    phone_numbers[, 3],
    "-", phone_numbers[, 4])

# Extracting age and gender again
# narratives has been pre-defined
narratives

# Add capture() to get age, unit and sex
pattern <- capture(optional(DGT) %R% DGT) %R%  
  optional(SPC) %R% capture(or("YO", "YR", "MO")) %R%
  optional(SPC) %R% capture(or("M", "F"))

# Pull out from narratives
str_match(narratives, pattern = pattern)

# Regx form
pattern_regex <- "([\\d]?\\d)[\\s]?((?:YO|YR|MO))[\\s]?((?:M|F))"
str_match(narratives, pattern = pattern_regex)

# Edit to capture just Y and M in units
pattern2 <- capture(optional(DGT) %R% DGT) %R%  
  optional(SPC) %R% capture(or("Y", "M")) %R% optional(or("O","R")) %R%
  optional(SPC) %R% capture(or("M", "F"))

# Regex form
pattern_regex2 <- "([\\d]?\\d)[\\s]?((?:Y|M))[(?:O|R)][\\s]?((?:M|F))"
# Check pattern
str_view(narratives, pattern2)
str_view(narratives, pattern_regex2)

# Pull out pieces
str_match(narratives, pattern2)
str_match(narratives, pattern_regex2)

# Backreferences  -------------------------------------------
# Is the action to refer to acaptured part of a pattern
REF1 # rebus
"\\1" # regex
REF2 # rebus
"\\2" # regex
# Ex.
SPC %R%
  capture(one_or_more(WRD)) %R%
  SPC %R%
  REF1
"\\s([\\w]+)\\s\\1"
str_view("Paris in the  the spring", 
         SPC %R%
           capture(one_or_more(WRD)) %R%
           SPC %R%
           REF1)
str_view("Paris in the  the spring", 
         "\\s([\\w]+)\\s\\1")
str_replace("Paris in the the spring",
            "\\s([\\w]+)\\s\\1",
            replacement = str_c(" ", REF1))

# Using backreferences in patterns
str_replace(boy_names, pattern = "^[:upper:]+", 
            replacement = "[:lower:]")

# Names with three repeated letters
repeated_three_times <- capture(LOWER) %R%
  REF1 %R%
  REF1

# Test it
str_view(boy_names, pattern = repeated_three_times, match = TRUE)

# Regex form
str_view(boy_names, pattern = "([:lower:])\\1\\1", match = TRUE)

# Names with a pair of repeated letters
pair_of_repeated <- capture(LOWER) %R%
  capture(LOWER) %R%
  REF1 %R%
  REF2

# Test it
str_view(boy_names, pattern = pair_of_repeated, match = TRUE)

# Regex form
str_view(boy_names, pattern = "([:lower:])([:lower:])\\1\\2", match = TRUE)

# Names with a pair that reverses
pair_that_reverses <- capture(LOWER) %R%
  capture(LOWER) %R%
  REF2 %R%
  REF1

# Test it
str_view(boy_names, pattern = pair_that_reverses, match = TRUE)

# Regex form
str_view(boy_names, pattern = "([:lower:])([:lower:])\\2\\1", match = TRUE)

# Four letter palindrome names
four_letter_palindrome <- exactly(capture(LOWER) %R%
            capture(LOWER) %R%
            REF2 %R%
            REF1)
# Test it
str_view(boy_names, pattern = four_letter_palindrome, match = TRUE)

# Regex form
str_view(boy_names, pattern = "^([:lower:])([:lower:])\\2\\1$", match = TRUE)

# Repalcing with regular expression
# View text containing phone numbers
contact

# Replace digits with "X"
str_replace(contact, DGT, "X")

# Replace all digits with "X"
str_replace_all(contact, DGT, "X")

# Replace all digits with different symbol
str_replace_all(contact, DGT, c("X", ".", "*", "_"))

# Replacing with backreferences
# Build pattern to match words ending in "ING"
pattern <- "ING" 
str_view(narratives, pattern)

# Test replacement
str_replace(narratives, capture(pattern), 
            str_c("CARELESSLY", REF1, sep = " "))

# One adverb per narrative
adverbs_10 <- sample(adverbs, 10)

# Replace "***ing" with "adverb ***ly"
str_replace(narratives, capture(pattern), 
            str_c(adverbs_10, REF1, sep = " "))


x <- c("hello", "sweet", "kitten")
str_replace(x, capture(ANY_CHAR), str_c(REF1, REF1))
