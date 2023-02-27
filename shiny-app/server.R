#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

source("get_data.R")

# Define server logic required to draw a histogram
function(input, output, session) {

  #bs_themer()


  #Prepare the data frame
  data_selected_wide <- reactive(
    data_wide %>%
      filter(location %in% input$countries) %>%
      select(1, 2, input$variables)
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
       config(displayModeBar = F) %>%
       layout(
         showlegend = T,
         #plot_bgcolor='#e5ecf6',
         title= input$variables,
         xaxis = list(
           title = "",
           showgrid = F,
           rangeslider = list(
             bgcolor = "#e5ecf6",
             visible = T,
             thickness = 0.08),
           rangeselector=list(
             buttons=list(
               list(count=1, label="1m", step="month", stepmode="backward"),
               list(count=6, label="6m", step="month", stepmode="backward"),
               list(count=1, label="YTD", step="year", stepmode="todate"),
               list(count=1, label="1y", step="year", stepmode="backward"),
               list(step="all")
               )
             )
           ),
         yaxis = list(
           title = ""
           )
         )
     })


  output$reactable_wide <- renderReactable({
    data_selected_wide() %>%
      reactable(
        filterable = T,
        searchable = T,
        sortable = T,
        resizable = T,
        striped = T,
        showPageSizeOptions = TRUE,
        pageSizeOptions = c(10, 15, 20, 30, 50, 100),
        defaultPageSize = 15,
        defaultSorted = list(location = "asc", date = "desc"),
        defaultColDef = colDef(
          header = function(value) str_to_title(gsub("_", " ", value, fixed = TRUE)),
          align = "center",
          minWidth = 150,
          width = 200
          ),
        columns = list(
          location = colDef(align = "left"),
          #iso_code = colDef(show = F),
          continent = colDef(show = F)
          )
        )
    })

  # output$reactable_long <- renderReactable({
  #   data_selected_long() %>% reactable()
  #   })


}
