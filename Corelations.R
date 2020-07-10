countries <- read.csv("D:/Projekt_COVID/HDI_2018.csv",
                        header = TRUE, sep = ",",stringsAsFactors = FALSE)
countries <- as_tibble(countries)
countries

countries_1 <- countries %>%
  select(-X)
countries_1



