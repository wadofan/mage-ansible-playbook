#!/bin/sh
export CERT_EMAIL="{{ letsencrypt_email }}"
export CERT_DOMAIN="{{ letsencrypt_domain }}"

docker compose -f {{ project_dir }}/compose.yml up certbot
sleep 10
docker compose -f {{ project_dir }}/compose.yml exec nginx nginx -s reload
