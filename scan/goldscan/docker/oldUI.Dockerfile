FROM hexpm/elixir:1.19.4-erlang-27.3.4.6-alpine-3.22.2 AS builder-deps

WORKDIR /app

RUN apk --no-cache --update add \
    alpine-sdk gmp-dev automake libtool inotify-tools autoconf python3 file gcompat libstdc++ curl ca-certificates git make bash

# Cache elixir deps
COPY mix.exs mix.lock ./
COPY apps/goldscan_web/mix.exs ./apps/goldscan_web/
COPY apps/explorer/mix.exs ./apps/explorer/
COPY apps/ethereum_jsonrpc/mix.exs ./apps/ethereum_jsonrpc/
COPY apps/indexer/mix.exs ./apps/indexer/
COPY apps/utils/mix.exs ./apps/utils/
COPY apps/nft_media_handler/mix.exs ./apps/nft_media_handler/

ENV MIX_ENV="prod"
ENV MIX_HOME=/opt/mix
RUN mix local.hex --force
RUN mix do deps.get, local.rebar --force, deps.compile --skip-umbrella-children

COPY config ./config
COPY rel ./rel
COPY apps ./apps

##############################################################
FROM builder-deps AS builder-ui

RUN apk --no-cache --update add nodejs npm && \
    npm install npm@latest

# Add goldscan npm deps
RUN cd apps/goldscan_web/assets/ && \
    npm install && \
    npm run deploy && \
    cd /app/apps/explorer/ && \
    npm install

RUN cd apps/goldscan_web && mix phx.digest

##############################################################
FROM builder-ui AS builder

ENV DISABLE_WEBAPP=false
ARG ADMIN_PANEL_ENABLED
ENV ADMIN_PANEL_ENABLED=${ADMIN_PANEL_ENABLED}
ARG DISABLE_API
ENV DISABLE_API=${DISABLE_API}
ARG API_V1_READ_METHODS_DISABLED
ENV API_V1_READ_METHODS_DISABLED=${API_V1_READ_METHODS_DISABLED}
ARG API_V1_WRITE_METHODS_DISABLED
ENV API_V1_WRITE_METHODS_DISABLED=${API_V1_WRITE_METHODS_DISABLED}
ARG CHAIN_TYPE
ENV CHAIN_TYPE=${CHAIN_TYPE}
ARG BRIDGED_TOKENS_ENABLED
ENV BRIDGED_TOKENS_ENABLED=${BRIDGED_TOKENS_ENABLED}
ARG API_GRAPHQL_MAX_COMPLEXITY
ENV API_GRAPHQL_MAX_COMPLEXITY=${API_GRAPHQL_MAX_COMPLEXITY}
ARG MUD_INDEXER_ENABLED
ENV MUD_INDEXER_ENABLED=${MUD_INDEXER_ENABLED}

# Run backend compilation
RUN mix compile

RUN mkdir -p /opt/release && \
    mix release goldscan && \
    mv _build/${MIX_ENV}/rel/goldscan /opt/release

##############################################################
FROM hexpm/elixir:1.19.4-erlang-27.3.4.6-alpine-3.22.2

WORKDIR /app

ARG GOLDSCAN_USER=goldscan
ARG GOLDSCAN_GROUP=goldscan
ARG GOLDSCAN_UID=10001
ARG GOLDSCAN_GID=10001

RUN apk --no-cache --update add jq curl && \
    addgroup --system --gid ${GOLDSCAN_GID} ${GOLDSCAN_GROUP} && \
    adduser --system --uid ${GOLDSCAN_UID} --ingroup ${GOLDSCAN_GROUP} --disabled-password ${GOLDSCAN_USER}

ENV DISABLE_WEBAPP=false
ENV ADMIN_PANEL_ENABLED=false
ARG DISABLE_API
ENV DISABLE_API=${DISABLE_API}
ARG API_V1_READ_METHODS_DISABLED
ENV API_V1_READ_METHODS_DISABLED=${API_V1_READ_METHODS_DISABLED}
ARG API_V1_WRITE_METHODS_DISABLED
ENV API_V1_WRITE_METHODS_DISABLED=${API_V1_WRITE_METHODS_DISABLED}
ARG CHAIN_TYPE
ENV CHAIN_TYPE=${CHAIN_TYPE}
ARG BRIDGED_TOKENS_ENABLED
ENV BRIDGED_TOKENS_ENABLED=${BRIDGED_TOKENS_ENABLED}
ARG API_GRAPHQL_MAX_COMPLEXITY
ENV API_GRAPHQL_MAX_COMPLEXITY=${API_GRAPHQL_MAX_COMPLEXITY}
ARG MUD_INDEXER_ENABLED
ENV MUD_INDEXER_ENABLED=${MUD_INDEXER_ENABLED}

ARG RELEASE_VERSION
ENV RELEASE_VERSION=${RELEASE_VERSION}
ARG GOLDSCAN_VERSION
ENV GOLDSCAN_VERSION=${GOLDSCAN_VERSION}

COPY --from=builder --chown=${GOLDSCAN_USER}:${GOLDSCAN_GROUP} /opt/release/goldscan .
COPY --from=builder --chown=${GOLDSCAN_USER}:${GOLDSCAN_GROUP} /app/apps/explorer/node_modules ./node_modules
COPY --from=builder --chown=${GOLDSCAN_USER}:${GOLDSCAN_GROUP} /app/config/config_helper.exs ./config/config_helper.exs
COPY --from=builder --chown=${GOLDSCAN_USER}:${GOLDSCAN_GROUP} /app/config/config_helper.exs /app/releases/${RELEASE_VERSION}/config_helper.exs
COPY --from=builder --chown=${GOLDSCAN_USER}:${GOLDSCAN_GROUP} /app/config/assets/precompiles-arbitrum.json ./config/assets/precompiles-arbitrum.json

RUN mkdir dets && mkdir temp && chown -R ${GOLDSCAN_USER}:${GOLDSCAN_GROUP} /app

USER ${GOLDSCAN_USER}:${GOLDSCAN_GROUP}
