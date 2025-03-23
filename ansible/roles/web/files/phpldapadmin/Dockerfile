FROM osixia/phpldapadmin:latest
RUN mkdir -p /opt/phpldapadmin-templates
COPY creation /opt/phpldapadmin-templates/creation
COPY startup.sh /container/service/phpldapadmin-additional-templates/
RUN chmod +x /container/service/phpldapadmin-additional-templates/startup.sh
