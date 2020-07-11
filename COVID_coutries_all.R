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
coronavirus Wuhan OR SARS-CoV-2[TIAB] AND 2019/12/31:2020/06/30[DP]"

out1 <- batch_pubmed_download(pubmed_query_string = ml_query, batch_size = 5000,
dest_dir = "D:/Projekt_COVID/COVID_Data", format = "xml")
readLines(out1[1])[1:30]

# Load downloaded data
mypath = "D:/Projekt_COVID/COVID_Data"
setwd(mypath)

# Create list of text files
txt_files_ls = list.files(path=mypath, pattern="*.txt") 


# Save downloaded data as df regarding publication authors
a <- table_articles_byAuth(txt_files_ls,included_authors = "all",
     max_chars = 500,autofill = TRUE,dest_file = "D:/Projekt_COVID",getKeywords = FALSE,encoding = "UTF8")

# Save raw data from table_articles
saveRDS(a,"D:/Projekt_COVID/raw_data.RDS")

# Check structure of the data 
str(raw_data)

# Save df as tibble
b <- as_tibble(raw_data)

# Delete unnecessary columns
c <- b %>%
  select(-abstract, -keywords,-email)
c
# Pull address column from the rest of the tibble
d <- c %>%
  pull(address)
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

# Delete useless data
px <- m %>%
  slice(c(1:121,123))

# Rename columns
px <- px %>% 
  rename("Number"="freq")
px <- px %>%
  rename("Country"="X..i..")
px

# Save results 
saveRDS(px,"D:/Projekt_COVID/matched_countries.RDS")

