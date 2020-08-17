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
  distinct(title) %>%
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

# Change names of some countries

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

# Remove punctuation
e <- gsub("[[:punct:]\n]","",s)
e
# Split data at word boundaries
f <- strsplit(e, " ")
f

### Prepare world.cities for analysis

# Load world.cities data
data("world.cities")

# Pull country.etc from world.cities
r <- world.cities %>%
  pull(country.etc)

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
l <- clusterApply(cluster_1,f,function(x)x[which(toupper(x) %in% toupper(r$value))])

# Stop cluster
stopCluster(cluster_1)

## Tidy outcome data 
l <- do.call(rbind, lapply(l, as.data.frame))

# Check data structure
str(l)
l

### Tidy output data

# Change factor to character variable
o <- data.frame(lapply(l, as.character), stringsAsFactors=FALSE)

# Count countries
o <- o %>%
 mutate(X..i..=tolower(X..i..))
m <- count(o)
m

# Arrange results in decreasing order
m <- as_tibble(m)
m <- m %>%
  arrange(desc(freq))
m

## Delete useless data

# Remove guadalupe
px <- m %>%
  slice(c(1:97,99:156))
# Remove martinique
px <- px %>%
  slice(c(1:98,100:155))
# Remove gibraltar
px <- px %>%
  slice(c(1:115,117:154))
# Remove sicily
px <- px %>%
  slice(c(1:117,119:153))
# Remove Somaila
px <- px %>%
  slice(c(1:141,143:152))
# Remove Greenland
px <- px %>%
  slice(c(1:144,146:151))
# Remove Reunion
px <- px %>%
  slice(c(1:148,150))
# Rename columns
px <- px %>% 
  rename("Number_of_authors"="freq")
px <- px %>%
  rename("Country"="X..i..")
px

# Save results 
saveRDS(px,"D:/Projekt_COVID/matched_countries.RDS")

