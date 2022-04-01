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
#COPY config/config.exs config/$MIX_ENV.exs config/
COPY config/ config/

# copy the mix configs for the web app
COPY apps/frobots_web/mix.exs /app/apps/frobots_web/

# copy ALL
COPY . /app/

RUN mix deps.get --only $MIX_ENV
#RUN mix deps.update scenic_driver_glfw
# compile dependencies
RUN MIX_ENV=$MIX_ENV mix deps.compile

# copy assets
#COPY apps/frobots_web/priv priv
#COPY apps/frobots_web/assets assets


WORKDIR /app/apps/frobots_web
# install phoenix
#RUN mix archive.install hex phx_new

# install esbuild
#RUN mix esbuild.install

# Compile assets
RUN mix assets.deploy
#RUN mix esbuild default --minify
#RUN mix phx.digest


# compile project
#COPY apps/frobots_web/lib lib
#RUN mix compile

WORKDIR /app

# compile
RUN MIX_ENV=$MIX_ENV mix compile


RUN MIX_ENV=$MIX_ENV mix release


# app stage
#FROM alpine:3.14 AS app
#FROM alpine:3.14.2 AS app
FROM elixir:alpine AS app

ARG MIX_ENV

# install runtime dependencies
RUN apk add --no-cache libstdc++ openssl ncurses-libs

ENV USER="elixir"

WORKDIR "/home/${USER}/app"

# Create  unprivileged user to run the release
#RUN \
##  groupadd \
##   --gid 1000 \
##   --system "${USER}" \
##  && adduser \
#  adduser \
#   --shell /bin/sh \
#   --uid 1000 \
#   --group "${USER}"
##   --home "/home/elixir"

#RUN useradd --system --uid 1000 --home-dir /home/elixir --user-group --shell /bin/sh elixir
#RUN su elixir

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
