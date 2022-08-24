# 190UnixIntroImage
Dockerfile for creating the Docker image used for Introduction to Unix unit.

## Creating the Image

- `docker build -t braughtg/90-unix-intro:f22 .`

## Pushing the Image

- `docker login`
- `docker push braughtg/190-unix-intro:f22`

## Getting the Container

- `docker pull braughtg/190-unix-intro:f22`
- `docker create --name comp190 -p 5901:5901 -p 6901:6901 braughtg/190-unix-intro:f22`

## Starting/Restarting the Container

- `docker start comp190`

## Stopping the Container

- `docker stop comp190`
