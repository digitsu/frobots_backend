#!/bin/bash

set -a

export DOCKER_HOST=unix:///tmp/docker.sock
cp $SSH_KEY /tmp/.ssh.key
chmod 0600 /tmp/.ssh.key

if [[ $CI_COMMIT_BRANCH == "main" ]]; then
    ip='not a valid branch'
elif [[ $CI_COMMIT_BRANCH == "dev" ]]; then
    ip=240b:10:2f60:18ff:94df:e0ff:fed8:9527
    #ip=10.8.8.167
    
else
    ip='not a valid branch'
fi
echo "Building Docker image"
mkdir -p ~/.ssh
cp ./contrib/ssh_config ~/.ssh/config || true

rm /tmp/docker.sock || true

ssh -i /tmp/.ssh.key -f -o StrictHostKeyChecking=no -N -L '/tmp/docker.sock':'/var/run/docker.sock' -J jumper@jumphost deployer@${ip}

rm /tmp/.ssh.key || true

docker image build --build-arg SENDGRID_API_KEY  -t elixir/frobots_backend -f ./Dockerfile .

docker stop frobots_backend ||true
docker stop postgres || true
#docker network create frobots-network ||true
docker volume create postgres_home ||true
docker volume create postgres_data ||true

docker container prune --force ||true

docker run --detach --rm --network $FROBOTS_NETWORK --network-alias postgres-server -e POSTGRES_PASSWORD=$POSTGRES_PASS -e POSTGRES_USER=$POSTGRES_USER -v postgres_home:/home/${POSTGRES_USER} -v postgres_data:/var/lib/postgresql/data --name postgres postgres:12-bullseye

docker run --rm -dp $PORT:$PORT -e SENDGRID_API_KEY -e POOL_SIZE -e PORT -e DATABASE_URL=$DATABASE_URL_NEW -e SECRET_KEY_BASE -e ADMIN_USER -e ADMIN_PASS --network $FROBOTS_NETWORK --network-alias frobots_backend --name frobots_backend elixir/frobots_backend

docker exec frobots_backend bin/frobots_backend eval "FrobotsWeb.Release.migrate"
