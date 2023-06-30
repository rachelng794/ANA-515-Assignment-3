#Get Working directory.
getwd()

##Installing the following package using tools menu: tidyverse, stringr, ggplot2.
#Call libraries.
library(tidyverse)
library(stringr)
library(ggplot2)

#1) Using read_csv, which is base R function, to read data from csv file from a local file.
storm1990 <- read_csv("C:/Users/kylie/Documents/R/Week 6/stormevents-1990.csv")

#2) Select the following columns "select" function: BEGIN_YEARMONTH, EPISODE_ID, STATE, STATE_ FIPS, CZ_NAME, CZ_TYPE, CZ_FIPS, EVENT_TYPE.
storm1990_select <- select(storm1990, BEGIN_YEARMONTH, EPISODE_ID, STATE, STATE_FIPS, CZ_NAME, CZ_TYPE, CZ_FIPS, EVENT_TYPE)

#3) Arrange the data by the state name. 
arrange(storm1990_select, STATE)

#4) Change state and county names to title case.
storm1990_select$STATE = str_to_title(storm1990_select$STATE)
storm1990_select$CZ_NAME = str_to_title(storm1990_select$CZ_NAME)

#5) Limit to the events listed by county FIPS (CZ_TYPE of “C”).
storm1990_filter <- filter(storm1990_select, CZ_TYPE=="C")

#Remove the CZ_TYPE column.
storm1990_remove <- select(storm1990_filter, -CZ_TYPE)

#6) Pad the state and county FIPS with a “0” at the beginning.
storm1990_remove$STATE_FIPS = str_pad(storm1990_remove$STATE_FIPS, width=5, side = "left", pad = "0")
storm1990_remove$CZ_FIPS = str_pad(storm1990_remove$CZ_FIPS , width=5, side = "left", pad = "0")

# Unite the two columns to make one FIPS column with the new state-county FIPS code.
storm1990_unite <- unite(storm1990_remove, "STATE_CZ_FIPS", c("STATE_FIPS","CZ_FIPS"))

#7) Change all the column names to lower case.
names(storm1990_unite) <- tolower(names(storm1990_unite))

#8) There is data that comes with base R on U.S. states (data("state")).
#Use that to create a dataframe with these three columns: state name, area, and region.
us_state_info<-data.frame(state=state.name, region=state.region, area=state.area)

#9) Create a dataframe with the number of events per state in the year of your birth. 
#Create a frequency table and assign new dataframe to it.
state_feq <- data.frame(table(storm1990_unite$state))

#Rename Var1 column in state_feq to state
state_feq1 <- rename(state_feq, c("state"="Var1", "freq"="Freq"))

#Merge in the state information dataframe you just created in step 8.
#The merge function will only merge common states and automatically remove the remaining ones.
merged <- merge(x=state_feq1, y=us_state_info, by.x="state", by.y="state")

#10) Create the following plot.
storm_plot <- ggplot(merged, aes(x = area, y = freq)) +
  geom_point(aes(color = region)) +
  labs(x = "Land area (square miles)",
       y = "# of storm events in 1990")
storm_plot
