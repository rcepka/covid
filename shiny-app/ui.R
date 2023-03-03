#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#



# FliudPage()
ui <- fluidPage(

    navbarPage("Covid - globálna situácia",
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
                            label = tags$h5("Vyberte krajiny"),
                            choices = countries_list,
                            selected = c("Slovakia", "Austria", "Czechia", "Hungary", "Germany"),
                            options = list(
                              enable_search = TRUE),
                            ),
                          selectInput(
                            "variables",
                            label = tags$h5("Vyberte premennú"),
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
                              "Graf",
                              class = "m-3",
                              #wellPanel(
                                plotlyOutput("plotly_long", height = "750px") %>% withSpinner()
                              #)
                            ),
                            # tabPanel(
                            #   "Interactive map",
                            #   source("testUI.R")
                            # ),
                            tabPanel(
                              "Zdroj dát",
                              class = "m-3",
                              #wellPanel(
                                reactableOutput("reactable_wide", width = "75%")
                              #)
                            ),
                            tabPanel(
                              "Zobrazenie trendov",
                              fluidRow(
                                column(9,
                                       class="m-3",
                                        reactableOutput("reactable_trends") %>% withSpinner()
                                ),
                                column(2,
                                       "hello, text")
                              )
                            )
                          )
                        )
                   )
             )
    )
