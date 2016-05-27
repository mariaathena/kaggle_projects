# Natural Language Processing - U.S. Secretary of State Hillary R. Clinton Emails
# Maria Athena B. Engesaeth
# 01_create_event_dictionary
#
# Prepare working environment------------------------------------------------------

# Clean up
rm(list = ls())

# library(tidyr)
library(magrittr)
library(readr)
library(dplyr)
select <- dplyr::select
library(quanteda)
tokenize <- quanteda::tokenize
library(data.table) # writes 17x faster to csv

# library(countrycode)
# library(qdapDictionaries) # word list and dictionaries
# library(rworldmap) # worldmap by region with aggregation


# Load data ---------------------------------------------------------------------------

# Tokenised vocabulary created with python scripts using the wikipedia api 
# and python nltk module
event.vocab <- read_csv("./dictionary/event_vocab.csv")


# Clean vocabulary --------------------------------------------------------------------

# Create DFM: Tokenise and remove symbols, numbers, stopwords
clean_vocab <- dfm(event.vocab$vocabulary,
                   ignoredFeatures = stopwords("english"),
                   stem = TRUE,
                   removePunct = TRUE,
                   removeSeparators = TRUE,
                   removeHyphens = TRUE,
                   removeNumbers = TRUE) %>%
  as.matrix() %>%
  as.data.frame() %>%
  add_rownames(var = 'event')

# Output ready dictionary dfm --------------------------------------------------------

# Output to csv
fwrite(clean_vocab, './dictionary/parsed_dict.csv')

rm(list = ls())
gc()


