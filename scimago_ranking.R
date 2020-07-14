library(xlsx)
library(stringr)
library(tidyverse)

# Load data
ranking <- read.csv("D:/Projekt_COVID/scimagojr_country_rank_2019.csv",
                      header = TRUE, sep = ",",stringsAsFactors = FALSE)
ranking <- as_tibble(ranking)
ranking

# Tidy data for matching

ranking_1 <- ranking %>%
  pull(Rank)
ranking_1 <- as_tibble(ranking_1)


ranking_2 <- ranking %>%
  pull(Country)
ranking_2 <- as_tibble(ranking_2)

ranking_3 <- bind_cols(ranking_1,ranking_2)

# Change countries name and lowercase them
ranking_3 <- ranking_3 %>%
  mutate(value1=tolower(value1))


ranking_4 <- apply(ranking_3,2,function(x)gsub("viet nam","vietnam",x))
ranking_4 <- apply(ranking_4,2,function(x)gsub("united states","usa",x))
ranking_4 <- apply(ranking_4,2,function(x)gsub("united kingdom","uk",x))
ranking_4 <- apply(ranking_4,2,function(x)gsub("saudi arabia","saudiarabia",x))
ranking_4 <- apply(ranking_4,2,function(x)gsub("south africa","southafrica",x))
ranking_4 <- apply(ranking_4,2,function(x)gsub("russian federation","russia",x))
ranking_4 <- apply(ranking_4,2,function(x)gsub("new zealand","newzealand",x))
ranking_4 <- apply(ranking_4,2,function(x)gsub("south korea","southkorea",x))
ranking_4 <- apply(ranking_4,2,function(x)gsub("costa rica","costarica",x))
ranking_4 <- apply(ranking_4,2,function(x)gsub("czech republic","czechrepublic",x))
ranking_4 <- apply(ranking_4,2,function(x)gsub("north macedonia","macedonia",x))
ranking_4 <- apply(ranking_4,2,function(x)gsub("syrian arab republic","syria",x))
ranking_4 <- apply(ranking_4,2,function(x)gsub("brunei darussalam","brunei",x))

ranking_4 <- as_tibble(ranking_4)                     
str(ranking_4)


ranking_px <- matched_countries %>%
  slice(1:117,119:122)

# Match countries and ranking

ranking_5 <- ranking_4$value[match(ranking_px$Country,ranking_4$value1)]
ranking_5 <- as_tibble(ranking_5)

#### Match ranking to the rest of the table

ranking_6 <- bind_cols(readyData_for_correlation,ranking_5)
ranking_6

# Change type of variable

ranking_6 <- ranking_6 %>%
  mutate(value= as.double(value))
ranking_6

# Rename value and number
ranking_6 <- ranking_6 %>%
  rename("Scimago_rank"="value")

ranking_6 <- ranking_6 %>%
  rename("Number_of_publications"="Number")

# Make plot and analyse correlation

s <- ggplot(ranking_6,aes(x=Scimago_rank,y=Number_of_publications)) +geom_point() + geom_smooth() + scale_y_log10()
s
# Save plot
ggsave(device = "png", filename = "scimago_ranking_600_dpi.png",plot =  s,dpi = 600, 
       path = "D:/Projekt_COVID/Plots")

### Make table 

ranking_7 <- ranking_6 %>%
  select(-c(Population,Population_mln,Articles_perMln,HDI_2018,))
ranking_7

ranking_7 <- ranking_7 %>%
  slice(1:20)
ranking_7 

ranking_8 <- as.data.frame(ranking_7)
ranking_8


# Change first letter in Country to uppercase
ranking_9 <- ranking_8 %>%
  mutate(Country= str_to_title(Country))

ranking_9 <- as_tibble(ranking_9)
ranking_9
# Save RDS data 
saveRDS(ranking_9,"D:/Projekt_COVID/scimago_ranking_readyData.RDS")

# Save as excel file
write.xlsx(ranking_9,file = "D:/Projekt_COVID/Tabels/scimago_ranking.xlsx")

