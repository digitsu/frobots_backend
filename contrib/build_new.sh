#!/bin/bash

set -a

export DOCKER_HOST=unix:///tmp/docker.sock
cp $SSH_KEY /tmp/.ssh.key
chmod 0600 /tmp/.ssh.key

if [[ $CI_COMMIT_BRANCH == "main" ]]; then
    ip='not a valid branch'
elif [[ $CI_COMMIT_BRANCH == "dev" ]]; then
    ip=240b:10:2f60:18ff:94df:e0ff:fed8:9527
    
else
    ip='not a valid branch'
fi

cp ./ssh_config ~/.ssh/config
cat ~/.ssh/config
rm /tmp/docker.sock

ssh -i /tmp/.ssh.key -f -o StrictHostKeyChecking=no -N -L '/tmp/docker.sock':'/var/run/docker.sock' -J jumper@jumphost deployer@${ip}

docker image build --build-arg SENDGRID_API_KEY  -t elixir/frobots_backend -f ./Dockerfile .

docker stop frobots_backend
docker container prune --force
docker run --rm -dp $PORT:$PORT -e SENDGRID_API_KEY -e POOL_SIZE -e PORT -e DATABASE_URL -e SECRET_KEY_BASE -e ADMIN_USER -e ADMIN_PASS --network frobots-network --name frobots_backend elixir/frobots_backend

docker exec frobots_backend bin/frobots_backend eval "FrobotsWeb.Release.migrate"
