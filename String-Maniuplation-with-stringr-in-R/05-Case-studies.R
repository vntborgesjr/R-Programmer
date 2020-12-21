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
# Pattern for start, word then .
pattern_1 <- ___

# Test pattern_1
str_view(play_lines, ___, match = ___) 
str_view(play_lines, ___, match = ___)