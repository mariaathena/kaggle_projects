# Natural Language Processing - U.S. Secretary of State Hillary R. Clinton Emails
# Maria Athena B. Engesaeth
# 00_exploration
#
# Prepare working environment------------------------------------------------------

# Clean up
rm(list = ls())

# library(magrittr)
# library(tidyr)
# library(dplyr)
# select <- dplyr::select
library(readr)
library(quanteda)
tokenize <- quanteda::tokenize

library(countrycode)
library(RSQLite) # SQLite access
# library(qdapDictionaries) # word list and dictionaries
# library(rworldmap) # worldmap by region with aggregation


# Load data -----------------------------------------------------------------------

emails <- read_csv("./data/Emails.csv")
aliases <- read_csv("./data/Aliases.csv")
receivers <- read_csv("./data/EmailReceivers.csv")
people <- read_csv("./data/Persons.csv")

# Load data
summary(emails)

ieDfm <- dfm(ie2010Corpus, 
             ignoredFeatures = c(stopwords("english"), "will"),
             stem = TRUE)
