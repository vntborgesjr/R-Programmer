# --------------------------------------------------- 
# String Manipulation with stringr in R - Case studies 
# 12 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Case study ------------------------------------------------
# Getting the play into R
library(stringi)
library(stringr)

# Read play in using stri_read_lines()
earnest <- stri_read_lines("Datasets/earnest_file.txt")

# Detect start and end lines
start <- str_which(earnest, "START OF THE PROJECT")
end <- str_which(earnest, "END OF THE PROJECT")

# Get rid of gutenberg intro text
earnest_sub  <- earnest[(start + 1):(end - 1)]

# Detect first act
lines_start <- str_which(earnest_sub, "FIRST ACT")

# Set up index
intro_line_index <- 1:(lines_start - 1)

# Split play into intro and play
intro_text <- earnest_sub[intro_line_index]
play_text <- earnest_sub[- intro_line_index]

# Take a look at the first 20 lines
writeLines(play_text[1:20])

# Identify the lines, take 1
# Get rid of empty strings
empty <- stri_isempty(play_text)
play_lines <- play_text[!empty]

# Pattern for start, word then .
pattern_1 <- START %R% one_or_more(WRD) %R% DOT
pattern_1_regex <- "^[\\w]+\\."

# Test pattern_1
str_view(play_lines, pattern_1, match = TRUE) 
str_view(play_lines, pattern_1, match = FALSE)

# Regex form
str_view(play_lines, pattern_1_regex, match = TRUE) 

# Pattern for start, capital, word then .
pattern_2 <- START %R% 
  ascii_upper() %R%
  one_or_more(WRD) %R%
  DOT
pattern_2_regex <- "^[A-Z][\\w]+\\."

# Test pattern_2
str_view(play_lines, pattern_2, match = TRUE)
str_view(play_lines, pattern_2, match = FALSE)

# Regex form
str_view(play_lines, pattern_2_regex, match = TRUE)

# Get subset of lines that match
lines <- str_subset(play_lines, pattern_2)

# Extract match from lines
who <- str_extract(lines, pattern_2)

# Let's see what we have
unique(who)

# Identifying the lines, take 2
# Create vector of characters
characters <- c("Algernon", "Jack", "Lane", "Cecily", "Gwendolen", "Chasuble", 
                "Merriman", "Lady Bracknell", "Miss Prism")

# Match start, then character name, then .
pattern_3 <- START %R%
  or1(characters) %R%
  DOT
pattern_3_regex <- "^(?:Algernon|Jack|Lane|Cecily|Gwendolen|Chasuble|Merriman|Lady Bracknell|Miss Prism)\\."

# View matches of pattern_3
str_view(play_lines, pattern_3)

# View non-matches of pattern_3
str_view(play_lines, pattern_3, match = FALSE)

# Pull out matches
lines <- str_subset(play_lines, pattern_3)

# Extract match from lines
who <- str_extract(lines, pattern_3)

# Let's see what we have
unique(who)

# Count lines per character
table(who)
