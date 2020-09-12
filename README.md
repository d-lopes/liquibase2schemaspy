# liquibase2schemaspy
generate a [schemaSpy](http://schemaspy.org) documentation from a [liquibase](https://www.liquibase.org/) config

## usage

```
$ docker run --rm -v `pwd`/src/main/resources/db/changelog:/data/input -v `pwd`/build/output/schemaspy:/data/output liquibase2schemaspy:latest
```
