FROM python:3.12-alpine AS base

FROM base AS builder

ARG SUBLIMINAL_VERSION=2.2.1
ARG WATCHDOG_VERSION=4.0.1

RUN pip install --no-cache-dir \
                --no-compile \
                --no-warn-script-location \
                --disable-pip-version-check \
                --prefix=/build \
                subliminal==${SUBLIMINAL_VERSION} \
                watchdog[watchmedo]==${WATCHDOG_VERSION} &&\
    find /build -depth \
        \( \
            \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
            -o \
            \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
        \) -exec rm -rf '{}' +;

FROM base

COPY --from=builder /build /usr/local

# This hack is widely applied to avoid python printing issues in docker containers.
# See: https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/pull/13
ENV PYTHONUNBUFFERED=1

VOLUME /cache

CMD watchmedo --help && echo && subliminal --help
