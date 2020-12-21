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
,  capture(one_or_more(WRD)) %R%
,  SPC %R%
,  REF1)
str_view("Paris in the  the spring", 
         "\\s([\\w]+)\\s\\1")
str_replace("Paris in the the spring",
,   "\\s([\\w]+)\\s\\1",
,   replacement = str_c(" ", REF1))

# Using backreferences in patterns
str_replace(boy_names, pattern = "^[:upper:]+", 
,   replacement = "[:lower:]")

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
,   capture(LOWER) %R%
,   REF2 %R%
,   REF1)
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
adverbs <- c("ABNORMALLY",      "ABSENTMINDEDLY",  "ACCIDENTALLY"    
,      "ACIDLY"     ,     "ACTUALLY", "ADVENTUROUSLY"   
,      "AFTERWARDS",       "ALMOST",   "ALWAYS",  
 "ANGRILY", "ANNUALLY",         "ANXIOUSLY"       
, "ARROGANTLY",       "AWKWARDLY"     ,   "BADLY"  
, "BASHFULLY" ,       "BEAUTIFULLY"   ,   "BITTERLY"        
, "BLEAKLY", "BLINDLY", "BLISSFULLY"      
, "BOASTFULLY" ,      "BOLDLY",  "BRAVELY"         
, "BRIEFLY", "BRIGHTLY"   ,      "BRISKLY"         
, "BROADLY", "BUSILY",  "CALMLY" 
, "CAREFULLY"   ,     "CARELESSLY"  ,     "CAUTIOUSLY"      
, "CERTAINLY"    ,    "CHEERFULLY"  ,     "CLEARLY"         
, "CLEVERLY"      ,   "CLOSELY", "COAXINGLY"       
, "COLORFULLY"     ,  "COMMONLY"     ,    "CONTINUALLY"     
, "COOLLY",  "CORRECTLY"    ,    "COURAGEOUSLY"    
, "CROSSLY", "CRUELLY", "CURIOUSLY"       
, "DAILY",   "DAINTILY"      ,   "DEARLY"
, "DECEIVINGLY"     , "DEEPLY",  "DEFIANTLY"       
, "DELIBERATELY"     ,"DELIGHTFULLY"  ,   "DILIGENTLY"      
, "DIMLY",   "DOUBTFULLY"   ,    "DREAMILY"        
, "EASILY",  "ELEGANTLY"     ,   "ENERGETICALLY"   
, "ENORMOUSLY"       ,"ENTHUSIASTICALLY", "EQUALLY"         
, "ESPECIALLY"      , "EVEN",    "EVENLY" 
, "EVENTUALLY"      , "EXACTLY", "EXCITEDLY"       
, "EXTREMELY"       , "FAIRLY",  "FAITHFULLY"      
, "FAMOUSLY"        , "FAR", "FAST"   
, "FATALLY", "FEROCIOUSLY"  ,    "FERVENTLY"       
, "FIERCELY"        , "FONDLY",  "FOOLISHLY"       
, "FORTUNATELY"     , "FRANKLY", "FRANTICALLY"     
, "FREELY",  "FRENETICALLY" ,    "FRIGHTFULLY"     
, "FULLY",   "FURIOUSLY"     ,   "GENERALLY"       
, "GENEROUSLY" ,      "GENTLY",  "GLADLY" 
, "GLEEFULLY"   ,     "GRACEFULLY",       "GRATEFULLY"      
, "GREATLY", "GREEDILY"     ,    "HAPPILY"         
, "HASTILY", "HEALTHILY"     ,   "HEAVILY"         
, "HELPFULLY"    ,    "HELPLESSLY",       "HIGHLY"
, "HONESTLY"      ,   "HOPELESSLY" ,      "HOURLY" 
, "HUNGRILY"    ,     "IMMEDIATELY"  ,    "INNOCENTLY"      
, "INQUISITIVELY"  ,  "INSTANTLY"    ,    "INTENSELY"       
, "INTENTLY"        , "INTERESTINGLY" ,   "INWARDLY"        
, "IRRITABLY" ,       "JAGGEDLY"       ,  "JEALOUSLY"       
, "JOSHINGLY"  ,      "JOVIALLY"        , "JOYFULLY"        
, "JOYOUSLY"    ,     "JUBILANTLY"       ,"JUDGEMENTALLY"   
, "JUSTLY",  "KEENLY",  "KIDDINGLY"       
, "KINDHEARTEDLY",    "KINDLY",  "KISSINGLY"       
, "KNAVISHLY"     ,   "KNOTTILY"  ,       "KNOWINGLY"       
, "KNOWLEDGEABLY"  ,  "KOOKILY", "LAZILY"
, "LESS",    "LIGHTLY", "LIKELY" 
, "LIMPLY",  "LIVELY",  "LOFTILY"         
, "LONGINGLY"       , "LOOSELY", "LOUDLY" 
, "LOVINGLY"         ,"LOYALLY", "MADLY"  
, "MAJESTICALLY"    , "MEANINGFULLY",     "MECHANICALLY"    
, "MERRILY", "MISERABLY"    ,    "MOCKINGLY"       
, "MONTHLY", "MORE",    "MORTALLY"        
, "MOSTLY",  "MYSTERIOUSLY"  ,   "NATURALLY"       
, "NEARLY",  "NEATLY",  "NEEDILY"         
, "NERVOUSLY"        ,"NEVER",   "NICELY" 
, "NOISILY", "NOT", "OBEDIENTLY"      
, "OBNOXIOUSLY"     , "ODDLY",   "OFFENSIVELY"     
, "OFFICIALLY"      , "OFTEN",   "ONLY"   
, "OPENLY",  "OPTIMISTICALLY" ,  "OVERCONFIDENTLY" 
, "OWLISHLY"        , "PAINFULLY",        "PARTIALLY"       
, "PATIENTLY"       , "PERFECTLY" ,       "PHYSICALLY"      
, "PLAYFULLY"       , "POLITELY"   ,      "POORLY"
, "POSITIVELY"      , "POTENTIALLY" ,     "POWERFULLY"      
, "PROMPTLY"        , "PROPERLY"     ,    "PUNCTUALLY"      
, "QUAINTLY"        , "QUARRELSOMELY" ,   "QUEASILY"        
, "QUEERLY", "QUESTIONABLY"   ,  "QUESTIONINGLY"   
, "QUICKER", "QUICKLY", "QUIETLY"         
, "QUIRKILY"       ,  "QUIZZICALLY"   ,   "RAPIDLY"         
, "RARELY",  "READILY", "REALLY"
, "REASSURINGLY"   ,  "RECKLESSLY"     ,  "REGULARLY"       
, "RELUCTANTLY"    ,  "REPEATEDLY"      , "REPROACHFULLY"   
, "RESTFULLY"     ,   "RIGHTEOUSLY"     , "RIGHTFULLY"      
, "RIGIDLY", "ROUGHLY", "RUDELY" 
, "SADLY",   "SAFELY",  "SCARCELY"        
, "SCARILY", "SEARCHINGLY"  ,    "SEDATELY"        
, "SEEMINGLY"     ,   "SELDOM",  "SELFISHLY"       
, "SEPARATELY"    ,   "SERIOUSLY",        "SHAKILY"         
, "SHARPLY", "SHEEPISHLY" ,      "SHRILLY"         
, "SHYLY",   "SILENTLY"    ,     "SLEEPILY"        
, "SLOWLY",  "SMOOTHLY"     ,    "SOFTLY"
, "SOLEMNLY"      ,   "SOLIDLY", "SOMETIMES"       
, "SOON",    "SPEEDILY"      ,   "STEALTHILY"      
, "STERNLY", "STRICTLY"       ,  "SUCCESSFULLY"    
, "SUDDENLY"      ,   "SURPRISINGLY",     "SUSPICIOUSLY"    
, "SWEETLY", "SWIFTLY", "SYMPATHETICALLY" 
, "TENDERLY"      ,   "TENSELY", "TERRIBLY"        
, "THANKFULLY"    ,   "THOROUGHLY"   ,    "THOUGHTFULLY"    
, "TIGHTLY", "TOMORROW",         "TOO"
, "TREMENDOUSLY"  ,   "TRIUMPHANTLY",     "TRULY"
, "TRUTHFULLY"    ,   "ULTIMATELY"   ,    "UNABASHEDLY"     
, "UNACCOUNTABLY" ,   "UNBEARABLY"    ,   "UNETHICALLY"     
, "UNEXPECTEDLY"  ,   "UNFORTUNATELY"  ,  "UNIMPRESSIVELY"  
, "UNNATURALLY"   ,   "UNNECESSARILY"   , "UPBEAT"
, "UPLIFTINGLY"   ,   "UPRIGHT", "UPSIDE-DOWN"     
, "UPWARD",  "UPWARDLY"   ,      "URGENTLY"        
, "USEFULLY"      ,   "USELESSLY",        "USUALLY"         
, "UTTERLY", "VACANTLY"   ,      "VAGUELY"         
, "VAINLY",  "VALIANTLY"   ,     "VASTLY" 
, "VERBALLY"      ,   "VERY",    "VICIOUSLY"       
, "VICTORIOUSLY"  ,   "VIOLENTLY",        "VIVACIOUSLY"     
, "VOLUNTARILY"   ,   "WARMLY",  "WEAKLY" 
, "WEARILY", "WELL",    "WETLY"  
, "WHOLLY",  "WILDLY",  "WILLFULLY"       
, "WISELY",  "WOEFULLY" ,        "WONDERFULLY"     
, "WORRIEDLY"    ,    "WRONGLY", "YAWNINGLY"       
, "YEARLY",  "YEARNINGLY" ,      "YESTERDAY"       
, "YIELDINGLY"   ,    "YOUTHFULLY")

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

