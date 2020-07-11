final_data

ggplot(final_data, aes(x=HDI_2018, y=Articles_perMln)) + 
  geom_point(color='#2980B9', size = 4) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE, color='#2C3E50')
+ annotate(Rs=0.77)

corr <- cor.test(x=final_data$HDI_2018, y=final_data$Articles_perMln, method = 'spearman')
corr


# Calculate correlation
final_data %>%
  summarize(correlation = cor(HDI_2018, Articles_perMln))
