

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
print("Reading data into R data frame...")
data <- read_csv("data/covid.csv")


# prepare first test dataset
data <- data %>%
  select(iso_code,
         continent,
         location, # country
         date,
         total_cases,
         new_cases,
         total_deaths,
         new_deths,
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




data_deaths <- data %>%
  select(1:5, 8) %>%
  filter(iso_code == "AFG") %>%
  mutate(date = as.Date(date)) %>%
  mutate(date = as.POSIXct(date)) %>%
  xts(order.by = data_deaths$date)

a <- xts(data_deaths, order.by = data_deaths$date)

  dygraph(data_deaths) %>%
    dyRangeSelector(dateWindow = c("2022-10-01", "2022-11-01"))
  dygraph(a)


