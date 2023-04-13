# Frobots API Backend

**This is the umbrella project that includes the frobots_web API server and the FUBARs simulator**
## Running via IEX (for local testing)
Make sure you have asdf installed, follow the instructions on [frobots_client](https://gitlab.com/frobots/client/frobots_client)
and ensure that you have the versions installed as per the .tool-versions file in the dir.

Get the dependences

```shell
% mix deps.get
```
Setup the local postgres db (if you haven't already)
```shell
% cd apps/frobots
% mix ecto.setup
% cd ../../

```
Run the backend
```shell
% iex -S mix phx.server
```
That's it! Now go to another shell and run the frobots_client

## Running in via docker
Get all the deps and test to make sure everything work
In root dir
```shell
% mix deps.get
% mix test
```
You need docker installed.

Build docker from frobots_backend dir (the dir with the Dockerfile)
```shell
% docker image build -t elixir/frobots_web .
```

Start up a postgres container
```shell
% docker run -d --network frobots-network --network-alias postgres-server -e POSTGRES_PASSWORD=supersecret --name 
postgres postgres
```

Check it running (make note of the ID to be used below)
```shell
% docker ps
```

Connect to the postgres container (change to the container ID appropriate), and create the database
```shell
% docker exec -it 8281f722c845 psql -U postgres
```

Create the database
```shell
psql (14.0 (Debian 14.0-1.pgdg110+1))
Type "help" for help.

postgres=# CREATE DATABASE frobots_prod;
CREATE DATABASE
postgres=# \q
```

Export the env vars in .env for secrets etc etc at this time in the terminal that we will run the elixir app container
```shell
% source .env
```

Set the env var to point to the postgres container version (the default in .env is a local instance)
```shell
% export DATABASE_URL=ecto://postgres:supersecret@postgres-server/frobots_prod
```

Run the elixir app container
```shell
% docker container run -dp $PORT:$PORT -e POOL_SIZE -e PORT -e DATABASE_URL -e SECRET_KEY_BASE --network 
frobots-network --name frobots_web elixir/frobots_web
```

Run the migrations (this tests that the backend can talk to the postgres)
```shell
% docker exec -it frobots_web bin/frobots_web eval "FrobotsWeb.Release.migrate"
% docker exec -it frobots_web bin/frobots_web eval 'FrobotsWeb.Release.Seeder.seed(Elixir.Frobots.Repo, "seeds.exs")'
```
