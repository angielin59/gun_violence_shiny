
library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(leaflet)
library(maps)
library(shinydashboard)
library(shinythemes)
library(googleVis)

gunViolence <- read.csv("./gunViolence.csv", stringsAsFactors = FALSE)
populationData <- read.csv("./populationData.csv", stringsAsFactors = FALSE)

gunStats <- gunViolence %>%
  select(incident_id,date,state,
         city_or_county, n_killed, n_injured,
         congressional_district, gun_stolen, gun_type, latitude, longitude, n_guns_involved,
         participant_age, participant_age_group, participant_gender, participant_status, participant_type,
         state_house_district, state_senate_district) %>%
  mutate(date = as.Date(date)) %>%
  mutate(month = lubridate::month(date), year = lubridate::year(date)) %>%
  mutate(totalAff = n_killed + n_injured) %>%
  mutate(bins = ifelse(totalAff %in% 5:10, "5-10",
                       ifelse(totalAff %in% 10:20, "10-20", 
                              ifelse(totalAff %in% 20:2000, "20+", as.character(totalAff))
                       )
  )
  ) %>%
  arrange(date)

popData <- populationData %>%
  gather(year, popSize, X2010, X2011, X2012, X2013, X2014, X2015, X2016, X2017, X2018) %>%
  mutate(year = as.integer(gsub("X", "", year)))

dataset <- left_join(gunStats, popData)

leafplot <- dataset %>%
  select(state, city_or_county, latitude, longitude, bins, totalAff) %>%
  na.omit() %>%
  filter((latitude < 72.556) & (latitude > 24.6) & (longitude <-58) & (longitude > -180))


