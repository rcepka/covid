
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
  shinycssloaders,
  timetk
)

# get the date and time of actual update
  last_update <- format(Sys.time(), format = "%d.%m.%Y %H:%M")


# #############################
# Data All
# #############################

if (!file.exists("data/data_all.csv") == "TRUE") {

  cat(paste0(Sys.time(), " downloading the data all file because doesnt exists or is old.\n"))


  date_of_file <- format(today() - 7, format = "%m-%d-%Y")
  cat(paste0(Sys.time(), " downloading file of date: ", date_of_file, "\n"))

  # BAse project url: https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data

  base_url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/"
  urlfile <- paste0(base_url, date_of_file, ".csv")
  cat(paste0(Sys.time(), " downloading file of form url: \n", urlfile, "\n"))


  data_all <- read_csv(url(urlfile), col_select = !c(1, 2, 3, 12)) %>%
    mutate(Last_Update = date(Last_Update)) %>%
    #filter(Last_Update == mdy(date_of_file) + 1) %>%
    filter(Last_Update == Last_Update[1]) %>%
    group_by(Country_Region, Last_Update) %>%
    summarise(
      Confirmed = sum(Confirmed, na.rm = T),
      Deaths = sum(Deaths, na.rm = T),
      Recovered = sum(Recovered, na.rm = T),
      Active = sum(Active, na.rm = T),
      Incident_Rate = mean(Incident_Rate, na.rm = T),
      Case_Fatality_Ratio = mean(Case_Fatality_Ratio, na.rm = T)
    )

  # Summarized data
  data_all_summarized <- data_all %>%
    ungroup() %>%
    summarise(
      TotalCases = sum(Confirmed, na.rm = T),
      TotalDeaths = sum(Deaths)
    )


  write_csv(data_all, "data/data_all.csv")
  write_csv(data_all_summarized, "data/data_all_summarized.csv")

} else {

  cat(paste0(Sys.time(), " file exists, skip downloading and loading it locally.\n"))

  data_all <- read_csv("data/data_all.csv")
  data_all_summarized <- read_csv("data/data_all_summarized.csv")

}




# #############################
# Confirmed cases
# #############################

if (!file.exists("data/cases.csv") == "TRUE") {

  cat(paste0(Sys.time(), " downloading the data all file because doesnt exists or is old.\n"))

  cases <- read_csv(url(
    "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"),
    col_select = !c(1, 3, 4))


  cases <- cases %>%
    rename(Country = 1) %>%
    group_by(Country) %>%
    summarise(across(where(is.numeric), sum))


  cases_L <- cases %>%
    pivot_longer(
      !Country,
      names_to = "Date",
      values_to = "Cases"
      ) %>%
    mutate(
      Date = lubridate::mdy(Date)
      ) %>%
    nest(.by = Country) %>%
    mutate(data = map(data,
                      ~ mutate(.x,
                               Cases.New = Cases - lag(Cases)
                               )
                      )
           ) %>%
    unnest(data)


  write_csv(cases, "data/cases.csv")
  write_csv(cases_L, "data/cases_L.csv")


} else {


  cat(paste0(Sys.time(), " file exists, skip downloading and loading it locally.\n"))

  cases <- read_csv("data/cases.csv")
  cases_L <- read_csv("data/cases_L.csv")

}







# #############################
# Confirmed deaths
# #############################

if (!file.exists("data/deaths.csv") == "TRUE") {


  cat(paste0(Sys.time(), " downloading the data all file because doesnt exists or is old.\n"))

  deaths <- read_csv(url(
    "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"),
    col_select = !c(1, 3, 4))


  deaths <- deaths %>%
    rename(Country = 1) %>%
    group_by(Country) %>%
    summarise(across(where(is.numeric), sum))


  deaths_L <- deaths %>%
    pivot_longer(
      !Country,
      names_to = "Date",
      values_to = "Deaths"
      ) %>%
    mutate(Date = lubridate::mdy(Date)) %>%
    nest(.by = Country) %>%
    mutate(data = map(data,
                      ~ mutate(.x,
                               Deaths.New = Deaths - lag(Deaths)
                               )
                      )
           ) %>%
    unnest(data)


  write_csv(deaths, "data/deaths.csv")
  write_csv(deaths_L, "data/deaths_L.csv")


} else {


  cat(paste0(Sys.time(), " file exists, skip downloading and loading it locally.\n"))

  deaths <- read_csv("data/deaths.csv")
  deaths_L <- read_csv("data/deaths_L.csv")

}