# Unicode and pattern matching  -------------------------------------------
"\u03bc"
"\U1F600"
writeLines("\U1F600")
writeLines("\U0001F44F")
as.hexmode(utf8ToInt("😀"))
as.hexmode(utf8ToInt("👏"))
x <- "Normal(\u03bc = 0, \u03c3 = 1)"
x
str_view(x, pattern = "\u03bc")
# Look for all characters in the Greek and Coptic block
str_view_all(x, greek_and_coptic())

# Matching a specific code point or code groups
x <- c("\u00e8", "\u0065\u0300")
writeLines(x)
str_view(x, "\u00e8")
library(stringi)
as.hexmode(utf8ToInt(stri_trans_nfd("\u00e8")))
as.hexmode(utf8ToInt(stri_trans_nfc("\u0065\u0300")))

# Names with builtin accents
(tay_son_builtin <- c(
  "Nguy\u1ec5n Nh\u1ea1c", 
  "Nguy\u1ec5n Hu\u1ec7",
  "Nguy\u1ec5n Quang To\u1ea3n"
))

# Convert to separate accents
tay_son_separate <- stri_trans_nfd(tay_son_builtin)

# Verify that the string prints the same
tay_son_separate

# Match all accents
str_view_all(tay_son_separate, UP_DIACRITIC)

# Regex form
str_view_all(tay_son_separate, "\\p{DIACRITIC}")

# Matching a single grapheme
x <- c("Adele", "Ad\u00e8le", "Ad\u0065\u0300le")
writeLines(x)
str_view(x, "Ad" %R% ANY_CHAR %R% "le")
str_view(x, "Ad" %R% GRAPHEME %R% "le")

# tay_son_separate has been pre-defined
tay_son_separate

# View all the characters in tay_son_separate
str_view_all(tay_son_separate, ANY_CHAR)

# View all the graphemes in tay_son_separate
str_view_all(tay_son_separate, GRAPHEME)

# Combine the diacritics with their letters
tay_son_builtin <- stri_trans_nfc(tay_son_separate)
tay_son_builtin

# View all the graphemes in tay_son_builtin
str_view_all(tay_son_builtin, GRAPHEME)

# Regex form to select all characters
str_view_all(tay_son_separate, ".\\X(?:c|n)?")
str_view_all(tay_son_separate, "\\X")
