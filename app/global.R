
cat(paste0(Sys.time(), "starting the app!...\n"))
if (!require("pacman")) install.packages("pacman")


cat(paste0(Sys.time(), " Loading r packages with Pacman\n"))
pacman::p_load(
  shiny,
  tidyverse,
  #ggplot2,
  plotly,
  reactable,
  reactablefmtr,
  shinyWidgets,
  bslib,
  lubridate,
  dataui,
  shinycssloaders,
  here,
  readr
)






# refresh data every ...
autoInvalidate <- reactiveTimer(1000 * 60 * 60 * 24 * 7, NULL)
cat(paste0(Sys.time(), " Setting autoInvalidater\n"))
#autoInvalidate <- reactiveTimer(1000 * 60, NULL)




# Download data from Ourworldindata website
# https://github.com/owid/covid-19-data/tree/master/public/data



data_all <- reactive({

  autoInvalidate()

  cat(paste0(Sys.time(), " Downloading the main data from internet\n"))

  read_csv(
    url("https://covid.ourworldindata.org/data/owid-covid-data.csv")
    #file = here("covid", "chart", "app", "data", "covid.csv")
    #file = here("app", "data", "covid.csv")
  )
})



# prepare first test dataset
cat(paste0(Sys.time(), " Data cleansing START - data_wide\n"))
data_selected <- reactive({



  data_all() %>%
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



})
cat(paste0(Sys.time(), " Data cleansing STOP - data_wide \n"))



# countries <- reactive({
#
#   #autoInvalidate()
#
#   #cat(paste0(Sys.time(), " Downloading the Countries data set\n"))
#
#   read_csv(
#     file = here("app", "data", "world_countries.csv"),
#     #file = here("covid", "chart", "app", "data", "world_countries.csv"),
#     col_select = c(3, "sk")
#     ) %>%
#     rename(iso_code = 1,
#            country = 2
#            ) %>%
#     mutate(iso_code = toupper((iso_code)))
#
#   #cat(paste0(Sys.time(), " Countries data set cleansing finish\n"))
#
# })
#
# countries <- isolate(countries())



cat(paste0(Sys.time(), " Downloading the Countries data set\n"))
countries <- read_csv(
  file = here("data", "world_countries.csv"),
  #file = here("app", "data", "world_countries.csv"),
  #file = here("covid", "chart", "app", "data", "world_countries.csv"),
  col_select = c(3, "sk")
  ) %>%
  rename(
    iso_code = 1,
    country = 2
    ) %>%
  mutate(iso_code = toupper((iso_code)))

  cat(paste0(Sys.time(), " Countries data set cleansing finish\n"))





cat(paste0(Sys.time(), " Creating data_wide table \n"))
data_wide <- reactive({

  left_join(
    data_selected(), countries, by="iso_code"
     ) %>%
    relocate(country, .after = location) %>%
    select(-location) %>%
    rename(location = country) %>%
    filter(!is.na(location))

})

cat(paste0(Sys.time(), " data_wide table creation finish \n "))




cat(paste0(Sys.time(), " Creating data_long data frame\n"))
data_long <- reactive({

  data_wide() %>%
    pivot_longer(
      cols = !c(1,2,3,4), names_to = "metric", values_to = "values"
      )
})
cat(paste0(Sys.time(), " data_long data frame creation finish\n"))


#
# Populate select input widgets
#
# Select input choice - Countries
cat(paste0(Sys.time(), " Preparation of select input widget data\n"))

# List of countries
#countries_list <- unique(data_wide$location)

# Metrics/variables

# variables_id <- reactive({
#   colnames(data_wide())
#   #variables_id[-c(1,2,3,4)]
#   })
variables_id <- reactive({
  colnames(data_wide())[-c(1,2,3,4)]
  })

variables_names <- reactive(
  str_to_title(gsub("_", " ", variables_id()))
  )

variables <- reactive(
  data.frame(variables_id(), variables_names())
  )

variables2 <- reactive(
  factor(variables_id(), variables_names())
)
# all_colnames <- reactive(as_tibble(colnames(data_all())))
# all_colnames <- reactive({data_all() %>% select(1:4, order(colnames(.))) %>% colnames() %>% as_tibble()})

