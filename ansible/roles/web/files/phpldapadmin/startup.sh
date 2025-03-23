#!/bin/bash -e

CREATION_TEMPLATE_DIR="/opt/phpldapadmin-templates/creation"

for f in $(find "$CREATION_TEMPLATE_DIR" -type f); do
        mv "$f" "/var/www/phpldapadmin/templates/creation/$(basename "$f")"
done

exit 0
