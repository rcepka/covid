#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#
#
# if (!require("pacman")) install.packages("pacman")
#
#
# print("Loading r packages with Pacman")
# cat(paste0(Sys.time(), " Starting cron job...\n"))
# pacman::p_load(
#   shiny,
#   tidyverse,
#   ggplot2,
#   plotly,
#   reactable,
#   reactablefmtr,
#   shinyWidgets,
#   bslib,
#   lubridate,
#   dataui,
#   shinycssloaders
# )



# Define UI for application that draws a histogram
navbarPage(


  theme = bs_theme(
    version = 5,
    bootswatch = "darkly"
    ),



  # Application title
  titlePanel("Koronavírus - prehľad situácie"),


  tags$style("
    .maps ul li {
      width: 250px;
    }
      "),


  fluidRow(

    column(2,
           fluidRow(
             column(12, class="text-center fs-6",
                    card(height = 100,
                         card_body_fill(class="p-0 m-0 justify-content-center",
                                   tags$div(style="color:red;", "Aktualizované"),
                                   tags$div(class="fs-3 text-white", last_update)
                                   )
                         )
                    ),
           ),
           fluidRow(
              column(12, class="text-center",
                     card(height = 70, class="p-0 m-0",
                       card_body_fill(class = "ps-3 pe-3 pt-0 pb-0 m-0 justify-content-center",
                        tags$div(class="fs-6 p-0 m-0", style="color:red;", "Prípady",
                                 tags$span(class="text-white", "| Úmrtia podľa krajín/regiónov")
                                 )
                        )
                       )
                     )
              ),
           fluidRow(
             column(12, class = "text-center", full_screen = TRUE,
                    card(class="p-0 m-0",
                         card_body(class="p-0 m-0",
                                   reactableOutput("table")
                         )
                    )
             ),
           ),
    ),
    column(7,

           fluidRow(
             column(4, class="text-center",
                    card(height = 100, class="",
                      card_body_fill(class="p-0 justify-content-center",
                                     tags$div(class="fs-6 color-white", "Prípadov spolu"),
                                     tags$div(class="fs-2", style="color:red;", format(data_total_sum$Cases.total, big.mark = " "))
                                     )
                      )
                    ),
             column(4, class="text-center",
                    card(height = 100, class="",
                         card_body_fill(class="p-0 text-white justify-content-center",
                                        tags$div(class="fs-6", "Úmrtí spolu"),
                                        tags$div(class="fs-2", format(data_total_sum$Deaths.total, big.mark = " "))
                         )
                    )
                    ),
             column(4, class="text-center",
                    card(height = 100, class="",
                         card_body_fill(class="p-0 justify-content-center",
                           tags$div(class="fs-6 color-white", "Vakcinácií spolu"),
                           tags$div(class="fs-2", style="color:green;", format(data_total_sum$Vaccine.Doses.Total, big.mark = " "))
                         )
                    )
             ),
           ),

           fluidRow(
             column(4, class="text-center",
                    card(height = 70,
                         card_body_fill(class="p-0 justify-content-center",
                          tags$div(class="text-white", "Prípady za 28 dní"),
                          tags$div(class="fs-4", style="color:red;", format(data_total_28_days_sum$Cases.total.28, big.mark = " "))
                         )
                    )
             ),
             column(4, class="text-center",
                    card(height = 70,
                         card_body_fill(class="p-0 justify-content-center",
                          tags$div(class="text-white", "Úmrtia za 28 dní"),
                          tags$div(class="fs-4", style="color:red;", format(data_total_28_days_sum$Deaths.total.28, big.mark = " "))
                          )
                    )
             ),
             column(4, class="text-center",
                    card(height = 70,
                         card_body_fill(class="p-0 justify-content-center",
                          tags$div(class="text-white", "Vakcinácia za 28 dní"),
                          tags$div(class="fs-4", style="color:red;", format(data_total_28_days_sum$Vaccine.Doses.Total.28, big.mark = " "))
                         )
                    )
             )
           ),

           fluidRow(tags$div(class="maps",

             column(12,
                    tabsetPanel(
                      tabPanel("Celkovo",
                               card(height = 625,
                                    card_body_fill(
                                      class="p-0",
                                      leafletOutput("map_total")
                                      )
                                    )
                               ),
                      tabPanel("Mesačne",
                               card(height = 625,
                                    card_body_fill(
                                      class = "p-0",
                                      leafletOutput("map_28_days")
                                      )
                                    )
                               )
                    )
             )
           )
           )
    ),

    column(3,
           tabsetPanel(
             tabPanel("Týždenne",
                      card(height = 825, full_screen = TRUE,
                        card_body_fill(class="mt-3", plotlyOutput("subplot_weekly")))
                      ),
             tabPanel("Mesačne",
                      card(height = 825, full_screen = TRUE,
                           card_body_fill(class="mt-3", plotlyOutput("subplot_28_days")))
                      ),
           )
    ),
  )
)


