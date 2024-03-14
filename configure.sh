#!/bin/bash

INSTALLPATH="/etc/systemd/system/"
WORKINGDIRECTORY=$(pwd)
SERVICENAME="PionExporter"

# configuration file content
CONFIGURATION="# $SERVICENAME.service configuration

[Unit]
Description= $SERVICENAME - exporter agent for prometheus
After=multi-user.target

[Service]
Type=simple
ExecStart=$WORKINGDIRECTORY/json_exporter.py
WorkingDirectory=$WORKINGDIRECTORY
SyslogIdentifier=$SERVICENAME
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
"

echo "Service $SERVICENAME will be registered in $INSTALLPATH with working directort $WORKINGDIRECTORY."

echo "dependencies installing"
apt install python3-pip -y
pip install prometheus_client requests

systemctl stop "$SERVICENAME"
echo "$CONFIGURATION" > $INSTALLPATH$SERVICENAME.service
systemctl daemon-reload
echo "Service $SERVICENAME has been installed"
systemctl enable "$SERVICENAME"
systemctl start "$SERVICENAME"
echo "Service $SERVICENAME has been started"

systemctl status "$SERVICENAME"

