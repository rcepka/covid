
print("starting the app!")
 if (!require("pacman")) install.packages("pacman")


print("Loading r packages with Pacman")

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


# Download data from Ourworldindata website
# https://github.com/owid/covid-19-data/tree/master/public/data

if (!file.exists("data/covid.csv") == "TRUE") {

  print("downloading file because doesnt exists or is old.")

  download.file("https://covid.ourworldindata.org/data/owid-covid-data.csv", "data/covid.csv")

} else {

    print("file exists, skip downloading.")

  }


# import data set into R
#data <- read_csv(here("shiny-app", "data", "covid.csv"))
print("Reading csv data into R data frame...")
data_all <- read_csv("data/covid.csv")
print("Dataframe ready")


# prepare first test dataset
print("Data cleansing - main data table")
data_wide <- data_all %>%
  select(
    #iso_code,
    # continent,
    location, # country
    date,
    total_cases,
    new_cases,
    total_deaths,
    new_deaths,
    total_cases_per_million,
    new_cases_per_million,
    total_deaths_per_million,
    new_deaths_per_million,
    reproduction_rate,
    icu_patients,
    icu_patients_per_million,
    total_vaccinations,
    people_vaccinated,
    people_fully_vaccinated,
    new_vaccinations,
    )
print("Main data table ready")




print("Creating data long data frame")
data_long <- data_wide %>%
  pivot_longer(
    cols = !c(1,2), names_to = "metric", values_to = "values")


#
# Populate select input widgets
#
# Select input choice - Countries
print("Generating Select input widgets data")

# List of countries
countries_list <- unique(data_wide$location)

# Metrics/variables
variables_id <- colnames(data_wide)
variables_id <- variables_id[-c(1,2)]
variables_names <- str_to_title(gsub("_", " ", variables_id))
variables <- data.frame(variables_id, variables_names)



all_colnames <- as_tibble(colnames(data_all))




# #
# # Trends data frame
# #
# print("Building Trends data frame")
#
trends2 <- data_wide %>%
  na.omit() %>%
 # filter(location %in% c("Afganistan", "Angola", "Austria", "Belgium")) %>%
  select(1, 2, 3, 4) %>%
  group_by(location) %>%
  summarise(across(where(is.numeric), list))

# trends_L <- data_long %>%
#   na.omit() %>%
#   filter(location %in% input$countries) %>%
#   filter(metric == input$variables) %>%
#   group_by(location) %>%
#   summarise(across(where(is.numeric), list))


# trends2 %>% reactable(
#   .,
#   theme = pff(centered = TRUE),
#   compact = TRUE,
#   columns = list(
#     total_cases = colDef(
#       cell = react_sparkline(
#         data = .,
#         height = 100,
#         line_width = 1.5,
#         bandline = 'innerquartiles',
#         bandline_color = 'forestgreen',
#         bandline_opacity = 0.6,
#         labels = c('min','max'),
#         label_size = '0.9em',
#         highlight_points = highlight_points(min = 'blue', max = 'red'),
#         margin = reactablefmtr::margin(t=15,r=2,b=15,l=2),
#         tooltip_type = 2
#       )
#     ),
#     new_cases = colDef(
#       width = 400,
#         cell = react_sparkline(
#           data = .,
#           height = 100,
#           line_width = 1.5,
#           bandline = 'innerquartiles',
#           bandline_color = 'forestgreen',
#           bandline_opacity = 0.6,
#           labels = c('min','max'),
#           label_size = '0.9em',
#           highlight_points = highlight_points(min = 'blue', max = 'red'),
#           margin = reactablefmtr::margin(t=15,r=2,b=15,l=2),
#           tooltip_type = 2
#           )
#         )
#       )
#   )






#
# Summary data to display on the map
#
print("Genrating data for LEaflet mapping")
summary <- data_wide %>%
  group_by(location) %>%
  summarise(
    #total_cases = max(total_cases, na.rm = TRUE),
    total_deaths = max(total_deaths, na.rm = T),
    new_deaths = sum(new_deaths, na.rm = T)
  )

# library(leaflet)
# library(maps)
#
# summary %>% leaflet() %>%
#   addTiles()
# map("svk")






