

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


ranking_px <- px %>%
  slice(1:117,119:122)

# Match countries and ranking

ranking_5 <- ranking_4$value[match(ranking_px$Country,ranking_4$value1)]
ranking_5 <- as_tibble(ranking_5)
