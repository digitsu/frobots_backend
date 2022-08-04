#!/bin/sh

export DOCKER_HOST=unix:///tmp/docker.sock
chmod 0600 $SSH_KEY
ssh -i $SSH_KEY -o StrictHostKeyChecking=no -N -L '/tmp/docker.sock':'/var/run/docker.sock' -f deployer@172.105.215.192
docker image build -t elixir/frobots_backend .

