# Digital marketing analytics: Expedia dataset
#
# Prepare environment -------------------------------------------------------

library(dplyr)
library(magrittr)
library(readr)
library(RPostgreSQL)

# Load data into SQL database in local pgadmin3 server ----------------------
db <- src_postgres("postgres")

lines <- tbl(db, "lines_clean")

destinations.db <- tbl(db, '.data/destinations.csv')
test.db <- tbl(db, '.data/test.csv')
train.db <- tbl(db, '.data/train_new.csv')



# test <- read.csv(....)
# tmp <- copy_to(db, "data frame name here", temporary = FALSE)
# head train.csv -n1





# train <- read_csv("./data/train.csv")
# 
# subset_train <- train[sample(1:nrow(train), floor(nrow(train) * 0.003),
#                              replace=FALSE),]
# 
# write_csv(subset_train,"./data/train_sample.csv")

