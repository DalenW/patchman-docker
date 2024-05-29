FROM ubuntu:jammy

ENV WORKER="false"

# Default ENV Variables
ENV ADMIN_EMAIL="admin@example.com"
ENV ADMIN_USERNAME="admin"
ENV ADMIN_PW="password"
ENV PORT="8000"
ENV TIMEZONE="America/Denver"
ENV SECRET_KEY="7dAiqF&r_^=Q_)J+uu6Vy0+vBWc(p6fV&z4d)1T99rwGytG^Pb"
# note that the secret key is the default provided key

ENV DATABASE_TYPE="sqllite"
ENV DATABASE_USER="patchman"
ENV DATABASE_PASSWORD="password"
ENV DATABASE_HOST="postgres"
ENV DATABASE_PORT="5432"

ENV REDIS_HOST="redis"
ENV REDIS_PORT="6379"


# install curl
RUN apt-get update && apt-get install -y curl

# From https://github.com/furlongm/patchman/blob/master/INSTALL.md

RUN curl -sS https://repo.openbytes.ie/openbytes.gpg > /usr/share/keyrings/openbytes.gpg \
	&& echo "deb [signed-by=/usr/share/keyrings/openbytes.gpg] https://repo.openbytes.ie/patchman/ubuntu jammy main" > /etc/apt/sources.list.d/patchman.list

RUN apt-get update && apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y tzdata

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python3-django python3-django-tagging python3-django-extensions python3-django-bootstrap3 python3-djangorestframework python3-debian python3-rpm python3-progressbar python3-lxml python3-defusedxml python3-requests python3-colorama python3-magic python3-humanize

# realtime report processing
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python3-celery redis python3-redis python-celery-common

# postgresql
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install postgresql python3-psycopg2

# mysql
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install default-mysql-server python3-mysqldb

# install patchman last
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python3-patchman patchman-client

RUN pip install whitenoise
RUN pip install gunicorn

# RUN DEBIAN_FRONTEND=noninteractive apt-get -y install memcached python3-pymemcache
# RUN systemctl restart memcached

ADD settings.py /etc/patchman/local_settings.py

ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# CMD patchman-manage runserver