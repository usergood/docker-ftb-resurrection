#!/bin/sh

cd /minecraft
exec /sbin/setuser minecraft java $MINECRAFT_OPTS -jar $MINECRAFT_STARTUP_JAR 2>&1 | logger
