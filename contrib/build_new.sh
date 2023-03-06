#!/bin/bash

set -a

export DOCKER_HOST=unix:///tmp/docker.sock
cp $SSH_KEY /tmp/.ssh.key
chmod 0600 /tmp/.ssh.key

if [[ $CI_COMMIT_BRANCH == "main" ]]; then
    ip=$FROBOTSBACKEND_PROD
    mixenv=prod
elif [[ $CI_COMMIT_BRANCH == "dev" ]]; then
    ip=$FROBOTSBACKEND_STAGING
    mixenv=staging
else
    ip='not a valid branch'
fi
mkdir -p ~/.ssh
cp $SSH_CONFIG ~/.ssh/config || true
rm /tmp/docker.sock || true
ssh -i /tmp/.ssh.key -f -o StrictHostKeyChecking=no -N -L '/tmp/docker.sock':'/var/run/docker.sock' -J jumper@jumphost deployer@${ip}
rm /tmp/.ssh.key || true

echo "copy over certs"

echo "copy over the certificates"
cp $FROBOTS_CERT_PEM /tmp/.frobots.pem
cp $FROBOTS_CERT_KEY /tmp/.frobots.key

docker container prune --force
#docker container stop cert_copy || true
#docker container rm cert_copy || true
docker volume create web_certs
docker run --rm -d -v web_certs:/var/certs --name cert_copy busybox tail -f /dev/null

echo "copy container is running"
docker cp /tmp/.frobots.pem cert_copy:/var/certs/frobots_cert.pem
docker cp /tmp/.frobots.key cert_copy:/var/certs/frobots_cert.key

docker container exec cert_copy chown elixir:elixir /var/certs/frobots_cert.key
docker container exec cert_copy chown elixir:elixir /var/certs/frobots_cert.pem
docker container exec cert_copy chmod 600 /var/certs/frobots_cert.key 

docker container stop cert_copy ||true


echo "Building Docker image"

docker image build --build-arg MIX_ENV=${mixenv} -t elixir/frobots_backend -f ./Dockerfile .

docker stop frobots_backend ||true
docker stop postgres || true
#docker network create frobots-network ||true
docker volume create postgres_home ||true
docker volume create postgres_data ||true

docker container prune --force ||true

docker run --detach --rm --network $FROBOTS_NETWORK --network-alias postgres-server -e POSTGRES_PASSWORD=$POSTGRES_PASS -e POSTGRES_USER=$POSTGRES_USER -v postgres_home:/home/${POSTGRES_USER} -v postgres_data:/var/lib/postgresql/data --name postgres postgres:12-bullseye

docker run --rm -dp $PORT:$PORT -e GHOST_API_KEY -e SENDGRID_API_KEY -e SENDGRID_API_EXPORT_MAILINGLIST_KEY -e POOL_SIZE -e PORT -e DATABASE_URL=$DATABASE_URL_NEW -e SECRET_KEY_BASE -e ADMIN_USER -e ADMIN_PASS --network $FROBOTS_NETWORK --network-alias frobots_backend -v web_certs:/var/certs --name frobots_backend elixir/frobots_backend

docker exec frobots_backend bin/frobots_backend eval "FrobotsWeb.Release.migrate"
