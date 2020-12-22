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

# A case study on case ------------------------------------------------
# Changing case to ease matching
x <- c("Cat", "CAT", "cAt") 
str_view(x, "cat")
str_view(str_to_lower(x), "cat")
?whole_word

catcidents <- c("79yOf Fractured fingeR tRiPPED ovER cAT ANd fell to FlOOr lAst nIGHT AT HOME*",
                "21 YOF REPORTS SUS LACERATION OF HER LEFT HAND WHEN SHE WAS OPENING A CAN OF CAT FOOD JUST PTA. DX HAND LACERATION%",
                "87YOF TRIPPED OVER CAT, HIT LEG ON STEP. DX LOWER LEG CONTUSION ",
                "bLUNT CHest trAUma, R/o RIb fX, R/O CartiLAgE InJ To RIB cAge; 32YOM walKiNG DOG, dog took OfF aFtER cAt,FelL,stRucK CHest oN STepS,hiT rIbS",
                "42YOF TO ER FOR BACK PAIN AFTER PUTTING DOWN SOME CAT LITTER DX: BACK PAIN, SCIATICA",
                "4YOf DOg jUst hAd PUpPieS, Cat TRIED 2 get PuPpIes, pT THru CaT dwn stA Irs, LoST foOTING & FELl down ~12 stePS; MInor hEaD iNJuRY",
                "unhelmeted 14yof riding her bike with her dog when she saw a cat and sw erved c/o head/shoulder/elbow pain.dx: minor head injury,left shoulder",
                "24Yof lifting a 40 pound bag of cat litter injured lt wrist; wrist sprain",
                "3Yof-foot lac-cut on cat food can-@ home ",
                "Rt Shoulder Strain.26Yof Was Walking Dog On Leash And Dot Saw A Cat And Pulled Leash.",
                "15 mO m cut FinGer ON cAT FoOd CAn LID. Dx:  r INDeX laC 1 cm.",
                "31 YOM SUSTAINED A CONTUSION OF A HAND BY TRIPPING ON CAT & FALLING ON STAIRS.",
                "ACCIDENTALLY CUT FINGER WHILE OPENING A CAT FOOD CAN, +BLEEDING >>LAC",
                "4 Yom was cut on cat food can. Dx:  r index lac 1 cm.",
                "4 YO F, C/O FOREIGN BODY IN NOSE 1/2 HOUR, PT NOT REPORTING NATURE OF F B, PIECE OF CAT LITTER REMOVED FROM RT NOSTRIL, DX FB NOSE",
                "21Yowf  pT STAteS 4-5 DaYs Ago LifTEd 2 - 50 lB BagS OF CAT lItter.  al So sORTIng ClOThES & W/ seVERe paIn.  DX .  sTrain  LUMbOSaCRal.",
                "67 YO F WENT TO WALK DOG, IT STARTED TO CHASE CAT JERKED LEASH PULLED H ER OFF PATIO, FELL HURT ANKLES. DX BILATERAL ANKLE FRACTURES",
                "17Yof Cut Right Hand On A Cat Food Can - Laceration ",
                "46yof taking dog outside, dog bent her fingers back on a door. dog jerk ed when saw cat. hand holding leash caught on door jamb/ct hand",
                "19 YOF-FelL whIle WALKINg DOWn THE sTAIrS & TRiPpEd over a caT-fell oNT o \"TaIlBoNe\"         dx   coNtusIon LUMBaR, uti      *",
                "50YOF CUT FINGER ON CAT FOOD CAN LID.  DX: LT RING FINGER LAC ",
                "lEFT KNEE cOntusioN.78YOf triPPEd OVEr CaT aND fell and hIt knEE ON the fLoOr.",
                "LaC FInGer oN a meTAL Cat fOOd CaN ",
                "PUSHING HER UTD WITH SHOTS DOG AWAY FROM THE CAT'S BOWL&BITTEN TO FINGE R>>PW/DOG BITE",
                "DX CALF STRAIN R CALF: 15YOF R CALF PN AFTER FALL ON CARPETED STEPS, TR YING TO STEP OVER CAT, TRIPPED ON STAIRS, HIT LEG",
                "DISLOCATION TOE - 80 YO FEMALE REPORTS SHE FELL AT HOME - TRIPPED OVER THE CAT LITTER BOX & FELL STRIKING TOE ON DOOR JAMB - ALSO SHOULDER INJ",
                "73YOF-RADIUS FX-TRIPPED OVER CAT LITTER BOX-FELL-@ HOME ",
                "57Yom-Back Pain-Tripped Over A Cat-Fell Down 4 Steps-@ Home ",
                "76YOF SUSTAINED A HAND ABRASION CLEANING OUT CAT LITTER BOX THREE DAYS AGO AND NOW THE ABRASION IS INFECTED CELLULITIS HAND",
                "DX R SH PN: 27YOF W/ R SH PN X 5D. STATES WAS YANK' BY HER DOG ON LEASH W DOG RAN AFTER CAT; WORSE' PN SINCE. FULL ROM BUT VERY PAINFUL TO MOVE",
                "35Yof FeLt POp iN aBdoMeN whIlE piCKInG UP 40Lb BaG OF CAt litTeR aBdomINAL sTrain",
                "77 Y/o f tripped over cat-c/o shoulder and upper arm pain. Fell to floo r at home. Dx proximal humerus fx",
                "FOREHEAD LAC.46YOM TRIPPED OVER CAT AND FELL INTO A DOOR FRAME. ",
                "39Yof dog pulled her down the stairs while chasing a cat dx: rt ankle inj",
                "10 YO FEMALE OPENING A CAN OF CAT FOOD.  DX HAND LACERATION ",
                "44Yof Walking Dog And The Dof Took Off After A Cat And Pulled Pt Down B Y The Leash Strained Neck",
                "46Yof has low back pain after lifting heavy bag of cat litter lumbar spine sprain",
                "62 yOf FELL PUShIng carT W/CAT liTtER 3 DAYs Ago. Dx:  l FIfTH rib conT.",
                "PT OPENING HER REFRIGERATOR AND TRIPPED OVER A CAT AND FELL ONTO SHOULD ER FRACTURED HUMERUS",
                "Pt Lifted Bag Of Cat Food. Dx:  Low Back Px, Hx Arthritic Spine.",
                "Pt Lifted Bag Of Cat Food. Dx:  Low Back Px, Hx Arthritic Spine.")

