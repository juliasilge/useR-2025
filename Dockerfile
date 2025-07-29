FROM rocker/tidyverse:4.5.0
ENV RENV_CONFIG_REPOS_OVERRIDE=https://packagemanager.rstudio.com/cran/latest

# Set up ssh
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd \
    && echo 'root:root' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config


# Set up R environment
RUN mkdir -p /root/flights-demo
COPY flights.parquet /root/flights-demo/flights.parquet
RUN Rscript -e "install.packages('duckplyr')"

EXPOSE 22

ENTRYPOINT ["bash", "-c", "service ssh restart && bash"]

# docker build --platform linux/amd64 -t flights-demo . 
# docker run --rm --name flights-demo-container -it -p 3456:22 flights-demo
# docker ps 
# docker port flights-demo-container
# docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' flights-demo-container