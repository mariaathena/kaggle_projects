# Natural Language Processing - U.S. Secretary of State Hillary R. Clinton Emails
# Maria Athena B. Engesaeth
# 10_compare_email_to_events
#
# Prepare working environment------------------------------------------------------

# rm(list = ls()) # Clean up

library(magrittr)
library(readr)
library(dplyr)
select <- dplyr::select
library(quanteda)
tokenize <- quanteda::tokenize

# library(countrycode)
# library(qdapDictionaries) # word list and dictionaries
# library(rworldmap) # worldmap by region with aggregation


# Load data ---------------------------------------------------------------------------

# emails <- read_csv('./email_data/parsed_emails.csv')
# event.vocab <- read_csv("./dictionary/parsed_dict.csv")

# get email_clean dfm
source("./r/00_parse_emails.R")
# get event_dict dfm
source("./r/01_create_event_dictionary.R")


# Look for emai topic -----------------------------------------------------------------

# 
events <- c("hillary", "benghazi", "benghazi_committe",
            "arab_spring", "iran_deal", "doctrine")

email_topic <- event_dict[, events]
# hil_dfm_senti <- weight(hil_dfm_senti, type = "relFreq")




