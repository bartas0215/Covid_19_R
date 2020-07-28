#Load tidyverse package
library(tidyverse)


# Count univeristy names
xs <- c %>%
  distinct(address)

str_count(xs,pattern = "University of Gothenburg")


# Count articles by PMID
vc <- raw_data_full %>%
  distinct(PMID) %>%
  count()
vc


# Count number of cooperations
xcv <- raw_data_full %>%
  distinct(address,.keep_all= TRUE) %>%
  count(pmid)
xcv

