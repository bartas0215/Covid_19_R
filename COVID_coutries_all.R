###sample script - country analysis####
library(tidyverse)
library(easyPubMed)
library(maps)
library(plyr)
library(parallel)
#Download data about Coronavirus COVID 19 meta analysis
ml_query <- "COVID 19 OR novel coronavirus OR
coronavirus Wuhan OR SARS-CoV-2[TIAB] AND 2019/12/31:2020/06/30[DP]"

out1 <- batch_pubmed_download(pubmed_query_string = ml_query, batch_size = 1000,
dest_dir = "D:/Projekt_COVID/COVID_Data", format = "xml")
readLines(out1[1])[1:30]

# Save downloaded data as df regarding publication authors
a <- table_articles_byAuth(out1,included_authors = "all",
     max_chars = 500,autofill = TRUE,dest_file = "D:/Data_R_Meta/Dane_meta.rds",getKeywords = FALSE,encoding = "UTF8")

# Check structure of the data 
str(a)

# Save df as tibble
b <- as_tibble(a)

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
s <- gsub("South Korea","S_Korea",s)
s <- gsub("Saudi Arabia","S_Arabia",s)
s <- gsub("New Zealand","N_Zealand",s)
s <- gsub("the Netherlands","Netherlands",s)
s <- gsub("South Africa","S_Africa",s)
s <- gsub("Czech Republic", "C_Republic",s) 
s <- gsub("Costa Rica", "C_Rica",s)

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
r <- gsub("Korea South","S_Korea",r)
r <- gsub("Saudi Arabia","S_Arabia",r)
r <- gsub("New Zealand","N_Zealand",r)
r <- gsub("South Africa","S_Africa",r)
r <- gsub("Czech Republic", "C_Republic",r)
r <- gsub("Costa Rica", "C_Rica",r)
                              

                              ### Matching countries ###

### Cluster data

# Detect number of cores
detectCores()

# Make cluster 
cluster_1 <- makeCluster(3)

# Export needed data to every cluster
clusterExport(cluster_1,"world.cities")

# Apply function
l <- clusterApply(cluster_1,f,function(x)x[which(toupper(x) %in% toupper(world.cities$country.etc))])

# Stop cluster
stopCluster(cluster_1)

## Tidy outcome data 
l <- do.call(rbind, lapply(l, as.data.frame))

# Check data structure
str(l)
l
# Count countries
m <- count(l)
m
# Arrange results in decreasing order
m <- as_tibble(m)
m <- m %>%
  arrange(desc(freq))
m



