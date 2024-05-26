FROM ubuntu:jammy

# install curl
RUN apt-get update && apt-get install -y curl

# From https://github.com/furlongm/patchman/blob/master/INSTALL.md

RUN curl -sS https://repo.openbytes.ie/openbytes.gpg > /usr/share/keyrings/openbytes.gpg \
	&& echo "deb [signed-by=/usr/share/keyrings/openbytes.gpg] https://repo.openbytes.ie/patchman/ubuntu jammy main" > /etc/apt/sources.list.d/patchman.list

RUN apt-get update && apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python3-django python3-django-tagging python3-django-extensions python3-django-bootstrap3 python3-djangorestframework python3-debian python3-rpm python3-progressbar python3-lxml python3-defusedxml python3-requests python3-colorama python3-magic python3-humanize

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python3-patchman patchman-client

RUN pip install whitenoise

CMD patchman-manage runserver