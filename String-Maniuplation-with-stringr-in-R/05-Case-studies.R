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
start <- str_which(earnest, ___)
end <- str_which(earnest, ___)

# Get rid of gutenberg intro text
earnest_sub  <- ___