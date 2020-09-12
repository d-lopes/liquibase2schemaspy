# liquibase2schemaspy
generate a [schemaSpy](http://schemaspy.org) documentation from a [liquibase](https://www.liquibase.org/) config

## Usage

This is how you call the converter with default parameter settings

```
$ docker run --rm \
      -v `pwd`/src/main/resources/db/changelog:/data/input \
      -v `pwd`/build/output/schemaspy:/data/output \
    liquibase2schemaspy:latest
```

### Custom settings

| Parameter | Description                                                                                                                                    |
|-----------|------------------------------------------------------------------------------------------------------------------------------------------------|
| -c        | The path to the changelog file (must be absolute and starts with /data/input/...)   The value "/data/input/db.changelog.xml" is set by default |
| -s        | The name of the schema   The value "default" is set by default                                                                                 |

This is how you call the converter with default parameter settings

```
$ docker run --rm \
      -v `pwd`/src/main/resources/db/changelog:/data/input \
      -v `pwd`/build/output/schemaspy:/data/output \
    liquibase2schemaspy:latest -s myCustomSchema -c /data/input/other_changelog-name.xml
```
