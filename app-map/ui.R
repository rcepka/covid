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
     bg = "#353535",
     fg = "#151515",
   # primary = "#092c74",
    bootswatch = "darkly"
    ),


  # Application title
  titlePanel("Old Faithful Geyser Data"),


  fluidRow(
    class = "bg-dark",



    tags$style(HTML("
        .tabs > .nav > li[class=active] > a {
           #background-color: #fff;
           color: #FFFFFF;
        }")),


    tags$style(
      '
      ul li:nth-child(1) {
  width: 150px;
  background-color: white;
  #background-color: salmon;
  color: #f50000;
  }

  ul li:nth-child(2) {
  width: 250px;
  background-color: salmon;
  }

  .nav-tabs li > a {
  color: #FFFFFF;
  }

  ul li > a {
  color: #FFFFFF;
  }

  '),




    column(2,
           fluidRow(style = "height:100px;",
             column(12, class="text-center fs-6 p-2 border border-5",
                    tags$div(style="color:red;", "Aktualizované"),
                    tags$div(class="fs-3 text-white", last_update)
                    ),
           ),
           fluidRow(style = "height:70px;",
                    column(12, class="text-center p-2 border border-bottom-0 border-5", style = "font-size:1.1rem;",
                           tags$div(style="color:red;", "Prípady",
                                    tags$span(class="text-white", "| Úmrtia podľa krajín/regiónov"),
                           ),
                    ),
           ),
           fluidRow(
             column(12, class = "text-center p-0 border border-top-0 border-5", style = "height:705px",
                    reactableOutput("table"),
                    ),
           ),
    ),
    column(7,
           fluidRow(style = "height:100px;",
             column(4, class="text-center p-2 border border-5",
                    tags$div(class="fs-6 color-white", "Prípadov spolu"),
                    tags$div(class="fs-2", style="color:red;", format(data_all_summarized$TotalCases, big.mark = "."))
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

                    "MAP",
                    #plotlyOutput("subplot_weekly")
                    )
           ),
    ),
    column(3, class="text-center border border-5 p-0 m-0", style = "height:875px",
           tags$div(class="robo", tabsetPanel(
             tabPanel("Týždenne", plotlyOutput("subplot_weekly")),
             tabPanel("28-dní")

           ))
           # plotlyOutput("plot_cases_weekly"),
           # plotlyOutput("plot_deaths_weekly"),
           # plotlyOutput("plot_doses_weekly"),
           #plotlyOutput("subplot_weekly")
           ),
    )
)


