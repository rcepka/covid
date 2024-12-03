#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

source("global.R")


# FliudPage()
ui <- fluidPage(

    navbarPage("Covid - globálna situácia, zobrazenie formou grafu",
                 theme = bs_theme(version = 5, bootswatch = "minty"),
                 # tabPanel("Component 1"),
                 # tabPanel("Component 2"),
                 # tabPanel("Component 3"),


             fluidRow(
                   column(2,

                          card(
                            card_body(
                              div(
                                class="h4",
                                "COVID-19 explorer"
                                ),
                              div(class="text-secondary fs-6",
                                  markdown("Zdroj dát OurWorldInData.com [COVID-19 dataset](https://github.com/owid/covid-19-data/tree/master/public/data)")
                                  )
                            )
                          ),

                          multiInput(
                            inputId = "countries",
                            label = tags$h5("Vyberte krajiny"),
                            choices = countries$country,
                            selected = c("Slovensko", "Rakúsko", "Česko", "Maďarsko", "Nemecko"),
                            options = list(
                              enable_search = TRUE),
                            ),
                          selectInput(
                            "variables",
                            label = tags$h5("Vyberte premennú"),
                            choices = setNames(isolate(variables()$variables_id), isolate(variables()$variables_names)),
                            selected = "total_cases_per_million",
                          ),
                          # br(),
                          # prettySwitch(
                          #   inputId = "relative_to_population",
                          #   label = "Relative to population",
                          #   status = "success",
                          #   fill = TRUE
                          # ),

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
                              class = "p-3 border border-top-0 rounded-bottom",
                              #wellPanel(
                                plotlyOutput("plotly_long", height = "700px") %>% withSpinner()
                              #)
                            ),
                            tabPanel(
                              "Zdroj dát",
                              class = "p-3 border border-top-0 rounded-bottom",
                              #wellPanel(
                                reactableOutput("reactable_wide", width = "75%")
                              #)
                            ),
                            tabPanel(
                              "Zobrazenie trendov",
                              class="p-3 border border-top-0 rounded-bottom",
                              reactableOutput("reactable_trends") %>% withSpinner()
                              )
                            )
                          ) # column end
             ) #fluidrow end
    ) # navbarpage
)
