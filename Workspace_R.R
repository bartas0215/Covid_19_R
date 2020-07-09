print(f,n=481)
print(sci_journal_14,n=481)
print(sci_journal_1,n=30883)

# Remove all data in parenthesis
h <- apply(sci_journal_1,2,function(x)gsub("\\s*\\([^\\)]+\\)","",x))
h <- apply(h,2,function(x)gsub("-.*","",x))


# Remove all data after colon
h <- apply(h,2,function(x)gsub(":.*","",x))

# Remove commas
h <- apply(h,2,function(x)gsub(",","",x))

# Remove euqal sign 
h <- apply(h,2,function(x)gsub("=","",x))

# Change &amp; to and
h <- apply(h,2,function(x)gsub("&amp;", "and", x))

# Remove whitespace
h <- apply(h,2,function(x)gsub('\\s+', '',x))
# Save as tibble
h <- as_tibble(h)
h




#Match on country in world.countries
CountryList_raw <- (lapply(f, function(x)x[which(toupper(x) %in% toupper(world.cities$country.etc))]))
g <- do.call(rbind, lapply(CountryList_raw, as.data.frame))
CountryList_raw