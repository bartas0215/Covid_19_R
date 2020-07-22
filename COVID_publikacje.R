# Load tidyverse package
library(tidyverse)
# install easyPubMed package
install.packages("easyPubMed")
# Load easyPubMed package
library(easyPubMed)

# Retrieve sets of articles regarding COVID 19 from 31th December to July 2020
ml_query <- "COVID 19 OR novel coronavirus OR
coronavirus Wuhan OR SARS-CoV-2[TIAB]  AND 2019/12/31:2020/06/30[DP]"
out1 <- batch_pubmed_download(pubmed_query_string = ml_query, batch_size = 180)
readLines(out1[1])[1:30]
out1

# Retrieve number of all publications regarding COVID 19 from from 31th December to July 2020
try({
 covid_querry_all <- get_pubmed_ids("COVID 19 OR novel coronavirus OR
coronavirus Wuhan OR SARS-CoV-2[TIAB] AND (2019/12/31[PDAT]:2020/06/30[PDAT])")
  print(covid_querry_all$Count)
}, silent = TRUE)

# Retrieve number of all journal articles with abstract regarding COVID 19 from 31th December to July 2020
try({
  covid_querry_journal <- get_pubmed_ids("COVID 19 OR novel coronavirus OR
coronavirus Wuhan OR SARS-CoV-2[TIAB] AND 2019/12/31:2020/06/30[DP] AND
       Journal Article[PT] ")
  print(covid_querry_journal$Count)
}, silent = TRUE)

# Retrieve number of review articles regarding COVID 19 from 31th December to July 2020
try({
  covid_querry_review <- get_pubmed_ids("COVID 19 OR novel coronavirus OR
coronavirus Wuhan OR SARS-CoV-2[TIAB] AND 2019/12/31:2020/06/30[DP] AND
       Review[PT] ")
  print(covid_querry_review$Count)
 }, silent = TRUE)

# Retrieve number of meta_analysis articles regarding COVID 19 from 31th December to July 2020
try({
  covid_querry_meta <- get_pubmed_ids("COVID 19 OR novel coronavirus OR
coronavirus Wuhan OR SARS-CoV-2[TIAB] AND 2019/12/31:2020/06/30[DP] AND
       Meta-Analysis[PT] ")
  print(covid_querry_meta$Count)
}, silent = TRUE)

# Retrieve number of guideline articles regarding COVID 19 from 31th December to July 2020
try({
  covid_querry_guide <- get_pubmed_ids("COVID 19 OR novel coronavirus OR
coronavirus Wuhan OR SARS-CoV-2[TIAB] AND 2019/12/31:2020/06/30[DP] AND
       Guideline[PT]")
  print(covid_querry_guide$Count)
}, silent = TRUE)



ml_query <- "COVID 19 OR novel coronavirus OR
coronavirus Wuhan OR SARS-CoV-2[TIAB] AND 2019/12/31:2020/06/30[DP]
        AND Meta-Analysis[PT] "
out1 <- batch_pubmed_download(pubmed_query_string = ml_query, batch_size = 180,
                                dest_dir = NULL, format = "xml")
readLines(out1[1])[1:30]
out1

a <- table_articles_byAuth(out1,included_authors = "all",
                      max_chars = 500,autofill = TRUE,dest_file = "D:/Data_R_Meta/Dane_meta.rds",getKeywords = FALSE,encoding = "UTF8")
a
library(tidyverse)
str(a)


b <- as_tibble(a)
b


c <- b %>%
  select(-abstract, -keywords,-email)
c
