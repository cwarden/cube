FROM debian:stable
MAINTAINER Christian G. Warden <christian.warden@greatvines.com>

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

# Make sure the repository information is up to date
RUN apt-get update && apt-get -y install git curl make g++ python man-db

RUN adduser --disabled-password --gecos "Node User" nodejs

RUN git clone https://github.com/creationix/nvm.git /srv/nvm
RUN echo ". /srv/nvm/nvm.sh; nvm install 0.10; nvm alias default 0.10" | bash -l
RUN echo '. /srv/nvm/nvm.sh; npm install -g supervisor foreman' | bash -l

RUN chown -R nodejs:nodejs /srv
RUN chown -R nodejs:nodejs /.npm

RUN echo '. /srv/nvm/nvm.sh' > /srv/bash_init
RUN echo 'export MONGODB_URI=mongodb://$MONGODB_1_PORT_27017_TCP_ADDR:$MONGODB_1_PORT_27017_TCP_PORT/cube' >> /srv/bash_init

USER nodejs
WORKDIR /srv/cube
ENV BASH_ENV /srv/bash_init
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["npm install && nf -p 1080 start $SERVICE"]

VOLUME /srv/cube

EXPOSE 1080
EXPOSE 1180
