# Natural Language Processing - U.S. Secretary of State Hillary R. Clinton Emails
# Maria Athena B. Engesaeth
# 00_parse_data
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

# library(countrycode)
# library(RSQLite) # SQLite access
# library(qdapDictionaries) # word list and dictionaries
# library(rworldmap) # worldmap by region with aggregation


# Load data -----------------------------------------------------------------------

emails <- read_csv("./data/Emails.csv")
aliases <- read_csv("./data/Aliases.csv")
receivers <- read_csv("./data/EmailReceivers.csv")
persons <- read_csv("./data/Persons.csv")


# Load data -----------------------------------------------------------------------

# There seems to be advantages to using the fields
# ExtractedTo over MetadataTo
# ExtractedFrom over MetadataFrom
# MetadataSubject over ExtractedSubject


# Clean date field
utc <- emails %>% 
  select(DocNumber, MetadataDateSent) %>%
  mutate(date_time = as.POSIXct(MetadataDateSent))


# Create Receiver by joining data from Persons df
receiver <- emails %>% 
  select(DocNumber, SenderPersonId, ExtractedTo) %>% 
  left_join(persons, by = c("SenderPersonId" = "Id")) %>% 
  mutate(receiver = Name) %>% 
  select(-SenderPersonId, -ExtractedTo, -Name)


# Create Sender by joining data from Persons df
sender <- emails %>% 
  select(DocNumber, SenderPersonId, MetadataFrom, ExtractedFrom) %>% 
  left_join(persons, by = c("SenderPersonId" = "Id")) %>% 
  mutate(sender = Name) %>% 
  select(-SenderPersonId, -MetadataFrom, -ExtractedFrom, -Name)


# Create CCed by joining data from Persons df
cced <- emails %>% 
  select(DocNumber, SenderPersonId, ExtractedCc) %>% 
  left_join(persons, by = c("SenderPersonId" = "Id")) %>% 
  mutate(cced = Name) %>% 
  select(-SenderPersonId, -ExtractedCc, Name)


# Clean subject field
subject <- emails %>% 
  select(DocNumber, MetadataSubject) %>% 
  mutate(subject = MetadataSubject) %>% 
  select(-MetadataSubject)

  
# Clean email main content field: apply tokeniser and stem words
clean_email_content <- emails %>% 
  select(DocNumber, ExtractedReleaseInPartOrFull, ExtractedBodyText, RawText) %>% 
  mutate(edited = ifelse(ExtractedReleaseInPartOrFull == "RELEASE IN FULL", 0, 1)) %>% 
  mutate(email_pdf = ExtractedBodyText,
         email_raw = RawText) %>% 
  select(-ExtractedReleaseInPartOrFull, -ExtractedBodyText, -RawText)


# Cleaned dataframe to output
parsed_data <- emails %>% 
  select(DocNumber) %>% 
  left_join(utc) %>% 
  left_join(sender) %>% 
  left_join(receiver) %>% 
  left_join(cced) %>% 
  left_join(subject) %>% 
  left_join(clean_email_content)


write_csv(parsed_data, './data/parsed_emails.csv')

