

xs <- c %>%
  distinct(title,.keep_all = TRUE)


str_count(xs,pattern = "University of Gothenburg")


vc <- c %>%
  distinct(pmid) %>%
  count()
vc


ds <- c1 %>%
  distinct(title,.keep_all = TRUE)
