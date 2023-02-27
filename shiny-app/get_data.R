

# Download data from Ourworldindata website
# https://github.com/owid/covid-19-data/tree/master/public/data

if (!file.exists("data/covid.csv") == "TRUE") {

  print("downloading file because doesnt exists or is old.")

  download.file("https://covid.ourworldindata.org/data/owid-covid-data.csv", "data/covid.csv")

} else {

    print("file exists, skip downloading.")

  }


# import dataset into R
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



# Populate select input widgets

# Select input choice - Countries
countries_list <- unique(data_wide$location)

# Metrics/variables
variables_id <- colnames(data_wide)
variables_id <- variables_id[-c(1,2)]
variables_names <- str_to_title(gsub("_", " ", variables_id))
variables <- data.frame(variables_id, variables_names)



# Summary data to display on the map


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


all_colnames <- as_tibble(colnames(data_all))



# #
# # Spraklines testing
# #
# sparklines_data <- data_long %>%
#   group_by(location, date = lubridate::floor_date(date, "month")) %>%
#   na.omit(.) %>%
#   summarize(across(where(is.numeric), list)) %>%
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
# sparkline(sparklines_data$values[2], "line")
#
# library(sparkline)
#
# remotes::install_github("timelyportfolio/dataui")