# #############################
#  recovered
# #############################

if (!file.exists("data/recovered.csv") == "TRUE") {


  cat(paste0(Sys.time(), " downloading the data all file because doesnt exists or is old.\n"))


  recovered <- read_csv(url(
    "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv"),
    col_select = !c(1, 3, 4))


  recovered <- recovered %>%
    rename(Country = 1) %>%
    group_by(Country) %>%
    summarise(across(where(is.numeric), sum))


  recovered_L <- recovered %>%
    pivot_longer(
      !Country,
      names_to = "Date",
      values_to = "Recovered"
      ) %>%
    mutate(Date = lubridate::mdy(Date)) %>%
    nest(.by = Country) %>%
    mutate(data = map(data,
                      ~ mutate(.x,
                               Recovered.New = Recovered - lag(Recovered)
                               )
                      )
           ) %>%
    unnest(data)


  write_csv(recovered, "data/recovered.csv")
  write_csv(recovered_L, "data/recovered_L.csv")


} else {


  cat(paste0(Sys.time(), " file exists, skip downloading and loading it locally.\n"))

  recovered <- read_csv("data/recovered.csv")
  recovered_L <- read_csv("data/recovered_L.csv")

}





# #############################
#  Vaccines
# #############################

if (!file.exists("data/vaccines.csv") == "TRUE") {


  cat(paste0(Sys.time(), " downloading the data all file because doesnt exists or is old.\n"))


  vaccines <- read_csv(url(
    #"https://raw.githubusercontent.com/govex/COVID-19/master/data_tables/vaccine_data/global_data/time_series_covid19_vaccine_doses_admin_global.csv"),
    "https://raw.githubusercontent.com/govex/COVID-19/master/data_tables/vaccine_data/global_data/time_series_covid19_vaccine_global.csv"),
    col_select = !c(2, 3)
    )

  vaccines <- vaccines %>%
    rename(Country = Country_Region) %>%
    nest(.by = Country) %>%
    mutate(data = map(data,
                      ~ mutate(.x,
                               Doses_admin.New = Doses_admin - lag(Doses_admin),
                               People_at_least_one_dose.New = People_at_least_one_dose - lag(People_at_least_one_dose)
                               )
                      )
           ) %>%
    unnest(data)



  # # filter only latest date records
  # vaccines <- vaccines %>%
  #   filter(Date == max(Date))
  #   #bind_rows(summarise_all(., ~if(is.numeric(.)) sum(.) else "Total"))
  #
  #
  # Summerized vaccines
  vaccines_summarised <- vaccines %>%
    summarise(
      Doses_admin = sum(Doses_admin, na.rm = T),
      People_at_least_one_dose = sum(People_at_least_one_dose, na.rm = T)
    )


  write_csv(vaccines, "data/vaccines.csv")
  write.csv(vaccines_summarised, "data/vaccines_summarised.csv")


} else {


  cat(paste0(Sys.time(), " file exists, skip downloading and loading it locally.\n"))
  vaccines <- read_csv("data/vaccines.csv")
  vaccines_summarised <- read_csv("data/vaccines_summarised.csv")

}



# #############################
# Table
# #############################

countries_table <- data_all %>%
  select(1, 3, 4) %>%
  reactable(
    theme = cyborg(),
    pagination = F,
    height = 700,
    fullWidth = F,
    #width = 100,
    columns = list(
      Country_Region = colDef(name = "Štát")
    )
    )





