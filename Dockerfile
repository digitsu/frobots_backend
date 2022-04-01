ARG MIX_ENV="prod"

# build stage
FROM elixir:alpine AS build

# install build dependencies
RUN apk add --no-cache build-base git python3 curl

# sets work dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && mix local.rebar --force

ARG MIX_ENV
ENV MIX_ENV="${MIX_ENV}"

# install mix dependencies
COPY mix.exs mix.lock ./

# copy compile configuration files
RUN mkdir config
COPY config/ config/

# copy the mix configs for the web app
COPY apps/frobots_web/mix.exs /app/apps/frobots_web/

# copy ALL
COPY . /app/

RUN mix deps.get --only $MIX_ENV

# compile dependencies
RUN mix deps.compile


WORKDIR /app/apps/frobots_web

# Compile assets
RUN mix assets.deploy


WORKDIR /app

# compile
RUN mix compile


RUN mix release


# app stage
FROM alpine AS app

ARG MIX_ENV

# install runtime dependencies
RUN apk add --no-cache libstdc++ openssl ncurses-libs

ENV USER="elixir"

WORKDIR "/home/${USER}/app"

RUN \
 addgroup \
  -g 1000 \
  -S "${USER}" \
 && adduser \
  -s /bin/sh \
  -u 1000 \
  -G "${USER}" \
  -h "/home/${USER}" \
  -D "${USER}" \
 && su "${USER}"

# run as user
USER "${USER}"

# copy release executables
COPY --from=build --chown="${USER}":"${USER}" /app/_build/"${MIX_ENV}"/rel/frobots_web ./

ENTRYPOINT ["bin/frobots_web"]

CMD ["start"]
