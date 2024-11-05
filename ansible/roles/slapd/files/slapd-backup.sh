#!/bin/sh

slapcat -l "${BACKUP_HOME}/$(date --iso-8601=hours).ldif"
