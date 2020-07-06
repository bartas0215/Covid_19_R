###sample script - Publications matching####
library(tidyverse)
library(easyPubMed)
#Download data about Coronavirus COVID 19 meta analysis
ml_query <- "COVID 19 OR novel coronavirus OR
coronavirus Wuhan OR SARS-CoV-2[TIAB] AND 2019/12/31:2020/06/30[DP]
        AND Guideline[PT] "
out1 <- batch_pubmed_download(pubmed_query_string = ml_query, batch_size = 180,
                              dest_dir = NULL, format = "xml")
readLines(out1[1])[1:30]

# Save downloaded data as df regarding publication authors
a <- table_articles_byAuth(out1,included_authors = "all",
                           max_chars = 500,autofill = TRUE,dest_file = "D:/Data_R_Meta/journal.rds",getKeywords = FALSE,encoding = "UTF8")

# Check structure of the data 
str(a)

# Save df as tibble
b <- as_tibble(a)

# Delete unnecessary columns
c <- b %>%
  select(-abstract, -keywords,-email)
c
# Distinct journal column from the rest of the tibble
d <- distinct(c,journal)
d
# Make all letters in lowercase
d <- d  %>% 
  mutate(journal = tolower(journal))
d

                    ### Prepare data from EasyPubMed###

# Remove all data in parenthesis
q <- apply(d,2,function(x)gsub("\\s*\\([^\\)]+\\)","",x))

# Remove all data after colon
q <- apply(q,2,function(x)gsub(":.*","",x))

# Remove commas
q <- apply(q,2,function(x)gsub(",","",x))

# Remove euqal sign 
q <- apply(q,2,function(x)gsub("=","",x))

# Change &amp; to and
q <- apply(q,2,function(x)gsub("&amp;", "and", x))

# Remove whitespace
q <- apply(q,2,function(x)gsub('\\s+', '',x))
# Save as tibble
q <- as_tibble(q)

# Remove punctuation from journal column and make tibble again 
e <- q$journal %>%
  removePunctuation()
e
e <- as_tibble(e)
e
print(e,n=136)
# Rename value column to Title 
f <- e %>%
  rename("Title"= "value")
f
                          
                        ### Scimago journals - data loading ###

# Load Scimago journal database 
sci_journal <- read.csv("D:/Projekt_COVID/scimagojr_2019.csv",
                        header = TRUE, sep = ";",stringsAsFactors = FALSE)
sci_journal <- as_tibble(sci_journal)
sci_journal
# Check structure of the data
glimpse(sci_journal)

#Load tm library
library(tm)
                      ### Scimago data preparation ###
### Prepare Scimago database for matching (pull Title column)###
sci_journal_1 <- sci_journal %>%
  pull(Title)
sci_journal_1
sci_journal_1 <-as_tibble(sci_journal_1)

# Make all the letters in lowercase
sci_journal_1 <- sci_journal_1 %>%
  mutate(value =tolower(value))

# Remove punctuation from Title column
sci_journal_2 <- sci_journal_1$value %>%
  removePunctuation()
sci_journal_2 <- as_tibble(sci_journal_2)
sci_journal_2

# Rename column to Title
sci_journal_3 <- sci_journal_2 %>%
  rename("Title"= "value")
sci_journal_3

# Remove whitespace in Title column
sci_journal_4 <- apply(sci_journal_3,2,function(x)gsub('\\s+', '',x))
sci_journal_4 <- as_tibble(sci_journal_4)
sci_journal_4

### Scimago data preparation - adding Categories to Title tibble without punctuation

# Pull Categories data column from
sci_journal_10 <- sci_journal %>%
  pull(Categories)
sci_journal_10 <- as_tibble(sci_journal_10)
sci_journal_10

# Rename value to Categories
sci_journal_12 <- sci_journal_10 %>%
  rename("Categories"= "value")
sci_journal_12

# Bind two tibbles (Title and Categories)
sci_journal_13 <- bind_cols(sci_journal_4,sci_journal_12)
sci_journal_13


                      ### Matching data ###

# Match data
sci_journal_14 <- sci_journal_13$Title[match(f$Title,sci_journal_13$Title)]
sci_journal_14
sci_journal_14 <- as_tibble(sci_journal_14)
sci_journal_14

# Drop missing rows
sci_journal_15 <- sci_journal_14 %>%
  drop_na()
sci_journal_15


