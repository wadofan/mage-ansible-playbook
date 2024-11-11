#!/bin/sh
docker compose -f {{ project_dir }}/compose.yml up certbot
sleep 10
docker compose -f {{ project_dir }}/compose.yml exec nginx nginx -s reload
