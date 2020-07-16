# Read shanghai ranking 
sh <- read.csv("D:/Projekt_COVID/shanghai_ranking.csv",stringsAsFactors = FALSE,
               header = TRUE, sep = ",")



sh <- as_tibble(sh)
sh

# Save RDS
saveRDS(sh,"D:/Projekt_COVID/shangai_ranking_Readydata")

## Prepare table 

# Order data
sh_1 <- sh %>%
  arrange(desc(Number_of_articles))
sh_1

# Slice first 20 rows

sh_2 <- sh_1 %>%
  slice(1:20)

write.xlsx(sh_2,"D:/Projekt_COVID/Tabels/shangai_ranking.xlsx")

## Prepare plot

# Calculate correlation
cor_sh <- cor(sh$Total.Score,sh$Number_of_articles,
             method = "spearman")
cor_sh


# Make plot for correlation

cor_sh_1 <- ggplot(sh,aes(x=Total.Score,y=Number_of_articles)) + geom_point() +  geom_smooth() + annotate("text",x=87.5, y=87.5, 
                                                                                                           label=paste("Rs = 0.3"), size = 7
) 
cor_sh_1

# Save sh_corr plot
ggsave(device = "png", filename = "sh_cor_600_dpi.png",plot =  cor_sh_1,dpi = 600, 
       path = "D:/Projekt_COVID/Plots")

