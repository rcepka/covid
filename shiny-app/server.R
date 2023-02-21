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
  data_selected <- reactive(
   # data2 %>% filter(location == input$countries),
    data %>%
      #filter(location == input$countries)%>%
      filter(location %in% input$countries) %>%
      select(date, input$variables)
    )




   output$dygr <- renderDygraph({

     # dygraph_data() <- data_selected() %>%
     #   xts(order.by = data_selected()$date)


     dygraph_data <- xts(data_selected(), order.by = data_selected()$date)

     # dygraph(dygraph_data) %>%
     #   dySeries(input$variables) %>%
     #   dyOptions(colors = RColorBrewer::brewer.pal(3, "Set2")) %>%
     #   dyRangeSelector()

     dygraph(dygraph_data) %>%
       dySeries(input$variables) %>%
       dyRangeSelector()

     })


  output$plot <- renderPlot({

    #Without reactive()
    ggplot(data,
      aes(x = date, y = .data[[input$variables]], color = location)
           ) +
      geom_line(show.legend = FALSE)

    # # with reactive()
    # data_selected() %>%
    #   ggplot(aes(x = date, y = input$variables, color = iso_code)) +
    #   geom_line(show.legend = FALSE)



  })




output$reactable <- renderReactable({
  data %>%
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
        iso_code = colDef(show = F),
        continent = colDef(show = F)
        )
      )

})



  output$table <- renderTable({head(data_selected())})

  output$text <- renderText({input$variables})
  output$text2 <- renderText({input$countries})

}