# #############################
# End data frames
# #############################

  data_total <- left_join(
    cases_L, deaths_L, by = c("Country", "Date")
    )

  data_total <- left_join(
    data_total, recovered_L, by = c("Country", "Date")
  )

  data_total <- left_join(
    data_total, vaccines, by = c("Country", "Date")
  )






  # # Add columns with new variables => new
  # data_total <- data_total %>%
  #   # mutate(
  #   #   Cases.New = ifelse(Cases - lag(Cases) < 0, 0, Cases - lag(Cases)),
  #   #   Deaths.New = ifelse(Deaths - lag(Deaths) < 0, 0, Deaths - lag(Deaths)),
  #   #   Recovered.New = ifelse(Recovered - lag(Recovered) < 0, 0, Recovered - lag(Recovered)),
  #   #   Doses_admin.New = ifelse(Doses_admin - lag(Doses_admin) < 0, 0, Doses_admin - lag(Doses_admin)),
  #   #   People_at_least_one_dose.New = ifelse(People_at_least_one_dose - lag(People_at_least_one_dose) < 0, 0, People_at_least_one_dose - lag(People_at_least_one_dose))
  #   # ) %>%
  #   mutate(
  #     Cases.New = Cases - lag(Cases),
  #     Deaths.New = Deaths - lag(Deaths),
  #     Recovered.New = Recovered - lag(Recovered),
  #     Doses_admin.New = Doses_admin - lag(Doses_admin),
  #     People_at_least_one_dose.New = People_at_least_one_dose - lag(People_at_least_one_dose)
  #   ) %>%
  #   relocate(Cases.New, .after = Cases) %>%
  #   relocate(Deaths.New, .after = Deaths) %>%
  #   relocate(Recovered.New, .after = Recovered) %>%
  #   relocate(Doses_admin.New, .after = Doses_admin) %>%
  #   relocate(People_at_least_one_dose.New, .after = People_at_least_one_dose)



  # Create the list of date by week and 28-days period
  start_date <- ymd(min(data_total$Date))
  end_date <- ymd(max(data_total$Date))
  dates_7_days <- seq(ymd(start_date), ymd(end_date), by = "7 days")
  dates_28_days <- seq(ymd(start_date), ymd(end_date), by = "28 days")


  data_weekly <- data_total %>%
    #group_by(Country) %>%
    filter(Date %in% dates_7_days) %>%
    group_by(Date) %>%
    #summarise(across(Cases:People_at_least_one_dose.New, ~sum(.x, na.rm = T)))
    summarise_if(is.numeric, sum, na.rm = TRUE)

  data_monthly <- data_total %>%
    filter(Date %in% dates_28_days) %>%
    group_by(Date) %>%
    summarise_if(is.numeric, sum, na.rm = T)



  # # Other way, using the Timetk library
  # data_weekly <- data_total %>%
  #   group_by(Date) %>%
  #   summarise_by_time(
  #     .date_var = Date,
  #     .by = "week",
  #     Cases = sum(Cases),
  #     Cases.New2 = sum(Cases.New)
  #   )





  # plot_cases_weekly <- data_weekly %>%
  #   plot_ly() %>%
  #   add_bars(x = ~Date, y = ~Cases.New, color = I("red")) %>%
  #   layout(height = 300)
  #
  # plot_deaths_weekly <- data_weekly %>%
  #   plot_ly() %>%
  #   add_bars(x = ~Date, y = ~Deaths.New, color = I("white"))
  #
  # plot_doses_weekly <- data_weekly %>%
  #   plot_ly() %>%
  #   add_bars(x = ~Date, y = ~Doses_admin.New, color = I("green"))
  #
  # subplot(
  #   plot_cases_weekly,
  #   plot_deaths_weekly,
  #   plot_doses_weekly,
  #         nrows = 3)









  # # Testing mutate of nested data
  # cases_L <- cases_L %>%
  #   nest(.by = Country) %>%
  #   mutate(data = map(data,
  #                     ~ mutate(.x,
  #                              Cases.New = Cases - lag(Cases)
  #                              )
  #                     )
  #          ) %>%
  #   unnest(data)

