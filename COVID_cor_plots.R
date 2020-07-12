final_data_covid_2


      ### Plot_correlation with total cases###

# Calculate spearman correlation

cor_total_cases <- cor(final_data_covid_2$Articles_perMln,final_data_covid_2$Total_cases_perMln ,
             method = "spearman")
cor_total_cases

# Make plot for correlation

cor_tc <- ggplot(final_data_covid_2,aes(x=Total_cases_perMln,y=Articles_perMln)) + geom_point() + geom_smooth() + annotate("text",x=20000, y=0.1 ,
                                                                                                          label=paste("Rs = 0.52"), size = 10
) + scale_y_log10() 


cor_tc

# Save totalCases_corr plot
ggsave(device = "png", filename = "totalCases_cor_600_dpi",plot =  cor_tc,dpi = 600, 
       path = "D:/Projekt_COVID/Plots")

      ### Plot_correlation with total deaths

cor_total_deaths <- cor(final_data_covid_2$Articles_perMln,final_data_covid_2$Total_deaths_perMln ,
                       method = "spearman")
cor_total_deaths

# Make plot for correlation

cor_td <- ggplot(final_data_covid_2,aes(x=Total_deaths_perMln,y=Articles_perMln)) + geom_point() + geom_smooth() + annotate("text",x=600, y=0.1, 
                                                                                                                           label=paste("Rs = 0.47"), size = 10
) + scale_y_log10() 


cor_td

# Save HDI_corr plot
ggsave(device = "png", filename = "totalDeaths_600_dpi",plot =  cor_td,dpi = 600, 
       path = "D:/Projekt_COVID/Plots")



