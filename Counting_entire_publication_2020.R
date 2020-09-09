# Retrieve number of all publications regarding COVID 19 from from 31th December to July 2020
try({
  covid_querry_all <- get_pubmed_ids("2019/12/31[PDAT]:2020/06/30[PDAT]")
  print(covid_querry_all$Count)
}, silent = TRUE)
