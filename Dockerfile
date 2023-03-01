
FROM rcepka/shiny-verse:latest


RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    dpkg \
    cron


RUN service cron start


## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

COPY /shiny-app ./shiny-app
#COPY / ./


# install renv & restore packages
RUN Rscript /shiny-app/install_packages.R


# expose port
EXPOSE 3838


# run app on container start
CMD ["R", "-e", "shiny::runApp('/shiny-app', host = '0.0.0.0', port = 3838)"]
