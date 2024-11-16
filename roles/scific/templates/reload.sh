#!/bin/sh
export DOMAIN="{{ letsencrypt_domain }}"

docker compose -f {{ project_dir }}/compose.yml exec nginx nginx -s reload
