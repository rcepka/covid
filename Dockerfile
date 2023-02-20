FROM rcepka/shiny-base


COPY /shiny-app ./shiny-app


# install renv & restore packages
RUN Rscript /shiny-app/install_packages.R


# expose port
EXPOSE 3838


# run app on container start
CMD ["R", "-e", "shiny::runApp('/app', host = '0.0.0.0', port = 3838)"]
