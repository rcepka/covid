
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


start_date <- as.Date("2021-01-01")
end_date <- today() - 1
i <- interval(start_date, end_date) %/% days(1)

start_date + 1

date <- today() - 1
date_formatted <- format(date, format = "%m-%d-%Y")
base_url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/"
urlfile <- paste0(base_url, date_formatted, ".csv")
data_all <- read_csv(url(urlfile)) %>%
  select(!c(1, 2, 3, 12))

data_selected <- data_all %>%
  mutate(Last_Update = date(Last_Update))%>%
  filter(Last_Update == date +1) %>%
  group_by(Country_Region, Last_Update) %>%
  summarise(
    Confirmed = sum(Confirmed, na.rm = T),
    Deaths = sum(Deaths, na.rm = T),
    Recovered = sum(Recovered, na.rm = T),
    Active = sum(Active, na.rm = T),
    Incident_Rate = mean(Incident_Rate, na.rm = T),
    Case_Fatality_Ratio = mean(Case_Fatality_Ratio, na.rm = T)
    )



date <- today() - 2
date_formatted <- format(date, format = "%m-%d-%Y")
base_url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/"
urlfile <- paste0(base_url, date_formatted, ".csv")
data_all2 <- read_csv(url(urlfile)) %>%
  select(!c(1, 2, 3, 12))

data_selected2 <- data_all2 %>%
  mutate(Last_Update = date(Last_Update))%>%
  filter(Last_Update == date +1) %>%
  group_by(Country_Region, Last_Update) %>%
  summarise(
    Confirmed = sum(Confirmed, na.rm = T),
    Deaths = sum(Deaths, na.rm = T),
    Recovered = sum(Recovered, na.rm = T),
    Active = sum(Active, na.rm = T),
    Incident_Rate = mean(Incident_Rate, na.rm = T),
    Case_Fatality_Ratio = mean(Case_Fatality_Ratio, na.rm = T)
  )


unique(data_all$Last_Update)



dim(data_selected)
dim(data_all)




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
#countries_list <- unique(data_wide$location)

# Metrics/variables
variables_id <- colnames(data_wide)
variables_id <- variables_id[-c(1,2,3,4)]
variables_names <- str_to_title(gsub("_", " ", variables_id))
variables <- data.frame(variables_id, variables_names)



all_colnames <- as_tibble(colnames(data_all))
all_colnames <- data_all %>% select(1:4, order(colnames(.))) %>% colnames() %>% as_tibble()

