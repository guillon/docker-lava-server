FROM debian:jessie-backports

#
# Installs lava-server from images.validation.linaro.org repository.
#
# Sources at: https://github.com/guilon/lava-server.
#
# For LAVA installation documentation, refer to:
# http://www.linaro.org/
# https://porter.automotivelinux.org/static/docs/v2/
# https://porter.automotivelinux.org/static/docs/v2/installing_on_debian.html
#
# In order to access the lava-server http service, one may at least
# bind the port 80, for instance run this image with:
#
#  $ docker run --name lava-server -d -p 8080:80 guillon/lava-server
#
# and browse lava-server at http://localhost:8080.
#
# Note that it is important to split the installation of postgresql
# and lava-server into separate commands and start postgresql before
# actually installing lava-server which needs a running instance for
# confiouration.
#
# Note that the provided entrypoint.sh will create an initial admin
# accouint optionally and set the initial password to changeit.
#
# The important VOLUMES for persistent storage are defined at the end
# of the file.
#

MAINTAINER Christophe Guillon <christophe.guillon@st.com>

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y wget && \
    wget -q http://images.validation.linaro.org/production-repo/production-repo.key.asc && \
    apt-key add production-repo.key.asc && rm production-repo.key.asc && \
    echo "deb http://images.validation.linaro.org/production-repo sid main" >/etc/apt/sources.list.d/linaro.list

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y expect postgresql && \
    apt-get install -t jessie-backports -y python-django python-django-tables2 && \
    apt-get install -y lava-tool lava-dispatcher lava-coordinator && \
    apt-get install -y apache2

RUN service postgresql start && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y lava-server && \
    service postgresql stop && \
    apt-get clean

RUN a2dissite 000-default && \
    a2ensite lava-server.conf

VOLUME /var/lib/lava
VOLUME /var/lib/lava-server
VOLUME /var/lib/postgresql

EXPOSE 80
EXPOSE 5432
EXPOSE 3079

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
