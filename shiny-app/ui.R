#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# if (!require("pacman")) install.packages("pacman")
#
pacman::p_load(
  shiny,
  tidyverse,
  ggplot2,
  plotly,
  reactable,
  reactablefmtr,
  shinyWidgets
)

source("get_data.R")

# FliudPage() version II
fluidPage(

  # Application title
  titlePanel("Global Covid situation exploration"),

  column(3,

         wellPanel(

         multiInput(
           inputId = "countries",
           label = "Select countries",
           choices = countries_list,
           selected = c("Slovakia", "Austria", "Czechia"),
           options = list(
             enable_search = TRUE
             #non_selected_header = "Choose between:",
             #selected_header = "You have selected:"
             )
         ),

         hr(),

         selectInput("variables",
                     label = "Select metric",
                     choices = setNames(variables$variables_id, variables$variables_names),
                     selected = "Slovakia"),
         ),
         ),

  column(9,

         tabsetPanel(

           tabPanel("Plot",
                    plotlyOutput("plotly_long", height = "850px")
           ),
           tabPanel("Table data",
                    reactableOutput("reactable_wide"),
                    reactableOutput("reactable_long"),
                    )
           )
         )
  )
