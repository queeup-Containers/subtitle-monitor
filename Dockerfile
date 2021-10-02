FROM python:alpine AS base

FROM base AS builder

ARG VERSION=2.1.6

RUN apk add --no-cache unrar &&\
    pip install --no-cache-dir \
                --no-compile \
                --no-warn-script-location \
                --disable-pip-version-check \
                --prefix=/build \
                subliminal watchdog[watchmedo]==${VERSION} &&\
    find /build -depth \
        \( \
            \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
            -o \
            \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
        \) -exec rm -rf '{}' +;

FROM base

COPY --from=builder /build /usr/local
COPY --from=builder /usr/bin/unrar /usr/local/bin/
COPY --from=builder /usr/lib/libstdc++.so* /usr/local/lib/

# This hack is widely applied to avoid python printing issues in docker containers.
# See: https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/pull/13
ENV PYTHONUNBUFFERED=1

VOLUME /cache
