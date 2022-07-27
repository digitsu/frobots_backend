ARG MIX_ENV="prod"

# build stage
FROM elixir:alpine AS build

# install build dependencies
RUN apk add --no-cache build-base git python3 curl openssh perl


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
#RUN /app/wrapper.pl mix deps.get --only $MIX_ENV
RUN /bin/sh -c 'source /app/.env; mix deps.get --only $MIX_ENV'
#RUN mix deps.get --only $MIX_ENV

# compile dependencies
RUN /bin/sh -c 'source /app/.env; mix deps.compile'
#RUN /app/wrapper.pl mix deps.compile


WORKDIR /app/apps/frobots_web

# Compile assets
RUN /bin/sh -c 'source /app/.env; mix assets.deploy'
#RUN /app/wrapper.pl mix assets.deploy


WORKDIR /app

# compile
RUN /bin/sh -c 'source /app/.env; mix compile'
#RUN /app/wrapper.pl mix compile

RUN /bin/sh -c 'source /app/.env; mix release'
#RUN /app/wrapper.pl mix release


# app stage
FROM alpine AS app

ARG MIX_ENV

# install runtime dependencies
RUN apk add --no-cache libstdc++ openssl ncurses-libs bash

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
COPY --from=build --chown="${USER}":"${USER}" /app/_build/"${MIX_ENV}"/rel/frobots_backend ./
COPY --from=build --chown="${USER}":"${USER}" /app/apps/frobots/priv/templates /app/_build/prod/lib/frobots/priv/templates/

ENTRYPOINT ["bin/frobots_backend"]

CMD ["start"]
