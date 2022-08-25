# 190UnixIntroImage
Dockerfile for creating the Docker image used for Introduction to Unix unit.

## Creating the Image

- `docker build -t braughtg/90-unix-intro:f22 .`

## Pushing the Image

- `docker login`
- `docker push braughtg/190-unix-intro:f22`

## Getting the Container

- `docker pull braughtg/190-unix-intro:f22`

For Mac:
- `docker create --name comp190 --publish 5901:5901 --publish 6901:6901 --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock braughtg/190-unix-intro:f22`

For Windows:
- `docker create --name comp190 --publish 5901:5901 --publish 6901:6901 --mount type=bind,source=//var/run/docker.sock,target=/var/run/docker.sock braughtg/190-unix-intro:f22`

## Starting/Restarting the Container

- `docker start comp190`

## Stopping the Container

- `docker stop comp190`
