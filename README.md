# 190UnixIntroImage
Dockerfile for creating the Docker image used for Introduction to Unix unit.

## Building and Pushing the Image

Builds an image for both amd64 and arm64, creates a multi-aarchitecture manifest, pushes the images to Docker Hub.

- `docker login`
- `docker buildx create --name comp190builder --use`
- `docker buildx build --platform linux/amd64,linux/arm64 -t braughtg/90-unix-intro:f22 --push .`

## Getting the Image

- `docker pull braughtg/190-unix-intro:f22`

## Creating the Container

For Mac:
- `docker create --name comp190 --publish 5901:5901 --publish 6901:6901 --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock braughtg/190-unix-intro:f22`

For Windows:
- `docker create --name comp190 --publish 5901:5901 --publish 6901:6901 --mount type=bind,source=//var/run/docker.sock,target=/var/run/docker.sock braughtg/190-unix-intro:f22`

## Starting/Restarting the Container

- `docker start comp190`

## Stopping the Container

- `docker stop comp190`
