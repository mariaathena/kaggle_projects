# Natural Language Processing - U.S. Secretary of State Hillary R. Clinton Emails
# Maria Athena B. Engesaeth
# 00_parse_emails
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
library(feather)

# Load data -----------------------------------------------------------------------

emails <- read_csv("./email_data/Emails.csv")
aliases <- read_csv("./email_data/Aliases.csv")
receivers <- read_csv("./email_data/EmailReceivers.csv")
persons <- read_csv("./email_data/Persons.csv")


# Load data -----------------------------------------------------------------------

# There seems to be advantages to using the fields
# ExtractedTo over MetadataTo
# ExtractedFrom over MetadataFrom
# MetadataSubject over ExtractedSubject


# Clean date field
utc <- emails %>% 
  select(DocNumber, MetadataDateSent) %>%
  mutate(date = format(as.POSIXct(MetadataDateSent,
                                  format = "%F"),
                       format = "%m/%d/%Y")) %>% 
  select(-MetadataDateSent)


# Create Receiver by joining data from Persons df
receiver <- emails %>% 
  select(DocNumber, MetadataTo) %>% 
  mutate(receiver = MetadataTo) %>% 
  select(-MetadataTo) %>% 
  distinct() %>% 
  na.omit()


# Create Sender by joining data from Persons df
sender <- emails %>% 
  select(DocNumber, SenderPersonId, MetadataFrom, ExtractedFrom) %>% 
  left_join(persons, by = c("SenderPersonId" = "Id")) %>% 
  mutate(sender = Name) %>% 
  select(-SenderPersonId, -MetadataFrom, -ExtractedFrom, -Name) %>% 
  distinct() %>% 
  na.omit()


# Create CCed by joining data from Persons df
cced <- emails %>% 
  select(DocNumber, ExtractedCc) %>% 
  mutate(cced = ExtractedCc) %>% 
  # left_join(aliases, by = c("cced" = "Aliases")) %>% 
  select(-ExtractedCc) %>% 
  distinct() %>% 
  na.omit()


# Clean subject field
subject <- emails %>% 
  select(DocNumber, MetadataSubject) %>% 
  mutate(subject = MetadataSubject) %>% 
  select(-MetadataSubject)


# Clean email content ------------------------------------------------------------------
# Clean email main content field: apply tokeniser and remove stopwords

email_content <- emails %>%
  select(DocNumber, ExtractedReleaseInPartOrFull, RawText) %>% 
  mutate(edited = ifelse(ExtractedReleaseInPartOrFull == "RELEASE IN FULL", 0, 1)) %>% 
  rowwise() %>%
  mutate(email_raw = toLower(RawText, keepAcronyms = FALSE)) %>% 
  mutate(email_raw = tokenize(email_raw,
                              removePunct = TRUE,
                              removeSeparators = TRUE,
                              removeHyphens = TRUE,
                              removeNumbers = TRUE)) %>%
  # mutate(email_raw = paste(email_raw, collapse = ", ")) %>%
  select(-ExtractedReleaseInPartOrFull, -RawText)

# remove stopwords
email_content$email_raw <- removeFeatures(email_content$email_raw, 
                                          c(stopwords("english"))) 

# stem words and only keep unique words
email_content$email_raw <- wordstem(email_content$email_raw, language = "porter")


# Join dataframes to output -----------------------------------------------------------

# flatten word list for export to csv
email_clean <- email_content %>% 
  rowwise() %>% 
  mutate(email_raw = toString(email_raw))
  # mutate(email_raw = paste(email_raw, collapse = ", "))

# Join dataframes
parsed_data <- emails %>% 
  select(DocNumber) %>% 
  left_join(utc) %>% 
  left_join(sender) %>% 
  left_join(receiver) %>% 
  # left_join(cced) %>% 
  left_join(subject) %>% 
  left_join(email_clean) %>% 
  na.omit()

# Simplified dataframe
simple_data <- emails %>% 
  select(DocNumber) %>% 
  left_join(utc) %>% 
  left_join(email_clean) %>% 
  na.omit()

# Output to csv
# fwrite(parsed_data, './email_data/parsed_emails.csv')
# write_csv(parsed_data, './email_data/parsed_emails.csv')
write_feather(simple_data, './email_data/simplified_email.feather')
write_feather(parsed_data, './email_data/parsed_email.feather')


# # Create quanteda corpus from email content from PDF extract
# email.corpus <- corpus(clean_email$email_raw,
#                        docvars = emails[c(1,2,3,4,5,6)],
#                        docnames = emails$DocNumber)
# 
# # Create DFM: Tokenise and remove symbols, numbers, stopwords
# clean_content <- dfm(email.corpus,
#                    ignoredFeatures = stopwords("english"),
#                    stem = TRUE,
#                    removePunct = TRUE,
#                    removeSeparators = TRUE,
#                    removeHyphens = TRUE,
#                    removeNumbers = TRUE)
#   as.matrix() %>%
#   as.data.frame() %>%
#   add_rownames(var = 'DocNumber')
# rm(list= ls()[!(ls() %in% c('clean_email', 'clean_content'))])

rm(list = ls())
gc()
