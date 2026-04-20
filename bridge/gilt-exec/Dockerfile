# ─── BUILDER STAGE ───────────────────────────────────────────────────────────────
FROM golang:1.26.1-alpine AS builder

ARG GILT_DIR=/var/lib/gilt-exec/
ENV GILT_DIR=$GILT_DIR

RUN apk add --no-cache build-base git linux-headers

WORKDIR ${GILT_DIR}

COPY go.mod go.sum ./

RUN --mount=type=ssh \
    --mount=type=cache,target=/go/pkg/mod \
    go mod download

COPY . .

RUN --mount=type=ssh \
    --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    make gilt

# ─── RUNTIME STAGE ────────────────────────────────────────────────────────────────
FROM alpine:3.23

ARG GILT_DIR=/var/lib/gilt-exec/
ENV GILT_DIR=$GILT_DIR

RUN apk add --no-cache bash ca-certificates && \
    mkdir -p ${GILT_DIR}

WORKDIR ${GILT_DIR}

COPY --from=builder ${GILT_DIR}/build/bin/gilt /usr/bin/

EXPOSE 8545 8546 8547 30303 30303/udp

ENTRYPOINT ["gilt"]
