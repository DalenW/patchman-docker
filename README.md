# Patchman Docker

This is a modified version of https://github.com/uqlibrary/docker-patchman to work with the latest version of Patchamn on Python3, not Python2. 

`docker build -f Dockerfile -t patchman .`
`docker run -dp 8000:8000 patchman`

## Environemnt Variables

| **Environment Variable** | **Default Value**                               |
| ------------------------ | ----------------------------------------------- |
| ADMIN_EMAIL              | `admin@example.com`                             |
| ADMIN_USERNAME           | `admin`                                         |
| ADMIN_PW                 | `password`                                      |
| SECRET_KEY               | `random password like string (see docker file)` |
| TIMEZONE                 | `America/Denver`                                |
