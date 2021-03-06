# Supported tags and respective `Dockerfile` links

* `7.0.82-jre7-centos`, `7.0-jre7-centos`, `7-jre7-centos`, `7.0.82-centos`, `7.0-centos`, `7-centos` [(7/jre7-centos/Dockerfile)](https://github.com/antoineco/tomcat/blob/54e75a75772b31ab3c36a546e3f2a25b867a4d52/7/jre7-centos/Dockerfile)
* `7.0.82-jre8-centos`, `7.0-jre8-centos`, `7-jre8-centos` [(7/jre8-centos/Dockerfile)](https://github.com/antoineco/tomcat/blob/54e75a75772b31ab3c36a546e3f2a25b867a4d52/7/jre8-centos/Dockerfile)
* `8.0.48-jre7-centos`, `8.0-jre7-centos`, `8.0.48-centos`, `8.0-centos` [(8.0/jre7-centos/Dockerfile)](https://github.com/antoineco/tomcat/blob/73c765b9017a7bfb89042c7ffc169ab93b92f3dc/8.0/jre7-centos/Dockerfile)
* `8.0.48-jre8-centos`, `8.0-jre8-centos` [(8.0/jre8-centos/Dockerfile)](https://github.com/antoineco/tomcat/blob/73c765b9017a7bfb89042c7ffc169ab93b92f3dc/8.0/jre8-centos/Dockerfile)
* `8.5.24-jre8-centos`, `8.5-jre8-centos`, `8-jre8-centos`, `jre8-centos`, `8.5.24-centos`, `8.5-centos`, `8-centos`, `centos` [(8.5/jre8-centos/Dockerfile)](https://github.com/antoineco/tomcat/blob/73c765b9017a7bfb89042c7ffc169ab93b92f3dc/8.5/jre8-centos/Dockerfile)
* `9.0.2-jre8-centos`, `9.0-jre8-centos`, `9-jre8-centos`, `9.0.2-centos`, `9.0-centos`, `9-centos` [(9.0/jre8-centos/Dockerfile)](https://github.com/antoineco/tomcat/blob/73c765b9017a7bfb89042c7ffc169ab93b92f3dc/9.0/jre8-centos/Dockerfile)

![logo](https://raw.githubusercontent.com/antoineco/tomcat/master/logo.png)

# What is the `tomcat` image?

An extension of the official [`tomcat`][docker-tomcat] image with extra OS variants.

# How to use the `tomcat` image?

This image shares all its features with the official [`tomcat`][docker-tomcat] image.

# Image Variants

The `tomcat` images come in different flavors, each designed for a specific use case.

## Base operating system

### `tomcat:<version>-centos`

This image is based on the [CentOS](https://www.centos.org/) operating system, available in [the `centos` official image][docker-centos].

## Components

A tagging convention determines the version of the components distributed with the `tomcat` image.

### `<version α>`

* Tomcat release: **α**
* OpenJDK JRE release: *recommended version for that particular Tomcat release*

### `<version α>-jre<β>`

* Tomcat release: **α**
* OpenJDK JRE release: **β** (latest patch version)

### `jre<β>`

* Tomcat release: *as distributed with the [`tomcat:latest`][docker-tomcat] image*
* OpenJDK JRE release: **β** (latest patch version)

# Maintenance

## Updating configuration

You can automatically update OpenJDK versions and regenerate the repository tree with:

```
./generate-dockerfiles.sh
```

## Updating library definition

After committing changes to the repository, regenerate the library definition file with:

```
./generate-bashbrew-library.sh >| tomcat
```

## Rebuilding images

All images in this repository can be rebuilt and tagged manually using [Bashbrew][bashbrew], the tool used for cloning, building, tagging, and pushing the Docker official images. To do so, simply call the `bashbrew` utility, pointing it to the included `tomcat` definition file as in the example below:

```
bashbrew --library . build tomcat
```

## Automated build pipeline

Any push to the upstream [`openjdk`][docker-openjdk] repository or to the source repository triggers an automatic rebuild of all the images in this repository. From a high perspective the automated build pipeline looks like the below diagram:

![Automated build pipeline][pipeline]


[banner]: https://raw.githubusercontent.com/antoineco/tomcat/master/logo.png
[docker-tomcat]: https://hub.docker.com/_/tomcat/
[docker-centos]: https://hub.docker.com/_/centos/
[docker-openjdk]: https://hub.docker.com/r/antoineco/openjdk/
[bashbrew]: https://github.com/docker-library/official-images/blob/master/bashbrew/README.md
[pipeline]: https://raw.githubusercontent.com/antoineco/tomcat/master/build_pipeline.png
