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

  output$table <- renderReactable ({

    #countries_table

    countries_table <- data_all %>%
      select(1, 3, 4) %>%
      reactable(
        theme = cyborg(),
        pagination = F,
        height = 700,
        width = 305,
        fullWidth = F,
        compact = T,
        #width = 100,
        columns = list(
          Country_Region = colDef(
            name = "Štát",
            cell = merge_column(
              data = .,
              merged_name = "Confirmed",
              merged_position = "below",
              size = 13,
              merged_size = 10
            ))
        )
      )

  })




  output$plot_cases_weekly <- renderPlotly({

    plot_cases_weekly <- data_weekly %>%
    #data_weekly %>%
      plot_ly() %>%
      add_bars(x = ~Date, y = ~Cases.New, color = I("red")) %>%
      layout(
        title = "",
        #height = 250,
        plot_bgcolor  = "rgba(0, 0, 0, 0)",
        paper_bgcolor = "rgba(0, 0, 0, 0)",
        font = list(color = 'red'),
        yaxis = list(title = "Nové prípady týždenne"),
        xaxis = list()
      ) %>%
      config(displayModeBar = FALSE)

  })


  output$plot_deaths_weekly <- renderPlotly({

    plot_deaths_weekly <- data_weekly %>%
    #data_weekly %>%
      plot_ly(
        #height = 250
        ) %>%
      add_bars(x = ~Date, y = ~Deaths.New, color = I("white")) %>%
      layout(
        plot_bgcolor  = "rgba(0, 0, 0, 0)",
        paper_bgcolor = "rgba(0, 0, 0, 0)",
        font = list(color = '#FFFFFF'),
        yaxis = list(title = "Úmrtia týždenne")
        ) %>%
      config(displayModeBar = FALSE)

  })


  output$plot_doses_weekly <- renderPlotly({

    plot_doses_weekly <- data_weekly %>%
    #data_weekly %>%
      plot_ly(
        #height = 250
        ) %>%
      add_bars(x = ~Date, y = ~Doses_admin.New, color = I("green")) %>%
      layout(
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

  })



  output$subplot_weekly <- renderPlotly({

    subplot(
      plot_cases_weekly,
      plot_deaths_weekly,
      plot_doses_weekly,
      #height = 750,
      titleY = T,
      titleX = F,
      margin = 0.045,
      nrows = 3
      ) %>%
      layout(
        height = 970,
        showlegend = F,
        margin = list(b = 200)
        ) %>%
      config(displayModeBar = F)

  })




}
