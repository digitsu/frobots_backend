#!/bin/sh

export DOCKER_HOST=unix:///tmp/docker.sock
chmod 0600 $SSH_KEY
ssh -i $SSH_KEY -o StrictHostKeyChecking=no -N -L '/tmp/docker.sock':'/var/run/docker.sock' -f deployer@172.105.215.192
docker image build -t elixir/frobots_backend -f ./contrib/Dockerfile .
docker stop frobots_backend
echo $DATABASE_URL
docker run --rm -dp $PORT:$PORT -e POOL_SIZE -e PORT -e DATABASE_URL -e SECRET_KEY_BASE -e ADMIN_USER -e ADMIN_PASS --network frobots-network --name frobots_backend elixir/frobots_backend
#</dev/null docker exec frobots_backend bin/frobots_backend eval "FrobotsWeb.Release.migrate"
