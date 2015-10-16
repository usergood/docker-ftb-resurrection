FROM phusion/baseimage:0.9.17
MAINTAINER kurri@glappet.com

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
VOLUME /minecraft
WORKDIR /minecraft
USER minecraft
EXPOSE 25565

ENV FTB_RESURRECTION_URL http://new.creeperrepo.net/FTB2/modpacks/FTBResurrection/1.0.1/FTBResurrectionServer.zip
ENV LAUNCHWRAPPER net/minecraft/launchwrapper/1.11/launchwrapper-1.11.jar
ENV MINECRAFT_HOME /minecraft
ENV MINECRAFT_VERSION 1.7.10
ENV MINECRAFT_OPTS -server -Xms1048m -Xmx6072m -XX:MaxPermSize=256m -XX:+UseParNewGC -XX:+UseConcMarkSweepGC
ENV MINECRAFT_STARTUP_JAR FTBServer-1.7.10-1291.jar

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install software-properties-common -y

RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer

RUN useradd -s /bin/bash -d /minecraft -m minecraft

#ADD http://new.creeperrepo.net/FTB2/modpacks/FTBResurrection/1.0.1/FTBResurrectionServer.zip /minecraft/resurrection.zip
RUN apt-get install zip -y
RUN apt-get install curl -y

RUN \
    curl -S $FTB_RESURRECTION_URL -o /tmp/infinity.zip && \
    unzip /tmp/infinity.zip -d $MINECRAFT_HOME && \
    mkdir -p $MINECRAFT_HOME/libraries && \
    curl -S https://libraries.minecraft.net/$LAUNCHWRAPPER -o $MINECRAFT_HOME/libraries/$LAUNCHWRAPPER && \
    find $MINECRAFT_HOME -name "*.log" -exec rm -f {} \; && \
    rm -rf $MINECRAFT_HOME/ops.* $MINECRAFT_HOME/whitelist.* $MINECRAFT_HOME/logs/* /tmp/*
    
#RUN cd /minecraft && unzip resurrection.zip && rm resurrection.zip
RUN echo "eula=true" > /minecraft/eula.txt
RUN chown -R minecraft:minecraft /minecraft

RUN mkdir /etc/service/minecraft
ADD minecraft.sh /etc/service/minecraft/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
