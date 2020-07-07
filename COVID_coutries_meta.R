###sample script - country analysis####
library(tidyverse)
library(easyPubMed)
library(maps)
library(plyr)
#Download data about Coronavirus COVID 19 meta analysis
ml_query <- "COVID 19 OR novel coronavirus OR
coronavirus Wuhan OR SARS-CoV-2[TIAB] AND 2019/12/31:2020/06/30[DP]
        AND Meta-Analysis[PT] "
out1 <- batch_pubmed_download(pubmed_query_string = ml_query, batch_size = 180,
        dest_dir = NULL, format = "xml")
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
s <- gsub("United States","USA",d)
s <- gsub("South Korea","S_Korea",d)
s <- gsub("Saudi Arabia","S_Arabia",d)
s <- gsub("New Zealand","N_Zealand",d)
s <- gsub("the Netherlands","Netherlands",d)

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


### Matching countries

#Match on country in world.countries
CountryList_raw <- (lapply(f, function(x)x[which(toupper(x) %in% toupper(world.cities$country.etc))]))
g <- do.call(rbind, lapply(CountryList_raw, as.data.frame))

# Check data structure
str(g)

# Count countries
h <- count(g)
h

# Arrange results in decreasing order
i <- as_tibble(h)
i <- i %>%
  arrange(desc(freq))
i



