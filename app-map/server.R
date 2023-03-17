#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#



# Define server logic required to draw a histogram
function(input, output, session) {

 #bs_themer()

    #countries_table
  output$table <- renderReactable ({

    data_total_sum_by_countries %>%
      reactable(
        theme = reactableTheme(
          backgroundColor = "transparent"
        ),
        pagination = F,
        height = 700,
        #width = 275,
        fullWidth = T,
        borderless = T,
        compact = T,
        #width = 100,
        defaultColDef = colDef(name=""),
        columns = list(
          Country = colDef(
            #name = "Štát",
            maxWidth = 125
          ),
          Cases.Total = colDef(
            #name = "Prípady",
            maxWidth = 80,
            cell = merge_column(
              data = .,
              merged_name = "Cases.28",
              merged_position = "above",
              size = 10,
              merged_size = 13,
              merged_color = "red",
              merged_weight = "bold"
            )
          ),
        Deaths.total = colDef(
          #name = "Úmrtia",
          maxWidth = 80,
          cell = merge_column(
            data = .,
            merged_name = "Deaths.28",
            merged_position = "below"
          )
        ),
        Cases.28 = colDef(show = F),
        Deaths.28 = colDef(show = F)
        )
    )


  })




  output$subplot_weekly <- renderPlotly({

    plot_cases_weekly <- data_weekly %>%
      #data_weekly %>%
      plot_ly() %>%
      add_bars(x = ~Date, y = ~Cases.New.weekly, color = I("red")) %>%
      layout(
        title = "",
        #height = 450,
        plot_bgcolor  = "rgba(0, 0, 0, 0)",
        paper_bgcolor = "rgba(0, 0, 0, 0)",
        font = list(color = 'red'),
        yaxis = list(title = "Nové prípady týždenne"),
        xaxis = list()
      ) %>%
      config(displayModeBar = FALSE)

    plot_deaths_weekly <- data_weekly %>%
      #data_weekly %>%
      plot_ly(
        #height = 250
      ) %>%
      add_bars(x = ~Date, y = ~Deaths.New.weekly, color = I("white")) %>%
      layout(
        plot_bgcolor  = "rgba(0, 0, 0, 0)",
        paper_bgcolor = "rgba(0, 0, 0, 0)",
        font = list(color = '#FFFFFF'),
        yaxis = list(title = "Úmrtia týždenne")
      ) %>%
      config(displayModeBar = FALSE)

    plot_doses_weekly <- data_weekly %>%
      #data_weekly %>%
      plot_ly(
        #height = 250
      ) %>%
      add_bars(x = ~Date, y = ~Doses_admin.New.weekly, color = I("green")) %>%
      layout(
        #height = 250,
        plot_bgcolor  = "rgba(0, 0, 0, 0)",
        paper_bgcolor = "rgba(0, 0, 0, 0)",
        font = list(color = 'white'),
        xaxis = list(
          title = ""
        ),
        yaxis = list(
          title = "Vakcinácia týždeňne"
        )
      ) %>%
      config(displayModeBar = FALSE)

    subplot(
      plot_cases_weekly,
      plot_deaths_weekly,
      plot_doses_weekly,
      titleY = T,
      titleX = F,
      margin = 0.045,
      nrows = 3
      ) %>%
      layout(
        height = 800,
        #margin = list(b = 200),
        showlegend = F
        ) %>%
      config(displayModeBar = F)

  })


  output$subplot_28_days <- renderPlotly({

    plot_cases_28_days <- data_28_days %>%
      #data_weekly %>%
      plot_ly() %>%
      add_bars(x = ~Date, y = ~Cases.New.28_days, color = I("red")) %>%
      layout(
        title = "",
        #height = 450,
        plot_bgcolor  = "rgba(0, 0, 0, 0)",
        paper_bgcolor = "rgba(0, 0, 0, 0)",
        font = list(color = 'red'),
        yaxis = list(title = "Nové prípady"),
        xaxis = list()
      ) %>%
      config(displayModeBar = FALSE)

    plot_deaths_28_days <- data_28_days %>%
      #data_weekly %>%
      plot_ly(
        #height = 250
      ) %>%
      add_bars(x = ~Date, y = ~Deaths.New.28_days, color = I("white")) %>%
      layout(
        plot_bgcolor  = "rgba(0, 0, 0, 0)",
        paper_bgcolor = "rgba(0, 0, 0, 0)",
        font = list(color = '#FFFFFF'),
        yaxis = list(title = "Úmrtia")
      ) %>%
      config(displayModeBar = FALSE)

    plot_doses_28_days <- data_28_days %>%
      #data_weekly %>%
      plot_ly(
        #height = 250
      ) %>%
      add_bars(x = ~Date, y = ~Doses_admin.New.28_days, color = I("green")) %>%
      layout(
        #height = 250,
        plot_bgcolor  = "rgba(0, 0, 0, 0)",
        paper_bgcolor = "rgba(0, 0, 0, 0)",
        font = list(color = 'white'),
        xaxis = list(
          title = ""
        ),
        yaxis = list(
          title = "Vakcinácia"
        )
      ) %>%
      config(displayModeBar = FALSE)

    subplot(
      plot_cases_28_days,
      plot_deaths_28_days,
      plot_doses_28_days,
      titleY = T,
      titleX = F,
      margin = 0.045,
      nrows = 3
    ) %>%
      layout(
        height = 800,
        #margin = list(b = 200),
        showlegend = F
      ) %>%
      config(displayModeBar = F)

  })




}
