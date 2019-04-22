#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

fluidPage(
    theme = shinytheme("cerulean"),
    titlePanel("Gun Violence Incidents Data"),
    navbarPage("Navigation",
        tabPanel("Introduction",
               mainPanel(
                   p("By Angie Lin", style = "color:black"), 
                   p(em("NYC Data Science Academy", style = "color:black")),
                   p("April 2019", style = "color:black"),
                   h3(strong("Introduction to the App:", style = "color:black")),
                   p("The goal of this app is to help the user visualize trends in gun violence though various observations/variables. 
                   With a more broad understanding of the trends of gun violence, it is possible for us to see where to actively target 
                   areas to decrease the amount of gun violence in the future. We look at the number of incidents and deaths from gun violence 
                    through different states, as well as over months and years.", 
                    style = "color:black"), 
                    
                    p(h3(strong("Source:", style = "color:black"))),
                    p("Link: ", a("https://www.kaggle.com/jameslko/gun-violence-data", 
                        href = "https://www.kaggle.com/jameslko/gun-violence-data"), 
                        style = "color:black"),
                    p("This dataset is sourced from Kaggle. The dataset is derived from web scrapping techniques on another thirs party site, ", 
                        a("gunviolencearchive.org", href = "https://www.gunviolencearchive.org/"), ".
                        I, and NYC Data Science Academy, do not own this dataset or was involved with web scrapping it. For more information, 
                        please visit the provided links.", style = "color:black"),
                   
                    p(h3(strong("Description of Tabs:", style = "color:black"))),
                    p(h5(strong("Introduction:", style = "color:black"))), 
                    p("This tab contains the introduction page for this app.", style = "color:black"),
                    
                    p(h5(strong("Overview Plots:", style = "color:black"))),
                    p("This contains 2 tabs, US Map and US Chart.", style = "color:black"),
                    
                    p("The ", strong("US Map"), "tab contains a map of the continental US with markers for the locations of incidents 
                    based on the number of effected people. Effected people would be the number of people that were killed or injured during the event. 
                    The user is to select the number of effected persons per a given incident from the dropdown menu. The options are a list of 
                     0, 1, 2, 3, 4, 5-10, 10-20, 20+.", style = "color:black"), 
                    
                    p("The ", strong("US Chart"), "tab contains a chart of the number of incidents per every 100,000 people in each state. 
                    This chart takes into account population sizes in each state so that the number of incidents can 
                    be compared on an equal basis.", style = "color:black"), 
                    
                    p(h5(strong("By States:", style = "color:black"))),
                    p("This tab contains the graphs for gun related incidents by state. The user can select which state 
                    they wish to view. The available full years from the dataset are 2014 to 2017.", style = "color:black"),
                    
                    p("In the ", strong("Year")," tab, we see the number of incidents per 100,000 people by year for any given user state input.",
                      style = "color:black"),
                    
                    p("In the ", strong("City/County"), "tab, we see the number of incidents by city/county in each state. Only the top 20 
                    cities/counties with the highest number of gun violence incidents are shown. Note: District of Columbia does not have 
                    counties and cities.", style = "color:black"),
                    
                    p(h5(strong("By Month:", style = "color:black"))),
                    p("This tab contains charts for gun related incidents for each state over the time of months to illustrate 
                    if the rate of incidents change based on the season. The user is able to select the state and year they 
                    wish to view.", style = "color:black"), 
                    
                    p("In the ", strong("Incidents"), "tab, we see the number of incidents in each month per state.", style = "color:black"), 
                    
                    p("In the ", strong("Deaths"), "tab, we see the number of deaths that have resulted from gun violence in each month per state.",
                      style = "color:black")
                )
        ),
        tabPanel("Overview Plots",
            tabsetPanel(type = "tabs",
                tabPanel("US Map",
                    p("---------", style = "color:white"),
                    selectInput("selectBin", "Select # of Effected Persons", choices = sort(unique(gunStats$bins)), selected = "0"),
                    leafletOutput("mymap")
                ),
                tabPanel("US Chart", 
                        box(htmlOutput("percentIncStatic"))
                )
            )
        ),
        tabPanel("By States",
            sidebarLayout(
                sidebarPanel(
                    selectizeInput(inputId = "state",
                                   label = "Select A State",
                                   choices = sort(unique(gunViolence[, 'state'])))
            ),
            mainPanel(
                tabsetPanel(type = "tabs",
                        tabPanel("Year",
                            fluidRow(
                                box(htmlOutput("ratioByState"))
                            )
                        ),
                        tabPanel("City/County",
                            fluidRow(
                                box(htmlOutput("byCity"))
                            )
                        )
                )
            )
        )
    ),
    tabPanel("By Month",
             sidebarLayout(
                 sidebarPanel(
                     selectizeInput(inputId = "stateMonth",
                                    label = "Select A State",
                                    choices = sort(unique(gunViolence[, 'state']))),
                     selectizeInput(inputId = "yearMonth",
                                    label = "Select A Year",
                                    choices = c(2014, 2015, 2016, 2017))
                 ),
                 mainPanel(
                     tabsetPanel(type = "tabs",
                                 tabPanel("Incidents",
                                          fluidRow(
                                              box(htmlOutput("incByMonth"))
                                          )
                                 ),
                                 tabPanel("Deaths",
                                          fluidRow(
                                              box(htmlOutput("deathByMonth"))
                                          )
                                 )
                     )
                 )
             )
    )
)
)

