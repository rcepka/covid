#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#



if (!require("pacman")) install.packages("pacman")


print("Loading r packages with Pacman")
cat(paste0(Sys.time(), " Starting cron job...\n"))
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
  dataui,
  shinycssloaders
)



# Define UI for application that draws a histogram
navbarPage(

  theme = bs_theme(
    version = 5,
     # bg = "#353535",
     # fg = "#151515",
   # primary = "#092c74",
    bootswatch = "darkly"
    ),


  # Application title
  titlePanel("Old Faithful Geyser Data"),


  fluidRow(

    column(2,
           fluidRow(#style = "height:130px;",
             column(12, class="text-center fs-6 align-middle",
                    card(height = 100,
                         card_body_fill(class="p-0 m-0 justify-content-center",
                                   tags$div(style="color:red;", "Aktualizované"),
                                   tags$div(class="fs-3 text-white", last_update)
                                   )
                         )
                    ),
           ),
           fluidRow(style = "height:70px;",
                    column(12, class="text-center",
                           card(
                            card_body(
                              tags$div(class="fs-6", style="color:red;", "Prípady",
                                       tags$span(class="text-white", "| Úmrtia podľa krajín/regiónov")
                              )
                            )
                           )
                    )
           ),
           fluidRow(class="p-0 m-0", #style = "height:705px",
             column(12, class = "text-center p-0 m-0",
                    card(class="p-0 m-0",
                         card_body(class="p-0 m-0",
                                   reactableOutput("table")
                         )
                    )
             ),
           ),
    ),
    column(7,
           fluidRow(style = "height:130px;",
             column(4, class="text-center",
                    card(
                      card_body(class="p-0 m-0", height = 130,
                        tags$div(class="fs-6 color-white", "Prípadov spolu"),
                        tags$div(class="fs-2", style="color:red;", format(data_all_summarized$TotalCases, big.mark = "."))
                      )
                    )
             ),
             column(4, class="text-center p-2 border",
                    tags$div(class="fs-6 color-white", "Úmrtí spolu"),
                    tags$div(class="fs-2", style="color:red;", format(data_all_summarized$TotalDeaths, big.mark = "."))
                    ),
             column(4, class="text-center p-2 border",
                    tags$div(class="fs-6 color-white", "Vakcinácií Spolu"),
                    tags$div(class="fs-2", style="color:green;", format(vaccines_summarised$People_at_least_one_dose, big.mark = "."))
                    ),
           ),
           fluidRow(
             column(4,
                    "28-day cases"
             ),
             column(4,
                    "28-days deaths"
             ),
             column(4,
                    "28-day vaccine doses"
             ),
           ),
           fluidRow(
             column(12, class="text-center", style = "height:875px",

                    card(card_body("MAP")),
                    #plotlyOutput("subplot_weekly")
                    )
           ),
    ),
    column(3, class="text-center",
           tabsetPanel(
             tabPanel("Týždenne", card(card_body(class="mt-5", height = 825, plotlyOutput("subplot_weekly")))),
             tabPanel("28-dní")

           )
           # plotlyOutput("plot_cases_weekly"),
           # plotlyOutput("plot_deaths_weekly"),
           # plotlyOutput("plot_doses_weekly"),
           #plotlyOutput("subplot_weekly")
           ),
    )
)


