#!/bin/bash

function java9 {
	sudo update-alternatives --set java /usr/lib/jvm/java-9-oracle/bin/java;export JAVA_HOME=/usr/lib/jvm/java-9-oracle
}
function java8 {
	sudo update-alternatives --set java /usr/lib/jvm/java-8-oracle/jre/bin/java;export JAVA_HOME=/usr/lib/jvm/java-8-oracle
}
function java7 {
	sudo update-alternatives --set java /usr/lib/jvm/java-7-oracle/jre/bin/java;export JAVA_HOME=/usr/lib/jvm/java-7-oracle
}
function java6 {
	sudo update-alternatives --set java /usr/lib/jvm/java-6-oracle/jre/bin/java;export JAVA_HOME=/usr/lib/jvm/java-6-oracle
}

#echo "change versions"
#exit
java8
rm release.properties
REL=7.0.2
DEV=7.0.3-SNAPSHOT
REPOID=orgsimpleflatmapper-1668
mvn --batch-mode -Dtag=sfm-parent-$REL -Pdev release:prepare \
                 -DreleaseVersion=$REL \
                 -DdevelopmentVersion=$DEV
cp release.properties tmp/release.properties

GPG_TTY=$(tty)
export GPG_TTY


java7
cp tmp/release.properties .
mvn release:perform -Darguments="-DstagingRepositoryId=$REPOID -DskipTests -Dhttps.protocols=TLSv1.2" -Dhttps.protocols=TLSv1.2

java9
cp tmp/release.properties .
export MAVEN_OPTS="--add-opens java.base/java.util=ALL-UNNAMED --add-opens java.base/java.lang.reflect=ALL-UNNAMED --add-opens java.base/java.text=ALL-UNNAMED --add-opens java.desktop/java.awt.font=ALL-UNNAMED "
mvn release:perform -Darguments="-DstagingRepositoryId=$REPOID"
unset MAVEN_OPTS


java8
cp tmp/release.properties .
mvn release:perform -Darguments="-DstagingRepositoryId=$REPOID"


