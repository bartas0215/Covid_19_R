###sample script - country analysis####
library(tidyverse)
library(easyPubMed)
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
# Distinct address column from the rest of the tibble
d <- distinct(c,address)
d
# Save data as data frame
e <- as.data.frame(d)
e
# Install packages "maps" and "plyr"
install.packages("maps")
install.packages("plyr")

# Load packages 
library(maps)
library(plyr)

# Load word.cities data
data("world.cities")

# Remove punctuation
e <- gsub("[[:punct:]\n]","",e)

# Split data at word boundaries
f <- strsplit(e, " ")

#Match on country in world.countries
CountryList_raw <- (lapply(raw2, function(x)x[which(toupper(x) %in% toupper(world.cities$country.etc))]))
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



