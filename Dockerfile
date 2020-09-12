FROM openjdk:8-alpine

# install necessary extensions
RUN  mkdir -p /var/libs && apk update \
 && apk add bash wget \
    graphviz ttf-freefont

# pull needed JARs from official maven repos
RUN wget -O /var/libs/liquibase-core-3.8.4.jar https://repo1.maven.org/maven2/org/liquibase/liquibase-core/3.8.4/liquibase-core-3.8.4.jar \
    && wget -O /var/libs/logback-classic-1.2.3.jar https://repo1.maven.org/maven2/ch/qos/logback/logback-classic/1.2.3/logback-classic-1.2.3.jar \
    && wget -O /var/libs/logback-core-1.2.3.jar https://repo1.maven.org/maven2/ch/qos/logback/logback-core/1.2.3/logback-core-1.2.3.jar \
    && wget -O /var/libs/h2-1.4.200.jar https://repo1.maven.org/maven2/com/h2database/h2/1.4.200/h2-1.4.200.jar \
    && wget -O /var/libs/slf4j-api-1.7.25.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.25/slf4j-api-1.7.25.jar \
    && wget -O /var/schemaspy-6.1.0.jar https://github.com/schemaspy/schemaspy/releases/download/v6.1.0/schemaspy-6.1.0.jar

ADD convert.sh /convert.sh

RUN chmod +x /convert.sh

VOLUME ["/data/input", "/data/ouput"]

ENTRYPOINT ["/convert.sh"]
