
print("starting the app!")
cat(paste0(Sys.time(), "starting the app!...\n"))
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


# Download data from Ourworldindata website
# https://github.com/owid/covid-19-data/tree/master/public/data

if (!file.exists("data/covid.csv") == "TRUE") {

  cat(paste0(Sys.time(), " downloading file because doesnt exists or is old.\n"))
  download.file("https://covid.ourworldindata.org/data/owid-covid-data.csv", "data/covid.csv")

} else {

    cat(paste0(Sys.time(), " file exists, skip downloading.\n"))

  }



# import data set into R
#data <- read_csv(here("shiny-app", "data", "covid.csv"))
print("Reading csv data into R data frame...")
data_all <- read_csv("data/covid.csv")
print("Dataframe loaded")


# prepare first test dataset
print("Data cleansing - main data table")
data_wide <- data_all %>%
  select(
    iso_code,
    continent,
    location,
    date,
    total_cases,
    total_cases_per_million,
    new_cases,
    new_cases_per_million,
    total_deaths,
    total_deaths_per_million,
    new_deaths,
    new_deaths_per_million,
    new_tests,
    new_tests_per_thousand,
    total_tests,
    total_tests_per_thousand,
    new_vaccinations,
    total_vaccinations,
    total_vaccinations_per_hundred,
    people_fully_vaccinated,
    people_fully_vaccinated_per_hundred,
    people_vaccinated,
    people_vaccinated_per_hundred,
    total_boosters,
    total_boosters_per_hundred,
    hosp_patients,
    hosp_patients_per_million,
    icu_patients,
    icu_patients_per_million,
    weekly_hosp_admissions,
    weekly_hosp_admissions_per_million,
    weekly_icu_admissions,
    weekly_icu_admissions_per_million,
    cardiovasc_death_rate,
    diabetes_prevalence,
    excess_mortality,
    excess_mortality_cumulative,
    excess_mortality_cumulative_absolute,
    excess_mortality_cumulative_per_million,
    extreme_poverty
    )
print("Main data table ready")



countries <- read_csv(
  file = "data/world_countries.csv",
  col_select = c(3, "sk")
  ) %>%
  rename(iso_code = 1,
         country = 2
         ) %>%
  mutate(iso_code = toupper((iso_code)))




data_wide <- left_join(data_wide, countries, by="iso_code") %>%
  relocate(country, .after = location) %>%
  select(-location) %>%
  rename(location = country) %>%
  filter(!is.na(location))


print("Creating data long data frame")
data_long <- data_wide %>%
  pivot_longer(
    cols = !c(1,2,3,4), names_to = "metric", values_to = "values")


#
# Populate select input widgets
#
# Select input choice - Countries
print("Generating Select input widgets data")

# List of countries
countries_list <- unique(data_wide$location)

# Metrics/variables
variables_id <- colnames(data_wide)
variables_id <- variables_id[-c(1,2,3,4)]
variables_names <- str_to_title(gsub("_", " ", variables_id))
variables <- data.frame(variables_id, variables_names)



all_colnames <- as_tibble(colnames(data_all))
all_colnames <- data_all %>% select(1:4, order(colnames(.))) %>% colnames() %>% as_tibble()




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
#   print("Deleting file")
#   cat(paste0(Sys.time(), "Now we are delete the file with data, because we want to test if it will be correctly downloaded again!!!\n
#              again\nagain\nagain\nagain\nagain\nagain\nagain\nagain\nagain\nagain\n"))
#
# unlink("data/covid.csv")
# cat(paste0(Sys.time(), "File was probably deleted .....\n"))
