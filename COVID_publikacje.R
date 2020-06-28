# Load tidyverse package
library(tidyverse)
# install easyPubMed package
install.packages("easyPubMed")
# Load easyPubMed package
library(easyPubMed)

# Retrive article through author 
try({
  my_query <- "Bartosz Nowak[AU]"
  my_query <- get_pubmed_ids(pubmed_query_string = my_query)
  my_data <- fetch_pubmed_data(my_query, encoding = "ASCII")
  listed_articles <- articles_to_list(my_data)
  custom_grep(listed_articles[[2]], "ArticleTitle", "char")}, silent = TRUE)

# Retrive sets of articles regarding COVID 19 from january to july 2020
ml_query <- "COVID 19[TIAB] AND 2020/01:2020/06[DP]"
out1 <- batch_pubmed_download(pubmed_query_string = ml_query, batch_size = 180)
readLines(out1[1])[1:30]
out1

# Retrive number of all publicatons regarding COVID 19 from january to july 2020
try({
 covid_querry_all <- get_pubmed_ids("COVID 19[TIAB] AND 2020/01/01:2020/06/27[DP]")
  print(covid_querry_all$Count)
}, silent = TRUE)

# Retrive number of all journal articles with abstract regarding COVID 19 from january to july 2020
try({
  covid_querry_journal <- get_pubmed_ids("COVID 19[TIAB] AND 2020/01/01:2020/06/27[DP]
       Journal Article[PT] ")
  print(covid_querry_journal$Count)
}, silent = TRUE)

# Retrive number of review articles regarding COVID 19 from january to july 2020
try({
  covid_querry_review <- get_pubmed_ids("COVID 19[TIAB] AND 2020/01/01:2020/06/27[DP]
       Review[PT] ")
  print(covid_querry_review$Count)
 }, silent = TRUE)

# Retrive number of meta_analysis articles regarding COVID 19 from january to july 2020
try({
  covid_querry_meta <- get_pubmed_ids("COVID 19[TIAB] AND 2020/01/01:2020/06/27[DP]
       Meta-Analysis[PT] ")
  print(covid_querry_meta$Count)
}, silent = TRUE)

# Retrive number of guideline articles regarding COVID 19 from january to july 2020
try({
  covid_querry_guide <- get_pubmed_ids("COVID 19[TIAB] AND 2020/01/01:2020/06/27[DP]
       Guideline[PT]")
  print(covid_querry_guide$Count)
}, silent = TRUE)

ml_query <- "COVID 19[TIAB] AND 2020/01/01:2020/06/27[DP]
        AND Meta-Analysis[PT] "
out1 <- batch_pubmed_download(pubmed_query_string = ml_query, batch_size = 180,dest_dir=
      "D:/Data_R_Meta", format = "xml")
readLines(out1[1])[1:30]
out1
