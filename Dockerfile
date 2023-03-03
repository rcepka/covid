
FROM rcepka/shiny-verse:latest


RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    dpkg \
    cron \
    nano

## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean




# Create the log file to be able to run tail
RUN touch /var/log/cron.log
#RUN chmod 0644 /var/log/cron.log

CMD service cron start




COPY /shiny-app ./shiny-app

#WORKDIR ./shiny-app


# install renv & restore packages
RUN Rscript /shiny-app/install_packages.R



# Setup cron job
RUN (crontab -l ; echo "* * * * * echo "Hello cron world" >> /var/log/cron.log") | crontab
#RUN (crontab -l ; * * * * * Rscript ~/cron-reporting-example/master.R >> ~/cron-reporting-example/master.log 2>&1 | crontab
RUN (crontab -l ; echo "*/5 * * * * Rscript /shiny-app/global.R  >> /var/log/cron.log") | crontab
RUN (crontab -l ; echo "* * * * * Rscript /shiny-app/test.R  >> /var/log/cron.log") | crontab
RUN (crontab -l ; echo "* * * * * Rscript /test.R  >> /var/log/cron.log") | crontab
RUN (crontab -l ; echo "* * * * * Rscript test2.R  >> /var/log/cron.log") | crontab



# Run the command on container startup
CMD cron && tail -f /var/log/cron.log




# expose port
EXPOSE 3838


# run app on container start
CMD ["R", "-e", "shiny::runApp('/shiny-app', host = '0.0.0.0', port = 3838)"]
