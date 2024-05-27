#!/bin/bash

# This is a modified version of https://github.com/uqlibrary/docker-patchman/blob/master/entry.sh

CONFIGFILE=/etc/patchman/local_settings.py

# Ensure our variables are set
for i in ADMIN_EMAIL ADMIN_USERNAME ADMIN_PW SECRET_KEY TIMEZONE; do
  if [ -z ${!i} ]; then
    echo "$i is not set. Exiting."
    exit 1
  else
    # Replace config file variables
    sed -i "s/{$i}/${!i}/g" $CONFIGFILE;
  fi
done

patchman-manage makemigrations
patchman-manage migrate


# This exists because django's createsuperuser command does not allow setting password without console input
echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.filter(email='$ADMIN_EMAIL', is_superuser=True).delete(); User.objects.create_superuser('$ADMIN_USERNAME', '$ADMIN_EMAIL', '$ADMIN_PW')" | patchman-manage shell

# patchman-manage runserver
gunicorn patchman.wsgi -b 0.0.0.0:8000