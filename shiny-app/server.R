#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
function(input, output, session) {


  #Prepare the data frame
  data_selected_wide <- reactive(
    data_wide %>%
      filter(location %in% input$countries)
    )

  data_selected_long <- reactive(
    data_long %>%
      filter(location %in% input$countries) %>%
      filter(metric == input$variables)
    )


   output$plotly_long <- renderPlotly({

     plot_ly(data_selected_long(),
             x = ~date,
             y = ~values,
             color = ~location
             ) %>%
       add_lines() %>%
       layout(showlegend = T, title='',
              xaxis = list(rangeslider = list(visible = T, thickness = 0.1),
                           rangeselector=list(
                             buttons=list(
                               list(count=1, label="1m", step="month", stepmode="backward"),
                               list(count=6, label="6m", step="month", stepmode="backward"),
                               list(count=1, label="YTD", step="year", stepmode="todate"),
                               list(count=1, label="1y", step="year", stepmode="backward"),
                               list(step="all")
                             ))))
     })


  # output$plot_long <- renderPlot({
  #   # #Without reactive()
  #   # ggplot(data_wide,
  #   #        #aes(x = date, y = .data[[input$variables]], color = location)
  #   #        aes(x = date, y = .data[[input$variables]], color = .data[[input$variables]])
  #   # ) +
  #   #   geom_line(show.legend = FALSE)
  #
  #   # with reactive()
  #   data_selected_long() %>%
  #     ggplot(aes(x = date,
  #                #y = input$variables,
  #                #y = .data[[input$variables]],
  #                y = values,
  #                color = location
  #                )
  #            ) +
  #     geom_line(show.legend = T)
  # })



output$reactable_wide <- renderReactable({
  data_selected_wide() %>%
    reactable(
      #filterable = T,
      searchable = T,
      defaultPageSize = 10,
      defaultColDef = colDef(
        header = function(value) gsub("_", " ", value, fixed = TRUE),
        align = "center"
      ),
      columns = list(
        location = colDef(align = "left"),
        #iso_code = colDef(show = F),
        continent = colDef(show = F)
        )
      )
})

output$reactable_long <- renderReactable({
  data_selected_long() %>% reactable()
  })



  output$table <- renderTable({head(data_selected_wide())})

  output$text <- renderText({input$variables})
  output$text2 <- renderText({input$countries})

}
