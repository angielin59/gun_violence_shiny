#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

colStates <- maps::map("state", fill = TRUE,
                 plot = FALSE,
                 region = sort(unique(leafplot$state)))

capitalState <- function(x) {
    s <- strsplit(x, " ")[[1]]
    paste(toupper(substring(s, 1,1)), substring(s, 2),
          sep="", collapse=" ")
}

function(input, output) {
#Percent of incidents per person in each state  
   
    filterData <- reactive({
        leafplot %>%
            filter(bins == input$selectBin)
    })
    
    filterData2 <- reactive({
        leafplot %>%
            filter(bins == input$selectBin) %>%
            group_by(state) %>%
            summarise(totalA = sum(totalAff))
    })
    
    output$mymap <- renderLeaflet({
        leaflet() %>%
            setView(lng = -100, lat = mean(leafplot$latitude), zoom = 4) %>%
            addTiles
    })
    
    observe({
        leafletProxy("mymap", data = filterData) %>%
            clearShapes() %>%
            addPolygons(data=colStates,
                        color = "black", weight = 1, smoothFactor = 0.5,
                        opacity = 1.0, fillOpacity = 0.3,
                        fillColor = "green",
                        highlightOptions = highlightOptions(color = "White", weight = 4),
                        stroke = TRUE, 
                        label = lapply(colStates$names, capitalState)
                        ) %>%
            addCircles(lng = filterData()$longitude, lat = filterData()$latitude, 
                            radius = 6,
                             color = "blue",
                             fillOpacity = 0.5)
    })  
    
     output$percentIncStatic <- renderGvis({
        plot1 <- dataset %>%
            mutate(count = 1) %>%
            group_by(state) %>%
            summarize(ratio = (sum(count)/mean(popSize))*100000) 
        gvisColumnChart(plot1, xvar = "state", yvar = "ratio",
                        options=list(title = "Number of Gun Incidents Per Every 100,000 Persons", 
                                     vAxis="{title:'Incidents per 100,000 People'}",
                                     hAxis="{title:'States'}",
                                     width=1400, height=600, 
                                     legend = "none"))
    })

#Percent of incidents per person filtered by state from years
    output$ratioByState <- renderGvis({
        plot2 <- dataset %>%
            mutate(count = 1) %>%
            group_by(state, year) %>%
            mutate(totalRatio = (sum(count)/popSize)*100000) %>%
            summarize(ratio = first(totalRatio)) %>%
            filter(state == input$state, year > 2013, year < 2018) %>%
            mutate(year = as.character(year))
            gvisColumnChart(plot2, xvar = "year", yvar = "ratio",
                            options=list(title = "Number of Gun Incidents Per Every 100,000 Persons By Input State", 
                                         vAxis="{title:'Incidents per 100,000 People'}",
                                         hAxis="{title:'Year'}",
                                         width=700, height=500, 
                                         legend = "none"))
        })

#top 20 cities with highest number of people killed in each city by state
    output$byCity <- renderGvis({
        plot3 <- gunStats %>%
            mutate(count = 1) %>%
            filter(state == input$state) %>%
            group_by(city_or_county) %>%
            summarize(total = sum(count)) %>%
            arrange(desc(total)) %>%
            head(20)
        gvisColumnChart(plot3, xvar = "city_or_county", yvar = "total",
                        options=list(title = "Top 20 Number of Incidents Per City/County", 
                                     vAxis="{title:'Number of Incidents'}",
                                     hAxis="{title:'City or County'}",
                                     width=800, height=500, 
                                     legend = "none"))
    })
    
    output$incByMonth <- renderGvis({
        plot4 <- gunStats %>% 
            group_by(state, year, month) %>%
            mutate(count = 1) %>%
            summarize(total = sum(count)) %>%
            filter((state == input$stateMonth) & (year == input$yearMonth)) %>%
            mutate(month = factor(month.name[month], levels = month.name)) %>% 
            arrange(month) 
        gvisColumnChart(plot4, xvar = "month", yvar = "total",
                        options=list(title = "Number of Gun Related Incidents Each Month", 
                                                  vAxis="{title:'Number of Incidents'}",
                                                  hAxis="{title:'Month'}",
                                                  width=700, height=500, 
                                                    legend = "none"))
    })
    
    output$deathByMonth <- renderGvis({
        plot5 <- gunStats %>% 
            group_by(state, year, month) %>%
            summarize(total = sum(n_killed)) %>%
            filter((state == input$stateMonth) & (year == input$yearMonth)) %>%
            mutate(month = factor(month.name[month], levels = month.name))
        gvisColumnChart(plot5, xvar = "month", yvar = "total",
                        options=list(title = "Number of People Killed Each Month", 
                                                    vAxis="{title:'Number of People Killed'}",
                                                    hAxis="{title:'Month'}",
                                                    width=700, height=500, 
                                     legend = "none"))
    })
}

