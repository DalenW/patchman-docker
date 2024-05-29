# Patchman Docker

This project is a Dockerized version of [Patchman](https://github.com/furlongm/patchman). 

This is also a modified version of the [Docker-Patchman](https://github.com/uqlibrary/docker-patchman) project, updated to work with the latest version of Patchman on Python3, instead of Python2.

## Building and Running the Docker Image

To build the Docker image, use the following command:

```bash
docker build -f Dockerfile -t patchman .

docker run -dp 8000:8000 patchman
```

## Background Processing

If you want background processing, you must have a seperate database like postgres or mysql.
Additionally, you'll need to run a seperate worker container.


## Environemnt Variables

Note that if you use Postgres or MySQL, it is assumed that the database container will create the database automatically. The startup script will simply modify it.

| **Environment Variable** | **Default Value or Meaning** |
| ------------------------ | ----------------- |
| `WORKER`                 | `false`           |
| `ADMIN_EMAIL`            | `admin@example.com` |
| `ADMIN_USERNAME`         | `admin`           |
| `ADMIN_PW`               | `password`        |
| `PORT`                   | `8000`            |
| `TIMEZONE`               | `America/Denver`  |
| `SECRET_KEY`             | `random password like string (see docker file)` |
| `DATABASE_TYPE`          | `sqllite,postgres, mysql (default is sqlite)`         |
| `DATABASE_USER`          | `patchman (will also be the daatabase name)`        |
| `DATABASE_PASSWORD`      | `password`        |
| `DATABASE_HOST`          | `postgres`        |
| `DATABASE_PORT`          | `5432`            |
| `REDIS_HOST`             | `redis`           |
| `REDIS_PORT`             | `6379`            |