#!/bin/bash

# This is a modified version of https://github.com/uqlibrary/docker-patchman/blob/master/entry.sh

CONFIGFILE=/etc/patchman/local_settings.py

replace_envs() {
  # Ensure our variables are set that are listed in the docker file
  for i in ADMIN_EMAIL ADMIN_USERNAME ADMIN_PW SECRET_KEY TIMEZONE DATABASE_USER DATABASE_PASSWORD DATABASE_HOST DATABASE_PORT REDIS_HOST REDIS_PORT; do
    if [ -z ${!i} ]; then
      echo "$i is not set. Exiting."
      exit 1
    else
      # Replace config file variables
      sed -i "s/{$i}/${!i}/g" $CONFIGFILE;
    fi
  done
}

start_worker() {
  # Start the worker
  # C_FORCE_ROOT=1 celery -b redis://redis:6379/0 -A patchman worker -l INFO -E --detach
  C_FORCE_ROOT=1 celery -b redis://$REDIS_HOST:$REDIS_PORT/0 -A patchman worker -l INFO -E
}

start_server() {
  # Start the server
  # patchman-manage runserver
  # gunicorn patchman.wsgi -b 0.0.0.0:8000
  gunicorn patchman.wsgi -b 0.0.0.0:$PORT
}


migrate_db() {
  patchman-manage makemigrations
  patchman-manage migrate

  # This exists because django's createsuperuser command does not allow setting password without console input
  echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.filter(email='$ADMIN_EMAIL', is_superuser=True).delete(); User.objects.create_superuser('$ADMIN_USERNAME', '$ADMIN_EMAIL', '$ADMIN_PW')" | patchman-manage shell
}

set_db_standards() {
  # why don't we create the database? because it's assumed that the containers will create the default database in the name of the user, which is the database name

  if [ "$DATABASE_TYPE" != "postgres" ]; then
    # ALTER ROLE patchman SET client_encoding TO 'utf8';
    psql -h $DATABASE_HOST -p $DATABASE_PORT -U $DATABASE_USER -d $DATABASE_USER -c "ALTER ROLE $DATABASE_USER SET client_encoding TO 'utf8';"

    # ALTER ROLE patchman SET default_transaction_isolation TO 'read committed';
    psql -h $DATABASE_HOST -p $DATABASE_PORT -U $DATABASE_USER -d $DATABASE_USER -c "ALTER ROLE $DATABASE_USER SET default_transaction_isolation TO 'read committed';"

    # ALTER ROLE patchman SET timezone TO 'UTC';
    psql -h $DATABASE_HOST -p $DATABASE_PORT -U $DATABASE_USER -d $DATABASE_USER -c "ALTER ROLE $DATABASE_USER SET timezone TO 'UTC';"

    # GRANT ALL PRIVILEGES ON DATABASE patchman to patchman;
    psql -h $DATABASE_HOST -p $DATABASE_PORT -U $DATABASE_USER -d $DATABASE_USER -c "GRANT ALL PRIVILEGES ON DATABASE $DATABASE_USER to $DATABASE_USER;"

    # GRANT ALL ON SCHEMA public TO patchman;
    psql -h $DATABASE_HOST -p $DATABASE_PORT -U $DATABASE_USER -d $DATABASE_USER -c "GRANT ALL ON SCHEMA public TO $DATABASE_USER;"
  fi

  if [ "$DATABASE_TYPE" != "mysql" ]; then
    # ALTER DATABASE patchman CHARACTER SET utf8;
    mysql -h $DATABASE_HOST -P $DATABASE_PORT -u $DATABASE_USER -p$DATABASE_PASSWORD -e "ALTER DATABASE $DATABASE_USER CHARACTER SET utf8;"

    # ALTER DATABASE patchman COLLATE utf8_general_ci;
    mysql -h $DATABASE_HOST -P $DATABASE_PORT -u $DATABASE_USER -p$DATABASE_PASSWORD -e "ALTER DATABASE $DATABASE_USER COLLATE utf8_general_ci;"

    # GRANT ALL PRIVILEGES ON patchman.* TO patchman@localhost IDENTIFIED BY 'changeme';
    mysql -h $DATABASE_HOST -P $DATABASE_PORT -u $DATABASE_USER -p$DATABASE_PASSWORD -e "GRANT ALL PRIVILEGES ON $DATABASE_USER.* TO $DATABASE_USER@$DATABASE_HOST IDENTIFIED BY '$DATABASE_PASSWORD';"
  fi

}

main() {
  # Replace the environment variables in the config file
  replace_envs

  set_db_standards

  migrate_db

  if [ "$WORKER" = "true" ]; then
    start_worker
  else
    start_server
  fi
}

main
