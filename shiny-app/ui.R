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
print("starting the app!")

print("Loading r packages with Pacman")

pacman::p_load(
  shiny,
  tidyverse,
  ggplot2,
  plotly,
  reactable,
  reactablefmtr,
  shinyWidgets,
  bslib,
  lubridate,
  dataui
)

print("going to get the data.")
source("get_data.R")


# FliudPage()
#ui <- fluidPage(

ui <- navbarPage("Covid - the global situation",
                 theme = bs_theme(version = 5, bootswatch = "minty"),
                 # tabPanel("Component 1"),
                 # tabPanel("Component 2"),
                 # tabPanel("Component 3"),


                 # Application title
                 #titlePanel("Global Covid situation exploration"),


             fluidRow(
                   column(2,

                          multiInput(
                            inputId = "countries",
                            label = tags$h5("Select countries"),
                            choices = countries_list,
                            selected = c("Slovakia", "Austria", "Czechia", "Hungary", "Germany"),
                            options = list(
                              enable_search = TRUE),
                            ),
                          selectInput(
                            "variables",
                            label = tags$h5("Select metric"),
                            choices = setNames(variables$variables_id, variables$variables_names),
                            selected = "total_cases_per_million",
                          ),
                          br(),
                          prettySwitch(
                            inputId = "relative_to_population",
                            label = "Relative to population",
                            status = "success",
                            fill = TRUE
                          ),

                          # card(
                          #   card_header(
                          #     class = "bg-dark",
                          #     "A header"
                          #   ),
                          #   card_body(
                          #     markdown("Some text with a [link](https://github.com)")
                          #     )
                          #   )
                          ),

                   column(10,

                          tabsetPanel(
                            tabPanel(
                              "Plot",
                              wellPanel(
                                plotlyOutput("plotly_long", height = "750px")
                              )
                            ),
                            # tabPanel(
                            #   "Interactive map",
                            #   source("testUI.R")
                            # ),
                            tabPanel(
                              "Data explorer",
                              wellPanel(
                                reactableOutput("reactable_wide"),
                                reactableOutput("reactable_long"),
                              ),
                            ),
                          )
                        )
                   )

)

