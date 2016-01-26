#!/bin/sh

PI_ENCFILE='/etc/privacyidea/enckey'
PI_AUDIT_KEY_PRIVATE='/etc/privacyidea/private.pem'
PI_AUDIT_KEY_PUBLIC='/etc/privacyidea/public.pem'

source /opt/privacyidea/venv/bin/activate
cd /opt/privacyidea/

if [ -f "$PI_ENCFILE" ]
then
  echo "PI_ENCFILE=$PI_ENCFILE"
else
  echo "Generating $PI_ENCFILE"
  /opt/privacyidea/pi-manage create_enckey
fi

if [ -f "$PI_AUDIT_KEY_PRIVATE" ] && [ -f "$PI_AUDIT_KEY_PUBLIC" ]
then
  echo "PI_AUDIT_KEY_PRIVATE=$PI_AUDIT_KEY_PRIVATE"
  echo "PI_AUDIT_KEY_PUBLIC=$PI_AUDIT_KEY_PUBLIC"
else
  echo "Generating $PI_AUDIT_KEY_PRIVATE and $PI_AUDIT_KEY_PUBLIC"
  /opt/privacyidea/pi-manage create_audit_keys
fi

rm -f /etc/nginx/sites-enabled/privacyidea
ln -s /etc/nginx/sites-available/privacyidea /etc/nginx/sites-enabled/privacyidea

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf --nodaemon
# uwsgi --xml /opt/privacyidea/deploy/uwsgi/apps-available/privacyidea.xml --socket 0.0.0.0:9000 -w privacyideaapp:application --master --thunder-lock --enable-threads --post-buffering 8192 --chdir /opt/privacyidea