#!/usr/bin/env bash

set -e

APP_JAR="/usr/src/application.jar"
APP_MODULE_PATH="/app/"
APP_BOOT_LAUNCHER="org.springframework.boot.loader.PropertiesLauncher"
APP_CONFIG_LOCATION="file:/home/viloveul/"

exec java $JAVA_OPTS -cp $APP_JAR -Dloader.path=$APP_MODULE_PATH $APP_BOOT_LAUNCHER --spring.config.additional-location=$APP_CONFIG_LOCATION
