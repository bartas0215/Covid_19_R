# Load Scimago journal database 
qa <- read.csv("D:/Projekt_COVID/scimagojr_2019.csv",
                        header = TRUE, sep = ";",stringsAsFactors = FALSE)
qa <- as_tibble(qa)
qa