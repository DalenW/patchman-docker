# Django settings for patchman project.

DEBUG = False

ADMINS = (
  ('{ADMIN_USERNAME}', '{ADMIN_EMAIL}'),
)

database = {}
database_type = ('{DATABASE_TYPE}')

database = {
  'default': {
      'ENGINE': 'django.db.backends.sqlite3',
      'NAME': '/var/lib/patchman/db/patchman.db',
  }
}

if database_type.upper() == 'POSTGRESQL':
  database = {
    'default': {
      'ENGINE': 'django.db.backends.postgresql_psycopg2',
      'NAME': '{DATABASE_USER}',
      'USER': '{DATABASE_USER}',
      'PASSWORD': '{DATABASE_PASSWORD}',
      'HOST': '{DATABASE_HOST}',
      'PORT': '{DATABASE_PORT}',
        'CHARSET' : 'utf8'
    }
  }
  
if database_type.upper() == 'MYSQL':
  database = {
   'default': {
       'ENGINE': 'django.db.backends.mysql',
       'NAME': '{DATABASE_USER}',
       'USER': '{DATABASE_USER}',
       'PASSWORD': '{DATABASE_PASSWORD}',
       'HOST': '{DATABASE_HOST}',
       'PORT': '{DATABASE_PORT}',
       'STORAGE_ENGINE': 'INNODB',
       'CHARSET' : 'utf8'
   }
}

DATABASES = database

# Local time zone for this installation. Choices can be found here:
# http://en.wikipedia.org/wiki/List_of_tz_zones_by_name
# TIME_ZONE = '{TIMEZONE}'
TIME_ZONE = 'America/New_York'

# Language code for this installation. All choices can be found here:
# http://www.i18nguy.com/unicode/language-identifiers.html
LANGUAGE_CODE = 'en-us'

# Create a unique string here, and don't share it with anybody.
SECRET_KEY = '7dAiqF&r_^=Q_)J+uu6Vy0+vBWc(p6fV&z4d)1T99rwGytG^Pb'

# Add the IP addresses that your web server will be listening on,
# instead of '*'
ALLOWED_HOSTS = ['127.0.0.1', '*']

# Maximum number of mirrors to add or refresh per repo
MAX_MIRRORS = 5

# Number of days to wait before notifying users that a host has not reported
DAYS_WITHOUT_REPORT = 14

# Whether to run patchman under the gunicorn web server
RUN_GUNICORN = False

# Enable memcached
# CACHES = {
#     'default': {
#         'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
#         'LOCATION': '127.0.0.1:11211',
#     }
# }

USE_ASYNC_PROCESSING = True