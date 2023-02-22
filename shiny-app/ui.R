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
  here,
  xts
)


source("get_data.R")
#here::i_am("shiny-app/ui.R")



# # fluidPage() version I
# fluidPage(
#
#     # Application title
#     titlePanel("Old Faithful Geyser Data"),
#
#     # Sidebar with a slider input for number of bins
#     sidebarLayout(
#
#       sidebarPanel(
#
#         multiInput(
#                  inputId = "countries",
#                  label = "Select countries",
#                  choices = countries_list,
#                  selected = c("Slovakia", "Austria", "United States"),
#                  options = list(
#                    enable_search = TRUE)
#                  ),
#         selectInput("variables",
#                   label = h3("Select metric"),
#                   choices = variables_list,
#                   selected = "Slovakia"),
#         ),
#
#
#     mainPanel(
#
#
#
#       dygraphOutput("dygr"),
#       plotOutput("plot"),
#       tableOutput("table"),
#       textOutput("text"),
#       textOutput("text2")
#       )
#     )
# )




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
         selectInput("variables",
                     label = h3("Select metric"),
                     choices = variables_list,
                     selected = "Slovakia"),
         ),
         ),

  column(9,

         tabsetPanel(

           tabPanel("Plot",
                    #plotlyOutput("plotly_wide"),
                    plotlyOutput("plotly_long", height = "850px")
           ),
           tabPanel("Table data",
                    reactableOutput("reactable_wide"),
                    reactableOutput("reactable_long"),
                    )
           )
         )
  )
