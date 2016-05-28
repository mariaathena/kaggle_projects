# Natural Language Processing - U.S. Secretary of State Hillary R. Clinton Emails
# Maria Athena B. Engesaeth
# 01_create_event_dictionary
#
# Prepare working environment------------------------------------------------------

rm(list = ls()) # Clean up

library(tidyr)
library(magrittr)
library(readr)
library(dplyr)
select <- dplyr::select
library(quanteda)
tokenize <- quanteda::tokenize
# library(data.table) # writes 17x faster to csv
library(feather)

# Load data ---------------------------------------------------------------------------

# Tokenised vocabulary created with python scripts using the wikipedia api 
# and python nltk module
event.vocab <- read_csv("./dictionary/event_vocab.csv")


# Clean vocabulary --------------------------------------------------------------------

# lowercase and tokenise vocabulary
event_dict <- event.vocab %>%
  rowwise() %>%
  mutate(dictionary = toLower(vocabulary, keepAcronyms = FALSE)) %>% 
  mutate(dictionary = tokenize(dictionary,
                              removePunct = TRUE,
                              removeSeparators = TRUE,
                              removeHyphens = TRUE,
                              removeNumbers = TRUE)) %>%
  select(-vocabulary)

# remove stopwords
event_dict$dictionary <- removeFeatures(event_dict$dictionary,
                                        c(stopwords("english")))

# stem words and only keep unique words
event_dict$dictionary <- wordstem(event_dict$dictionary, language = "porter")


# # Create DFM: Tokenise and remove symbols, numbers, stopwords
# event_dict <- dfm(event.vocab$vocabulary,
#                    ignoredFeatures = stopwords("english"),
#                    stem = TRUE,
#                    removePunct = TRUE,
#                    removeSeparators = TRUE,
#                    removeHyphens = TRUE,
#                    removeNumbers = TRUE) %>% 
#   as.matrix() %>%
#   as.data.frame() %>%
#   add_rownames(var = 'event')


# Output ready dictionary dfm --------------------------------------------------------

# flatten word list for export to csv
event_dict <- event_dict %>% 
  mutate(dictionary = paste(dictionary, collapse = ", "))

write_feather(event_dict, './dictionary/parsed_dict.feather')
# fwrite(event_dict, './dictionary/parsed_dict.csv')

# rm(list= ls()[!(ls() %in% c('clean_email', 'clean_content', 'event_dict'))])
