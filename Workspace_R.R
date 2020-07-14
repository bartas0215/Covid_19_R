
readyData_for_correlation <- readyData_for_correlation %>%
  rename("Number of articles"="Number")
readyData_for_correlation

readyData_for_correlation_covid <- readyData_for_correlation_covid %>%
  rename("Number of articles"="Number")
readyData_for_correlation_covid

saveRDS(readyData_for_correlation,"D:/Projekt_COVID/readyData_for_correlation.RDS")
saveRDS(readyData_for_correlation_covid,"D:/Projekt_COVID/readyData_for_correlation_covid.RDS")
