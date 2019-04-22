# gun_violence_shiny
R Shiny project on gun violence.

Source:
Link: https://www.kaggle.com/jameslko/gun-violence-data
This dataset is sourced from Kaggle. The dataset is derived from web scrapping techniques on another thirs party site, 
gunviolencearchive.org. I do not own this dataset or was involved with web scrapping it. For more information, please 
visit the provided links.

The goal of this app is to help the user visualize trends in gun violence though various observations/variables. 
With a more broad understanding of the trends of gun violence, it is possible for us to see where to actively target 
areas to decrease the amount of gun violence in the future. We look at the number of incidents and deaths from gun violence through 
different states, as well as over months and years. 

The summary below is to describe in more detail the contents of each tab and explain the plots and charts.

Overview Plots:
The US Map tab contains a map of the continental US with markers for the locations of incidents based on the number of effected people. 
The user is to select the number of effected persons per a given incident from the dropdown menu. The options are a list of 
0, 1, 2, 3, 4, 5-10, 10-20, 20+. The US Chart tab contains a chart of the number of incidents per every 100,000 people in each state. 
This chart takes into account population sizes in each state so that the number of incidents can be compared on an equal basis.

By States:
This tab contains the graphs for gun related incidents by state. The user can select which state they wish to view. 
The available full years from the dataset are 2014 to 2017. In the Year tab, we see the number of incidents per 100,000 people by year 
for any given user state input. In the City/County tab, we see the number of incidents by city/county in each state. Only the top 20 
cities/counties with the highest number of gun violence incidents are shown. Note: District of Columbia does not have counties and cities.

By Month:
This tab contains charts for gun related incidents for each state over the time of months to illustrate if the rate of incidents change 
based on the season. The user is able to select the state and year they wish to view. In the Incidents tab, we see the number of incidents 
in each month per state. In the Deaths tab, we see the number of deaths that have resulted from gun violence in each month per state.
