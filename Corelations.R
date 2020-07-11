### Read and clean data for correlation study ###
library(tidyverse)

                        ###HDI###

# Read HDI 2018 data
countries <- read.csv("D:/Projekt_COVID/HDI_2018.csv",
                        header = TRUE, sep = ",",stringsAsFactors = FALSE)
countries <- as_tibble(countries)
countries

# Tidy countries HDI data
countries_1 <- countries %>%
  select(-X,-HDI.Rank..2018.)
countries_1

countries_2 <- countries_1 %>%
  mutate(Country = tolower(Country))

# Make changes for matching process

countries_3 <- apply(countries_2,2,function(x)gsub("\\s*\\([^\\)]+\\)","",x))
countries_3 <- apply(countries_3,2,function(x)gsub("viet nam","vietnam",x))
countries_3 <- apply(countries_3,2,function(x)gsub("united states","usa",x))
countries_3 <- apply(countries_3,2,function(x)gsub("united kingdom","uk",x))
countries_3 <- apply(countries_3,2,function(x)gsub("saudi arabia","saudiarabia",x))
countries_3 <- apply(countries_3,2,function(x)gsub("south africa","southafrica",x))
countries_3 <- apply(countries_3,2,function(x)gsub("russian federation","russia",x))
countries_3 <- apply(countries_3,2,function(x)gsub("new zealand","newzealand",x))
countries_3 <- apply(countries_3,2,function(x)gsub("korea","southkorea",x))
countries_3 <- apply(countries_3,2,function(x)gsub("costa rica","costarica",x))
countries_3 <- apply(countries_3,2,function(x)gsub("czechia","czechrepublic",x))
countries_3 <- apply(countries_3,2,function(x)gsub("north macedonia","macedonia",x))
countries_3 <- apply(countries_3,2,function(x)gsub("syrian arab republic","syria",x))
countries_3 <- apply(countries_3,2,function(x)gsub("brunei darussalam","brunei",x))

countries_4 <- as_tibble(countries_3)
countries_4



# Match HDI to output data from COVID_countries_all
countries_5 <- countries_4$X2018[match(px$Country,countries_4$Country)]
countries_5 <- as_tibble(countries_5)
countries_5

### Tidy countries_5 tibble

# Make value as double
countries_6 <- countries_5$value %>%
  as.double()

countries_6 <- as_tibble(countries_6)

# Bind tibbles

countries_6 <- bind_cols(px,countries_6)
countries_6
str(countries_6)

# Solve problem with Taiwan and Somalia (no HDI for 2018) variables

countries_7  <- countries_6 %>%
  slice(c(1:15,17:122))
countries_7  <- countries_7 %>%
  slice(c(1:116,118:121))
countries_7

countries_7 <- countries_7 %>%
  add_row(Country = "taiwan",Number = 283, value=0.880)
countries_7 <- countries_7 %>%
  add_row(Country = "somalia",Number = 2, value=0)
countries_7

# Arrange in order
countries_7 <- countries_7 %>%
  arrange(desc(Number))



countries_7 <- countries_7 %>%
  rename("HDI_2018"="value")
countries_7



                                ### Population ###
# Read population 2018 data
population_1 <- read.csv("D:/Projekt_COVID/Population_2018.csv", sep = ",", stringsAsFactors = FALSE)
population_1 <- as_tibble(population_1)
population_1

# Tidy population 2018 data
population_2 <- population_1 %>%
  select(-X,-HDI.Rank..2018. )
population_2
population_3 <- population_2 %>%
  mutate(Country = tolower(Country))

# Make changes for matching process

 population_4 <- apply(population_3,2,function(x)gsub("\\s*\\([^\\)]+\\)","",x))
 population_4 <- apply(population_4,2,function(x)gsub("viet nam","vietnam",x))
 population_4 <- apply(population_4,2,function(x)gsub("united states","usa",x))
 population_4 <- apply(population_4,2,function(x)gsub("united kingdom","uk",x))
 population_4 <- apply(population_4,2,function(x)gsub("saudi arabia","saudiarabia",x))
 population_4 <- apply(population_4,2,function(x)gsub("south africa","southafrica",x))
 population_4 <- apply(population_4,2,function(x)gsub("russian federation","russia",x))
 population_4 <- apply(population_4,2,function(x)gsub("new zealand","newzealand",x))
 population_4 <- apply(population_4,2,function(x)gsub("korea","southkorea",x))
 population_4 <- apply(population_4,2,function(x)gsub("costa rica","costarica",x))
 population_4 <- apply(population_4,2,function(x)gsub("czechia","czechrepublic",x))
 population_4 <- apply(population_4,2,function(x)gsub("north macedonia","macedonia",x))
 population_4 <- apply(population_4,2,function(x)gsub("syrian arab republic","syria",x))
 population_4 <- apply(population_4,2,function(x)gsub("brunei darussalam","brunei",x))
 
 
 
 population_4 <- as_tibble(population_4)
 population_4
 
 
 
 # Match population to output data from COVID_countries_all
 population_5 <- population_4$X2018[match(px$Country,population_4$Country)]
 population_5 <- as_tibble(population_5)
 population_5
 
 ### Tidy population_6 tibble
 
 # Make value as double
 population_6 <- population_5$value %>%
   as.double()
 
 population_6 <- as_tibble(population_6)
 
 # Bind tibbles
 
 population_6 <- bind_cols(px,population_6)
 population_6
 str(population_6)
 
 # Solve problem with Taiwan variable
 
 population_7  <- population_6 %>%
   slice(c(1:15,17:122))
 population_7  <- population_7 %>%
   slice(c(1:116,118:121))
population_7
 population_7 <- population_7 %>%
   add_row(Country = "taiwan",Number = 283, value=238)
 population_7
 
 # Arrange in order
 population_7 <- population_7 %>%
   arrange(desc(Number))
 
 
 
 population_7 <- population_7 %>%
   rename("Population"="value")
population_7
 population_8 <- population_7 %>%
   mutate(Population_mln = Population*1e6)
population_8 
 
population_9 <- population_8 %>%
  mutate(Articles_perMln=(Number*1e6)/Population_mln)

population_9


                        ### Final data preparation ###

# Pull hdi data from countries_7 tibble
hdi <- countries_7 %>%
  pull(HDI_2018)
hdi
hdi <- as_tibble(hdi)

# Rename value to HDI_2018
hdi <- hdi %>%
  rename("HDI_2018"="value")

# Prepare final data for correlation analysis
final_data <- bind_cols(population_9,hdi)

# Save data
saveRDS(final_data,"D:/Projekt_COVID/readyData_for_correlation.RDS")
