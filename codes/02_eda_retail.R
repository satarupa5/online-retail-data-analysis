library(tidyverse)
library(lubridate)
library(forcats)

# load the cleaned retail data from step 1.Lets load the .RData file as its load
# time is significantly faster than csv or excel files.
load("./intermediate-data/retail_cleaned.RData")
# Have a quick look at the data
glimpse(retail_cleaned)

# How to arrange the countries based on their total sales? and which country has
# maximum sales? Group the data countrywise then find the frequency of sales per
# country using the count function step3 : Arrange the countries by descending
# sales

country_mostsales <- retail_cleaned %>% 
  group_by(Country) %>%
  summarize(countrywise_totalrevenue = sum(TotalPrice))%>%
  arrange(desc(countrywise_totalrevenue))


by_top10_countries <- country_mostsales %>% 
  top_n(n = 10, wt = countrywise_totalrevenue)

# Visualize the top 10 countries as per total sales. scatterplot of country
# versus sales.Country has no natural ordering,so we use fact-reorder() to
# display the conutries as per increasing sales. In other words, The scatterplot
# is arranged so that the country having minimum sales is plotted first and then
# the country having second lowest sales and so on till the final country which
# has maximum sales.

by_top10_countries %>% 
  mutate(Country = fct_reorder(Country, countrywise_totalrevenue)) %>% 
  ggplot(aes(Country, countrywise_totalrevenue))+
  geom_point()+
  coord_flip()
# So UK has the highest sale followed by Netherlands, EIRE , Germany and France


# However, UK is the home country of the firm and that explains why this country
# has large amount of sales. Hence lets check the trend by separating UK. We
# visualize how sales are distributed over various countries.

country_mostsales_without_uk <-  country_mostsales[-1,]

country_mostsales_without_uk %>% 
  mutate(Country = fct_reorder(Country, countrywise_totalrevenue)) %>% 
  ggplot(aes(Country, countrywise_totalrevenue))+
  geom_point()+
  coord_flip()

# Most valued product-The product briging largest turnover

mostvalued_product <- retail_cleaned %>% 
  group_by(Description) %>%
  summarize(value_of_product = sum(TotalPrice)) %>% 
  arrange(desc(value_of_product)) 

# top20 most valued product

top20_valued_products <- mostvalued_product %>% 
  top_n(n = 20, wt = value_of_product)

# Categorical variable like Description does not have an intrinsic order, so we
# reorder it as per increasing count.

# graphical representation of most valued product

top20_valued_products %>% 
  mutate(Description = fct_reorder(Description, value_of_product)) %>% 
  ggplot(aes(Description, value_of_product))+
  geom_point()+
  coord_flip()
# So REGENCY CAKESTAND 3 TIER, WHITE HANGING HEART T-LIGHT HOLDER, JUMBO BAG RED
# RETROSPOT are the top3 most valued products


# which product is most sold worldwide?
mostsold_product <- retail_cleaned %>% 
  group_by(Description) %>%
  summarize(total_units_sold = sum(Quantity)) %>% 
  arrange(desc(total_units_sold)) 

# top20 most sold products--
top20_mostsoldproducts <- mostsold_product %>% 
  top_n(n = 20, wt = total_units_sold)


top20_mostsoldproducts %>% 
  mutate(Description = fct_reorder(Description, total_units_sold)) %>% 
  ggplot(aes(Description, total_units_sold))+
  geom_point()+
  coord_flip()
# Most sold products worldwide are WORLD WAR 2 GLIDERS ASSTD DESIGNS, UMBO BAG
# RED RETROSPOT, ASSORTED COLOUR BIRD ORNAMENT

# which customers are most valuable for the company?

by_mostvaluable_customer <- retail_cleaned %>% 
  group_by(CustomerID) %>%
  summarize(customer_amount = sum(TotalPrice)) %>% 
  arrange(desc(customer_amount)) 

top20_mostvaluable_customer <- by_mostvaluable_customer %>% 
  top_n(n = 20, wt = customer_amount)
View(top20_mostvaluable_customer)


# Which month of the year sees maximum turnover?

data_with_month <- retail_cleaned %>%
  mutate(months = month(InvoiceDate,label = T))

# the month() function separates out the month name from a date-time(dttm)
# column. We create a separate column name months with the month names of the
# sales data.
data_with_month %>% 
  group_by(months)%>%
  summarize(monthwise_totalrevenue = sum(TotalPrice))%>%
  ggplot()+
  geom_bar(mapping = aes(x = months, y = monthwise_totalrevenue), stat = "identity")+
  coord_flip()

# September to December appear to be the months with highest sales.This is not
# surprising as these months are winter months for Europian countries where most
# sales occur and winter time is festive time.
