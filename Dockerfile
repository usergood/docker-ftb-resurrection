FROM phusion/baseimage:0.9.17
MAINTAINER kurri@glappet.com

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
VOLUME /minecraft
WORKDIR /minecraft
USER minecraft
EXPOSE 25565

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install software-properties-common -y

RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer

RUN useradd -s /bin/bash -d /minecraft -m minecraft

ADD http://new.creeperrepo.net/FTB2/modpacks/FTBResurrection/1.0.1/FTBResurrectionServer.zip /minecraft/resurrection.zip

RUN apt-get install zip -y
RUN cd /minecraft && unzip resurrection.zip && rm resurrection.zip
RUN echo "eula=true" > /minecraft/eula.txt
RUN chown -R minecraft:minecraft /minecraft

RUN mkdir /etc/service/minecraft
ADD minecraft.sh /etc/service/minecraft/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
