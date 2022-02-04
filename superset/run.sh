#!/bin/bash

set -e

function fatal() {
    RED='\033[0;31m'
    NC='\033[0m'
    message=$1
    echo -e "${RED}Error: ${message}${NC}"
    exit 1
}

function establish_ssh_tunnel() {
    if [ -n "$SSH_USER" ] \
    && [ -n "$SSH_HOST" ] \
    && [ -n "$SSH_KEY" ] \
    && [ -n "$SSH_FORWARD_HOST" ] \
    && [ -n "$SSH_FORWARD_PORT" ]
    then
        mkdir -p "${HOME}"/.ssh
        echo -n "${SSH_KEY}" | base64 -d > "${HOME}"/.ssh/id_rsa
        chmod 600 "${HOME}"/.ssh/id_rsa
        echo "Forwarding port ${SSH_FORWARD_PORT} to ${SSH_FORWARD_HOST} using ${SSH_HOST}."
        nohup ssh -CN -o UserKnownHostsFile=/dev/null \
            -oBatchMode=yes -o StrictHostKeyChecking=no \
            -L "${SSH_FORWARD_PORT}:${SSH_FORWARD_HOST}:${SSH_FORWARD_PORT}" \
            -i "$HOME"/.ssh/id_rsa -l "${SSH_USER}" \
            -p "${SSH_PORT:-22}" "${SSH_HOST}" 2>&1 >> /dev/null &
    fi
}

function initialize_database() {
    if [ ! -f /app/superset_home/superset.db ]
    then
        # Check if the environment variables are set
        if [ -z "$ADMIN_USERNAME" ] \
        && [ -z "$ADMIN_EMAIL" ] \
        && [ -z "$ADMIN_PASSWORD" ]
        then
            fatal "Could not create the admin user. The required environment variables have not been provided."
        fi
        superset fab create-admin \
            --username "${ADMIN_USERNAME}" \
            --firstname "${ADMIN_FIRSTNAME}" \
            --lastname "${ADMIN_LASTNAME}" \
            --email "${ADMIN_EMAIL}" \
            --password "${ADMIN_PASSWORD}"
        superset db upgrade
        superset init
        superset load_test_users
        superset load_examples
    fi
}

function start_superset() {
    gunicorn \
        -w 10 \
        -k gevent \
        --timeout 120 \
        -b  0.0.0.0:8000 \
        --limit-request-line 0 \
        --limit-request-field_size 0 \
        "superset.app:create_app()"
}

initialize_database
establish_ssh_tunnel
start_superset
