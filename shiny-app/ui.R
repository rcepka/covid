#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

if (!require("pacman")) install.packages("pacman")

pacman::p_load(
  shiny,
  tidyverse,
  ggplot2,
  plotly,
  reactable,
  reactablefmtr,
  shinyWidgets,
  dygraphs,
  readr,
  here
)


#source("get_data.R")
#here::i_am("shiny-app/ui.R")





# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30),

           shinyWidgets::multiInput(
              inputId = "Id010",
              label = "Countries :",
              choices = NULL,
              choiceNames = lapply(seq_along(countries),
                                   function(i) tagList(tags$img(src = flags[i],
                                                                width = 20,
                                                                height = 15), countries[i])),
              choiceValues = countries
            )
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot")
        )
    )
)
