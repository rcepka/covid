

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


data <- data %>%
  mutate(date = as.Date(date)) %>%
  mutate(date = as.POSIXct(date))



data_L <- data %>%
  pivot_longer(!1:4, names_to = "metric", values_to = "values")
#  dygraph(data_L) %>%
#    dyRangeSelector()




#data <- xts(data, order.by = data$date)



data_deaths <- data %>%
  select(1:5, 8) %>%
  filter(iso_code == "AFG") %>%
  mutate(date = as.Date(date)) %>%
  mutate(date = as.POSIXct(date))

data_deaths <- xts(data_deaths, order.by = data_deaths$date)



  # dygraph(data_deaths) %>%
  #   dyRangeSelector()
  #dygraph(data2)


# Populate select input widgets
# Select input choice - Countries
countries_list <- unique(data$location)
variables_list <- colnames(data)
variables_list <- variables_list[-c(1,2,3,4)]


