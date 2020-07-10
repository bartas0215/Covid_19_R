countries <- read.csv("D:/Projekt_COVID/HDI_2018.csv",
                        header = TRUE, sep = ",",stringsAsFactors = FALSE)
countries <- as_tibble(countries)
countries

countries_1 <- countries %>%
  select(-X)
countries_1


population_1 <- read.csv("D:/Projekt_COVID/Population_2018.csv", sep = ",", stringsAsFactors = FALSE)
population_1 <- as_tibble(population_1)
population_1

population_2 <- population_1 %>%
  select(-X,-HDI.Rank..2018. )
population_2
population_3 <- population_2 %>%
  mutate(Country = tolower(Country))
population_3