#
#
# #
# # Sparklines testing
# #
# sparklines_data_L <- data_long %>%
#   group_by(location, date = lubridate::floor_date(date, "month")) %>%
#   na.omit(.) %>%
#   summarize(across(where(is.numeric), list))
#
# sparklines_data_W2 <- data_wide %>%
#   #group_by(location, date = lubridate::floor_date(date, "month")) %>%
#   group_by(location) %>%
#   #na.omit(.) %>%
#   summarize(across(where(is.numeric), list), na.rm = TRUE)
#
#
#
#   reactable(
#     .,
#     values = colDef(
#       cell = react_sparkline(
#         #data = .,
#         height = 100,
#         line_width = 1.5,
#         bandline = 'innerquartiles',
#         bandline_color = 'forestgreen',
#         bandline_opacity = 0.6,
#         labels = c('min','max'),
#         label_size = '0.9em',
#         highlight_points = highlight_points(min = 'blue', max = 'red'),
#         margin = reactablefmtr::margin(t=15,r=2,b=15,l=2),
#         tooltip_type = 2
#       )
#     )
#   )
#
#
#
#
#
#sparklines_data_L %>%
# sparklines_data_W %>%
#   filter(location %in% c("Algeria", "Argentina")) %>%
# reactable(
#   .,
#   theme = pff(centered = TRUE),
#   compact = TRUE,
#   columns = list(
#    new_cases = colDef(
#       cell = react_sparkline(
#         data = .,
#         height = 100,
#         line_width = 1.5,
#         bandline = 'innerquartiles',
#         bandline_color = 'forestgreen',
#         bandline_opacity = 0.6,
#         labels = c('min','max'),
#         label_size = '0.9em',
#         highlight_points = highlight_points(min = 'blue', max = 'red'),
#         margin = reactablefmtr::margin(t=15,r=2,b=15,l=2),
#         tooltip_type = 2
#       )
#     )
#   )
# )

#
#
#
#
#
#
#
#
#
#
#
#
#
# sparkline(sparklines_data$values[2], "line")
#
# library(sparkline)
#
# remotes::install_github("timelyportfolio/dataui")
# library(sparkline)
# a <- list(1, 2, 3, 5 , 8, 2)
# b <- list(c(1, 2, 3))
# c <- c(5,6,7,8)
# sparkline(a, "line")
#
# a %>%
#   reactable(
#     .,
#     values = colDef(
#       cell = react_sparkline(
#         data = .,
#         height = 100,
#         line_width = 1.5,
#         bandline = 'innerquartiles',
#         bandline_color = 'forestgreen',
#         bandline_opacity = 0.6,
#         labels = c('min','max'),
#         label_size = '0.9em',
#         highlight_points = highlight_points(min = 'blue', max = 'red'),
#         margin = reactablefmtr::margin(t=15,r=2,b=15,l=2),
#         tooltip_type = 2
#       )
#     )
#   )
#
#
#
#
#
#
# install.packages("palmerpenguins")
# library(palmerpenguins)
# data(package = 'palmerpenguins')
#
# remotes::install_github("timelyportfolio/dataui")
#
#
# penguins %>%
#   group_by(species, island) %>%
#   na.omit(.) %>%
#   summarize(across(where(is.numeric), list)) %>%
#   mutate(penguin_colors = case_when(
#     species == 'Adelie' ~ '#F5A24B',
#     species == 'Chinstrap' ~ '#AF52D5',
#     species == 'Gentoo' ~ '#4C9B9B',
#     TRUE ~ 'grey'
#   )) %>%
#   select(-c(year,body_mass_g,flipper_length_mm)) %>%
#   reactable(
#     .,
#     theme = pff(centered = TRUE),
#     compact = TRUE,
#     columns = list(
#       species = colDef(maxWidth = 90),
#       island = colDef(maxWidth = 85),
#       penguin_colors = colDef(show = FALSE),
#       bill_length_mm = colDef(
#         cell = react_sparkline(
#           data = .,
#           height = 100,
#           line_width = 1.5,
#           bandline = 'innerquartiles',
#           bandline_color = 'forestgreen',
#           bandline_opacity = 0.6,
#           labels = c('min','max'),
#           label_size = '0.9em',
#           highlight_points = highlight_points(min = 'blue', max = 'red'),
#           margin = reactablefmtr::margin(t=15,r=2,b=15,l=2),
#           tooltip_type = 2
#         )
#       ),
#       bill_depth_mm = colDef(
#         cell = react_sparkline(
#           data = .,
#           height = 100,
#           line_width = 1.5,
#           bandline = 'innerquartiles',
#           bandline_color = 'forestgreen',
#           bandline_opacity = 0.6,
#           labels = c('min','max'),
#           label_size = '0.9em',
#           highlight_points = highlight_points(min = 'blue', max = 'red'),
#           margin = reactablefmtr::margin(t=15,r=2,b=15,l=2),
#           tooltip_type = 2
#         )
#       )
#     )
#   )
#
#
#
# penguins_changed_2 <- penguins %>%
#   group_by(species, island) %>%
#   na.omit(.) %>%
#   summarize(across(where(is.numeric), list)) %>%
#   mutate(penguin_colors = case_when(
#     species == 'Adelie' ~ '#F5A24B',
#     species == 'Chinstrap' ~ '#AF52D5',
#     species == 'Gentoo' ~ '#4C9B9B',
#     TRUE ~ 'grey'
#   )) %>%
#   select(-c(year,body_mass_g,flipper_length_mm))

