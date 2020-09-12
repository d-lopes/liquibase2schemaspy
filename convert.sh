#!/bin/bash

for i in "$@"
do
case $i in
    -c=*|--changeLogFile=*)
    CHANGELOG_FILE="$2"
    shift # past argument
    shift # past value
    ;;
    -s=*|--schemaName=*)
    SCHEMA_NAME="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done

# default value
if [[ -z $CHANGELOG_FILE ]]; then
    CHANGELOG_FILE="/data/input/db.changelog.xml"
fi

if [[ -z $SCHEMA_NAME ]]; then
    SCHEMA_NAME="default"
fi

mkdir -p /data/tmp/$SCHEMA_NAME
cp /data/input/*.* /data/tmp/$SCHEMA_NAME

# strip changelog from problematic syntax for H2 databases (see http://www.h2database.com/html/commands.html)
#  (1) remove SQL single line comments
#  (2) remove line breaks
#  (3) remove WHERE clause from 'CREATE UNIQUE INDEX ... ON ... WHERE ...' syntax as this is not allowed
#  (4) replace 'UPDATE ... SET ... FROM ...' with dummy statement syntax as this is not allowed
sed -E "/ +--[^\w>]+/d" "$CHANGELOG_FILE" \
    | tr '[:space:]' ' ' \
    | sed -E "s/(CREATE UNIQUE INDEX [a-zA-Z0-9_]+)\s+(ON [a-zA-Z0-9_,\(\) ]+)\s+(WHERE [a-zA-Z0-9_=' ]+)/\1 \2/g" \
    | sed -E "s/(UPDATE[a-zA-Z0-9=\._, ]+)(FROM[^;<]+)/SELECT 1;/g" \
    > "/data/tmp/$SCHEMA_NAME/db.changelog_clean.xml"

# update H2 database from liquibase config
java -cp "/var/libs/*" liquibase.integration.commandline.Main \
        --driver=org.h2.Driver --url="jdbc:h2:~/$SCHEMA_NAME" \
        --username="sa" --password="" \
        --changeLogFile="/data/tmp/$SCHEMA_NAME/db.changelog_clean.xml" update

java -jar /var/schemaspy-6.1.0.jar -t h2 -dp "/var/libs/h2-1.4.200.jar" \
        -db "~/$SCHEMA_NAME" -u "sa" \
        -o "/data/output/$SCHEMA_NAME" -vizjs -renderer :cairo -imageformat svg
