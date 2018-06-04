#Following library is required for our analysis
library(tidyverse)
library(lubridate)

#Read the csv file
retail_dataimport <- read_csv("./original-dataset/Online_Retail.csv")

#creating a fresh copy of the data to work on so that the imported original data is intact and can be reverted back easily

retail <- retail_dataimport

# What are the variables in our dataset and what are their data structure
glimpse(retail)

# Check the dataset to find out which column has missing value and how many missing value are present corresponding to each column
retail %>% 
  map(., ~sum(is.na(.)))

#We ignore the entire row(ie observation), if any column has a missing value
retail <- retail[complete.cases(retail), ]

# Check whether all the missing values have been eliminated by summing the missing values of each column separately.
# we should  get zero for all columns

retail %>% 
  map(., ~sum(is.na(.)))

#Data cleaning
#Note that InvoiceDate is in <chr>, Country and Description is also in <chr>
# need to change InvoiceDate to <dttm> 
# need to change TransactionID, Country and Description as factor for proper analysis
#Idea is to replace the columns after transforming the data-type of each column, keeping their values fixed.

retail_cleaned <- retail %>%
  mutate(InvoiceDate = dmy_hm(InvoiceDate)) %>% #coerces InvoiceDate in a Date Time format
  mutate(Description = factor(Description, levels = unique(Description))) %>% 
  #coerces Description as a factor with each item as individual level of a factor

  mutate(Country = factor(Country, levels = unique(Country)))%>%
  mutate(InvoiceNo = factor(InvoiceNo, levels = unique(InvoiceNo))) %>%
  mutate(TotalPrice = Quantity * UnitPrice)

glimpse(retail_cleaned)

#Save it as a RData file which we will import in the next stage
save(retail_cleaned, file = "./intermediate-data/retail_cleaned.RData")

