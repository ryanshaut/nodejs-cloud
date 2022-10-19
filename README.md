[![Docker Image CI](https://github.com/ryanshaut/nodejs-cloud/actions/workflows/docker-image.yml/badge.svg?branch=main)](https://github.com/ryanshaut/nodejs-cloud/actions/workflows/docker-image.yml)


# nodejs-cloud
NodeJS running in the cloud


# DevOps

## Github Actions

Can run on the managed Github runner, or on a self-hosted runner

https://github.com/ryanshaut/nodejs-cloud/settings/actions/runners/new

Could definitely run in a docker container, but running on a debian 10 Vm for now.

(Install Docker)[https://docs.docker.com/engine/install/], create a new user and add that user to the `docker` group.
Then run the steps in the URL above