###sample script - country analysis####
library(tidyverse)
library(easyPubMed)
library(maps)
library(plyr)
library(parallel)
# Load if any conflict had occured
library(conflicted)
#Download data about Coronavirus COVID 19 meta analysis
ml_query <- "COVID 19 OR novel coronavirus OR
coronavirus Wuhan OR SARS-CoV-2[TIAB] AND (2019/12/31[PDAT]:2020/06/30[PDAT])"

out1 <- batch_pubmed_download(pubmed_query_string = ml_query, batch_size = 5000,
                              dest_dir = "D:/Projekt_COVID/COVID_Data_1", format = "xml")
readLines(out1[1])[1:30]

#### Retrieving data 

## For each batched file ##

# Load downloaded data
mypath_5 = "D:/Projekt_COVID/COVID_Data_5"
setwd(mypath_5)

# Create list of text files
txt_files_ls_5 = list.files(path=mypath_5, pattern="*.txt") 
txt_files_ls_5
# Save downloaded data as df regarding publication authors
a5 <- table_articles_byAuth(txt_files_ls_5,included_authors = "all",
                            max_chars = 500,autofill = TRUE,dest_file = "D:/Projekt_COVID",getKeywords = FALSE,encoding = "UTF8")

# Save raw data from table_articles
saveRDS(a5,"D:/Projekt_COVID/raw_data_5.RDS")

# Bind all data frames
raw_data_full <- do.call("rbind", list(raw_data,raw_data_1,raw_data_2,raw_data_3,raw_data_4,raw_data_5))
saveRDS(raw_data_full,"D:/Projekt_COVID/raw_data_full.RDS")

# Check number of articles
raw_data_full %>%
  distinct(title,.keep_all = TRUE) %>%
  count()

# Check structure of the data 
str(raw_data_full)

# Save df as tibble
b <- as_tibble(raw_data_full)

# Delete unnecessary columns
c <- b %>%
  select(-abstract, -keywords,-email)
c
# Distinct address column from the rest of the tibble
d <- c %>%
  distinct(address)
d

#####
d1 <- c %>%
  distinct(address,.keep_all = TRUE)

d2 <- d1 %>%
  pull(journal)
d2 <- as_tibble(d2)


#####


s <- gsub("United Kingdom","UK",d)
s <- gsub("United States","USA",s)
s <- gsub("South Korea","Southkorea",s)
s <- gsub("Saudi Arabia","Saudiarabia",s)
s <- gsub("New Zealand","Newzealand",s)
s <- gsub("the Netherlands","Netherlands",s)
s <- gsub("South Africa","Southafrica",s)
s <- gsub("Czech Republic", "Czechrepublic",s) 
s <- gsub("Costa Rica", "Costarica",s)
s <- gsub("Jersey", "USA",s)
s <- gsub("El Salvador", "ElSalvador",s)
s <- gsub("Ivory Coast", "IvoryCoast",s)
s <- gsub("Sri Lanka", "SriLanka",s)
s <- gsub("United Arab Emirates", "UAE",s)
s

s1 <- as_tibble(s)
s1


# Remove punctuation
e <- gsub("[[:punct:]\n]","",s)
e

e1 <- apply(s,2,function(x)gsub("[[:punct:]\n]","", x))
e1



# Split data at word boundaries
f1 <- strsplit(e1, " ")
f1

### Prepare world.cities for analysis

# Load world.cities data
data("world.cities")

# Pull country.etc from world.cities
r <- world.cities %>%
  pull(country.etc)

r
#####NEW####

# Change names of some countries
r <- gsub("Korea South","Southkorea",r)
r <- gsub("Saudi Arabia","Saudiarabia",r)
r <- gsub("New Zealand","Newzealand",r)
r <- gsub("South Africa","Southafrica",r)
r <- gsub("Czech Republic", "Czechrepublic",r)
r <- gsub("Costa Rica", "Costarica",r)
r <- gsub("Jersey", "USA",r) 
r <- gsub("Bosnia and Herzegovina", "Bosnia",r) 
r <- gsub("El Salvador", "ElSalvador",r)
r <- gsub("Ivory Coast", "IvoryCoast",r)
r <- gsub("Sri Lanka", "SriLanka",r)
r <- gsub("United Arab Emirates", "UAE",r)
r <- as_tibble(r)



r                              ### Matching countries ###

### Cluster data

# Detect number of cores
detectCores()

# Make cluster 
cluster_1 <- makeCluster(3)

# Export needed data to every cluster
clusterExport(cluster_1,"r")

# Apply function
l <- clusterApply(cluster_1,f1,function(x)x[which(toupper(x) %in% toupper(r$value))])

# Stop cluster
stopCluster(cluster_1)


# Unlist and tidy data
l
l2 <- unlist(lapply(l,function(x) if(identical(x,character(0))) ' ' else paste0(x,collapse=' ')))
l3 <- as_tibble(l2)

# Bind data
d3 <- bind_cols(d2,l3)

# Correction of duplicated data
d4 <- sapply(strsplit(as.character(d3$value1), split="\\s+"), function(x) {
  paste(unique(trimws(x)), collapse = ', ') } )
d4 <- as_tibble(d4)

# Bind data again
d5 <- bind_cols(d2,d4)

#### Match journals to their respective categories (sci_journal_13) 

# Prepare data 

# Remove all data in parenthesis
q2 <- apply(d2,2,function(x)gsub("\\s*\\([^\\)]+\\)","",x))

# Remove all data after colon
q2 <- apply(q2,2,function(x)gsub(":.*","",x))

# Remove commas
q2 <- apply(q2,2,function(x)gsub(",","",x))

# Remove equal sign 
q2 <- apply(q2,2,function(x)gsub("=","",x))

# Change &amp; to and
q2 <- apply(q2,2,function(x)gsub("&amp;", "and", x))

# Remove the from text 
q2 <- apply(q2,2,function(x)gsub("the", "", x))

# Remove whitespace
q2 <- apply(q2,2,function(x)gsub('\\s+', '',x))
q2 <- apply(q2,2,function(x)gsub(' +',' ',x))

# Save as tibble
q2 <- as_tibble(q2)

# Remove punctuation from journal column and make tibble again 
e2 <- q2$value %>%
  removePunctuation()
e2
e2 <- as_tibble(e2)
e2

# Lower letters in journal column
glimpse(e2)
f2 <- e2 %>%
  mutate(value =tolower(value))


### Matching data

con_1 <- sci_journal_13$Categories[match(f2$value,sci_journal_13$Title)]
con_1 <- as_tibble(con_1)

# Bind columns
d6 <- bind_cols(con_1,d4)

# Rename columns
d7 <- d6 %>%
  rename("Category"="value")

d7 <- d7 %>%
  rename("Country"="value1")

# Count countries on basis of categories
d8 <- d7 %>%
  group_by(Country) %>%
  count(Category)


# Save data
saveRDS(d7,"D:/Projekt_COVID/countries_categories_ready" )
