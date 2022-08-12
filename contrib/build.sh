#!/bin/sh

export DOCKER_HOST=unix:///tmp/docker.sock
chmod 0600 $SSH_KEY

if [[$CI_COMMIT_BRANCH == "main"]]
then
    ssh -i $SSH_KEY -o StrictHostKeyChecking=no -N -L '/tmp/docker.sock':'/var/run/docker.sock' -f deployer@172.105.215.192
elif [[$CI_COMMIT_BRANCH == "dev"]]
then
    ssh -i $SSH_KEY -o StrictHostKeyChecking=no -N -L '/tmp/docker.sock':'/var/run/docker.sock' -f deployer@172.104.73.245
fi

docker image build -t elixir/frobots_backend -f ./Dockerfile .
docker stop frobots_backend
docker run --rm -dp $PORT:$PORT -e POOL_SIZE -e PORT -e DATABASE_URL -e SECRET_KEY_BASE -e ADMIN_USER -e ADMIN_PASS --network frobots-network --name frobots_backend elixir/frobots_backend
docker exec frobots_backend bin/frobots_backend eval "FrobotsWeb.Release.migrate"
