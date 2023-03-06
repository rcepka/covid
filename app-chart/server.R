#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#source("get_data.R")

# Define server logic required to draw a histogram
function(input, output, session) {



  #Prepare the data frame
  data_selected_wide <- reactive(
    data_wide %>%
      filter(location %in% input$countries) %>%
      select(1, 2, 3, 4, input$variables)
    )

  data_selected_long <- reactive(
    data_long %>%
      filter(location %in% input$countries) %>%
      filter(metric == input$variables)
    )

  data_selected_trends <- reactive(
    data_wide %>%
      na.omit() %>%
      filter(location %in% input$countries) %>%
      select(1, input$variables) %>%
      group_by(location) %>%
      summarise(across(where(is.numeric), list))
    )

  data_selected_trends_long <- reactive(
    data_long %>%
      na.omit() %>%
      filter(location %in% input$countries) %>%
      filter(metric == input$variables) %>%
      group_by(location) %>%
      summarise(across(where(is.numeric), list))
  )




# Render chart witjh Plotly
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
         title = input$variables %>% gsub("_", " ", . , fixed = TRUE) %>% str_to_title(.),
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
               list(count=1, label="1rok", step="year", stepmode="backward"),
               list(step="all")
               )
             )
           ),
         yaxis = list(
           title = ""
           )
         )
     })



# Reactable rendering
  output$reactable_wide <- renderReactable({

    data_selected_wide() %>%
      reactable(
        #width = "75%",
        filterable = T,
        searchable = T,
        sortable = T,
        resizable = T,
        striped = T,
        fullWidth = T,
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
          location = colDef(name = "Krajina/štát", align = "left"),
          iso_code = colDef(show = F),
          continent = colDef(show = F),
          date = colDef(name = "Dátum")
          ),
        language = reactableLang(
          sortLabel = "Sort {name}",
          filterPlaceholder = "",
          filterLabel = "Filtruj {name}",
          searchPlaceholder = "Hľadaj",
          searchLabel = "Hľadaj",
          noData = "Hľadanie neprinieslo žiadne výsledky",
          pageNext = "Ďalej",
          pagePrevious = "Späť",
          pageNumbers = "{page} z {pages}",
          pageInfo = "{rowStart}\u2013{rowEnd} z {rows} riedkov",
          pageSizeOptions = "Ukáž {rows}",
          pageNextLabel = "Ďalšia strana",
          pagePreviousLabel = "Predchádzajúca strana",
          pageNumberLabel = "Strana {page}",
          pageJumpLabel = "Choď na stranu",
          pageSizeOptionsLabel = "Riadkov na stranu",
          groupExpandLabel = "Toggle group",
          detailsExpandLabel = "Toggle details",
          selectAllRowsLabel = "Vyber všetky riadky",
          selectAllSubRowsLabel = "Select all rows in group",
          selectRowLabel = "Select row",
          defaultGroupHeader = NULL,
          detailsCollapseLabel = NULL,
          deselectAllRowsLabel = NULL,
          deselectAllSubRowsLabel = NULL,
          deselectRowLabel = NULL
          )
        )
    })



    # Trends table based on data_long
    output$reactable_trends <- renderReactable({
      data_selected_trends_long() %>% reactable(
        .,
        theme = pff(
          centered = TRUE,
          font_size = 20,
          header_font_size = 24
          ),
        fullWidth = T,
        compact = FALSE,
        defaultColDef = colDef(
          vAlign = "center"
        ),
        columns = list(
          location = colDef(
            name = "Krajina/štát",
            width = 250,
            align = "left"
          ),
          values = colDef(
            name = "Trend",
            minWidth = 800,
            align = "center",
            cell = react_sparkline(
              data = .,
              height = 120,
              line_width = 1.5,
              bandline = 'innerquartiles',
              bandline_color = 'forestgreen',
              bandline_opacity = 0.6,
              show_area = T,
              labels = c('min','max'),
              label_size = '0.9em',
              highlight_points = highlight_points(min = 'blue', max = 'red'),
              margin = reactablefmtr::margin(t=15,r=2,b=15,l=2),
              tooltip_type = 2
            )
          )
        )
      )
    })


}
