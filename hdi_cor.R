#####HDI correlation plotting###
library(ggrepel)


final_data

# Calculate correlation
cor_1 <- cor(final_data$Articles_perMln,final_data$HDI_2018,
    method = "spearman")
cor_1


# Make plot for correlation

cor_hdi <- ggplot(final_data,aes(x=Articles_perMln,y=HDI_2018)) + geom_point() + geom_smooth() + annotate("text",x=50, y=0.4, 
                                                                                          label=paste("R = 0.759085"
                                                                                          ))
cor_hdi


# Addition on country label
cor_hdi_1 <- cor_hdi + geom_label_repel(aes(label = Country),
                           box.padding   = 0.5, 
                           point.padding = 2.0,
                           segment.color = 'grey50') +
  theme_classic()

cor_hdi_1

# Saving plots
saveRDS(cor_hdi,"D:/Projekt_COVID/Plots/hdi_cor_withoutLabel.RDS")
saveRDS(cor_hdi_1,"D:/Projekt_COVID/Plots/hdi_cor_Labeled.RDS")
