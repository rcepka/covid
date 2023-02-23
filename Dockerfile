FROM rcepka/shiny-verse


COPY /shiny-app ./shiny-app
#COPY . .


# install renv & restore packages
RUN Rscript /shiny-app/install_packages.R


# expose port
EXPOSE 3838


# run app on container start
CMD ["R", "-e", "shiny::runApp('/shiny-app', host = '0.0.0.0', port = 3838)"]
