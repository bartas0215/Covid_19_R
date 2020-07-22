final_data

              ### Total cases covid data preparation   


# Read data 
totalcov <- read.csv("D:/Projekt_COVID/total_cases_covid.csv",
                      header = FALSE, sep = ",",stringsAsFactors = FALSE)

# Slice unused data
total_cov_1 <- totalcov %>%
  slice(1,184)

total_cov_1


# Longer the table
total_cov_2 <- total_cov_1 %>% 
  pivot_longer(V3:V212)
total_cov_2

# Slice numbers and tidy data
total_cov_num <- total_cov_2 %>%
  slice(211:420)

total_cov_num <- total_cov_num %>%
  select(-c(V1,V2,name))

# Change total cov to double
total_cov_num <- total_cov_num$value %>%
  as.double()

total_cov_num <- as_tibble(total_cov_num)

              ### Total deaths covid data preparation ###


# Read data
totaldeath <- read.csv("D:/Projekt_COVID/total_deaths_covid.csv",
                     header = FALSE, sep = ",",stringsAsFactors = FALSE)


# Slice unused data
total_death_1 <- totaldeath %>%
  slice(1,184)


total_death_1


# Longer the table
total <- total_death_1 %>% 
  pivot_longer(V3:V212)
total

# Slice countries and tidy data
total_1_c <- total %>%
  slice(1:210)

total_1_c <- total_1_c %>%
  select(-c(V1,V2,name))

# Slice numbers and tidy data
total_1_num <- total %>%
  slice(211:420)

# Make as double
total_1_num <- total_1_num$value %>%
  as.double()
total_1_num <- as_tibble(total_1_num)


# Bind cols
total_death_3 <- bind_cols(total_1_c,total_1_num)

        
                        ### Final data preparation

# Bind cols
covid_data <- bind_cols(total_death_3,total_cov_num)
covid_data

# Slice somalia
covid_data <- covid_data %>%
  slice(1:173,175:210)


# Change variable names

covid_data <- covid_data %>%
  mutate(value=tolower(value))

# Prepare data for matching
covid_data_1 <- apply(covid_data,2,function(x)gsub("united states","usa",x))
covid_data_1 <- apply(covid_data_1,2,function(x)gsub("united kingdom","uk",x))
covid_data_1 <- apply(covid_data_1,2,function(x)gsub("saudi arabia","saudiarabia",x))
covid_data_1 <- apply(covid_data_1,2,function(x)gsub("south africa","southafrica",x))
covid_data_1 <- apply(covid_data_1,2,function(x)gsub("new zealand","newzealand",x))
covid_data_1 <- apply(covid_data_1,2,function(x)gsub("south korea","southkorea",x))
covid_data_1 <- apply(covid_data_1,2,function(x)gsub("costa rica","costarica",x))
covid_data_1 <- apply(covid_data_1,2,function(x)gsub("czech republic","czechrepublic",x))
covid_data_1 <- apply(covid_data_1,2,function(x)gsub("united arab emirates","uae",x))
covid_data_1 <- apply(covid_data_1,2,function(x)gsub("sri lanka","srilanka",x))
covid_data_1 <- apply(covid_data_1,2,function(x)gsub("bosnia and herzegovina","bosnia",x))



covid_data_1

covid_data_1 <- as_tibble(covid_data_1)

#Matching total deaths
covid_data_2 <- covid_data_1$value1[match(final_data$Country,covid_data_1$value)]
covid_data_2 <- as_tibble(covid_data_2)

covid_data_2 <- covid_data_2 %>%
  rename("Total_deaths"="value")

# Matching total cases
covid_data_3 <- covid_data_1$value2[match(final_data$Country,covid_data_1$value)]
covid_data_3 <- as_tibble(covid_data_3)

covid_data_3 <- covid_data_3 %>%
  rename("Total_cases"="value")

# Final data for correlation

final_data_covid <- bind_cols(final_data,covid_data_3,covid_data_2)

# Tidy data and add coulmn
final_data_covid_1 <- final_data_covid$Total_cases %>%
  as.double()

final_data_covid_1 <- as_tibble(final_data_covid_1)
final_data_covid_1

cov <- bind_cols(final_data,final_data_covid_1)
cov

final_data_covid_8 <- final_data_covid$Total_deaths %>%
  as.double()

final_data_covid_8 <- as_tibble(final_data_covid_8)
final_data_covid_8

final_data_10 <- bind_cols(cov,final_data_covid_8)
final_data_10

# Change names 

final_data_10 <-  final_data_10 %>%
  rename("Total_cases"="value")

final_data_10 <-  final_data_10 %>%
  rename("Total_deaths"="value1")

final_data_10

# Add columns 
final_data_covid_2 <- final_data_10 %>%
  mutate(Total_cases_perMln=(Total_cases*1e6)/Population_mln)

final_data_covid_2 <- final_data_covid_2 %>%
  mutate(Total_deaths_perMln=(Total_deaths*1e6)/Population_mln)

final_data_covid_2

## Tidy data

# Slice el salvador and samoa 
final_data_covid_2 <- final_data_covid_2 %>%
  slice(1:123,125:146)
final_data_covid_2 <- final_data_covid_2 %>%
  slice(1:125,127:145)

# Add rows
final_data_covid_2 <- final_data_covid_2 %>%
  add_row(Country = "samoa",Number_of_authors = 4, Population=0.20,Population_mln=200000,
          Articles_perMln=20.00000000,HDI_2018= 0.707,Total_cases=0,Total_deaths=0,
          Total_cases_perMln=0,Total_deaths_perMln=0)

final_data_covid_2 <- final_data_covid_2 %>%
  add_row(Country = "elsalvador",Number_of_authors = 3, Population=6.40,Population_mln=6400000,
          Articles_perMln=0.46875000,HDI_2018= 0.667,Total_cases=0,Total_deaths=0,
          Total_cases_perMln=0,Total_deaths_perMln=0)
# Arrange data in order
final_data_covid_2 <- final_data_covid_2 %>%
  arrange(desc(Number_of_authors))

# Save data
saveRDS(final_data_covid_2,"D:/Projekt_COVID/readyData_for_correlation_covid.RDS")

