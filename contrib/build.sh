#!/bin/bash

export DOCKER_HOST=unix:///tmp/docker.sock
cp $SSH_KEY /tmp/.ssh.key
chmod 0600 /tmp/.ssh.key

if [[ $CI_COMMIT_BRANCH == "main" ]]; then
    ip=172.105.215.192
elif [[ $CI_COMMIT_BRANCH == "dev" ]]; then
    ip=172.104.73.245
else
    ip='not a valid branch'
fi

echo $SENDGRID_API_KEY

ssh -i /tmp/.ssh.key -o StrictHostKeyChecking=no -N -L '/tmp/docker.sock':'/var/run/docker.sock' -f deployer@$ip
docker image build -t elixir/frobots_backend -f ./Dockerfile .
docker stop frobots_backend
docker container prune --force
docker run --rm -dp $PORT:$PORT -e POOL_SIZE -e PORT -e DATABASE_URL -e SECRET_KEY_BASE -e ADMIN_USER -e ADMIN_PASS --network frobots-network --name frobots_backend elixir/frobots_backend
docker exec frobots_backend bin/frobots_backend eval "FrobotsWeb.Release.migrate"
