# build stage
FROM 1.14.3-otp-24-slim AS build

ARG MIX_ENV
ENV MIX_ENV="${MIX_ENV}"

# install build dependencies
RUN apk add --no-cache build-base git nodejs npm python3 curl openssh perl


# sets work dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && mix local.rebar --force

# install mix dependencies
COPY mix.exs mix.lock ./

# copy compile configuration files
RUN mkdir config
COPY config/ config/

# copy the mix configs for the web app
COPY apps/frobots_web/mix.exs /app/apps/frobots_web/
COPY apps/frobots_web/assets/package*.json /app/apps/frobots_web/assets/

# copy ALL
COPY . /app/
#RUN /app/wrapper.pl mix deps.get --only $MIX_ENV
#RUN /bin/sh -c 'source /app/.env; mix deps.get --only $MIX_ENV'
#RUN mix deps.get --only $MIX_ENV
RUN mix deps.get --only $MIX_ENV

# compile dependencies
#RUN /bin/sh -c 'source /app/.env; mix deps.compile'
#RUN /app/wrapper.pl mix deps.compile
RUN mix deps.compile

WORKDIR /app/apps/frobots_web
RUN npm i --prefix ./assets

# Compile assets
#RUN /bin/sh -c 'source /app/.env; mix assets.deploy'
#RUN /app/wrapper.pl mix assets.deploy
RUN mix assets.deploy


WORKDIR /app

# compile
#RUN /bin/sh -c 'source /app/.env; mix compile'
#RUN /app/wrapper.pl mix compile
RUN mix compile

#RUN /bin/sh -c 'source /app/.env; mix release'
#RUN /app/wrapper.pl mix release
RUN mix release


# app stage
FROM alpine AS app

ARG MIX_ENV


# install runtime dependencies
RUN apk add --no-cache libstdc++ openssl ncurses-libs bash

ENV USER="elixir"
ENV HOME="/home/${USER}"
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
COPY --from=build --chown="${USER}":"${USER}" /app/apps/frobots/priv/templates /app/_build/"${MIX_ENV}"/lib/frobots/priv/templates/

# copy the certificate files
# RUN mkdir -p ${HOME}/.ssh
# RUN echo ${HOME}
# ARG FROBOTS_CERT_PEM
# ARG FROBOTS_CERT_KEY

# RUN echo ${FROBOTS_CERT_KEY} > ${HOME}/.ssh/frobots_cert.key
# RUN echo ${FROBOTS_CERT_PEM} > ${HOME}/.ssh/frobots_cert.pem
# RUN chmod 600 ${HOME}/.ssh/FROBOTS_CERT_KEY

ENV FROBOTS_SSL_KEY_PATH="/var/certs/frobots_cert.key"
ENV FROBOTS_SSL_CERT_PATH="/var/certs/frobots_cert.pem"

ENTRYPOINT ["bin/frobots_backend"]

CMD ["start"]
