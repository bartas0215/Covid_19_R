###sample script - Publications matching####
library(tidyverse)
library(easyPubMed)
library(tm)
library(plyr)
library(xlsx)
#Download data about Coronavirus COVID 19 meta analysis
ml_query <- "COVID 19 OR novel coronavirus OR
coronavirus Wuhan OR SARS-CoV-2[TIAB] AND 2019/12/31:2020/06/30[DP]
AND Review[PT]"
out1 <- batch_pubmed_download(pubmed_query_string = ml_query, batch_size = 1000,
                              dest_dir = NULL, format = "xml")
readLines(out1[1])[1:30]

# Load downloaded data
mypath = "D:/Projekt_COVID/COVID_Data"
setwd(mypath)

# Create list of text files
txt_files_ls = list.files(path=mypath, pattern="*.txt") 

# Save downloaded data as df regarding publication authors
a <- table_articles_byAuth(out1,included_authors = "all",
                           max_chars = 500,autofill = TRUE,dest_file = "D:/Data_R_Meta/journal.rds",getKeywords = FALSE,encoding = "UTF8")

# Check structure of the data 
str(a)

# Save df as tibble
b1 <- as_tibble(raw_data)

# Delete unnecessary columns
c1 <- b1 %>%
  select(-abstract, -keywords,-email)
c1
# Distinct journal column from the rest of the tibble
d1 <- distinct(c1,journal)
d1
# Make all letters in lowercase
d1 <- d1  %>% 
  mutate(journal = tolower(journal))
d1

                    ### Prepare data from EasyPubMed###



# Remove all data in parenthesis
q1 <- apply(d1,2,function(x)gsub("\\s*\\([^\\)]+\\)","",x))

# Remove all data after colon
q1 <- apply(q1,2,function(x)gsub(":.*","",x))

# Remove commas
q1 <- apply(q1,2,function(x)gsub(",","",x))

# Remove equal sign 
q1 <- apply(q1,2,function(x)gsub("=","",x))

# Change &amp; to and
q1 <- apply(q1,2,function(x)gsub("&amp;", "and", x))

# Remove the from text 
q1 <- apply(q1,2,function(x)gsub("the", "", x))

# Remove whitespace
q1 <- apply(q1,2,function(x)gsub('\\s+', '',x))
q1 <- apply(q1,2,function(x)gsub(' +',' ',x))

# Save as tibble
q1 <- as_tibble(q1)

# Remove punctuation from journal column and make tibble again 
e1 <- q1$journal %>%
  removePunctuation()
e1
e1 <- as_tibble(e1)
e1

# Rename value column to Title 
f1 <- e1 %>%
  rename("Title"= "value")
f1
                          
                        ### Scimago journals - data loading ###

# Load Scimago journal database 
sci_journal <- read.csv("D:/Projekt_COVID/scimagojr_2019.csv",
                        header = TRUE, sep = ";",stringsAsFactors = FALSE)
sci_journal <- as_tibble(sci_journal)
sci_journal
# Check structure of the data
glimpse(sci_journal)


                      ### Scimago data preparation ###
### Prepare Scimago database for matching (pull Title column)###
sci_journal_1 <- sci_journal %>%
  pull(Title)
sci_journal_1
sci_journal_1 <-as_tibble(sci_journal_1)

# Make all the letters in lowercase
sci_journal_1 <- sci_journal_1 %>%
  mutate(value =tolower(value))

## Make changes in Scimago database 

# Remove all data after colon
sci_journal_1 <- apply(sci_journal_1,2,function(x)gsub(":.*","",x))

# Remove "the" 
sci_journal_1 <- apply(sci_journal_1,2,function(x)gsub("the","",x))


# Remove punctuation from Title column
sci_journal_2 <- sci_journal_1 %>%
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

# Prepare data
sci_journal_11 <- apply(sci_journal_10,2,function(x)gsub(';.*', '',x))
sci_journal_11 <- apply(sci_journal_11,2,function(x)gsub("\\s*\\([^\\)]+\\)","",x))
sci_journal_11 <- as_tibble(sci_journal_11)
# Rename value to Categories
sci_journal_12 <- sci_journal_11 %>%
  rename("Categories"= "value")
sci_journal_12

# Bind two tibbles (Title and Categories)
sci_journal_13 <- bind_cols(sci_journal_4,sci_journal_12)
sci_journal_13


                      ### Matching data_categories ###

# Match data
sci_journal_14 <- sci_journal_13$Categories[match(f1$Title,sci_journal_13$Title)]
sci_journal_14
sci_journal_14 <- as_tibble(sci_journal_14)
sci_journal_14


# Drop missing rows
sci_journal_15 <- sci_journal_14 %>%
  drop_na()
sci_journal_15

# COunt categories
sci_journal_16 <- count(sci_journal_15)
sci_journal_16 <- as_tibble(sci_journal_16)
sci_journal_16

sci_journal_16 <- sci_journal_16 %>%
  arrange(desc(freq))
print(sci_journal_16, n=124)

#SLice 20 from the top
sci_journal_17 <- sci_journal_16 %>%
  slice(1:20)
sci_journal_17

# Rename columns
sci_journal_18 <- sci_journal_17 %>%
  rename("Categories"= "value")
sci_journal_18 <- sci_journal_18 %>%
  rename("Number"= "freq")

sci_journal_18


# Save as RDS file
saveRDS(sci_journal_18,"D:/Projekt_COVID/scimago_categories_readyData.RDS")

# Save as excel file
write.xlsx(sci_journal_18,file = "D:/Projekt_COVID/Tabels/categories_scimago.xlsx")

                  ### Matching data_q ###

sci_journal_10q <- sci_journal %>%
  pull(Categories)
sci_journal_10q <- as_tibble(sci_journal_10q)
sci_journal_10q

# Remove all text except for Q value
sci_journal_11q <- apply(sci_journal_10q,2,function(x)gsub(';.*', "",x))
sci_journal_11q <- apply(sci_journal_11q,2,function(x)gsub("\\s+\\([^)]*\\)(*SKIP)(*FAIL)|.", "", perl = TRUE,x))
sci_journal_11q <- as_tibble(sci_journal_11q)
sci_journal_11q

# Remove additional words
sci_journal_12q <- apply(sci_journal_11q,2,function(x)gsub('(miscellaneous)', "",x))
sci_journal_12q <- apply(sci_journal_12q,2,function(x)gsub('(social science)', "",x))
sci_journal_12q <- apply(sci_journal_12q,2,function(x)gsub('(medical)', "",x))
sci_journal_12q <- apply(sci_journal_12q,2,function(x)gsub('(clinical)', "",x))
sci_journal_12q <- as_tibble(sci_journal_12q)
sci_journal_12q



# Remove parenthesis
sci_journal_13q <- apply(sci_journal_12q,2,function(x)gsub("[()]","",x))
sci_journal_13q <- as_tibble(sci_journal_13q)
sci_journal_13q

# Remove whitespace
sci_journal_13q <- apply(sci_journal_13q,2,function(x)gsub('\\s+', '',x))
sci_journal_13q <- as_tibble(sci_journal_13q)
sci_journal_13q

# Bind the table

sci_journal_14q <- bind_cols(sci_journal_4,sci_journal_13q)
sci_journal_14q

# Match data 

sci_journal_15q <- sci_journal_14q$value[match(f1$Title,sci_journal_14q$Title)]
sci_journal_15q <- as_tibble(sci_journal_15q)
sci_journal_15q

# Drop missing rows
sci_journal_15q <- sci_journal_15q %>%
  drop_na()
sci_journal_15q


### Continuation in quartile script