# catcidents has been pre-defined
head(catcidents)

# Construct pattern of DOG in boundaries
whole_dog_pattern <- whole_word("DOG")

# See matches to word DOG
str_view(catcidents, whole_dog_pattern, match = TRUE)

# Regex form
str_view(catcidents, "\\bDOG\\b")

# Transform catcidents to upper case
catcidents_upper <- str_to_upper(catcidents)

# View matches to word "DOG" again
str_view(catcidents_upper, whole_dog_pattern, match = TRUE)

# Which strings match?
has_dog <- str_detect(catcidents_upper, whole_dog_pattern)

# Pull out matching strings in original 
catcidents[has_dog]

# Ignoring cases when matching
str_view(x, regex("cat", ignore_case = TRUE))

# View matches to "TRIP"
str_view(catcidents, "TRIP")

# Construct case insensitive pattern
trip_pattern <- regex("TRIP", ignore_case = TRUE)

# View case insensitive matches to "TRIP"
str_view(catcidents, trip_pattern)

# Get subset of matches
trip <- str_subset(catcidents, trip_pattern)

# Extract matches
str_extract(trip, trip_pattern)

# Fixing case problems
library(stringi)

# Get first five catcidents
cat5 <- catcidents[1:5]

# Take a look at original
writeLines(cat5)

# Transform to title case
writeLines(str_to_title(cat5))

# Transform to title case with stringi
writeLines(stri_trans_totitle(cat5))

# Transform to sentence case with stringi
writeLines(stri_trans_totitle(cat5, type = "sentence"))
