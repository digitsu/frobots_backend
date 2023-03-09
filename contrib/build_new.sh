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
echo "making .ssh dir"
mkdir -p ~/.ssh
echo "copying config" $SSH_CONFIG
cp $SSH_CONFIG ~/.ssh/config 
echo "removing old socket"
rm /tmp/docker.sock || true
echo "test ping jumphost" 
ping -c 4 jumphost
echo "testing ping to ip direct"
ping -c 4 172.105.215.192
echo "jumping to" $ip
#ssh -i /tmp/.ssh.key -f -o StrictHostKeyChecking=no -N -L '/tmp/docker.sock':'/var/run/docker.sock' -J jumper@jumphost deployer@${ip}
echo "whoami"
whoami
#ssh -i /tmp/.ssh.key -f -o StrictHostKeyChecking=no -N -L '/tmp/docker.sock':'/var/run/docker.sock' -J jumper@172.105.215.192 deployer@${ip}

ssh -i /tmp/.ssh.key -F ~/.ssh/config -f -o StrictHostKeyChecking=no -N -L '/tmp/docker.sock':'/var/run/docker.sock' -J jumper@jumphost deployer@${ip}

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

docker image build --build-arg MIX_ENV=${mixenv} --build-arg HTTP_PROXY=${HTTP_PROXY} --build-arg HTTPS_PROXY=${HTTPS_PROXY} -t elixir/frobots_backend -f ./Dockerfile .

echo "clean up images"
docker stop frobots_backend || true
docker stop postgres || true
#docker network create frobots-network || true
docker volume create postgres_home || true
docker volume create postgres_data || true

docker container prune --force || true

echo "running postgres"
docker run --detach --rm --network $FROBOTS_NETWORK --network-alias postgres-server -e POSTGRES_PASSWORD=$POSTGRES_PASS -e POSTGRES_USER=$POSTGRES_USER -v postgres_home:/home/${POSTGRES_USER} -v postgres_data:/var/lib/postgresql/data --name postgres postgres:12-bullseye
echo "running the backend"
docker run --rm -dp $PORT:$PORT -e SENDGRID_API_KEY -e SENDGRID_API_EXPORT_MAILINGLIST_KEY -e POOL_SIZE -e PORT -e DATABASE_URL=$DATABASE_URL_NEW -e SECRET_KEY_BASE -e ADMIN_USER -e ADMIN_PASS --network $FROBOTS_NETWORK --network-alias frobots_backend -v web_certs:/var/certs --name frobots_backend elixir/frobots_backend
echo "running migrations"
docker exec frobots_backend bin/frobots_backend eval "FrobotsWeb.Release.migrate"
