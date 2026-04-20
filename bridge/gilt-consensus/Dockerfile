# ─── BUILDER STAGE ───────────────────────────────────────────────────────────────
FROM golang:1.26-alpine AS builder

ARG GILTCONSENSUS_DIR=/var/lib/gilt-consensus/
ENV GILTCONSENSUS_DIR=${GILTCONSENSUS_DIR}

RUN apk add --no-cache build-base git linux-headers

WORKDIR ${GILTCONSENSUS_DIR}

COPY go.mod go.sum ./

RUN --mount=type=ssh \
    --mount=type=cache,target=/go/pkg/mod \
    go mod download

COPY . .

RUN --mount=type=ssh \
    --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    make build

# ─── RUNTIME STAGE ────────────────────────────────────────────────────────────────
FROM alpine:3.23

ARG GILTCONSENSUS_DIR=/var/lib/gilt-consensus/
ENV GILTCONSENSUS_DIR=${GILTCONSENSUS_DIR}

RUN apk add --no-cache bash ca-certificates && \
    mkdir -p ${GILTCONSENSUS_DIR}

WORKDIR ${GILTCONSENSUS_DIR}

COPY --from=builder ${GILTCONSENSUS_DIR}/build/giltconsd /usr/local/bin/giltconsd

EXPOSE 1317 26656 26657

ENTRYPOINT ["/usr/local/bin/giltconsd"]
