#
#
#
# Download data from Ourworldindata website
# https://github.com/owid/covid-19-data/tree/master/public/data

  cat(paste0(Sys.time(), " downloading data file within regular cron job.\n"))

  download.file("https://covid.ourworldindata.org/data/owid-covid-data.csv", "/shiny-app/data/covid.csv")

  cat(paste0(Sys.time(), " downloaded data file from website.\n"))


