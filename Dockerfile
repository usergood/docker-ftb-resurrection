FROM dlord/minecraft
MAINTAINER kurri@glappet.com

ENV FTB_RESURRECTION_URL http://new.creeperrepo.net/FTB2/modpacks/FTBResurrection/1_0_1/FTBResurrectionServer.zip
ENV LAUNCHWRAPPER net/minecraft/launchwrapper/1.11/launchwrapper-1.11.jar

RUN \
    curl -S $FTB_RESURRECTION_URL -o /tmp/infinity.zip && \
    unzip /tmp/infinity.zip -d $MINECRAFT_HOME && \
    mkdir -p $MINECRAFT_HOME/libraries && \
    curl -S https://libraries.minecraft.net/$LAUNCHWRAPPER -o $MINECRAFT_HOME/libraries/$LAUNCHWRAPPER && \
    find $MINECRAFT_HOME -name "*.log" -exec rm -f {} \; && \
    rm -rf $MINECRAFT_HOME/ops.* $MINECRAFT_HOME/whitelist.* $MINECRAFT_HOME/logs/* /tmp/*

ENV MINECRAFT_VERSION 1.7.10
ENV MINECRAFT_OPTS -server -Xms1048m -Xmx6072m -XX:MaxPermSize=256m -XX:+UseParNewGC -XX:+UseConcMarkSweepGC
ENV MINECRAFT_STARTUP_JAR FTBServer.1.7.10.jar

VOLUME ["/opt/minecraft", "/var/lib/minecraft"]
